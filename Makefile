EXE_TYPE := byte
EXE_NAME := curl

.PHONY: \
	build \
	clean \
	clean_bin \
	clean_manually

build:
	@ocamlbuild \
		-cflags '-w +A' \
		-I lib \
		-use-ocamlfind \
		-package unix \
		$(EXE_NAME).$(EXE_TYPE)
	@mkdir -p bin
	@cp _build/lib/$(EXE_NAME).$(EXE_TYPE) bin/$(EXE_NAME)
	@rm $(EXE_NAME).$(EXE_TYPE)

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
	@rm -rf bin/
