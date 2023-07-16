main:
    j pre_start
    nop
exc_base:
    mfc0 $26, $13           # c0_cause
    andi $27, $26, 0xc      # exccode
    lw $27, 0x20($27)       # j_table 0x20
    nop
    jr $27
    nop
int_entry:
    nop                     # 这个nop理解成中断处理做的事就行了
    eret
    nop
sys_entry:
    nop
epc_plus4:
    mfc0 $26, $14           # c0_epc
    addi $26, $26, 4
    mtc0 $26, $14           # c0_epc
e_return:
    eret
    nop
uni_entry:
    nop
    j epc_plus4
    nop
ovr_entry:
    nop
    j exit
    nop

pre_start:
    addi $1, $0, 0x20
    sw $1, 0x0020($0)       # (0x20) 0. int_entry
    addi $1, $0, 0x2c
    sw $1, 0x0024($0)       # (0x24) 1. sys_entry
    addi $1, $0, 0x44
    sw $1, 0x0028($0)       # (0x28) 2. uni_entry
    addi $1, $0, 0x50
    sw $1, 0x002c($0)       # (0x2c) 3. ovr_entry
    addi $1, $0, 0x0002
    sw $1, 0x0048($0)       # (0x48) for testing overflow
    addi $1, $0, -1
    srl $1, $1, 1
    sw $1, 0x004c($0)       # (0x4c) 2 + max_int -> overflow
    addi $1, $0, 0x00a3
    sw $1, 0x0050($0)       # (0x50) 0 + a3 = a3
    addi $1, $0, 0x0027
    sw $1, 0x0054($0)       # (0x54) a3 + 27 = ca
    addi $1, $0, 0x0079
    sw $1, 0x0058($0)       # (0x58) ca + 79 = 143
    addi $1, $0, 0x0115
    sw $1, 0x005c($0)       # (0x5c) 143 + 115 = 258
    j start
    nop
start:
    addi $8, $0, 0xf        # im[3:0] = 1111
exc_ena:
    mtc0 $8, $12            # c0_status: enable exc and intr
unimpl:
    div $9, $8              # unimplemented instruction
    nop
sys:
    syscall
    nop
int:
    ori $4, $0, 0x50
    addi $5, $0, 4
    add $8, $0, $0
loop:
    lw $9, 0($4)
    add $8, $8, $9
    addi $5, $5, -1
    bne $5, $0, loop
    addi $4, $4, 4
ov:
    lw $8, 0x48($0)
    lw $9, 0x4c($0)
forever:
    j start
    add $9, $9, $8          # overflow
exit:
    j exit
    nop