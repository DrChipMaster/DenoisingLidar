`timescale 1ns / 1ps

module tb_imp_test;
    reg clock;
    parameter Clock_period = 10; 
    wire  done;
    wire fifo_empty;

initial begin
        clock = 1;
end

always #(Clock_period/2) clock <= ~clock;


    Implementation_interface m_interface (.clock(clock),
    .done(done),
    .fifo_empty(fifo_empty));
endmodule