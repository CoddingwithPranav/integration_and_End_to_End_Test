#!/bin/bash
# Change to the parent directory where docker-compose.yml is located
cd "$(dirname "$0")/.."
echo "Starting Docker Compose services..."
docker compose -f docker-compose.yml up -d
echo '🟡 - Waiting for database to be ready...'
./scripts/wait-for-it.sh -t 10 "postgresql://postgres:mysecretpassword@db:5432/postgres" -- echo '🟢 - Database is ready!'
npx prisma migrate dev --name init
npm run test
docker compose -f docker-compose.yml down