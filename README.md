Initial readme for the project

run server:
1. Get docker container running: `cd server && docker-compose up -d`
2. Sync schema: `ts-node ./node_modules/typeorm/cli.js schema:sync`