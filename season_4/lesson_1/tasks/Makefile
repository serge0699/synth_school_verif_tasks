.PHONY: cov

# Coverage target
cov: run
	@echo "Collecting statistics to $(OUT)/stats (log file at $(OUT)/stats.log)..."
	$(v)vcover report -details -html -htmldir \
		$(OUT)/stats $(OUT)/cov.ucdb > $(OUT)/stats.log

include ../examples/Makefile