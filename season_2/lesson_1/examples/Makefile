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
##   * EXT_POSTFIX - additional extension to compile
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
##   * Run example 06_alu with GUI and .svp files compile and
##     passing define VERSION_4 to the compilation
##     | make EXAMPLE=06_alu SIM_OPTS=-gui COMP_OPTS=+define+VERSION_4 \
##     |   EXT_POSTFIX=svp
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

# Extension postfix
# This option will allow us to simulate custom extensions
EXT_POSTFIX = none

# All Verilog / SystemVerilog files from example directory
VERILOG = $(shell find $(EXAMPLE)/ -name "*.*v")

# All custom extensions files
VERILOG += $(shell find $(EXAMPLE)/ -name "*.$(EXT_POSTFIX)")

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
$(OUT)/compile.stamp: $(VERILOG) $(OUT)/EXT_POSTFIX.$(EXT_POSTFIX) \
	$(OUT)/COMP_OPTS.$(subst /,,$(COMP_OPTS)) | $(OUT)
	@echo "Compiling $(EXAMPLE) (log file at $(OUT)/compile.log) ..."
	$(v)vlib $(OUT)/work > $(OUT)/compile.log
	$(v)vmap work $(OUT)/work >> $(OUT)/compile.log
	$(v)vlog -sv $(COMP_OPTS) -work work $(VERILOG) >> $(OUT)/compile.log
	@touch $@
endif

# Compilation options target
# Because we depend on this variable for compilation
$(OUT)/COMP_OPTS.$(subst /,,$(COMP_OPTS)): | $(OUT)
	$(v)rm -f $(OUT)/COMP_OPTS.*
	@touch $@

# Extension postfix target
# Because we depend on this variable for compilation
$(OUT)/EXT_POSTFIX.$(EXT_POSTFIX): | $(OUT)
	$(v)rm -f $(OUT)/EXT_POSTFIX.*
	@touch $@

# Output directory target
$(OUT):
	@mkdir -p $@

include ../../common/make_help.mk