DOC_PATH = doc/apidoc/

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

clean:
	mix clean --deps
	rm -rf ${DOC_PATH}

doc:
	apidoc -v -i priv/api/ -o ${DOC_PATH}
	@echo "Open in your browser: $(shell pwd)/${DOC_PATH}index.html"
