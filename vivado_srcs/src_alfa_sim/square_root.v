`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 03/31/2021 06:55:00 PM
// Design Name:
// Module Name: square_root
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


module square_root #(parameter N = 32)
                   (
                     input wire clock,
                     input wire [N-1:0] num,
                     output reg [N/2-1:0] sq_root);
    //intermediate signals.
    reg [N-1:0] a;
    reg [N/2-1:0] q;
    reg [N/2+1:0] left,right,r;
    integer i;
    
    
    always @(posedge clock)
    begin
        sq_root = 0;
        a     = num;
        q     = 0;
        i     = 0;
        left  = 0;   //input to adder/sub
        right = 0;  //input to adder/sub
        r     = 0;  //remainder
        //run the calculations for N/2 iterations.
        for(i = 0;i<N/2;i = i+1) begin
            right = {q,r[N/2+1],1'b1};
            left  = {r[N/2-1:0],a[N-1:N-2]};
            a     = {a[N-3:0],2'b00};    //left shift by 2 bits.
            if (r[N/2+1] == 1) //add if r is negative
                r = left + right;
            else    //subtract if r is positive
                r = left - right;
                q = {q[N/2-2:0],!r[N/2+1]};
        end
        sq_root <= q;   //final assignment of output.
    end
    //end of Function
    
endmodule
