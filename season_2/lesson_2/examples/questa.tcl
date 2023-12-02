# Import environment variables
set TOP $::env(TOP)
set OUT $::env(OUT)
set WAVES $::env(WAVES)

# Create VCD
if $WAVES {
    vcd file $OUT/sim.vcd;
    vcd add $TOP/*
}

# Run
if { ![batch_mode] && $WAVES } {add wave -position end sim:/$TOP/*};
run -a;
if { ![batch_mode] && $WAVES } {config wave -signalnamewidth 1; wave zoom full};
if  [batch_mode] {exit -force};
