`timescale 1ns / 1ps

module alu16bit (
    input  [15:0] A,
    input  [15:0] B,
    input  [3:0]  ALU_Sel,
    output reg [15:0] ALU_Out,
    output [5:0]  Flags
);

    
    reg CF, PF, AF, ZF, SF, OF;
    reg [16:0] temp_ext; 
    reg [4:0]  temp_half; 

  
    assign Flags = {OF, SF, ZF, AF, PF, CF};

    always @(*) begin
     
        temp_ext  = 17'b0;
        temp_half = 5'b0;
        CF = 1'b0;
        AF = 1'b0;
        OF = 1'b0;

        case(ALU_Sel)
            4'b0000, 4'b0001: begin 
                
                temp_ext  = A + B;
                temp_half = A[3:0] + B[3:0];
                ALU_Out   = temp_ext[15:0];
                
                CF = temp_ext[16];
                AF = temp_half[4];
               
                OF = (~A[15] & ~B[15] & ALU_Out[15]) | (A[15] & B[15] & ~ALU_Out[15]);
            end
            
            4'b0010, 4'b0011: begin 
                
                temp_ext  = A - B;
                temp_half = A[3:0] - B[3:0];
                ALU_Out   = temp_ext[15:0];
                
                CF = temp_ext[16]; 
                AF = temp_half[4];
               
                OF = (~A[15] & B[15] & ALU_Out[15]) | (A[15] & ~B[15] & ~ALU_Out[15]);
            end
            
            4'b0100: ALU_Out = A & B;   // AND
            4'b0101: ALU_Out = A | B;   // OR
            4'b0110: ALU_Out = A ^ B;   // XOR
            4'b0111: ALU_Out = ~A;      // NOT
            
            4'b1000: begin              // INC
                temp_ext  = A + 1;
                temp_half = A[3:0] + 1;
                ALU_Out   = temp_ext[15:0];
                
                CF = temp_ext[16];
                AF = temp_half[4];
                OF = (~A[15] & ALU_Out[15]); 
            end
            
            4'b1001: begin              // DEC
                temp_ext  = A - 1;
                temp_half = A[3:0] - 1;
                ALU_Out   = temp_ext[15:0];
                
                CF = temp_ext[16];
                AF = temp_half[4];
                OF = (A[15] & ~ALU_Out[15]);
            end
            
            default: ALU_Out = 16'b0;
        endcase

        // Calculate common flags that apply to all operations
        ZF = (ALU_Out == 16'b0);
        SF = ALU_Out[15];
        
        PF = ~^ALU_Out[7:0]; 
    end
endmodule