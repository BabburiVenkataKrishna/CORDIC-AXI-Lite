`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/20/2026 02:31:47 PM
// Design Name: 
// Module Name: XY_Hardware
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


module XY_Hardware(
input [31:0]X,
input [31:0]Y,
input LD,
input add_sel,
input init,
input CLK,
input rst,
input [4:0] cnt,
output reg signed[31:0]X_out,
output reg signed[31:0]Y_out
);
    
    reg  signed[31:0]X_in;
    reg  signed[31:0]Y_in;
    
    reg  signed[31:0] X_next;
    reg  signed[31:0] Y_next;
    
    wire signed[31:0] X_shift;
    wire signed[31:0] Y_shift;
    
    Right_shifter xshift (
        .D_in(X_out),
        .cnt(cnt),
        .D_shift(X_shift)
    );    
    
    Right_shifter yshift (
        .D_in(Y_out),
        .cnt(cnt),
        .D_shift(Y_shift)
    );
        
    always@(*)
    begin
        if(add_sel)
        begin
            X_next = X_out - Y_shift;
            Y_next = X_shift + Y_out;
        end
        else
        begin
            X_next = X_out + Y_shift;
            Y_next = -X_shift + Y_out;
        end
    end
    
    always@(*)
    begin
        if(init)
        begin
            X_in = X;
            Y_in = Y;
        end
        else
        begin
            X_in = X_next;
            Y_in = Y_next;
        end
    end
    
    always@(posedge CLK)
    begin 
        if(rst)
        begin
            X_out <= 'b0;
            Y_out <= 'b0;
        end
        else if(LD)
        begin
            X_out <= X_in;
            Y_out <= Y_in;
        end
    end
    
endmodule
