main:
    addi	$t0,$zero,0x0111    #$t0=0x00000111
    addiu	$t0,$zero,0x0eee    #$t0=0x00000eee
    andi	$t1,$t0,0xfff0      #$t1=0x00000ee0
    ori	    $t1,$t0,0xfff0      #$t1=0x0000fffe
    xori    $t1,$t0,0xffff      #$t1=0x0000f111
    lui     $t0,0x1111
    #这里有MARS个bug，addi用十六进制表示负数的话
    #MARS会把它汇编成lui,ori,add的组合，导致符号拓展出现问题
    addi	$t0,$zero,-2        #$t0=-2(0xfffffffe)
    #这里有MARS个bug，无法用十六进制表示负数
    #比如写-100就可以汇编通过，0xff9c就会报错
    #"0xff9c": operand is out of range
    slti    $t1,$t0,-3          #$t1=0
    slti    $t1,$t0,0x0001      #$t1=1
    sltiu   $t1,$t0,-1          #$t1=1
    sltiu   $t1,$t0,0x0001      #$t1=0