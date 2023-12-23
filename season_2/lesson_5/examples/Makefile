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
endif

# Compile Verilog / SystemVerilog files from example directory
ifeq ($(WITH_PKG),0)
	VERILOG = $(shell find $(EXAMPLE)/ -name "*.*v")
else
	VERILOG =  $(shell find $(EXAMPLE)/ -name "*_pkg.*v")
	VERILOG += $(EXAMPLE)/$(DUT).sv
	VERILOG += $(EXAMPLE)/$(TOP).sv
	VERILOG += $(EXAMPLE)/$(INTF).sv
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