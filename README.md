# Libra: Architectural Support For Principled, Secure And Efficient Balanced Execution On High-End Processors

This is the repository for our [paper](https://mici.hu/papers/winderix24libra.pdf) published at CSS '24.

```bibtex
@inproceedings{winderix24libra,
  title     = {Libra: Architectural Support for Principled, Secure and Efficient Balanced Execution on High-End Processors},
  author    = {Winderix, Hans and Bognar, Marton and Daniel, Lesly-Ann and Piessens, Frank},
  booktitle = {{ACM} Conference on Computer and Communications Security ({CCS})},
  year      = 2024
}
```

## Prerequisites

- [Docker](https://docs.docker.com/engine/install/) for installing the core and running the benchmarks.
  - Disk space required for the built container image: 11 GB.
- [Xilinx Vivado](https://www.xilinx.com/products/design-tools/vivado/vivado-ml.html) for running the hardware cost measurements.
  - Requires a Xilinx/AMD account (which you can create for free).
  - Customizing the installation: Vivado Design Suite and the 7 Series Production Devices are sufficient, everything else can be deselected.
  - Disk space required: 52 GB.
  - We used version 2022.2 (ML Edition) in our evaluation, but we expect similar results from newer versions.

When cloning the repository, make sure to clone recursively (or [initialize submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules#_cloning_submodules) after cloning):

```shell
git clone --recurse-submodules https://github.com/proteus-core/libra
```

## Structure of the repository

- `libra-eval`: our benchmarks and the tooling to run them
- `libra-llvm`: the LLVM compiler framework, with our modification to add support for encoding the level-offset branch instruction (required to compile the benchmark programs).
  - `llvm/lib/Target/RISCV/RISCVInstrFormats.td`: TableGen description of the Libra RISC-V opcodes
  - `llvm/lib/Target/RISCV/RISCVInstrInfo.td`: TableGen description of the Libra RISC-V instructions
  - `llvm/lib/Target/RISCV/Disassembler/RISCVDisassembler.cpp`: making sure libra instructions are correctly disassembled
- `src/main/scala/riscv`: the Proteus core with our modifications to add support for Libra. Main modifications are the following:
  - `plugins/Libra.scala`: managing the Libra state and decoding the Libra-specific ISA instructions (**HR4**).
  - `plugins/scheduling/dynamic/ReorderBuffer.scala`: preventing speculative execution after a level-offset branch.
  - `plugins/BranchUnit.scala`: updating the Libra state by level-offset instructions.
  - `plugins/BranchTargetPredictorBase.scala`: disabling the branch predictor in secret-dependent regions (**HR2**).
  - `plugins/memory/Fetcher.scala`: ensuring a secret-independent instruction fetching pattern (**HR2**, **HR3**).

## Performance and security evaluation

Build the Docker image (estimated time ~5h, RAM usage ~10GB):

```shell
docker build -t libra .
```

Building the Docker image also runs both the performance (Table 2, paragraph "Binary size" and "Execution time" in Section 7.2) and the security (paragraph "Security" in Section 7.2) evaluations.
The result of the performance evaluation is saved in the file `/results-performance.tex`.
As the security evaluation exits with an error on a detected security violation, a successful build of the image indicates that there were no detected security violations.

The container can be launched with the following command:

```shell
docker run -i -h "libra" -t libra
```

If desired, the performance evaluation can be re-run from the `/evaluation` directory (estimated time ~2min):

```shell
make realclean  # Clean up simulation artifacts
make            # Run the software benchmarks, results are stored in `results.tex`
```

Expected output (for the performance evaluation):

```tex
root@libra:/# cat /evaluation/results.tex
% Binary size
fork & 136 & 1.00 & 1.12 & 0.94 \\
triangle & 132 & 1.06 & 1.15 & 1.00 \\
bsl & 336 & 1.04 & 1.08 & 1.01 \\
diamond & 192 & 1.10 & 1.23 & 1.04 \\
kruskal & 452 & 1.05 & 1.16 & 1.04 \\
ifthenloop & 200 & 1.20 & 1.20 & 1.16 \\
switch & 500 & 1.41 & 1.92 & 1.15 \\
sharevalue & 500 & 1.02 & 1.15 & 1.01 \\
mulmod16 & 276 & 1.01 & 1.16 & 0.96 \\
keypad & 416 & 1.08 & 1.12 & 1.06 \\
modexp2 & 324 & 1.02 & 1.09 & 1.01 \\
\textbf{mean} & & \textbf{1.09} & \textbf{1.20} & \textbf{1.03}\\

% Execution time
fork & 110 & 1.00 & 1.11 & 1.00 \\
triangle & 116 & 1.03 & 1.05 & 0.98 \\
bsl & 1415 & 1.20 & 1.54 & 1.24 \\
diamond & 186 & 1.07 & 1.18 & 1.06 \\
kruskal & 1573 & 1.09 & 1.21 & 1.16 \\
ifthenloop & 407 & 1.35 & 1.28 & 1.56 \\
switch & 1402 & 2.11 & 2.70 & 1.92 \\
sharevalue & 1410 & 1.38 & 1.76 & 1.73 \\
mulmod16 & 339 & 1.23 & 1.47 & 1.32 \\
keypad & 3490 & 2.86 & 3.48 & 3.61 \\
modexp2 & 11716 & 1.72 & 1.79 & 1.78 \\
\textbf{mean} & & \textbf{1.38} & \textbf{1.57} & \textbf{1.46}\\
```

If desired, the security evaluation can be re-run from the `/evaluation` directory (estimated time ~1h):

```shell
make realclean   # Clean up simulation artifacts
make security    # Run the security evaluation
```

Expected output (for the security evaluation):

```shell
$ make security
...
$ # target finishes with no error reported
```

## Hardware evaluation

> [!NOTE]
> In contrast to the performance and security evaluation above, the results of the hardware evaluation can vary due to changes in the sbt and SpinalHDL libraries and the non-deterministic nature of the place-and-route algorithms. We use these results as an indication that Libra can be implemented with little extra cost, but optimizing our implementation was out of scope.

First, find the name of the `libra` container (`stupefied_poincare` in this example):

```shell
$ docker ps -a
CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS                     PORTS     NAMES
21aa3b3408e6   libra          "/bin/sh -c /bin/bash"   8 seconds ago    Exited (0) 2 seconds ago             stupefied_poincare
```

Using this name, we can copy the `Core.v` files containing the Verilog design for the base Proteus core and the Libra-enabled version to the host machine:

```shell
docker cp stupefied_poincare:/proteus/Core.v Core-Libra.v
docker cp stupefied_poincare:/proteus-base/Core.v Core.v
```

To run the evaluation of the hardware overheads (paragraph "Hardware cost" in Section 7.2), first set up the Vivado project.

### Creating the Vivado project

1. Launch Vivado, and start the Create Project wizard.
2. Choose the project name and location as desired.
3. **Project type**: RTL Project.
4. **Add sources**: select `Core.v` (copied from the Docker container) and `synthesis/Top.v` (a file in this repository). Do **not** check "Copy sources into project" or "Scan and add RTL include files into project".
5. **Add constraints**: select `synthesis/Constraints.xdc`.
6. **Default part**: select your target FPGA, the `xc7a35ticsg324-1L`.
7. Finish the wizard.
8. When the project is open, if `Top.v` is not selected as the top module (shown in bold), right-click on it and "Set as Top".

### Running the Vivado evaluation for the baseline

9. Ensure the timing constraint in `Constraints.xdc` is the value indicated in the paper (`37.4 ns`). As the synthesis process is not completely deterministic, you might need to increase this value slightly if the implementation fails with a failed timing. For example, to change the timing constraint to `37.5 ns`, replace `-period 37.400` in `Constraints.xdc` with `-period 37.500`.
10. Click "Run Implementation" in the *Flow Navigator* in the left pane (which will run synthesis first if necessary). (Estimated time ~20 minutes per run.)

### Interpreting the results

11. When the implementation finishes, the relevant values for number of LUTs and registers can be found on the "Design Runs" tab at the bottom of the screen, in line "impl_1" and in the columns "LUT" and "FF", respectively.
If the timing constraint for the critical path is met, this is shown by a black (and positive) number under the WNS (worst negative slack) field in the same table, failed timings are indicated by an error and a red (negative) WNS number.

### Running the Vivado evaluation for Libra

12. Replace `Core.v` with `Core-Libra.v` on your disk and rerun the implementation, again adjusting the constraint slightly if necessary.

### Expected results

The following results are reported in the paper. Keep in mind that because the synthesis process is not deterministic, results may vary.

|              |    LUT |     FF |
|--------------|-------:|-------:|
| Core.v       | 16,531 | 13,566 |
| Core-Libra.v | 18,414 | 14,850 |
| **Increase** | +11.4% |  +9.5% |
