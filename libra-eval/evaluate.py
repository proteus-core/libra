import ProteusVCD
import sys
import os
import importlib

#############################################################################
if __name__ == '__main__':

  # Parse command line
  assert len(sys.argv) > 1, "Benchmark name expected"
  benchmark = sys.argv[1]

  # Load VCD file
  vcd = ProteusVCD.ProteusVCD("%s.vcd" % benchmark)
  
  with open("%s.results" % benchmark, "w") as f:
    
    def write(msg):
      f.write("%s" % msg)

    def writeln(msg):
      f.write("%s\n" % msg)

    writeln("benchmark=%s" % benchmark)

    # 1. Correctness evaluation (benchmark specific)
    # Dynamically import "<benchmark>.py" and verify correctness by comparing
    # the expected results with the actual results.
    write("Correctness evaluation:")
    basename = benchmark.split("-")[0]
    m = importlib.import_module("%s.%s" % (basename, basename))
    m.verify_correctness(benchmark, f, vcd)
    writeln("OK");

    # 2. Performance evaluation (generic)
    writeln("Performance evaluation:")
    writeln("size=%d" % os.path.getsize("%s.bin" % benchmark))
    writeln("cycles=%d" % vcd.total_cycles())
