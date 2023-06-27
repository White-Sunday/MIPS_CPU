main:
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