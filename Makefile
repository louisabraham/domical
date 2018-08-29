docs/eval.js:
	$(MAKE) -C toplevel
	cp toplevel/_build/default/eval/eval.js docs

.PHONY: docs/eval.js