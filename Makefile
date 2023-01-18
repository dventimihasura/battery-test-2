SHELL=bash

ab.log:
	pgbench -i -IdtGvpf -s100 -q
	docker run -d --net=host -e HASURA_GRAPHQL_DATABASE_URL=postgres://$${PGUSER}:$${PGPASSWORD}@$${PGHOST}:$${PGPORT}/$${PGDATABASE} -e HASURA_GRAPHQL_ENABLE_CONSOLE=true hasura/graphql-engine:latest
	sleep 10
	curl -s -H 'Content-type: application/json' --data-binary @config.json "http://127.0.0.1:8080/v1/metadata" | jq -r '.'
	ab -c50 -t10 -l -H "Accept: application/json" "http://127.0.0.1:8080/api/rest/abalance/10" >> $@

