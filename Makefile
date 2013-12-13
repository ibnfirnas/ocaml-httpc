EXE_TYPE := byte
EXE_NAME := http_client_example
PACKAGES := str,unix

.PHONY: \
	build \
	make_bin \
	clean \
	clean_bin \
	clean_manually

build: make_bin
	@ocamlbuild \
		-cflags '-w +A' \
		-I examples \
		-I lib \
		-use-ocamlfind \
		-package $(PACKAGES) \
		$(EXE_NAME).$(EXE_TYPE)
	@cp _build/examples/$(EXE_NAME).$(EXE_TYPE) bin/$(EXE_NAME)
	@rm $(EXE_NAME).$(EXE_TYPE)

make_bin:
	@mkdir -p bin

clean: clean_bin
	@ocamlbuild -clean

clean_manually: clean_bin
	@find \
		. \
			-name '*.o' \
		-or -name '*.cmi' \
		-or -name '*.cmo' \
		-or -name '*.cmx' \
	| xargs rm -f

clean_bin:
	@rm -rf bin
