onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group FPGA /Lab2task3_testbench/HEX0
add wave -noupdate -expand -group FPGA /Lab2task3_testbench/HEX1
add wave -noupdate -expand -group FPGA /Lab2task3_testbench/HEX2
add wave -noupdate -expand -group FPGA /Lab2task3_testbench/HEX3
add wave -noupdate -expand -group FPGA /Lab2task3_testbench/HEX4
add wave -noupdate -expand -group FPGA /Lab2task3_testbench/HEX5
add wave -noupdate -expand -group FPGA /Lab2task3_testbench/KEY
add wave -noupdate -expand -group FPGA /Lab2task3_testbench/LEDR
add wave -noupdate -expand -group FPGA /Lab2task3_testbench/i
add wave -noupdate -expand -group FPGA -expand /Lab2task3_testbench/SW
add wave -noupdate /Lab2task3_testbench/address
add wave -noupdate /Lab2task3_testbench/clock
add wave -noupdate /Lab2task3_testbench/data
add wave -noupdate /Lab2task3_testbench/whichMem
add wave -noupdate /Lab2task3_testbench/wren
add wave -noupdate /Lab2task3_testbench/L2T3/DataOut
add wave -noupdate -expand -group {Task 3} /Lab2task3_testbench/L2T3/t3/clock
add wave -noupdate -expand -group {Task 3} /Lab2task3_testbench/L2T3/t3/data
add wave -noupdate -expand -group {Task 3} /Lab2task3_testbench/L2T3/t3/q
add wave -noupdate -expand -group {Task 3} /Lab2task3_testbench/L2T3/t3/rdaddress
add wave -noupdate -expand -group {Task 3} /Lab2task3_testbench/L2T3/t3/sub_wire0
add wave -noupdate -expand -group {Task 3} /Lab2task3_testbench/L2T3/t3/wraddress
add wave -noupdate -expand -group {Task 3} /Lab2task3_testbench/L2T3/t3/wren
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {606 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {2287 ps} {3301 ps}
