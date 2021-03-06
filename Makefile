TARGETS := $(shell ls scripts)

.dapper:
	@echo Downloading dapper
	@curl -sL https://releases.rancher.com/dapper/latest/dapper-`uname -s`-`uname -m` > .dapper.tmp
	@@chmod +x .dapper.tmp
	@./.dapper.tmp -v
	@mv .dapper.tmp .dapper

serve-docs: mkdocs
	docker run --net=host --rm -it -v $${PWD}:/docs mkdocs serve

deploy-docs: mkdocs
	sudo chown -R "${USER}" .
	git fetch rancher gh-pages
	docker run -v $${HOME}/.ssh:/root/.ssh --rm -it -v $${PWD}:/docs mkdocs gh-deploy -r rancher

mkdocs:
	docker build -t mkdocs -f Dockerfile.docs .

$(TARGETS): .dapper
	./.dapper $@

.DEFAULT_GOAL := default

.PHONY: $(TARGETS)
