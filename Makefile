UID = $(shell id -u)
GID = $(shell id -g)

docs = docs/docs.json docs/markdown/index.md docs/markdown/MuteSync.md docs/docs_index.json docs/html/index.html docs/html/template_docs.json docs/html/MuteSync.html

$(docs): *.lua
	docker build -t hs-docs .
	mkdir -p docs
	docker run -u $(UID):$(GID) --rm -v $(CURDIR):/wd hs-docs

docs: $(docs)
