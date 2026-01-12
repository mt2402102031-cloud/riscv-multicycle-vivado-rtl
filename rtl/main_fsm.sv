//`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////
//// Company: 
//// Engineer: 
//// 
//// Create Date: 07/07/2025 12:58:08 PM
//// Design Name: 
//// Module Name: main_fsm
//// Project Name: 
//// Target Devices: 
//// Tool Versions: 
//// Description: 
//// 
//// Dependencies: 
//// 
//// Revision:
//// Revision 0.01 - File Created
//// Additional Comments:
//// 
////////////////////////////////////////////////////////////////////////////////////


module main_fsm(
    input  logic       clk,
    input  logic       reset,
    input  logic [6:0] op,
    input  logic       Zero,
    output logic [1:0] ALUSrcA, ALUSrcB, ALUOp, ResultSrc,
    output logic       AdrSrc,
    output logic       IRWrite, PCUpdate, MemWrite, RegWrite, Branch
);


    typedef enum logic [3:0] {
        S0_FETCH, S1_DECODE, S2_MEMADR, S3_MEMREAD, S4_MEMWB,
        S5_MEMWRITE, S6_EXECUTER, S7_ALUWB, S8_EXECUTEI,
        S9_JAL, S10_BEQ
    } state_t;

    state_t state, next_state;

    // State Transition
    always_ff @(posedge clk or posedge reset) begin
        if (reset) 
            state <= S0_FETCH;
        else 
            state <= next_state;
    end

    // Next State Logic and Output Logic
        // Next State Logic and Output Logic
    always_comb begin
        // Default values for outputs to avoid latches
        IRWrite = 0;
        PCUpdate = 0;
        RegWrite = 0;
        MemWrite = 0;
		  Branch = 0;
        AdrSrc = 0;
        ALUOp = 2'b00;
        ALUSrcA = 2'b00;
        ALUSrcB = 2'b00;
        ResultSrc = 2'b00;
         next_state =  S0_FETCH;

        case (state)
            // Fetch state: Fetch instruction from memory, increment PC
            S0_FETCH: begin
                AdrSrc = 0;
					 IRWrite = 1;
                ALUSrcA = 2'b00;
                ALUSrcB = 2'b10;
                ALUOp = 2'b00;
                ResultSrc = 2'b10;
					 PCUpdate = 1;
                next_state = S1_DECODE;
            end
            
            // Decode state: Decode instruction, set ALUSrc for subsequent operations
            S1_DECODE: begin
                ALUSrcA = 2'b01;
                ALUSrcB = 2'b01;
                ALUOp = 2'b00;
                case (op)
                    7'b0000011, 7'b0100011: next_state = S2_MEMADR;  // lw, sw
                    7'b0110011: next_state = S6_EXECUTER;            // R-type
                    7'b0010011: next_state = S8_EXECUTEI;            // I-type ALU
                    7'b1101111: next_state = S9_JAL;                 // jal
                    7'b1100011: next_state = S10_BEQ;                // beq
                    default:    next_state = S0_FETCH;
                endcase
            end

            // Memory Address Computation state
            S2_MEMADR: begin
                ALUSrcA = 2'b10;
                ALUSrcB = 2'b01;
                ALUOp = 2'b00;
					 next_state = (op == 7'b0000011) ? S3_MEMREAD : S5_MEMWRITE;
            end
            
            // Memory Read state
            S3_MEMREAD: begin
                ResultSrc = 2'b00;
					 AdrSrc = 1;
                next_state = S4_MEMWB;
            end
            
            // Memory Write-Back state
            S4_MEMWB: begin
                ResultSrc = 2'b01;
                RegWrite = 1;
                next_state = S0_FETCH;
            end
            
            // Memory Write state
            S5_MEMWRITE: begin
					 ResultSrc = 2'b00;
					 AdrSrc = 1;
                MemWrite = 1;
                next_state = S0_FETCH;
            end
            
            // R-type Execute state
            S6_EXECUTER: begin
                ALUSrcA = 2'b10;
                ALUSrcB = 2'b00;
                ALUOp = 2'b10;
                next_state = S7_ALUWB;
            end
            
            // ALU Write-Back state
            S7_ALUWB: begin
                ResultSrc = 2'b00;
                RegWrite = 1;
                next_state = S0_FETCH;
            end
            
            // I-type Execute state
            S8_EXECUTEI: begin
                ALUSrcA = 2'b10;
                ALUSrcB = 2'b01;
                ALUOp = 2'b10;
                next_state = S7_ALUWB;
            end
            
            // Jump and Link (JAL) state
            S9_JAL: begin
                ALUSrcA = 2'b01;
                ALUSrcB = 2'b10;
                ALUOp = 2'b00;
                ResultSrc = 2'b00;
					 PCUpdate = 1;
                next_state = S7_ALUWB;
            end
            
            // Branch if Equal (BEQ) state
            S10_BEQ: begin
                ALUSrcA = 2'b10;
                ALUSrcB = 2'b00;
                ALUOp = 2'b01;
                ResultSrc = 2'b00;
					 Branch = 1;
                next_state = S0_FETCH;
            end

            // Default case to handle unexpected states
            default: next_state = S0_FETCH;
        endcase   end
   
endmodule

