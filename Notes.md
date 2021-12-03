Overall
=======

PC should be able to connect to writereg via mux with mem/alu result.(For link instructions)
Add a mux before write register with constant 11111, this write the next program count to the 31st register.
Add mux to select if address come from register or instruction for jump instructions

ALU
===

Change "Zero" port to "branch_con"
Will be asserted if condition satisfied

Control
=======

Add a new output "link" to write the program count into the 31st register
Need new input "branch_type" to indicate if the branch need to link
Need new output jump_reg

Register File
=============

"HI & LO"?
Need to be addressed but not sure how


