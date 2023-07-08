onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand /task2RAM_testbench/address
add wave -noupdate /task2RAM_testbench/clock
add wave -noupdate -expand /task2RAM_testbench/data
add wave -noupdate -expand /task2RAM_testbench/q
add wave -noupdate /task2RAM_testbench/wren
add wave -noupdate -expand /task2RAM_testbench/dut/q
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1165852391 ps} 0}
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
WaveRestoreZoom {10700716400 ps} {10700717400 ps}
