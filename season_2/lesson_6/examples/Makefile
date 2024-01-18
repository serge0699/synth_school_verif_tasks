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
##   ------------------------------------------------------------
##   --- lower arguments is only for package-based testbench  ---
##   ------------------------------------------------------------
##   * WITH_PKG - if example uses package - set this to '1',
##                default is '0'
##   * DUT - design under test name if example uses package,
##           default is 'pow'
##   * INTF - interface name if example uses package,
##            default is 'axis_intf'
##   * EXAMPLE_REUSE - set to another example folder, if you want
##                     to reuse sources from that example,
##                     default is ''
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
##   * Run example 12_pow with GUI and package mode
##     | make EXAMPLE=12_pow SIM_OPTS=-gui WITH_PKG=1
##
##   * Run example 13_complex in package mode with usage of
##     sources from example 12_pow and with DUT name 'complex'
##     | make EXAMPLE=13_complex WITH_PKG=1 EXAMPLE_REUSE=12_pow \
##     | SIM_OPTS=-gui DUT=complex
##     
##-----------------------------------------------------------------------

# Example select
EXAMPLE = 01_sum

# Example code reuse select
EXAMPLE_REUSE =

# Top simulation module select
TOP = testbench
export TOP

# Output directory
OUT = $(EXAMPLE)/out
export OUT

# Waveforms save enable
WAVES = 1
export WAVES

# Package-based testbench flag
WITH_PKG = 0

# DUT file name if package-based testbench
DUT = pow

# Interface name if package-based testbench
INTF = axis_intf

# Temporary directories and files
TEMP_DIRS   = $(shell find -maxdepth 2 -path "./*/*" -type d)
TEMP_FILES  = $(shell find -mindepth 2 ! -wholename "*/*.*v" -not -path "./*/*" -type f)
TEMP_FILES += $(shell find -name "*.ini" -type f)

# Compilation options
COMP_OPTS = 

# Simulation options
SIM_OPTS = -c
ifneq ($(WITH_PKG),0)
	SIM_OPTS += +incdir=$(EXAMPLE) -permit_unmatched_virtual_intf
	ifneq ($(EXAMPLE_REUSE),)
		SIM_OPTS += +incdir=$(EXAMPLE_REUSE)
	endif
endif

# Compile Verilog / SystemVerilog files from example directory
ifeq ($(WITH_PKG),0)
	VERILOG = $(shell find $(EXAMPLE)/ -name "*.*v")
else
	ifneq ($(EXAMPLE_REUSE),)
		VERILOG += $(shell find $(EXAMPLE_REUSE)/ -name "*_pkg.*v")
		VERILOG += $(EXAMPLE_REUSE)/$(INTF).sv
	else
		VERILOG += $(EXAMPLE)/$(INTF).sv
	endif
	VERILOG += $(shell find $(EXAMPLE)/ -name "*_pkg.*v")
	VERILOG += $(EXAMPLE)/$(DUT).sv
	VERILOG += $(EXAMPLE)/$(TOP).sv
endif

# All Verilog / SystemVerilog files from example directory
ALL_VERILOG = $(shell find $(EXAMPLE)/ -name "*.*v")

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
ifneq ($(ALL_VERILOG),) # Guard on compilation only from existing example
$(OUT)/compile.stamp: $(ALL_VERILOG) | $(OUT)
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