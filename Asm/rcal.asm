main:
    addi $t0,$zero,1
    addi $t1,$zero,4
    sll $t2,$t0,3       #$t2=8
    sllv $t2,$t0,$t1    #$t2=16
    srl $t2,$t1,2       #$t2=1
    addi $t1,$zero,-2   #$t1=0xfffffffe
    sra $t2,$t1,1       #$t2=0xffffffff
    srav $t2,$t1,$t0    #$t2=0xffffffff

    addi $t0,$zero,1
    addi $t1,$zero,-1
    slt $t2,$t0,$t1     #$t2=0
    sltu $t2,$t0,$t1    #$t2=1
    addi $t1,$zero,1
    slt $t2,$t0,$t1     #$t2=0
    sltu $t2,$t0,$t1    #$t2=0

    addi $t0,$zero,2
    addi $t1,$zero,-1
    add $t2,$t0,$t1     #$t2=1
    addu $t2,$t0,$t1
    sub $t2,$t0,$t1     #$t2=1
    subu $t2,$t0,$t1
    and $t2,$t0,$t1     #$t2=2
    or $t2,$t0,$t1      #$t2=-1
    xor $t2,$t0,$t1     #$t2=-3(0xfffffffd)
    nor $t2,$t0,$t1     #$t2=0