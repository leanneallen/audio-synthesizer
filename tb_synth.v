`timescale 1ns / 1ps

module tb_synth();
    
    reg clk;
    reg [15:0] sw;
    wire [6:0] seg;
    wire [3:0] an;
    
    synthesizer DUT (.clk(clk), .sw(sw), .seg(seg), .an(an));
    
    always begin
        #5 clk = ~clk;
    end
    
    initial begin
        clk = 0;
        
    end
    
    
endmodule
