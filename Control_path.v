`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/20/2026 05:12:22 PM
// Design Name: 
// Module Name: Control_path
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


module Control_path(
input [31:0]Z,
input [4:0] cnt,
input start,
input CLK,
input rst,
output reg LD,
output reg add_sel,
output reg init,
output reg busy,
output reg done
);

        parameter IDLE    = 2'b00;
        parameter INIT    = 2'b01;
        parameter ITERATE = 2'b10;
        parameter DONE    = 2'b11;
        
        
        
        reg [1:0]current_state;
        reg [1:0]next_state;
        
        always@(*)
        begin
            case(current_state)
            IDLE:           begin
                                if(start) next_state = INIT;
                                else next_state = IDLE;
                            end
            INIT:           begin
                                if(start) next_state = INIT;
                                else next_state = ITERATE; 
                            end
            ITERATE:        begin
                                if(cnt==29) next_state = DONE ;
                                else next_state = ITERATE; 
                            end
            DONE:           begin
                                next_state = IDLE;
                            end
                              
            default:        begin
                                next_state = IDLE;
                            end
            endcase
        end
        
        
        always@(posedge CLK)
        begin
            if(rst)
                current_state <= IDLE;
            else
                current_state <= next_state;
        end
        

        always@(*)
        begin
            if(rst)
            begin
                LD=0; init=0; add_sel=0;
            end
            else 
            begin
                case(current_state)
                IDLE   :          begin
                                      LD=0; init=0; add_sel=0;
                                  end
                INIT   :          begin
                                     LD=1; init=1; add_sel=0;
                                  end
                ITERATE:          begin
                                     if(Z[31])
                                        begin
                                            LD=1; init=0 ; add_sel =0; 
                                        end
                                     else 
                                        begin
                                            LD=1; init=0 ; add_sel =1;
                                        end
                                  end
                DONE   :          begin
                                     LD=0; init=0; add_sel=0;
                                  end                  
                                  
                default:                begin 
                                            LD=0 ; init=0 ; add_sel =0;
                                        end
                endcase
            end
        end
        
        
        always@(posedge CLK)
        begin
            if(rst)
            begin
                busy <=0; done <=0;
            end
            else 
            begin
                case(current_state)
                IDLE:               begin
                                        if (next_state==INIT)
                                        begin
                                        busy <=1;
                                        done <=0;
                                        end
                                    end
                INIT:               begin
                                        if (next_state==ITERATE)
                                        begin
                                        busy <=1;
                                        done <=0;
                                        end
                                    end
                ITERATE:            begin
                                        if (next_state==DONE)
                                        begin
                                        done <=1;
                                        busy <=0;
                                        end
                                    end
                DONE:               begin
                                        busy <=0;
                                        done <=0;
                                    end                  
                                    
                default:            begin  
                                        busy <=0;                                     
                                        done <=0;
                                    end

                endcase
            end
        end
    

endmodule
