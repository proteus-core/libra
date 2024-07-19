import os
import sys
import subprocess
import re
import scipy.stats

#############################################################################
class Result:
  def __init__(self, name, size, cycles):
    self.name = name
    self.size = size
    self.cycles = cycles

#############################################################################
def load(results, folder, benchmark):
  with open("%s/%s.results" % (folder, benchmark)) as f:
    fread = f.read()
    m = re.search("size=(\d+)", fread)
    assert m, benchmark
    size = m.group(1)
    m = re.search("cycles=(\d+)", fread)
    assert m, benchmark
    cycles = m.group(1)
    results[benchmark] = Result(benchmark, float(size), float(cycles))

#############################################################################
def latex(benchmarks, results):
  tex = open("results.tex", "w")
  assert tex

  # Binary size
  tex.write("% Binary size\n")
  array = []
  for benchmark in benchmarks:
    baseline = results[benchmark]
    balanced = results["%s-balanced" % benchmark]
    linear   = results["%s-linear"   % benchmark]
    folded   = results["%s-folded"   % benchmark]

    b = balanced.size / baseline.size
    l = linear.size   / baseline.size
    f = folded.size   / baseline.size

    array.append((baseline.size, b, l, f))

    tex.write("%s" % benchmark)

    # Baseline
    tex.write(" & %d" % baseline.size)

    # Relative size overhead
    tex.write(" & %.2f" % b)
    tex.write(" & %.2f" % l)
    tex.write(" & %.2f" % f)

    tex.write(" \\\\\n");

  tex.write("\\textbf{mean}")
  tex.write(" &")
  tex.write(" & \\textbf{%.2f}" % scipy.stats.gmean(array)[1])
  tex.write(" & \\textbf{%.2f}" % scipy.stats.gmean(array)[2])
  tex.write(" & \\textbf{%.2f}" % scipy.stats.gmean(array)[3])

  tex.write("\\\\\n\n")

  # Running time
  tex.write("% Execution time\n")
  array = []
  for benchmark in benchmarks:
    baseline = results[benchmark]
    balanced = results["%s-balanced" % benchmark]
    linear   = results["%s-linear"   % benchmark]
    folded   = results["%s-folded"   % benchmark]

    b = balanced.cycles / baseline.cycles
    l = linear.cycles   / baseline.cycles
    f = folded.cycles   / baseline.cycles

    array.append((baseline.cycles, b, l, f))

    tex.write("%s" % benchmark)

    # Baseline
    tex.write(" & %d" % baseline.cycles)

    # Relative cycles overhead
    tex.write(" & %.2f" % b)
    tex.write(" & %.2f" % l)
    tex.write(" & %.2f" % f)

    tex.write(" \\\\\n");

  tex.write("\\textbf{mean}")
  tex.write(" &")
  tex.write(" & \\textbf{%.2f}" % scipy.stats.gmean(array)[1])
  tex.write(" & \\textbf{%.2f}" % scipy.stats.gmean(array)[2])
  tex.write(" & \\textbf{%.2f}" % scipy.stats.gmean(array)[3])
  tex.write("\\\\\n\n")

  tex.close()

#############################################################################
if __name__ == "__main__":
  
  blacklist = []
  blacklist += [".git"]
  blacklist += ["__pycache__"]
  blacklist += ["tools"]
  blacklist += ["gtkw"]
  blacklist += ["test"]
  blacklist += ["lrcall"]

  benchmarks = [x for x in os.listdir(".") if os.path.isdir(x)]
  benchmarks = [x for x in benchmarks if x not in blacklist]
  
  # Run the benchmarks and perform the different evaluations
  target = "all"
  if len(sys.argv) > 1:
    target = sys.argv[1]

  for benchmark in benchmarks:
    result = subprocess.run(["make", "-C", benchmark, target])
    if result.returncode != 0:
      sys.exit(result.returncode)

  if target == 'all':

    # Load the performance results
    results = {}
    for benchmark in benchmarks:
      load(results, benchmark, benchmark)
      load(results, benchmark, "%s-linear"   % benchmark)
      load(results, benchmark, "%s-balanced" % benchmark)
      load(results, benchmark, "%s-folded"   % benchmark)

    latex(benchmarks, results)
