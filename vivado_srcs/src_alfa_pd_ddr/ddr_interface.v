

module ddr_interface #(parameter N = 16,
                    DISTANCE_MODULES = 1,
                    CORE_NUMBER = 16,
                    CACHE_MULTIPLIER=1                    
                    )(
                    //DDR_MODULE CONNECTION
                    output reg[31:0] o_write_address,
                    output reg[63:0] o_write_payload,
                    output reg[31:0] o_readAdress,
                    output reg o_initwritetxn,
                    output reg o_initreadtxn,
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
                    //DDR_MODULE CONNECTION
                    //AXI lite Module
                     input wire i_start,
                     input wire[31:0] i_pointcloud_size,
                     input wire[3:0] i_filtertype,
                     output reg[15:0] o_finish
                    //AXI lite Module
                    
                    );


reg[N*CORE_NUMBER-1:0] l1_cache_x[15*CACHE_MULTIPLIER-1:0];
reg[N*CORE_NUMBER-1:0] l1_cache_y[15*CACHE_MULTIPLIER-1:0];
reg[N*CORE_NUMBER-1:0] l1_cache_z[15*CACHE_MULTIPLIER-1:0];
reg[N*CORE_NUMBER-1:0] l1_cache_i[15*CACHE_MULTIPLIER-1:0];

assign l1_cache_x[0] = i_AMU_P0[15:0];


reg[N*CORE_NUMBER-1:0] cache_x;
reg[N*CORE_NUMBER-1:0] cache_y;
reg[N*CORE_NUMBER-1:0] cache_z;
reg[N*CORE_NUMBER-1:0] cache_i;

reg[N*DISTANCE_MODULES-1:0] l1_fcache_x[15*CACHE_MULTIPLIER-1:0];
reg[N*DISTANCE_MODULES-1:0] l1_fcache_y[15*CACHE_MULTIPLIER-1:0];
reg[N*DISTANCE_MODULES-1:0] l1_fcache_z[15*CACHE_MULTIPLIER-1:0];

reg[N*DISTANCE_MODULES-1:0]cache_feeder_x;
reg[N*DISTANCE_MODULES-1:0]cache_feeder_y;
reg[N*DISTANCE_MODULES-1:0]cache_feeder_z;

reg[N-1:0] feeder_pos;
reg[N-1:0] point_updated;
reg[N-1:0] point_pointer;
reg [N-1:0] core_cache_status;
reg [N-1:0] node_cache_status;

reg[6:0] state;

reg read_fifo;
reg reset;
reg cache_updated;
reg pause;

reg updating_l1cache;
reg updating_l1_feeder_cache;

wire[N*2-1:0] point_pos;
wire[N-1:0] outlier_from_fifo;
wire update_cache;
wire Controller_done;
wire fifo_empty;
reg[CACHE_MULTIPLIER-1:0] update_cycle;



always @(posedge clock) begin
    if(i_read_TxnDone && updating_l1cache)
    begin
        update_cycle <= update_cycle + 1;
        //Updating x l1 cache
        l1_cache_x[0+update_cycle] <= i_AMU_P0[15:0];
        l1_cache_x[1+update_cycle] <= i_AMU_P1[15:0];
        l1_cache_x[2+update_cycle] <= i_AMU_P2[15:0];
        l1_cache_x[3+update_cycle] <= i_AMU_P3[15:0];
        l1_cache_x[4+update_cycle] <= i_AMU_P4[15:0];
        l1_cache_x[5+update_cycle] <= i_AMU_P5[15:0];
        l1_cache_x[6+update_cycle] <= i_AMU_P6[15:0];
        l1_cache_x[7+update_cycle] <= i_AMU_P7[15:0];
        l1_cache_x[8+update_cycle] <= i_AMU_P8[15:0];
        l1_cache_x[9+update_cycle] <= i_AMU_P9[15:0];
        l1_cache_x[10+update_cycle] <= i_AMU_P10[15:0];
        l1_cache_x[11+update_cycle] <= i_AMU_P11[15:0];
        l1_cache_x[12+update_cycle] <= i_AMU_P12[15:0];
        l1_cache_x[13+update_cycle] <= i_AMU_P13[15:0];
        l1_cache_x[14+update_cycle] <= i_AMU_P14[15:0];
        //Updating y l1 cache
        l1_cache_y[0+update_cycle] <= i_AMU_P0[31:16];
        l1_cache_y[1+update_cycle] <= i_AMU_P1[31:16];
        l1_cache_y[2+update_cycle] <= i_AMU_P2[31:16];
        l1_cache_y[3+update_cycle] <= i_AMU_P3[31:16];
        l1_cache_y[4+update_cycle] <= i_AMU_P4[31:16];
        l1_cache_y[5+update_cycle] <= i_AMU_P5[31:16];
        l1_cache_y[6+update_cycle] <= i_AMU_P6[31:16];
        l1_cache_y[7+update_cycle] <= i_AMU_P7[31:16];
        l1_cache_y[8+update_cycle] <= i_AMU_P8[31:16];
        l1_cache_y[9+update_cycle] <= i_AMU_P9[31:16];
        l1_cache_y[10+update_cycle] <= i_AMU_P10[31:16];
        l1_cache_y[11+update_cycle] <= i_AMU_P11[31:16];
        l1_cache_y[12+update_cycle] <= i_AMU_P12[31:16];
        l1_cache_y[13+update_cycle] <= i_AMU_P13[31:16];
        l1_cache_y[14+update_cycle] <= i_AMU_P14[31:16];
        //Updating z l1 cache
        l1_cache_z[0+update_cycle] <= i_AMU_P0[47:32];
        l1_cache_z[1+update_cycle] <= i_AMU_P1[47:32];
        l1_cache_z[2+update_cycle] <= i_AMU_P2[47:32];
        l1_cache_z[3+update_cycle] <= i_AMU_P3[47:32];
        l1_cache_z[4+update_cycle] <= i_AMU_P4[47:32];
        l1_cache_z[5+update_cycle] <= i_AMU_P5[47:32];
        l1_cache_z[6+update_cycle] <= i_AMU_P6[47:32];
        l1_cache_z[7+update_cycle] <= i_AMU_P7[47:32];
        l1_cache_z[8+update_cycle] <= i_AMU_P8[47:32];
        l1_cache_z[9+update_cycle] <= i_AMU_P9[47:32];
        l1_cache_z[10+update_cycle] <= i_AMU_P10[47:32];
        l1_cache_z[11+update_cycle] <= i_AMU_P11[47:32];
        l1_cache_z[12+update_cycle] <= i_AMU_P12[47:32];
        l1_cache_z[13+update_cycle] <= i_AMU_P13[47:32];
        l1_cache_z[14+update_cycle] <= i_AMU_P14[47:32];
        //updating i l1 cache
        l1_cache_i[0+update_cycle] <= i_AMU_P0[63:48];
        l1_cache_i[1+update_cycle] <= i_AMU_P1[63:48];
        l1_cache_i[2+update_cycle] <= i_AMU_P2[63:48];
        l1_cache_i[3+update_cycle] <= i_AMU_P3[63:48];
        l1_cache_i[4+update_cycle] <= i_AMU_P4[63:48];
        l1_cache_i[5+update_cycle] <= i_AMU_P5[63:48];
        l1_cache_i[6+update_cycle] <= i_AMU_P6[63:48];
        l1_cache_i[7+update_cycle] <= i_AMU_P7[63:48];
        l1_cache_i[8+update_cycle] <= i_AMU_P8[63:48];
        l1_cache_i[9+update_cycle] <= i_AMU_P9[63:48];
        l1_cache_i[10+update_cycle] <= i_AMU_P10[63:48];
        l1_cache_i[11+update_cycle] <= i_AMU_P11[63:48];
        l1_cache_i[12+update_cycle] <= i_AMU_P12[63:48];
        l1_cache_i[13+update_cycle] <= i_AMU_P13[63:48];
        l1_cache_i[14+update_cycle] <= i_AMU_P14[63:48];
    end
    else if (!updating_l1cache and !updating_l1_feeder_cache) begin
        update_cycle <=0;
    end
end


always @(posedge clock) begin
    if (i_read_TxnDone and updating_l1_feeder_cache)
    begin
        l1_fcache_x[0+update_cycle] <= i_AMU_P0[15:0];
        l1_fcache_x[1+update_cycle] <= i_AMU_P1[15:0];
        l1_fcache_x[2+update_cycle] <= i_AMU_P2[15:0];
        l1_fcache_x[3+update_cycle] <= i_AMU_P3[15:0];
        l1_fcache_x[4+update_cycle] <= i_AMU_P4[15:0];
        l1_fcache_x[5+update_cycle] <= i_AMU_P5[15:0];
        l1_fcache_x[6+update_cycle] <= i_AMU_P6[15:0];
        l1_fcache_x[7+update_cycle] <= i_AMU_P7[15:0];
        l1_fcache_x[8+update_cycle] <= i_AMU_P8[15:0];
        l1_fcache_x[9+update_cycle] <= i_AMU_P9[15:0];
        l1_fcache_x[10+update_cycle] <= i_AMU_P10[15:0];
        l1_fcache_x[11+update_cycle] <= i_AMU_P11[15:0];
        l1_fcache_x[12+update_cycle] <= i_AMU_P12[15:0];
        l1_fcache_x[13+update_cycle] <= i_AMU_P13[15:0];
        l1_fcache_x[14+update_cycle] <= i_AMU_P14[15:0];
        //Ufpdating y l1 cache
        l1_fcache_y[0] <= i_AMU_P0[31:16];
        l1_fcache_y[1] <= i_AMU_P1[31:16];
        l1_fcache_y[2] <= i_AMU_P2[31:16];
        l1_fcache_y[3] <= i_AMU_P3[31:16];
        l1_fcache_y[4] <= i_AMU_P4[31:16];
        l1_fcache_y[5] <= i_AMU_P5[31:16];
        l1_fcache_y[6] <= i_AMU_P6[31:16];
        l1_fcache_y[7] <= i_AMU_P7[31:16];
        l1_fcache_y[8] <= i_AMU_P8[31:16];
        l1_fcache_y[9] <= i_AMU_P9[31:16];
        l1_fcache_y[10] <= i_AMU_P10[31:16];
        l1_fcache_y[11] <= i_AMU_P11[31:16];
        l1_fcache_y[12] <= i_AMU_P12[31:16];
        l1_fcache_y[13] <= i_AMU_P13[31:16];
        l1_fcache_y[14] <= i_AMU_P14[31:16];
        //Ufpdating z l1 cache
        l1_fcache_z[0] <= i_AMU_P0[47:32];
        l1_fcache_z[1] <= i_AMU_P1[47:32];
        l1_fcache_z[2] <= i_AMU_P2[47:32];
        l1_fcache_z[3] <= i_AMU_P3[47:32];
        l1_fcache_z[4] <= i_AMU_P4[47:32];
        l1_fcache_z[5] <= i_AMU_P5[47:32];
        l1_fcache_z[6] <= i_AMU_P6[47:32];
        l1_fcache_z[7] <= i_AMU_P7[47:32];
        l1_fcache_z[8] <= i_AMU_P8[47:32];
        l1_fcache_z[9] <= i_AMU_P9[47:32];
        l1_fcache_z[10] <= i_AMU_P10[47:32];
        l1_fcache_z[11] <= i_AMU_P11[47:32];
        l1_fcache_z[12] <= i_AMU_P12[47:32];
        l1_fcache_z[13] <= i_AMU_P13[47:32];
        l1_fcache_z[14] <= i_AMU_P14[47:32];
        //ufpdating i l1 cache
        l1_fcache_i[0] <= i_AMU_P0[63:48];
        l1_fcache_i[1] <= i_AMU_P1[63:48];
        l1_fcache_i[2] <= i_AMU_P2[63:48];
        l1_fcache_i[3] <= i_AMU_P3[63:48];
        l1_fcache_i[4] <= i_AMU_P4[63:48];
        l1_fcache_i[5] <= i_AMU_P5[63:48];
        l1_fcache_i[6] <= i_AMU_P6[63:48];
        l1_fcache_i[7] <= i_AMU_P7[63:48];
        l1_fcache_i[8] <= i_AMU_P8[63:48];
        l1_fcache_i[9] <= i_AMU_P9[63:48];
        l1_fcache_i[10] <= i_AMU_P10[63:48];
        l1_fcache_i[11] <= i_AMU_P11[63:48];
        l1_fcache_i[12] <= i_AMU_P12[63:48];
        l1_fcache_i[13] <= i_AMU_P13[63:48];
        l1_fcache_i[14] <= i_AMU_P14[63:48];
    end
end


always @(posedge clock) begin
      
end






 Controller#(.N(N),.CORE_NUMBER(CORE_NUMBER),.DISTANCE_MODULES(DISTANCE_MODULES)) m_controller(
        .clock(clock),
        .reset(reset),
        .cache_feeder_x(cache_feeder_x),
        .cache_feeder_y(cache_feeder_y),
        .cache_feeder_z(cache_feeder_z),
        .cache_x(cache_x),
        .cache_y(cache_y),
        .cache_z(cache_z),
        .cache_i(cache_i),
        .point_cloud_size(i_point_cloud_size),
        .read_fifo(read_fifo),
        .filter_selector(i_filtertype),
        .cache_updated(cache_update),
        .pause(pause),
        .outlier_pos_fifo(outlier_from_fifo),
        .point_pos(point_pos),
        .empty(fifo_empty),
        .update_cache(update_cache),
        .done(Controller_done)
    );
endmodule