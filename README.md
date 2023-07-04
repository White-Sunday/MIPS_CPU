# README

继续我的mips处理器设计之旅~

MIPS_CPU：多周期无流水线mips风格处理器，实现36条指令

MPS_CPU_P：多周期流水线mips风格处理器，实现36条指令

## MIPS_CPU

> 已经完成，是个比较简单的处理器设计，有很多不优美的地方，但用来应付课程设计足够。



## MIPS_CPU_P

> 本来打算只做一个流水版本（pipe），现在在尝试做高级版本（pro）

### 用到的一些优化策略

#### Carry Lookahead Adder

自己使用verilog语言实现一个Carry Lookahead Adder（CLA），即超前进位加法器来代替直接使用`+`运算符实现的加法器。

Carry Lookahead Adder是一种优化的加法器，它利用预先计算的进位信号（Carry）来加速加法运算。

相比之下，使用`+`运算符实现加法器是一种串行的加法器，需要等待每个位的进位信号传递到下一位。（来自gpt）

