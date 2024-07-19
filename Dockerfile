FROM ubuntu:22.04

# Set to noninteractive mode
ARG DEBIAN_FRONTEND=noninteractive

################################################################################
# Basic dependencies
################################################################################

RUN apt-get update && apt-get -yqq install git lsb-release sudo vim gnupg openjdk-17-jdk verilator curl make clang cmake ninja-build lld ccache g++ python3-pip gcc-riscv64-unknown-elf
RUN python3 -m pip install --user matplotlib scipy

WORKDIR /
RUN git clone https://github.com/cirosantilli/vcdvcd --branch 2.3.5 --depth 1
RUN python3 -m pip install --user ./vcdvcd
RUN cp ./vcdvcd/vcdcat /usr/local/bin/

################################################################################
# Install sbt (https://www.scala-sbt.org/)
################################################################################

RUN echo "deb https://repo.scala-sbt.org/scalasbt/debian all main" | tee /etc/apt/sources.list.d/sbt.list
RUN echo "deb https://repo.scala-sbt.org/scalasbt/debian /" | tee /etc/apt/sources.list.d/sbt_old.list
RUN curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | apt-key add
RUN apt-get update
RUN apt-get -yqq install sbt=1.8.0

################################################################################
# Install LLVM with Libra modifications
################################################################################

WORKDIR /toolchain
COPY ./libra-llvm .
RUN make configure-build
RUN make build
RUN make install

################################################################################
# Copy benchmarks
################################################################################

WORKDIR /evaluation
COPY ./libra-eval .

################################################################################
# Build dynamic pipeline and run RISC-V tests
################################################################################

WORKDIR /proteus
COPY ./newlib ./newlib
COPY ./sim ./sim
COPY ./src ./src
COPY ./tests ./tests
COPY build.sbt .
RUN make -C sim clean
# create simulator binary and run riscv-tests
RUN make CORE=riscv.CoreDynamicExtMem RISCV_PREFIX=riscv64-unknown-elf ARCHFLAGS="-march=rv32im -mabi=ilp32" -C tests

################################################################################
# Install base Proteus version (for comparison)
################################################################################

WORKDIR /proteus-base
RUN git clone --recurse-submodules --depth=1 --branch v24.01 https://github.com/proteus-core/proteus.git .
# create simulator binary and run riscv-tests
RUN make CORE=riscv.CoreDynamicExtMem RISCV_PREFIX=riscv64-unknown-elf ARCHFLAGS="-march=rv32im -mabi=ilp32" -C tests

################################################################################
# Run evaluation
################################################################################

WORKDIR /evaluation
RUN make
RUN cp results.tex /results-performance.tex
RUN make realclean
RUN make security

ENTRYPOINT ["/bin/bash"]
