DOC_PATH = doc/apidoc/
DOCKER_APP_INTANCES=3

.PHONY: deps compile test doc clean

deps:
	mix do deps.get

compile: deps
	mix compile

test: compile
	mix test

shell: compile
	iex -S mix

release: deps
	MIX_ENV=prod mix compile
	MIX_ENV=prod mix release

deploy: release undeploy
	@echo "Creating container ..."
	docker-compose build
	@echo "Deploying ${DOCKER_APP_INTANCES} instances of the container ..."
	docker-compose up --scale leagues=${DOCKER_APP_INTANCES}

undeploy:
	docker-compose stop
	docker-compose down

clean:
	docker-compose stop
	docker-compose down
	mix clean --deps
	rm -rf ${DOC_PATH}

doc:
	apidoc -v -i priv/api/ -o ${DOC_PATH}
	@echo "Open in your browser: $(shell pwd)/${DOC_PATH}index.html"
