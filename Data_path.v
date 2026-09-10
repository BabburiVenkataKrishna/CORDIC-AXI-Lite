`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/20/2026 02:21:00 PM
// Design Name: 
// Module Name: Data_path
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


module Data_path(
input [31:0]X,
input [31:0]Y,
input [31:0]Z,
input LD,
input init,
input CLK,
input rst,
input add_sel,
output [31:0]X_out,
output [31:0]Y_out,
output [31:0]Z_out,
output [4:0]cnt
);

    XY_Hardware xy_hardware(
        .X(X),
        .Y(Y),
        .LD(LD),
        .add_sel(add_sel),
        .init(init),
        .CLK(CLK),
        .rst(rst),
        .cnt(cnt[4:0]),
        .X_out(X_out),
        .Y_out(Y_out)
    );
    
    Z_Hardware z_hardware(
        .Z(Z),
        .LD(LD),
        .add_sel(add_sel),
        .init(init),
        .CLK(CLK),
        .rst(rst),
        .cnt(cnt[4:0]),
        .Z_out(Z_out)
    );
    
    Counter counter(
        .LD(LD),
        .init(init),
        .CLK(CLK),
        .rst(rst),
        .cnt(cnt)
    );

endmodule
