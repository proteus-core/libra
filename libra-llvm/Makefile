CMAKE_FLAGS_LLVM =

-include Makefile.local

MAKEFILE_DIR = $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

BUILD_TYPE ?= Release
JOBS       ?= 1

PACKAGE ?= libra

BUILDDIR     ?= $(MAKEFILE_DIR)build
INSTALLDIR   ?= $(MAKEFILE_DIR)install

DISTDIR        ?= $(MAKEFILE_DIR)dist
DISTBUILDDIR   ?= $(DISTDIR)/build
DISTINSTALLDIR ?= $(DISTDIR)/$(PACKAGE)/usr/local/$(PACKAGE)

CMAKE_GENERATOR ?= Ninja

#############################################################################

MKDIR = mkdir -p
CMAKE = cmake
NICE = nice

#############################################################################

LLVM_REPO = git@github.com:llvm/llvm-project.git
LLVM_FORK = git@gitlab:anon/llvm-project.git

SRCDIR_LLVM   = $(MAKEFILE_DIR)llvm
SRCDIR_CLANG  = $(MAKEFILE_DIR)clang

BUILDDIR_LLVM = $(BUILDDIR)/llvm

DISTBUILDDIR_LLVM = $(DISTBUILDDIR)/llvm

DISTDEPS =
DISTDEPS += cmake
DISTDEPS += ninja-build
DISTDEPS += gcc-multilib
DISTDEPS += python3
DISTDEPS += python3-distutils

CMAKE_FLAGS_LLVM += -G "$(CMAKE_GENERATOR)"
CMAKE_FLAGS_LLVM += -S $(SRCDIR_LLVM)
ifeq ($(CMAKE_GENERATOR), Ninja)
CMAKE_FLAGS_LLVM += -DLLVM_PARALLEL_COMPILE_JOBS=$(JOBS)
CMAKE_FLAGS_LLVM += -DLLVM_PARALLEL_LINK_JOBS=2
endif
CMAKE_FLAGS_LLVM += -DLLVM_TARGETS_TO_BUILD=RISCV
CMAKE_FLAGS_LLVM += -DLLVM_ENABLE_PROJECTS="llvm;clang;lld"
CMAKE_FLAGS_LLVM += -DLLVM_USE_LINKER=
CMAKE_FLAGS_LLVM += -DLLVM_ENABLE_LLD=1
CMAKE_FLAGS_LLVM += -DLLVM_ENABLE_PLUGINS=ON
CMAKE_FLAGS_LLVM += -DCMAKE_EXPORT_COMPILE_COMMANDS=1
CMAKE_FLAGS_LLVM += -DCMAKE_CXX_COMPILER=clang++
CMAKE_FLAGS_LLVM += -DCMAKE_C_COMPILER=clang
CMAKE_FLAGS_LLVM += -DCMAKE_C_COMPILER_LAUNCHER=ccache
CMAKE_FLAGS_LLVM += -DCMAKE_CXX_COMPILER_LAUNCHER=ccache

DEV_CMAKE_FLAGS_LLVM = $(CMAKE_FLAGS_LLVM)
DEV_CMAKE_FLAGS_LLVM += -B $(BUILDDIR_LLVM)
DEV_CMAKE_FLAGS_LLVM += -DCMAKE_INSTALL_PREFIX=$(INSTALLDIR)
DEV_CMAKE_FLAGS_LLVM += -DCMAKE_BUILD_TYPE=$(BUILD_TYPE)

DIST_CMAKE_FLAGS_LLVM = $(CMAKE_FLAGS_LLVM)
DIST_CMAKE_FLAGS_LLVM += -B $(DISTBUILDDIR_LLVM)
DIST_CMAKE_FLAGS_LLVM += -DCMAKE_INSTALL_PREFIX=$(DISTINSTALLDIR)
DIST_CMAKE_FLAGS_LLVM += -DCMAKE_BUILD_TYPE=Release
DIST_CMAKE_FLAGS_LLVM += -DLLVM_DISTRIBUTION_COMPONENTS="clang;lld;llvm-objdump"
DIST_CMAKE_FLAGS_LLVM += -DLLVM_INSTALL_TOOLCHAIN_ONLY=ON

#############################################################################

.PHONY: all
all:
	@echo BUILD_TYPE=$(BUILD_TYPE)
	@echo JOBS=$(JOBS)
	@echo CMAKE_GENERATOR=$(CMAKE_GENERATOR)

.PHONY: configure-build
configure-build:
	$(MKDIR) $(BUILDDIR_LLVM)
	$(CMAKE) $(DEV_CMAKE_FLAGS_LLVM)

.PHONY: build
build:
ifneq ($(CMAKE_GENERATOR), Ninja)
	$(NICE) $(CMAKE) --build $(BUILDDIR_LLVM) -- -j$(JOBS)
else
	$(NICE) $(CMAKE) --build $(BUILDDIR_LLVM)
endif

.PHONY: install
install:
	$(CMAKE) --build $(BUILDDIR_LLVM) --target install

.PHONY: dist-install-deps
dist-install-deps:
	apt-get -y install $(DISTDEPS)

.PHONY: dist-configure-build
dist-configure-build:
	$(MKDIR) $(DISTBUILDDIR)
	$(CMAKE) $(DIST_CMAKE_FLAGS_LLVM) $(SRCDIR_LLVM)

.PHONY: dist-build
dist-build:
	$(NICE) $(CMAKE) --build $(DISTBUILDDIR_LLVM)

.PHONY: dist-install
dist-install:
	$(CMAKE) --build $(DISTBUILDDIR_LLVM) --target install-distribution

.PHONY: dist-deb
dist-deb: dist-install
	$(MKDIR) $(DISTDIR)/$(PACKAGE)/DEBIAN
	chmod g-s $(DISTDIR)/$(PACKAGE)/DEBIAN
	cp morpheus/control $(DISTDIR)/$(PACKAGE)/DEBIAN
	cd $(DISTDIR) && dpkg-deb --build $(PACKAGE)

.PHONY: dist
dist:
	$(MAKE) dist-install-deps
	$(MAKE) dist-configure-build
	$(MAKE) dist-build
	$(MAKE) dist-install
	$(MAKE) dist-deb

.PHONY: clean
clean:
	#$(RM) $(BUILDDIR)
	#$(RM) $(DISTBUILDDIR)

.PHONY: realclean
realclean:
	$(RM) -rf $(BUILDDIR)
	$(RM) -rf $(INSTALLDIR)
	$(RM) -rf $(DISTDIR)
