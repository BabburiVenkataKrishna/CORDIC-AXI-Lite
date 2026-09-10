`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/20/2026 03:32:55 PM
// Design Name: 
// Module Name: Z_Hardware
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


module Z_Hardware(
input [31:0]Z,
input LD,
input add_sel,
input init,
input CLK,
input rst,
input [4:0] cnt,
output reg signed[31:0]Z_out
);
    
    reg signed[31:0] Z_in;
    reg signed[31:0] Z_next;
    reg [31:0] Z_rom;
    
    always@(*)
    begin
        case(cnt)
            5'd0    : Z_rom = 32'd421657428;
            5'd1    : Z_rom = 32'd248918914;
            5'd2    : Z_rom = 32'd131521918;
            5'd3    : Z_rom = 32'd66762579;
            5'd4    : Z_rom = 32'd33510843;
            5'd5    : Z_rom = 32'd16771757;
            5'd6    : Z_rom = 32'd8387925;
            5'd7    : Z_rom = 32'd4194218;
            5'd8    : Z_rom = 32'd2097141;
            5'd9    : Z_rom = 32'd1048574;
            5'd10   : Z_rom = 32'd524287;
            5'd11   : Z_rom = 32'd262143;
            5'd12   : Z_rom = 32'd131071;
            5'd13   : Z_rom = 32'd65535;
            5'd14   : Z_rom = 32'd32767;
            5'd15   : Z_rom = 32'd16383;
            5'd16   : Z_rom = 32'd8191;
            5'd17   : Z_rom = 32'd4095;
            5'd18   : Z_rom = 32'd2047;
            5'd19   : Z_rom = 32'd1023;
            5'd20   : Z_rom = 32'd511;
            5'd21   : Z_rom = 32'd255;
            5'd22   : Z_rom = 32'd127;
            5'd23   : Z_rom = 32'd63;
            5'd24   : Z_rom = 32'd31;
            5'd25   : Z_rom = 32'd15;
            5'd26   : Z_rom = 32'd7;
            5'd27   : Z_rom = 32'd4;
            5'd28   : Z_rom = 32'd2;
            5'd29   : Z_rom = 32'd1;
            default : Z_rom = 'b0;
        endcase
    end
    
    always@(*)
    begin
        if(add_sel)
        begin
            Z_next = Z_out - $signed(Z_rom);
        end
        else
        begin
            Z_next = Z_out + $signed(Z_rom);
        end
    end
    
    always@(*)
    begin
        if(init)
        begin
            Z_in = Z;
        end
        else
        begin
            Z_in = Z_next;
        end
    end
    
    always@(posedge CLK)
    begin 
        if(rst)
        begin
            Z_out <= 'b0;
        end
        else if(LD)
        begin
            Z_out <= Z_in;
        end
    end

endmodule
