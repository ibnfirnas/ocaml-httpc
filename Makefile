PROGRAMS := \
	httpc_example

DOC_FORMAT := html

DIR_DOC   := doc/api/$(DOC_FORMAT)
DIR_BUILD := _obuild
DIR_SRC   := lib


# TODO: Test a cross-platform way of grabbing number of CPUs
MAX_BUILD_WORKERS := $(shell sysctl -n hw.ncpu)


.PHONY:\
	build \
	clean \
	deps \
	doc \
	doc_httpc \
	programs \
	purge


programs: build bin
	@for p in $(PROGRAMS); do \
		src="$(DIR_BUILD)/$$p/$$p.byte" ; \
		dst="bin/$$p" ; \
		cp $$src $$dst ; \
	done

bin:
	@mkdir -p bin

build: ocp-build.root
	@ocp-build build -njobs $(MAX_BUILD_WORKERS)

ocp-build.root:
	@ocp-build -init -njobs $(MAX_BUILD_WORKERS)

doc: doc_httpc

doc_httpc: $(DIR_DOC) build
	@ocamlfind ocamldoc \
		-d $(DIR_DOC) \
		-$(DOC_FORMAT) \
		-I $(DIR_BUILD)/httpc \
		$(DIR_SRC)/*.ml

$(DIR_DOC):
	@mkdir -p $(DIR_DOC)

clean: clean_bin
	@ocp-build clean
	@rm -f ocp-build.root*

clean_manually: clean_bin
	@rm -rf $(DIR_BUILD)
	@find \
		. \
			-name '*.o' \
		-or -name '*.cmi' \
		-or -name '*.cmo' \
		-or -name '*.cmx' \
	| xargs rm -f

clean_bin:
	@rm -rf bin
