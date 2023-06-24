main:
    addi	$t0,$zero,0xffff        #$t0=0xffffffff
    sw    	$t0,0x1000($zero)
    lw	    $t1,0x1000($zero)       #$t1=0xffffffff
    lbu     $t1,0x1000($zero)       #$t1=0x000000ff
    lhu     $t1,0x1000($zero)       #$t1=0x0000ffff
    addi	$t0,$zero,0x0eee        #$t0=0x00000eee
    sb      $t0,0x1000($zero)
    lw	    $t1,0x1000($zero)       #$t1=0xffffffee
    sh      $t0,0x1000($zero)
    lw      $t1,0x1000($zero)       #$t1=0xffff0eee

