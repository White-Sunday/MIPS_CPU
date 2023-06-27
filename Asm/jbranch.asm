main:
    addi $t0,$zero,0
    j label
    addi $t0,$zero,1
label:
    addi $t0,$zero,2
    jal func
    sll	$zero, $zero, 0	#流水NOP
    addi $t0,$zero,3
func:
    addi $t0,$zero,4
    jr $ra
