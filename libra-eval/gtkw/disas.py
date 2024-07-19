#!/usr/bin/env python3

import sys
import util

def output(line):
  print(line, flush=True)

for line in sys.stdin:
  try:
    hexstring = line.strip()
    instr = bytes(reversed(bytes.fromhex(hexstring)))
    output(util.disassemble(instr))
  except:
    output('???')
