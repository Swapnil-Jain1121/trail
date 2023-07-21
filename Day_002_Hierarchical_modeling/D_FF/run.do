#compilation
vlog tb_D_FF_Behavioral.v

#elaboration
vsim -novopt -suppress 12110 tb

#adding signals to the wave
add wave -position insertpoint sim:/tb/*

#simulation
run -all