import sys

assert len(sys.argv) >= 4, "Usage: %s offF offT membC [iCnt]" % sys.argv[0]

offF  = int(sys.argv[1])
offT  = int(sys.argv[2])
membC = int(sys.argv[3])
iCnt  = -1

assert membC > 0 and membC <= 16, "Invalid member count: %d" % membC
assert offF >= 0 and offF < membC, "Invalid offset-on-false: %d" % offF
assert offT >= 0 and offT < membC, "Invalid offset-on-true: %d" % offT

#if membC > 1:
#  assert offT != offF

if len(sys.argv) == 4:
  # Ordinary level-offset branch: FFFF TTTT MMMM
  encoding = ((offF << 8) | (offT << 4) | (membC - 1)) << 1
else:
  # Terminating level-offset branch: FFF TTT MMM III
  assert len(sys.argv) == 5
  iCnt = int(sys.argv[4])
  encoding = ((offF << 9) | (offT << 6) | (membC - 1) << 3 | iCnt) << 1

print("offF(%d):offT(%d):membC(%d):iCnt(%d) -> 0x%03x" % (offF, offT, membC, iCnt, encoding)) 
