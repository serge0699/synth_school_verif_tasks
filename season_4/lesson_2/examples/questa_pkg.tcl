# Import environment variables
set TOP $::env(TOP)
set OUT $::env(OUT)
set WAVES $::env(WAVES)
set COV $::env(COV)

# Create VCD
if $WAVES {
    vcd file $OUT/sim.vcd;
    vcd add $TOP/intf_master/*
    vcd add $TOP/intf_slave/*
}

# Run
if { ![batch_mode] && $WAVES } {
    add wave -position end sim:/$TOP/*
    add wave -noupdate -expand -group Master /$TOP/intf_master/*
    add wave -noupdate -expand -group Slave /$TOP/intf_slave/*
};
run -a;

# Coverage
if $COV {
    coverage report -details;
}

# Format and exit
if { ![batch_mode] && $WAVES } {config wave -signalnamewidth 1; wave zoom full};
if  [batch_mode] {exit -force};

