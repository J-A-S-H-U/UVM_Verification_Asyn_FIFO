vlib work
vdel -all
vlib work

vlog interface.sv

vlog w2rsync.sv
vlog r2wsync.sv
vlog write_ptr.sv
vlog read_ptr.sv
vlog fifo_mem.sv
vlog top.sv

vlog environment.sv
vlog test.sv
vlog tb_top.sv

#vsim work.tb_top
vsim -coverage -vopt work.tb_top 


run -all
vcover report -html sv_fifo_coverage
coverage report -detail