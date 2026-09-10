`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/20/2026 03:44:04 PM
// Design Name: 
// Module Name: Right_shifter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Right_shifter (
    input  wire [31:0] D_in,      // 32-bit input data
    input  wire [4:0]  cnt,       // 5-bit shift amount (0 to 31)
    output wire [31:0] D_shift    // 32-bit shifted output
);

    // Signal to easily grab the sign bit
    wire sign = D_in[31];

    // Intermediate stages for the log2(32) = 5 stages of shifting
    wire [31:0] stage0;
    wire [31:0] stage1;
    wire [31:0] stage2;
    wire [31:0] stage3;

    // Stage 0: Shift by 1 if cnt[0] is high
    assign stage0 = cnt[0] ? { {1{sign}}, D_in[31:1] } : D_in;

    // Stage 1: Shift by 2 if cnt[1] is high
    assign stage1 = cnt[1] ? { {2{sign}}, stage0[31:2] } : stage0;

    // Stage 2: Shift by 4 if cnt[2] is high
    assign stage2 = cnt[2] ? { {4{sign}}, stage1[31:4] } : stage1;

    // Stage 3: Shift by 8 if cnt[3] is high
    assign stage3 = cnt[3] ? { {8{sign}}, stage2[31:8] } : stage2;

    // Stage 4: Shift by 16 if cnt[4] is high
    assign D_shift = cnt[4] ? { {16{sign}}, stage3[31:16] } : stage3;

endmodule

