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
    addi $1, $0, 0x00a3
    sw $1, 0x0050($0)       # (0x50) 0 + a3 = a3
    j start
    nop
start:
    addi $8, $0, 0xf        # im[3:0] = 1111
exc_ena:
    mtc0 $8, $12            # c0_status: enable exc and intr
int:
    lw $9, 0x0050($0)       # $9 = a3
    addi $10, $9, 1         # $10 = a4
exit:
    j exit
    nop