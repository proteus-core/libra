DIR_LLVM    = libra-llvm
DIR_PROTEUS = proteus
DIR_PAPER   = paper-sbe
DIR_EVAL    = libra-eval

GIT = git

.PHONY: build-hardware-dynamic
build-hardware-dynamic:
	$(RM) -r sim/build
	$(MAKE) -C sim CORE=riscv.CoreDynamicExtMem

.PHONY: build-toolchain
build-toolchain:
	$(MAKE) -C $(DIR_LLVM) configure-build
	$(MAKE) -C $(DIR_LLVM) build
	$(MAKE) -C $(DIR_LLVM) install
