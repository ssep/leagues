.PHONY: deps compile test doc clean

deps:
	mix do deps.get

compile: deps
	mix compile

test: compile
	mix test

shell: compile
	iex -S mix

clean:
	rm -rf doc/apidoc

doc:
	apidoc -v -i priv/api/ -o doc/apidoc/
