$ENV:STARSHIP_CONFIG = "C:\Users\Nisarg\Documents\starship.toml"
$ENV:STARSHIP_CACHE = "$HOME\AppData\Local\Temp"
Invoke-Expression (&starship init powershell)
# Shows navigable menu of all options when hitting Tab
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

# Autocompletion for arrow keys
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

# New-Alias <alias> <aliased-command>
New-Alias open ii

function gorust { set-location "$home\Documents\gitrust" }
# New-Alias -Name gh -Value Get-Help
function Get-GitPull { & git pull $args }
New-Alias -Name gg -Value Get-GitPull -Force -Option AllScope
function Get-GitStatus { & git status $args }
New-Alias -Name gs -Value Get-GitStatus

function Set-GitCommit { & git commit -m $args }
New-Alias -Name cc -Value Set-GitCommit

function Get-GitAdd{ & git add $args }
New-Alias -Name ga -Value Get-GitAdd

function Get-GitCheckout{ & git checkout $args }
New-Alias -Name gco -Value Get-GitCheckout

function Get-GitDiff{ & git diff $args }
New-Alias -Name gd -Value Get-GitDiff

function Get-GitReset{ & git reset $args }
New-Alias -Name grs -Value Get-GitReset