# riscv-multicycle-vivado-rtl
Multicycle RISC-V RTL processor with execution control, implemented and verified in Vivado up to post-implementation timing simulation.


## Features
- Multicycle datapath with centralized control FSM
- Instruction stop / resume control mechanism
- Synthesizable SystemVerilog RTL
- Verified using functional and post-implementation timing simulation

## Tool Flow
- RTL design in SystemVerilog
- Functional simulation
- Synthesis and implementation in Vivado
- Post-implementation timing simulation (timing clean)


## Repository Structure
rtl/          # RTL source files  
tb/           # Testbench  
constraints/  # XDC constraints  

