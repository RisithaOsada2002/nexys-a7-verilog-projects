`timescale 1ns / 1ps

module alu16bit_tb();

    // Inputs
    reg [15:0] A;
    reg [15:0] B;
    reg [3:0]  ALU_Sel;

    // Outputs
    wire [15:0] ALU_Out;
    wire [5:0]  Flags;


    wire OF = Flags[5];
    wire SF = Flags[4];
    wire ZF = Flags[3];
    wire AF = Flags[2];
    wire PF = Flags[1];
    wire CF = Flags[0];

    
    alu16bit uut (
        .A(A), 
        .B(B), 
        .ALU_Sel(ALU_Sel), 
        .ALU_Out(ALU_Out), 
        .Flags(Flags)
    );

    initial begin
      
        A = 0; B = 0; ALU_Sel = 0;

      
        $display("Time\t A\t B\t Sel\t Out\t OF SF ZF AF PF CF");
        $monitor("%0t\t %h\t %h\t %b\t %h\t %b  %b  %b  %b  %b  %b", 
                 $time, A, B, ALU_Sel, ALU_Out, OF, SF, ZF, AF, PF, CF);

       
        #10 A = 16'h0005; B = 16'h0003; ALU_Sel = 4'b0000;
        
        
        #10 A = 16'hFFFF; B = 16'h0001; ALU_Sel = 4'b0000;
        
      
        #10 A = 16'h0005; B = 16'h0005; ALU_Sel = 4'b0010;
        
        
        #10 A = 16'h0003; B = 16'h0005; ALU_Sel = 4'b0010;
        
        
        #10 A = 16'h7FFF; B = 16'h0001; ALU_Sel = 4'b0000;
        
      
        #10 A = 16'hFF00; B = 16'h0F0F; ALU_Sel = 4'b0100;
        
      
        #10 A = 16'hFF00; B = 16'h0F0F; ALU_Sel = 4'b0101;
        
       
        #10 A = 16'hFF00; B = 16'hFF0F; ALU_Sel = 4'b0110;
        
      
        #10 A = 16'hA5A5; B = 16'h0000; ALU_Sel = 4'b0111;
        
       
        #10 A = 16'h000F; ALU_Sel = 4'b1000;
        
        
        #10 A = 16'h0000; ALU_Sel = 4'b1001;

      
        #10 $finish;
    end
endmodule