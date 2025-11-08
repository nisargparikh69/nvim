-- nvim/lua/plugins/java.lua
return {
  'mfussenegger/nvim-jdtls',
  ft = { 'java' },
  config = function()
    local jdtls = require 'jdtls'

    local function find_java21()
      local candidates = {}
      if vim.env.JAVA21_HOME then
        table.insert(candidates, vim.env.JAVA21_HOME .. '/bin/java')
      end
      vim.list_extend(candidates, {
        '/usr/lib/jvm/temurin-21-jdk/bin/java',
        '/usr/lib/jvm/java-21-openjdk-amd64/bin/java',
        '/usr/lib/jvm/java-21-openjdk/bin/java',
      })
      for _, p in ipairs(candidates) do
        if vim.uv.fs_access(p, 'X') then
          return p
        end
      end
      return 'java'
    end

    local function start_jdtls()
      local root_markers = { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' }
      local root_dir = vim.fs.dirname(vim.fs.find(root_markers, { upward = true })[1]) or vim.loop.cwd()
      local workspace_dir = vim.fn.stdpath 'data' .. '/jdtls-workspaces/' .. vim.fn.fnamemodify(root_dir, ':p:h:t')

      local java_cmd = find_java21()
      if java_cmd == 'java' then
        vim.notify('[jdtls] Using "java" from PATH; ensure Java 21+', vim.log.levels.WARN)
      end

      local mason_base = vim.fn.stdpath 'data' .. '/mason/packages/jdtls'
      local launcher_jar = vim.fn.glob(mason_base .. '/plugins/org.eclipse.equinox.launcher_*.jar')
      local config_dir = mason_base .. '/config_linux'

      local cmd = {
        java_cmd,
        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        '-Dlog.level=WARN',
        '-Xms1g',
        '--add-opens',
        'java.base/java.util=ALL-UNNAMED',
        '--add-opens',
        'java.base/java.lang=ALL-UNNAMED',
        '-jar',
        launcher_jar,
        '-configuration',
        config_dir,
        '-data',
        workspace_dir,
      }

      local config = {
        cmd = cmd,
        root_dir = root_dir,
        settings = {
          java = {
            format = {
              enabled = true,
              settings = {
                url = vim.fn.expand '~/.config/jdtls/Default.xml',
                profile = 'nisprofile',
              },
            },
          },
        },
        capabilities = require('cmp_nvim_lsp').default_capabilities(),
        init_options = { bundles = {} },
      }

      jdtls.start_or_attach(config)
    end

    -- Format on save using LspAttach event
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('JdtlsFormatOnSave', { clear = true }),
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.name == 'jdtls' then
          -- Format on save
          vim.api.nvim_create_autocmd('BufWritePre', {
            buffer = args.buf,
            group = vim.api.nvim_create_augroup('JdtlsFormat_' .. args.buf, { clear = true }),
            callback = function()
              vim.lsp.buf.format { bufnr = args.buf, timeout_ms = 5000 }
            end,
          })

          -- Organize imports on save
          vim.api.nvim_create_autocmd('BufWritePre', {
            buffer = args.buf,
            group = vim.api.nvim_create_augroup('JdtlsImports_' .. args.buf, { clear = true }),
            callback = function()
              local params = vim.lsp.util.make_range_params()
              params.context = { only = { 'source.organizeImports' } }
              local result = vim.lsp.buf_request_sync(args.buf, 'textDocument/codeAction', params, 1000)
              for _, res in pairs(result or {}) do
                for _, action in pairs(res.result or {}) do
                  if action.edit then
                    vim.lsp.util.apply_workspace_edit(action.edit, 'utf-8')
                  end
                end
              end
            end,
          })

          vim.notify('[jdtls] Format on save enabled for buffer ' .. args.buf, vim.log.levels.INFO)
        end
      end,
    })

    -- Restart command
    vim.api.nvim_create_user_command('JdtlsRestart', function()
      vim.lsp.stop_client(vim.lsp.get_active_clients { name = 'jdtls' }, true)
      vim.defer_fn(function()
        if vim.bo.filetype == 'java' then
          start_jdtls()
        end
      end, 500)
    end, {})

    -- Start JDTLS on Java files
    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('JdtlsSetup', { clear = true }),
      pattern = 'java',
      callback = start_jdtls,
    })
  end,
}
