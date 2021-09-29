`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/23/2021 02:40:23 PM
// Design Name: 
// Module Name: test_module
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


module test_module#(BRAM_SHIFT=2)(
    //AXI MODULE
    output reg[31:0] o_write_address,
    output reg[63:0] o_write_payload,
    output reg[31:0] o_readAdress,
    output reg o_initwritetxn,
    output wire o_led1,
    output wire o_led2,
    output wire o_led3,
    output wire o_led4,
    output reg o_initreadtxn,
    output reg pulse_init,
    output reg[15:0] cycle_counter,
    input wire[63:0] i_AMU_P0,
    input wire[63:0] i_AMU_P1,
    input wire[63:0] i_AMU_P2,
    input wire[63:0] i_AMU_P3,
    input wire[63:0] i_AMU_P4,
    input wire[63:0] i_AMU_P5,
    input wire[63:0] i_AMU_P6,
    input wire[63:0] i_AMU_P7,
    input wire[63:0] i_AMU_P8,
    input wire[63:0] i_AMU_P9,
    input wire[63:0] i_AMU_P10,
    input wire[63:0] i_AMU_P11,
    input wire[63:0] i_AMU_P12,
    input wire[63:0] i_AMU_P13,
    input wire[63:0] i_AMU_P14,
    input wire rst,
    input wire i_write_TxnDone,
    input wire i_read_TxnDone,
    ///END AXI MODULE
    // BRAM CONNECTION
    output reg[31:0] addr_bram,
    output reg[31:0] write_in_bram,
    input wire[31:0] read_out_bram,
    output reg en_bram,
    output wire rst_bram,
    output reg[3:0] we_bram,
    // END BRAM CONNECTION
    
    input wire clk
    );
    
    assign o_led1 = i_AMU_P0[0];
    assign o_led2 = i_AMU_P4[0];
    assign o_led3 = i_AMU_P8[0];
    assign o_led4 = i_AMU_P12[0];
    assign rst_bram = rst;
    reg init_transaction;
    reg[4:0] state;
    reg[31:0] base_addr;
    always @(posedge clk)
    begin
        if(rst ==1)
        begin
            case (state)
                0:begin
                    addr_bram <=0;
                    if (read_out_bram >= 32'hfff) begin
                        state <= 1;
                        we_bram<= 3'h7;
                        write_in_bram <= 0;
                    end
                    else
                    begin
                        we_bram <=0;
                    end
                end
                1: begin
                    we_bram <=0;
                    addr_bram <= 1<<BRAM_SHIFT;
                    state <=2;
                end
                2:begin
                    addr_bram <= 2<<BRAM_SHIFT;
                    base_addr <= read_out_bram;
                    state <=3;
                end
                3:begin
                    we_bram <=0;
                    addr_bram <= 2<<BRAM_SHIFT;
                    o_readAdress <=base_addr;
                    o_write_address <= base_addr;
                    o_initreadtxn <=1;
                    state <= 4;
                end 
                4:begin
                    o_initreadtxn <=0;
                    if(i_read_TxnDone)
                    begin
                        state <= 5;
                        we_bram<= 3'h7;
                        write_in_bram <= i_AMU_P0;
                    end
                end
                5:begin
                    addr_bram <= 3<<BRAM_SHIFT;
                    write_in_bram <= 32'hffff;
                    state <=6;
                end
                6:begin
                    addr_bram <= 0;
                    write_in_bram <=0;
                    we_bram <=0;
                    state <=0;
                end
                default: state <=0; 
            endcase
          
//        if (init_transaction==0)
//                begin
//                    o_initreadtxn <=1;
//                    init_transaction<=1;
//                    pulse_init <= 1;
//                end
//            //o_axi_reset <=0;
//            o_readAdress <= 32'h50000000;
//            o_write_address <= 32'h50000000;
//            if(cycle_counter>50000)
//            begin
//                pulse_init <=1;
//                cycle_counter <=0;
//            end
//            else 
//            begin                
//                cycle_counter <= cycle_counter +1;
//                if(pulse_init)
//                begin
//                    pulse_init <=0;
//                    o_initreadtxn <=1;
//                end
//                else
//                begin
//                    o_initreadtxn <=0;
//                end
            
            
//            else
//            begin
//                o_initreadtxn <=0;
//                init_transaction<=0;
//            end
//                if (i_read_TxnDone)
//                begin
//                    cycle_counter <= 0;
//                    pulse_init <=1;
//                end
//                else
//                begin
//                    cycle_counter <= cycle_counter +1;
//                end
            //end
        end
        else
        begin
            cycle_counter <=0;
            o_initreadtxn <=0;
            init_transaction <=0;
            pulse_init <=0;
            state <=0;
        end
    end
    
endmodule
