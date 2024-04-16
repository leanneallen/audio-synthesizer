`timescale 1ns / 1ps

module synthesizer(clk, sw, seg, an);
    input clk;          // 500MHz built-in clock
    input [15:0] sw;     // Switches for choosing which types of waveforms
                        // to include in the output audio signal
//    input [3:0] JCR;    // DO NOT NEED: Pmod keypad rows
//    output [3:0] JCC;   // DO NOT NEED: Pmod keypad columns
//    inout [3:0] JA;     // Connectors for PmodI2S stereo audio output
    output [6:0] seg;   // 7-segment display onboard Nexys 3 board
    output [3:0] an;    // Anode for 7-segment display
    
    wire [15:0] sig_square; // Square wave
    wire [15:0] sig_saw;    // Sawtooth wave
    wire [15:0] sig_tri;    // Triangle wave
    wire [15:0] sig_sine;   // Sine wave
    wire [15:0] sig;        // Total audio output sig                        nal
    wire [11:0] freq;       // Current frequency to play
    
    // Pmod keypad input module which allows user to choose which note
    // (frequency) to play
    sw_input swin_ (
        // Inputs
        .clk    (clk),
        .sw     (sw),
        // Outputs
        .freq   (freq)
    );
    
    // Displays the current note being played to the 7-segment display
    display disp_ (
        // Inputs
        .freq   (freq),
        // Outputs
        .segOut (seg),
        .an  (an)
    );
    
    // Generates square wave
    osc_square squosc_ (
        // Inputs
        .freq   (freq),
        .clk    (clk),
        // Outputs
        .sig    (sig_square)
    );
    
    // Generates sawtooth and triangle waves
    osc_tri_saw trisawsc_ (
        // Inputs
        .freq   (freq),
        .clk    (clk),
        // Outputs
        .sig_saw    (sig_saw),
        .sig_tri    (sig_tri)
    );
    
    // Generates sine wave
    osc_sine sinesc_ (
        // Inputs
        .freq   (freq),
        .clk    (clk),
        // Outputs
        .sin    (sig_sine)
    );
    
    // Accumulates the waveforms chosen by the basys 3 switches into the
    // total output signal
    sig_adder sigadd_ (
        // Inputs
        .sw (sw),
        .sig_saw    (sig_saw),
        .sig_tri    (sig_tri),
        .sig_square (sig_square),
        .sig_sine   (sig_sine),
        .clk    (clk),
        // Outputs
        .sig    (sig)
    );

    // Sends the total calculated output signal to the PmodI2S stereo
    // audio output device
//    pmod_out out_ (
//        // Inputs
//        .sig    (sig),
//        .clk    (clk),
//        // Outputs
//        .MCLK   (JA[0]),
//        .LRCLK  (JA[1]),
//        .SCLK   (JA[2]),
//        .SDIN   (JA[3])
//    );

endmodule
