include .env

help:
	@echo "postgres			- Run a Postgres container"
	@echo "mysql 			- Run a mysql container"
	@echo "data_warehouse   - Run MySQL and PostgreSQL Container"
	@echo "clean			- Clean all container"

postgres: postgres-init postgres-create postgres-restore

postgres-init:
	@docker network inspect data-network >/dev/null 2>&1 || docker network create data-network
	@docker compose -f docker/docker-compose-postgres.yml --env-file .env up -d
	@echo 'Postgres Docker Host	: ${POSTGRES_CONTAINER_NAME}' &&\
		echo 'Postgres Account	: ${POSTGRES_USER}' &&\
		echo 'Postgres password	: ${POSTGRES_PASSWORD}' &&\
		echo 'Postgres Db		: ${POSTGRES_DB}'
	@sleep 5
	@echo '==========================================================='

postgres-create:
	@echo 'Starting Create Postgre Database'
	@docker exec -it ${POSTGRES_CONTAINER_NAME} psql -U ${POSTGRES_USER} -d ${POSTGRES_DB} -c  "DROP DATABASE IF EXISTS ${POSTGRES_DB_NEW};"
	@docker exec -it ${POSTGRES_CONTAINER_NAME} psql -U ${POSTGRES_USER} -d ${POSTGRES_DB} -c  "CREATE DATABASE ${POSTGRES_DB_NEW};"
	@sleep 5
	@echo '==========================================================='

postgres-restore:
	@echo 'Starting Restore Database'
	@docker exec -it ${POSTGRES_CONTAINER_NAME} pg_restore -U ${POSTGRES_USER} -d ${POSTGRES_DB_NEW} data/dvdrental.tar
	@sleep 15
	@echo 'NOW you can try to open PGADMIN'
	@echo '==========================================================='

postgres-psql:
	@docker exec -it ${POSTGRES_CONTAINER_NAME} psql -U ${POSTGRES_USER} -d ${POSTGRES_DB_NEW}

postgres-down:
	@docker compose -f docker/docker-compose-pgadmin.yml down 

mysql:
	@docker network inspect data-network >/dev/null 2>&1 || docker network create data-network
	@docker compose -f docker/docker-compose-mysql.yml --env-file .env up -d
	@sleep 10
	@docker exec -it ${MYSQL_CONTAINER_NAME} mysql -u root -p'${MYSQL_ROOT_PASSWORD}' -h 0.0.0.0 -e "GRANT ALL PRIVILEGES ON *.* TO '${MYSQL_USER}'@'%' WITH GRANT OPTION; FLUSH PRIVILEGES;"
	@docker exec -it ${MYSQL_CONTAINER_NAME} mysql -u root -p'${MYSQL_ROOT_PASSWORD}' -h 0.0.0.0 -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE_DW};"
	@echo 'MySQL Docker Host	: ${MYSQL_CONTAINER_NAME}' &&\
		echo 'MySQL Account		: ${MYSQL_USER}' &&\
		echo 'MySQL password	: ${MYSQL_PASSWORD}'

data_warehouse: mysql postgres python-env-cmdx

python-env:
	@echo 'Run Command Below'
	@echo 'source .venv/bin/activate && pip install -r requirements.txt'

docker-stop:
	@docker stop $$(docker ps -q)

setup-env:
	@echo 'export $$(grep -v '^#' .env | xargs)'

clean:
	@docker system prune --all --volumes --force

