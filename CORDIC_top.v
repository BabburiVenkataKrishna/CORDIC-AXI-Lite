`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/21/2026 08:19:20 PM
// Design Name: 
// Module Name: CORDIC_top
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


module CORDIC_top(
input [31:0]X,
input [31:0]Y,
input [31:0]Z,
input CLK,
input START,
input rst,
output [31:0]X_out,
output [31:0]Y_out,
output [31:0]Z_out,
output busy,
output done
    );
    
    
    wire LD, init,add_sel;
    wire [4:0]cnt;
    
    Data_path DP (
                    .X(X),
                    .Y(Y),
                    .Z(Z),
                    .LD(LD),
                    .init(init),
                    .CLK(CLK),
                    .rst(rst),
                    .add_sel(add_sel),
                    .X_out(X_out),
                    .Y_out(Y_out),
                    .Z_out(Z_out),
                    .cnt(cnt)
                    );
    
    Control_path CP(
                    .Z(Z_out),
                    .cnt(cnt),
                    .start(START),
                    .CLK(CLK),
                    .rst(rst),
                    .LD(LD),
                    .add_sel(add_sel),
                    .init(init),
                    .busy(busy),
                    .done(done)
                    );
    
endmodule
