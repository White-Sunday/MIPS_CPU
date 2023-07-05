# 知识积累

继续我的mips处理器设计之旅~

MIPS_CPU：多周期无流水线mips风格处理器，实现36条指令

MPS_CPU_P：多周期流水线mips风格处理器，实现36条指令

注意：前者复位信号高电平有效，后者复位信号低电平有效



## MIPS_CPU

> 已经完成，是个比较简单的处理器设计，有很多不优美的地方，但用来应付课程设计足够。



## MIPS_CPU_P

> 本来打算只做一个流水版本（pipe），现在在尝试做高级版本（pro）

### 用到的一些优化策略

#### Carry Lookahead Adder

**有待商榷**

自己使用verilog语言实现一个Carry Lookahead Adder（CLA），即超前进位加法器来代替直接使用`+`运算符实现的加法器。

Carry Lookahead Adder是一种优化的加法器，它利用预先计算的进位信号（Carry）来加速加法运算。

相比之下，使用`+`运算符实现加法器是一种串行的加法器，需要等待每个位的进位信号传递到下一位。（来自gpt）

**另一种说法**

在Verilog中，使用`+`运算符执行加法操作通常比手动实现全加器（Carry Look-Ahead Adder，CLA）更快和更方便。这是因为现代的Verilog编译器会自动将`+`运算符转换为适合目标设备的最佳加法器实现。

使用`+`运算符，编译器可以利用**目标设备上的硬件加法器**来执行加法操作。硬件加法器通常会使用优化的电路结构和并行处理来实现高效的加法运算。因此，通过使用`+`运算符，您可以充分发挥目标设备的硬件资源和性能。

相比之下，手动实现CLA需要更多的硬件资源和更复杂的逻辑电路。CLA是一种用于高位宽加法的优化算法，可以减少级联加法器的延迟。然而，它需要更多的逻辑门和内部连线，从而增加了电路的复杂性和资源占用。

综上所述，使用`+`运算符执行加法操作通常更快且更方便，而手动实现CLA可能会增加电路复杂性和资源占用。当使用Verilog编写代码时，可以直接使用`+`运算符，并依赖编译器来自动选择最佳的加法器实现。（来自gpt）

**有关简单逻辑的性能差距**

```Verilog
wire rtype = ~op[5]&~op[4]&~op[3]&~op[2]&~op[1]&~op[0];    // op=6'b000000
wire rtype = (op[5:0] == 6'b000000);    // op=6'b000000
```

在这种简单的逻辑表达式中，两种方式的性能差距通常可以忽略不计。**现代的Verilog编译器和综合工具对这种简单的逻辑操作具有高度的优化能力，并且可以自动选择最佳的实现方式。**

在硬件实现方面，两种方式也不会有显著的性能差异。编译器会根据目标设备和设计要求选择合适的电路结构和实现方式，以最大程度地利用硬件资源和优化性能。

因此，在这个特定的例子中，性能差距通常是可以忽略的，您可以根据个人的编程风格和可读性选择更适合您的方式。重要的是编写出清晰、易于理解和维护的代码。（来自gpt）
