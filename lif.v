`timescale 1ns / 1ps 
 
module lif( 
    input wire clk, 
    input wire rst, 
    input wire bit0, 
    output reg led0, 
    output reg [31:0] v_mem  // biar bisa monitor vmem 
    ); 
 
    // Define constants as integers scaled by a factor of 1e6 (for 
example) 
    parameter integer TIME_STEP = 1; // 1e6 to match scaling of TAU 
    parameter integer V_TH = 50; 
    parameter integer V_RESET = 0; 
    parameter integer WEIGHT = 5; 
    parameter integer LEAK = 1; 
 
    parameter integer RESISTOR = 1; // 1 (1 Ohm) scaled by 1e6 
    parameter integer CAPACITOR = 1; // 1 (1 Farad) scaled by 1e6 
    parameter integer TAU = (RESISTOR * CAPACITOR); // tau = R * C 
scaled by 1e6 
    
    reg input_current; 
    reg spike; 
    
    always @(posedge clk or posedge rst) begin 
        if (rst) begin 
            v_mem <= V_RESET; 
            spike <= 0; 
            led0 <= 0; 
            input_current <= 0; //biar jelas nialainya 
        end else begin             
            if (bit0 == 1) begin 
                input_current <= 1; 
            end else begin 
                input_current <= 0; 
            end 
            
            // Update v_mem with fixed-point arithmetic 
            v_mem <= v_mem + (TIME_STEP / TAU) * (-LEAK + 
(input_current * WEIGHT)); 
            
            if (v_mem >= V_TH) begin 
                spike <= 1; 
                v_mem <= V_RESET; 
            end else begin 
                spike <= 0; 
            end 
            
            led0 <= spike; 
        end 
    end 
endmodule