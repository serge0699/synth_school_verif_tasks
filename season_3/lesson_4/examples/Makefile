##-----------------------------------------------------------------------
##
## This is common examples/tasks Makefile.
##
## You can run concrete example/task from directory of this Makefile via:
##   make EXAMPLE=<example-directory>
##
## Available arguments:
##   * EXAMPLE - example directory
##   * SIM_OPTS - simulation options, default is '-c'
##   * TOP - top module for simulation, default is 'testbench'
##   * OUT - simulation logs directory, default is '$(EXAMPLE)/out'
##   * WAVES - waveform save enable, default is '1'
##
## Examples:
##
##   * Run example 02_sum with GUI
##     | make EXAMPLE=02_sim SIM_OPTS=-gui
##
##   * Run example 03_sum with GUI with randomization seed 12345
##     | make EXAMPLE=03_sim SIM_OPTS="-gui -sv_seed 12345"
##
##   * Run example 10_initial with GUI with no waveform saving
##     | make EXAMPLE=10_initial SIM_OPTS=-gui WAVES=0
##     
##-----------------------------------------------------------------------

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

# Compilation options
COMP_OPTS = 

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
	$(v)vsim $(SIM_OPTS) work.$(TOP) -work $(OUT)/work -do questa.tcl \
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
	$(v)vlog -sv $(COMP_OPTS) -work work $(VERILOG) >> $(OUT)/compile.log
	@touch $@
endif

# Output directory target
$(OUT):
	@mkdir -p $@

include ../../common/make_help.mk