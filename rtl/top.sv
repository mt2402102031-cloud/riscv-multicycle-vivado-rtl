`timescale 1ns / 1ps

module top #(parameter Width=32, Width1 = 1)(input  logic IR_SW,clk, reset, 
           input  logic IED,IEA,
           input  logic XWE,XED,
           input  logic [31:0] WriteData, 
           input  logic MemWrite,
           output logic [31:0] ReadData  //while generating bit stream 31 replace with 21
           //output logic [31:0] DataAdr1,
           //output logic [31:0] WriteData_con1
           );
  logic [6:0] DataAdr1;
  logic [31:0] WriteData_con1;
  logic [31:0] DataAdr;
  logic [31:0] DataAdr_con1,WriteData_con2;//ReadData1;
 // logic [31:0] DataAdr_con2
  logic MemWrite_i,MemWrite_o;
  
  // Instantiate processor and external memory
  riscvmulti rvmulti(IR_SW,clk, reset, MemWrite_i, DataAdr_con1, WriteData_con1, ReadData);
  
//  mux2 #(Width) Emux1(DataAdr_con1,DataAdr,IEA,DataAdr_con2);
  mux2_sp #(Width) Emux1(DataAdr_con1,DataAdr,IEA,DataAdr1);
  mux2 #(Width) Emux2(WriteData_con1,WriteData,IED,WriteData_con2);
  mux2 #(Width1) Emux3(MemWrite_i,MemWrite,XWE,MemWrite_o);

  flopenr #(Width) DataAdrs (clk,reset,XED,{23'b0,WriteData[8:2],2'b0},DataAdr);
 // dmem #(Width) dmem(clk, MemWrite_o, DataAdr_con2, WriteData_con2, ReadData1);
  dmem #(Width) dmem(clk, MemWrite_o, DataAdr1, WriteData_con2, ReadData);
  
 
  // assign ReadData = ReadData1;
 // assign DataAdr1 = DataAdr_con2;
endmodule
