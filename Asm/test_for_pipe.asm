main:
    addi $4, $0, 80 # $4=80(0x0050)
    addi $1, $0, 0x000000a3
    sw $1, 0($4)    # ram[0x0050]=0x000000a3
    addi $1, $0, 0x00000027
    sw $1, 4($4)    # ram[0x0054]=0x00000027 a3+27=ca
    addi $1, $0, 0x00000079
    sw $1, 8($4)    # ram[0x0058]=0x00000079 ca+79=143
    addi $1, $0, 0x00000115
    sw $1, 12($4)   # ram[0x005c]=0x00000115 143+115=258

    lui $1, 0       # $1=0
    ori $4, $1, 80  # $4=80(0x0050)
call:
    jal sum         # $31=16(0x0010)
dslot1:
    addi $5, $0, 4  # $5=4
return:
    sw $2, 0($4)    # ram[0x0060]=0x00000258
    lw $9, 0($4)    # $9=0x00000258
    sub $8, $9, $4  # $8=0x00000258-0x00000060=0x000001f8
    addi $5, $0, 3  # $5=3
loop2:
    addi $5, $5, -1
    ori $8, $5, 0xffff
    xori $8, $8, 0x5555 # $8=0x0000aaaa
    addi $9, $0, -1     # $9=0xffffffff
    andi $10, $9, 0xffff    # $10=0x0000ffff
    or $6, $10, $9      # $6=0xffffffff
    xor $8, $10, $9     # $8=0xffff0000
    and $7, $10, $6     # $7=0x0000ffff
    beq $5, $0, shift
dslot2:
    nop         # 就是sll $zero $zero 0
    j loop2
dslot3:
    nop
shift:
    addi $5, $0, -1     # $5=0xffffffff
    sll $8, $5, 15      # $8=0xffff8000
    sll $8, $8, 16      # $8=0x80000000
    sra $8, $8, 16      # $8=0xffff8000
    srl $8, $8, 15      # $8=0x0001ffff
finish:
    j finish
dslot4:
    nop
sum:
    add $8, $0, $0  # $8=0
loop:
    lw $9, 0($4)
stall:
    add $8, $8, $9  # 四次,$8加到0x258
    addi $5, $5, -1
    bne $5, $0, loop
dslot5:
    addi $4, $4, 4
    jr $31
dslot6:
    sll $2, $8, 0   # $2=258
