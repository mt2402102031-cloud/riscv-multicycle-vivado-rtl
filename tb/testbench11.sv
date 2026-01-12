//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Annu kumar 
// 
// Create Date: 07/17/2025 03:18:05 PM
// Design Name: 
// Module Name: testbench
// Project Name: 
// Target Devices: basys3 board
// Tool Versions: 2018.3
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module top_tb;

  logic clk ;
  logic reset;
  logic IR_SW, IED, IEA;
  logic XWE, XED;
  logic MemWrite;
  logic [31:0] WriteData;
  logic [31:0] ReadData;
  //logic [31:0] DataAdr1;
  //logic [31:0] WriteData_con1;
  //logic MemWrite_o;
  // Clock generation
  always #5 clk = ~clk;

  // Instantiate DUT
  top uut (
    .clk(clk),
    .reset(reset),
    .IR_SW(IR_SW),
    .IED(IED),
    .IEA(IEA),
    .XWE(XWE),
    .XED(XED),
    .MemWrite(MemWrite),
    .WriteData(WriteData),
    .ReadData(ReadData)
   // .DataAdr1(DataAdr1)
   // .WriteData_con1(WriteData_con1),
   // .MemWrite_o(MemWrite_o)
  );

  task load_instruction(input [31:0] addr, input [31:0] instr);
    begin
      // Address phase
      WriteData = addr;
       XED = 1; IEA=1;
       @(negedge clk);
       XED=0;  
       IED = 1; XWE = 1;
      WriteData = instr; MemWrite = 1;
      @(negedge clk);
       MemWrite = 0;
    end
  endtask

  initial begin
   clk = '0;
   reset = 0;
  end

  initial begin
    $display("==== BEGIN SIM ====");

    // Initial reset and signal defaults
    @(negedge clk);
    reset = 1'b1;
    IR_SW = 1'b1; XED = 0; XWE = 0; IED = 0; IEA = 0;
    MemWrite = 0; WriteData = 0;
    @(negedge clk);
     reset = 1;
    repeat(3)
    @(negedge clk);
      reset = 0;
    end

  initial begin
   @(negedge reset);
          XED = 1; IEA=1;
          repeat(6)
   @(negedge clk);
      // Load instructions starting from 0x00
      
    load_instruction(32'h00000000, 32'h00500113);  // addi x2, x0, 5
    
    load_instruction(32'h00000004, 32'h00C00193);  // addi x3, x0, 12
    load_instruction(32'h00000008, 32'hFF718393);  // addi x7, x3, -9
    load_instruction(32'h0000000C, 32'h0023E233);  // and  x4, x7, x2
    load_instruction(32'h00000010, 32'h0041F2B3);  // or   x5, x3, x4
    load_instruction(32'h00000014, 32'h004282B3);  // add  x5, x5, x4
    load_instruction(32'h00000018, 32'h02728863);  // beq  x5, x7, skip
    load_instruction(32'h0000001C, 32'h0041A233);  // xor  x4, x3, x4
    load_instruction(32'h00000020, 32'h00020463);  // beq  x4, x0, skip
    load_instruction(32'h00000024, 32'h00000293);  // addi x5, x0, 0
    load_instruction(32'h00000028, 32'h0023A233);  // xor  x4, x7, x2
    load_instruction(32'h0000002C, 32'h005203B3);  // add  x7, x4, x5
    load_instruction(32'h00000030, 32'h402383B3);  // sub  x7, x7, x2
    load_instruction(32'h00000034, 32'h0471AA23);  // sw   x7, 72(x3)
    load_instruction(32'h00000038, 32'h06002103);  // lw   x2, 96(x0)
    load_instruction(32'h0000003C, 32'h005104B3);  // add  x9, x2, x5
    load_instruction(32'h00000040, 32'h008001EF);  // jal  x3, 8
    load_instruction(32'h00000044, 32'h00100113);  // addi x2, x0, 1
    load_instruction(32'h00000048, 32'h00910133);  // add  x2, x2, x9
    load_instruction(32'h0000004C, 32'h0221A023);  // sw   x2, 32(x3)
    load_instruction(32'h00000050, 32'h00210063);  // beq  x2, x2, next

    reset = 1;
    repeat (2)
    @(negedge clk);
    XWE = 0; IED = 0; IEA = 0;
     @(negedge clk);
     IR_SW = 1'b0;
    repeat (2) @(negedge clk);
    @(posedge clk)
    #1;
    reset = 0;
    repeat(73)
     @(negedge clk);
 
     IR_SW = 1'b1;
    WriteData = 32'h00000064; XED = 1 ;IEA = 1;
     @(negedge clk); 
    XED = 0 ;
    
    repeat (2) @(negedge clk);
    $display("[TB] Final ReadData = %0d", ReadData);
    if (ReadData == 25)
      $display("[TB]  PASS: mem[100] = %0d", ReadData);
    else
      $display("[TB]  FAIL: mem[100] = %0d (Expected 25)", ReadData);
   $stop;
  end

endmodule


