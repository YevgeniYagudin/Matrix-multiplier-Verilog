![image](https://github.com/user-attachments/assets/68bb0288-93af-4cf0-884f-df6b3875b290)
Matrix Multiplication Hardware Accelerator
This project implements a hardware accelerator for matrix multiplication using Verilog and SystemVerilog. The design efficiently computes 
F=A*B+C with configurable parameters and robust error handling, including overflow, underflow, and negative flags.

The architecture is divided into three key blocks:
1. AMBA APB Interface: Handles variable bus widths (16, 32, 64 bits) for flexible integration and seamless data movement with the CPU.
2. Operand Memory and Scratchpad: Stores two operand matrices and up to four result matrices, supporting variable data widths (8, 16, 32 bits) for efficient data reuse.
3. Systolic Array: Implements an optimized multiplication algorithm for high-performance matrix computations.

Features:
Configurable matrix dimensions, data widths, and bus widths for flexibility across applications.
Efficiently performs F=A*B+C with minimal memory transfers.
Built-in overflow, underflow, and negative result flags for robust error handling.
Supports storage of two operand matrices and up to four result matrices in internal memory.
RTL Code: Written in Verilog-2005 and SystemVerilog.
Documentation: Includes design overview, block diagrams, and operational details.
Verification: SystemVerilog testbench for validating functionality and scalability.
This project combines flexibility, performance, and robust error detection for matrix multiplication, making it ideal for various applications.
![image](https://github.com/user-attachments/assets/71b9fbdf-56d0-4b67-8868-4efb7b7b07f9)
