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
<pre> nano data.bin  # Insert machine code instructions  </pre>

2.Compile and execute:
<pre> iverilog -o alu.vvp alu.v
vvp alu.vvp
</pre>

3.View waveforms:

<pre> gtkwave output_wave.vcd  </pre>

**Sample Program**

Demonstration of core functionality:
<pre> 
mov r2, 0x10     
mov r6, 0x05     
mov r8, 0x20     


sub r9, r2, r6   
and r10, r2, r8   


st r2, 0x04[r6]   
ld r11, 0x04[r6]  
  </pre>

Example Machine Code
<pre> 01001100100000000000000000010000  
01001101100000000000000000000101 
01001110000000000000000000100000 
00000010010000100110000000000000 
00010010100000101000000000000000 
01111100100001100000000000000100  
01110110110001100000000000000100   </pre>

**Output**

![image](https://github.com/user-attachments/assets/41625618-046b-4561-824a-70795c4e5da7)

**Implementation Details**
 Key components include:

Pipeline Control Unit: Manages instruction flow through stages

Forwarding Logic: Resolves data hazards without stalling

ALU: Supports 8 core operations (ADD, SUB, AND, OR, etc.)

Memory Interface: Byte-addressable load/store operations.




