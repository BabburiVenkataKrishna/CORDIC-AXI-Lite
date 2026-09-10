`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/20/2026 04:43:35 PM
// Design Name: 
// Module Name: counter
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


module Counter(
input LD,
input init,
input CLK,
input rst,
output reg[5:0] cnt
);
    
    reg [5:0] cnt_next;
    
    always @(*)
    begin
        if(rst)
        begin
            cnt_next = 6'b100000;
        end
        else if(init)
        begin
            cnt_next = 'b0;
        end
        else
        begin
            cnt_next = cnt+1;
        end
    end
    
    always @(posedge CLK)
    begin
        if(rst | LD)
        begin
            cnt <= cnt_next;
        end
    end
    
endmodule
