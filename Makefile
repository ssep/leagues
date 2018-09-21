.PHONY: doc clean

deps:
	mix do deps.get

clean:
	rm -rf doc/apidoc

doc:
	apidoc -v -i priv/api/ -o doc/apidoc/
