open --background -a Docker
while (! docker stats --no-stream ); do
  # Docker takes a few seconds to initialize
  echo "Waiting for Docker to launch..."
  sleep 10
done
echo "Stopping Other containers & Starting webrust containers Postgres/Redis.."
cd ~/Documents/GitHub/litigate/env/docker/litigate-local && docker compose stop && cd ~/Documents/rustProject/webrust && docker compose start
echo "Starting Meilisearch.."
cd ~ && ./meilisearch --master-key="aSampleMasterKey"
