**SimpleRISC Processor Implementation in Verilog**
A hardware implementation of a simplified RISC architecture using Verilog HDL, featuring pipelined execution and hazard detection.

**Key Features**
16-bit data path with reduced instruction set

5-stage pipeline architecture (FETCH, DECODE, EXECUTE, MEMORY, WRITE-BACK)

Hazard detection and forwarding unit

Support for arithmetic, logical, and memory operations

Compact 32-bit instruction encoding


**Simulation Setup**
**Prerequisites**
Icarus Verilog (iverilog v11.0+)
GTKWave (for waveform visualization)

**Running Simulations**
1.Prepare test program:
<pre> ```nano data.bin  # Insert machine code instructions ``` </pre>

2.Compile and execute:
<pre> ```iverilog -o alu.vvp alu.v
vvp alu.vvp
```</pre>

3.View waveforms:
<pre> ```gtkwave output_wave.vcd ``` </pre>

**Sample Program**
Demonstration of core functionality:
<pre> ```; Initialize registers with new values
mov r2, 0x10      // Load immediate value 0x10 into r2
mov r6, 0x05      // Load immediate value 0x05 into r6
mov r8, 0x20      // Load immediate value 0x20 into r8

; Perform arithmetic and logic operations
sub r9, r2, r6    // r9 = r2 - r6
and r10, r2, r8   // r10 = r2 AND r8

; Memory operations
st r2, 0x04[r6]   // Store r2 at memory address (r6 + 0x04)
ld r11, 0x04[r6]  // Load value from memory (r6 + 0x04) into r11
 ``` </pre>

Example Machine Code
<pre> ```01001100100000000000000000010000  ; mov r2, 0x10
01001101100000000000000000000101  ; mov r6, 0x05
01001110000000000000000000100000  ; mov r8, 0x20
00000010010000100110000000000000  ; sub r9, r2, r6
00010010100000101000000000000000  ; and r10, r2, r8
01111100100001100000000000000100  ; st r2, 0x04[r6]
01110110110001100000000000000100  ; ld r11, 0x04[r6] ``` </pre>

![image](https://github.com/user-attachments/assets/41625618-046b-4561-824a-70795c4e5da7)

**Implementation Details**
 Key components include:

Pipeline Control Unit: Manages instruction flow through stages

Forwarding Logic: Resolves data hazards without stalling

ALU: Supports 8 core operations (ADD, SUB, AND, OR, etc.)

Memory Interface: Byte-addressable load/store operations.



