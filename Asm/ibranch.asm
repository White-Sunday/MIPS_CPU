main:

# bgtz
    addi $t0,$zero,1
    bgtz $t0,label5
    addi $t2,$zero,0
label5:
    addi $t2,$zero,1
    addi $t0,$zero,0
    bgtz $t0,label6
    addi $t2,$zero,0
label6:
    addi $t2,$zero,1

# bltz
    addi $t0,$zero,1
    bltz $t0,label7
    addi $t2,$zero,0
label7:
    addi $t2,$zero,1
    addi $t0,$zero,-1
    bltz $t0,label8
    addi $t2,$zero,0
label8:
    addi $t2,$zero,1

# beq
    addi $t0,$zero,1
    addi $t1,$zero,1
    beq $t0,$t1,label1
    addi $t2,$zero,0
label1:
    addi $t2,$zero,1
    addi $t1,$zero,2
    beq $t0,$t1,label2
    addi $t2,$zero,0
label2:
    addi $t2,$zero,1

# bne
    addi $t0,$zero,1
    addi $t1,$zero,1
    bne $t0,$t1,label3
    addi $t2,$zero,0
label3:
    addi $t2,$zero,1
    addi $t1,$zero,2
    bne $t0,$t1,label4
    addi $t2,$zero,0
label4:
    addi $t2,$zero,1