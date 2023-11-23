# Example select
EXAMPLE = 01_sum

# Top simulation module select
TOP = testbench
export TOP

# Output directory
OUT = $(EXAMPLE)/out
export OUT

# Waveforms save enable
WAVES = 1
export WAVES

# Temporary directories and files
TEMP_DIRS   = $(shell find -maxdepth 2 -path "./*/*" -type d)
TEMP_FILES  = $(shell find -mindepth 2 ! -wholename "*/*.*v" -not -path "./*/*" -type f)
TEMP_FILES += $(shell find -name "*.ini" -type f)

# Simulation options
SIM_OPTS = -c

# All Verilog / SystemVerilog files from example directory
VERILOG = $(shell find $(EXAMPLE)/ -name "*.*v")

# Verbosity
v = @

.PHONY: run clean clean_all

# Run target
run: $(OUT)/compile.stamp
	@echo "Running $(EXAMPLE) (log file at $(OUT)/sim.log) ..."
	$(v)vsim $(SIM_OPTS) work.$(TOP) -do questa.tcl \
		-voptargs="+acc" -l $(OUT)/sim.log -wlf $(OUT)/sim.wlf > $(OUT)/sim.log

# Clean target
clean:
	@echo "Removing $(OUT) ..."
	$(v)rm -rf $(OUT)

# Clean all target
clean_all:
	@echo "Cleaning ..."
	@for dir in $(TEMP_DIRS); do \
		echo "Removing $$dir ..."; \
		rm -rf $$dir; \
	done
	@for file in $(TEMP_FILES); do \
		echo "Removing $$file ..."; \
		rm $$file; \
	done
	@echo "Cleaning done"

# Compile target
ifneq ($(VERILOG),) # Guard on compilation only from existing example
$(OUT)/compile.stamp: $(VERILOG) | $(OUT)
	@echo "Compiling $(EXAMPLE) (log file at $(OUT)/compile.log) ..."
	$(v)vlib $(OUT)/work > $(OUT)/compile.log
	$(v)vmap work $(OUT)/work >> $(OUT)/compile.log
	$(v)vlog -sv -work work $(VERILOG) >> $(OUT)/compile.log
	@touch $@
endif

# Output directory target
$(OUT):
	@mkdir -p $@