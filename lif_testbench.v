`timescale 1ns / 1ps 
 
module lif_testbench; 
    reg clk; 
    reg rst; 
    reg bit0; 
    wire led0; 
    wire [31:0] v_mem;  // Declare v_mem as wire 
 
    // Instantiate the Unit Under Test (UUT) 
    lif uut ( 
        .clk(clk), 
        .rst(rst), 
        .bit0(bit0), 
        .led0(led0), 
        .v_mem(v_mem)  // Connect v_mem to the UUT 
    ); 
 
    initial begin 
        // Initialize Inputs 
        clk = 0; 
        rst = 0; 
        bit0 = 0; 
 
        // Apply reset 
        rst = 1; 
        #10; 
        rst = 0; 
        
        // Test case 1: Apply bit0 = 1 
        #10 bit0 = 1; 
        #1000 bit0 = 0; 
        
        // Test case 2: Apply bit0 = 0 
        #10 bit0 = 0; 
        #1000 bit0 = 1; 
 
        // End simulation 
        #2000 $finish; 
    end 
 
    always #20 clk = ~clk; // Clock generator with 10ns period 
 
    initial begin 
        // Monitor the outputs 
        $monitor("Time = %0dns, clk = %b, rst = %b, bit0 = %b, v_mem = 
%d, led0 = %b", $time, clk, rst, bit0, v_mem, led0); 
 
        // Dump waveform data 
        $dumpfile("lif_testbench.vcd"); 
        $dumpvars(0, lif_testbench); 
    end 
 
endmodule