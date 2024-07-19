PYTHON = python3
CORE ?= dynamicExtMem

all: report.tex

report.tex:
	$(PYTHON) run-benchmarks.py

security:
	./run-security-evaluation.sh $(CORE) keypad
	# ./run-security-evaluation.sh $(CORE) kruskal        # fails
	./run-security-evaluation.sh $(CORE) bsl
	./run-security-evaluation.sh $(CORE) diamond
	./run-security-evaluation.sh $(CORE) fork
	./run-security-evaluation.sh $(CORE) ifthenloop
	./run-security-evaluation.sh $(CORE) modexp2
	./run-security-evaluation.sh $(CORE) mulmod16
	./run-security-evaluation.sh $(CORE) sharevalue
	./run-security-evaluation.sh $(CORE) switch
	./run-security-evaluation.sh $(CORE) triangle

clean:
	$(RM) report.tex

cleanresults:
	find . -name \*.results | xargs -r rm

realclean:
	$(MAKE) clean
	$(MAKE) cleanresults
	$(PYTHON) run-benchmarks.py clean
