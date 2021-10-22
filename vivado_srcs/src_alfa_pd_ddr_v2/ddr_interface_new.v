

module ddr_interface #(parameter N = 16,
                    DISTANCE_MODULES = 1,
                    CORE_NUMBER = 2,
                    CACHE_MULTIPLIER=1,
                    CACHE_FEEDER_MULTIPLIER=1,
                    AXI_MODULE_OUTPUTS = 15,
                    DDR_BASE_ADDRESS =32'h0F000000                    
                    )(
                    //DDR_MODULE CONNECTION
                    output reg[31:0] o_write_address,
                    output reg[63:0] o_write_payload,
                    output reg[31:0] o_readAdress,
                    output reg o_initwritetxn,
                    output wire o_initreadtxn,
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
                     output reg[15:0] o_finish,
                    //AXI lite Module
                    input wire clock,
                    //DEBUG
                    output reg[6:0] state,
                    output reg[N*CORE_NUMBER-1:0] cache_x,
                    output reg[N*DISTANCE_MODULES-1:0]cache_feeder_x,
                    output reg[N-1:0] feeder_pos,
                    output wire[N-1:0] point_pointer
                    );


reg[N*CORE_NUMBER-1:0] l1_cache_x[15*CACHE_MULTIPLIER-1:0];
reg[N*CORE_NUMBER-1:0] l1_cache_y[15*CACHE_MULTIPLIER-1:0];
reg[N*CORE_NUMBER-1:0] l1_cache_z[15*CACHE_MULTIPLIER-1:0];
reg[N*CORE_NUMBER-1:0] l1_cache_i[15*CACHE_MULTIPLIER-1:0];


reg[N*DISTANCE_MODULES-1:0] l1_fcache_x[15*CACHE_FEEDER_MULTIPLIER-1:0];
reg[N*DISTANCE_MODULES-1:0] l1_fcache_y[15*CACHE_FEEDER_MULTIPLIER-1:0];
reg[N*DISTANCE_MODULES-1:0] l1_fcache_z[15*CACHE_FEEDER_MULTIPLIER-1:0];

reg[N*DISTANCE_MODULES-1:0] l2_fcache_x[15*CACHE_FEEDER_MULTIPLIER-1:0];
reg[N*DISTANCE_MODULES-1:0] l2_fcache_y[15*CACHE_FEEDER_MULTIPLIER-1:0];
reg[N*DISTANCE_MODULES-1:0] l2_fcache_z[15*CACHE_FEEDER_MULTIPLIER-1:0];

reg pause;
//reg[6:0] state;
reg[6:0] next_state;

reg parallel_fetch_feeder_cache;
reg parallel_update_feeder_cache;


//reg[N*CORE_NUMBER-1:0] cache_x;
reg[N*CORE_NUMBER-1:0] cache_y;
reg[N*CORE_NUMBER-1:0] cache_z;
reg[N*CORE_NUMBER-1:0] cache_i;


//reg[N*DISTANCE_MODULES-1:0]cache_feeder_x;
reg[N*DISTANCE_MODULES-1:0]cache_feeder_y;
reg[N*DISTANCE_MODULES-1:0]cache_feeder_z;

//reg[N-1:0] feeder_pos;

//wire[N*2-1:0] point_pointer;
reg [N-1:0] core_cache_status;
reg [N-1:0] node_cache_status;


reg[N*2-1:0] point_post_buffer;


reg read_fifo;
reg reset;
reg cache_updated;

reg updating_l1cache;
reg updating_l1_feeder_cache;

reg[1:0] feeder_l1_cache_status;  //0 -> outdated; 1-> updating; 2->updated; 
reg[1:0] cluster_l1_cache_status;  //0 -> outdated; 1-> updating; 2->updated; 

reg[8:0] l1_cache_window_index;
reg[8:0] l1_feeder_cache_window_index;


wire[N*2-1:0] point_pos;
wire[N-1:0] outlier_from_fifo;
wire update_cache;
wire Controller_done;
wire fifo_empty;
reg[CACHE_MULTIPLIER-1:0] update_cycle;

wire[CACHE_MULTIPLIER-1:0] cycle_offset;




reg state1_start;
reg state3_start;
reg start_state5;



reg state6_start;
reg whait_axi;
reg starting;
reg block_1cycle;
reg stored_update_cache;


assign cycle_offset = update_cycle * AXI_MODULE_OUTPUTS;
reg[15:0] noise_points;

reg [1:0]init_read_owner;

reg only_1read;

reg[N*2-1:0] point_pointer_base;


always @(posedge clock) begin    //prevent multiple reads.
    if (o_initreadtxn ==1) begin
        only_1read<=0;
    end
    else if (i_read_TxnDone && init_read_owner >0) begin
        only_1read <=1;
    end
    else if (rst==0) begin
        only_1read <=1;
    end
end


wire read_cache;
assign read_cache = ((init_read_owner==1)&&(only_1read==0))?1:0;
wire read_fcache;
assign read_fcache = ((init_read_owner==2)&&(only_1read==0))?1:0;
reg init_fetch_fcache;
reg init_fetch_cache;

integer index;
always @(posedge clock) begin
    if(i_read_TxnDone && read_cache)
    begin
        point_pointer_base <= point_post_buffer;
        //Updating x l1 cache
        l1_cache_x[0+cycle_offset] <= i_AMU_P0[15:0];
        l1_cache_x[1+cycle_offset] <= i_AMU_P1[15:0];
        l1_cache_x[2+cycle_offset] <= i_AMU_P2[15:0];
        l1_cache_x[3+cycle_offset] <= i_AMU_P3[15:0];
        l1_cache_x[4+cycle_offset] <= i_AMU_P4[15:0];
        l1_cache_x[5+cycle_offset] <= i_AMU_P5[15:0];
        l1_cache_x[6+cycle_offset] <= i_AMU_P6[15:0];
        l1_cache_x[7+cycle_offset] <= i_AMU_P7[15:0];
        l1_cache_x[8+cycle_offset] <= i_AMU_P8[15:0];
        l1_cache_x[9+cycle_offset] <= i_AMU_P9[15:0];
        l1_cache_x[10+cycle_offset] <= i_AMU_P10[15:0];
        l1_cache_x[11+cycle_offset] <= i_AMU_P11[15:0];
        l1_cache_x[12+cycle_offset] <= i_AMU_P12[15:0];
        l1_cache_x[13+cycle_offset] <= i_AMU_P13[15:0];
        l1_cache_x[14+cycle_offset] <= i_AMU_P14[15:0];
        //Updating y l1 cache
        l1_cache_y[0+cycle_offset] <= i_AMU_P0[31:16];
        l1_cache_y[1+cycle_offset] <= i_AMU_P1[31:16];
        l1_cache_y[2+cycle_offset] <= i_AMU_P2[31:16];
        l1_cache_y[3+cycle_offset] <= i_AMU_P3[31:16];
        l1_cache_y[4+cycle_offset] <= i_AMU_P4[31:16];
        l1_cache_y[5+cycle_offset] <= i_AMU_P5[31:16];
        l1_cache_y[6+cycle_offset] <= i_AMU_P6[31:16];
        l1_cache_y[7+cycle_offset] <= i_AMU_P7[31:16];
        l1_cache_y[8+cycle_offset] <= i_AMU_P8[31:16];
        l1_cache_y[9+cycle_offset] <= i_AMU_P9[31:16];
        l1_cache_y[10+cycle_offset] <= i_AMU_P10[31:16];
        l1_cache_y[11+cycle_offset] <= i_AMU_P11[31:16];
        l1_cache_y[12+cycle_offset] <= i_AMU_P12[31:16];
        l1_cache_y[13+cycle_offset] <= i_AMU_P13[31:16];
        l1_cache_y[14+cycle_offset] <= i_AMU_P14[31:16];
        //Updating z l1 cache
        l1_cache_z[0+cycle_offset] <= i_AMU_P0[47:32];
        l1_cache_z[1+cycle_offset] <= i_AMU_P1[47:32];
        l1_cache_z[2+cycle_offset] <= i_AMU_P2[47:32];
        l1_cache_z[3+cycle_offset] <= i_AMU_P3[47:32];
        l1_cache_z[4+cycle_offset] <= i_AMU_P4[47:32];
        l1_cache_z[5+cycle_offset] <= i_AMU_P5[47:32];
        l1_cache_z[6+cycle_offset] <= i_AMU_P6[47:32];
        l1_cache_z[7+cycle_offset] <= i_AMU_P7[47:32];
        l1_cache_z[8+cycle_offset] <= i_AMU_P8[47:32];
        l1_cache_z[9+cycle_offset] <= i_AMU_P9[47:32];
        l1_cache_z[10+cycle_offset] <= i_AMU_P10[47:32];
        l1_cache_z[11+cycle_offset] <= i_AMU_P11[47:32];
        l1_cache_z[12+cycle_offset] <= i_AMU_P12[47:32];
        l1_cache_z[13+cycle_offset] <= i_AMU_P13[47:32];
        l1_cache_z[14+cycle_offset] <= i_AMU_P14[47:32];
        //updating i l1 cache
        l1_cache_i[0+cycle_offset] <= i_AMU_P0[63:48];
        l1_cache_i[1+cycle_offset] <= i_AMU_P1[63:48];
        l1_cache_i[2+cycle_offset] <= i_AMU_P2[63:48];
        l1_cache_i[3+cycle_offset] <= i_AMU_P3[63:48];
        l1_cache_i[4+cycle_offset] <= i_AMU_P4[63:48];
        l1_cache_i[5+cycle_offset] <= i_AMU_P5[63:48];
        l1_cache_i[6+cycle_offset] <= i_AMU_P6[63:48];
        l1_cache_i[7+cycle_offset] <= i_AMU_P7[63:48];
        l1_cache_i[8+cycle_offset] <= i_AMU_P8[63:48];
        l1_cache_i[9+cycle_offset] <= i_AMU_P9[63:48];
        l1_cache_i[10+cycle_offset] <= i_AMU_P10[63:48];
        l1_cache_i[11+cycle_offset] <= i_AMU_P11[63:48];
        l1_cache_i[12+cycle_offset] <= i_AMU_P12[63:48];
        l1_cache_i[13+cycle_offset] <= i_AMU_P13[63:48];
        l1_cache_i[14+cycle_offset] <= i_AMU_P14[63:48];
    end
    else if (rst==0 || state==0) begin
        point_pointer_base <=0;
        for (index= 0;index<CACHE_MULTIPLIER ;index = index+1) begin
            l1_cache_x[0+index] <= 0;
            l1_cache_x[1+index] <= 0;
            l1_cache_x[2+index] <= 0;
            l1_cache_x[3+index] <= 0;
            l1_cache_x[4+index] <= 0;
            l1_cache_x[5+index] <= 0;
            l1_cache_x[6+index] <= 0;
            l1_cache_x[7+index] <= 0;
            l1_cache_x[8+index] <= 0;
            l1_cache_x[9+index] <= 0;
            l1_cache_x[10+index] <=0;
            l1_cache_x[11+index] <=0;
            l1_cache_x[12+index] <=0;
            l1_cache_x[13+index] <=0;
            l1_cache_x[14+index] <=0;
            //Updating y l1 cache
            l1_cache_y[0+index] <=  0;
            l1_cache_y[1+index] <=  0;
            l1_cache_y[2+index] <=  0;
            l1_cache_y[3+index] <=  0;
            l1_cache_y[4+index] <=  0;
            l1_cache_y[5+index] <=  0;
            l1_cache_y[6+index] <=  0;
            l1_cache_y[7+index] <=  0;
            l1_cache_y[8+index] <=  0;
            l1_cache_y[9+index] <=  0;
            l1_cache_y[10+index] <= 0;
            l1_cache_y[11+index] <= 0;
            l1_cache_y[12+index] <= 0;
            l1_cache_y[13+index] <= 0;
            l1_cache_y[14+index] <= 0;
            //Updating z l1 cache
            l1_cache_z[0+index] <=  0;
            l1_cache_z[1+index] <=  0;
            l1_cache_z[2+index] <=  0;
            l1_cache_z[3+index] <=  0;
            l1_cache_z[4+index] <=  0;
            l1_cache_z[5+index] <=  0;
            l1_cache_z[6+index] <=  0;
            l1_cache_z[7+index] <=  0;
            l1_cache_z[8+index] <=  0;
            l1_cache_z[9+index] <=  0;
            l1_cache_z[10+index] <= 0;
            l1_cache_z[11+index] <= 0;
            l1_cache_z[12+index] <= 0;
            l1_cache_z[13+index] <= 0;
            l1_cache_z[14+index] <= 0;
            //updating i l1 cache
            l1_cache_i[0+index] <=  0;
            l1_cache_i[1+index] <=  0;
            l1_cache_i[2+index] <=  0;
            l1_cache_i[3+index] <=  0;
            l1_cache_i[4+index] <=  0;
            l1_cache_i[5+index] <=  0;
            l1_cache_i[6+index] <=  0;
            l1_cache_i[7+index] <=  0;
            l1_cache_i[8+index] <=  0;
            l1_cache_i[9+index] <=  0;
            l1_cache_i[10+index] <= 0;
            l1_cache_i[11+index] <= 0;
            l1_cache_i[12+index] <= 0;
            l1_cache_i[13+index] <= 0;
            l1_cache_i[14+index] <= 0;
        end
    end
end

always @(posedge clock) begin
     if(i_read_TxnDone && only_1read == 0 && init_read_owner>0)
     begin
            update_cycle <= update_cycle + 1;
     end
    else if (rst==0 ||state==0) begin
        update_cycle <=0;
     end
    else if (init_read_owner==0) begin
            update_cycle <=0;
    end

end
reg hold_cache;
always @(posedge clock) begin    //update l1 feeder cache
    if (i_read_TxnDone && (read_fcache||hold_cache))
    begin
        if (l1_feeder_cache_window_index==0) begin
            hold_cache<=0;
            l1_fcache_x[0+cycle_offset] <= i_AMU_P0[15:0];
            l1_fcache_x[1+cycle_offset] <= i_AMU_P1[15:0];
            l1_fcache_x[2+cycle_offset] <= i_AMU_P2[15:0];
            l1_fcache_x[3+cycle_offset] <= i_AMU_P3[15:0];
            l1_fcache_x[4+cycle_offset] <= i_AMU_P4[15:0];
            l1_fcache_x[5+cycle_offset] <= i_AMU_P5[15:0];
            l1_fcache_x[6+cycle_offset] <= i_AMU_P6[15:0];
            l1_fcache_x[7+cycle_offset] <= i_AMU_P7[15:0];
            l1_fcache_x[8+cycle_offset] <= i_AMU_P8[15:0];
            l1_fcache_x[9+cycle_offset] <= i_AMU_P9[15:0];
            l1_fcache_x[10+cycle_offset] <= i_AMU_P10[15:0];
            l1_fcache_x[11+cycle_offset] <= i_AMU_P11[15:0];
            l1_fcache_x[12+cycle_offset] <= i_AMU_P12[15:0];
            l1_fcache_x[13+cycle_offset] <= i_AMU_P13[15:0];
            l1_fcache_x[14+cycle_offset] <= i_AMU_P14[15:0];
            //Updating y l1 cache
            l1_fcache_y[0+cycle_offset] <= i_AMU_P0[31:16];
            l1_fcache_y[1+cycle_offset] <= i_AMU_P1[31:16];
            l1_fcache_y[2+cycle_offset] <= i_AMU_P2[31:16];
            l1_fcache_y[3+cycle_offset] <= i_AMU_P3[31:16];
            l1_fcache_y[4+cycle_offset] <= i_AMU_P4[31:16];
            l1_fcache_y[5+cycle_offset] <= i_AMU_P5[31:16];
            l1_fcache_y[6+cycle_offset] <= i_AMU_P6[31:16];
            l1_fcache_y[7+cycle_offset] <= i_AMU_P7[31:16];
            l1_fcache_y[8+cycle_offset] <= i_AMU_P8[31:16];
            l1_fcache_y[9+cycle_offset] <= i_AMU_P9[31:16];
            l1_fcache_y[10+cycle_offset] <= i_AMU_P10[31:16];
            l1_fcache_y[11+cycle_offset] <= i_AMU_P11[31:16];
            l1_fcache_y[12+cycle_offset] <= i_AMU_P12[31:16];
            l1_fcache_y[13+cycle_offset] <= i_AMU_P13[31:16];
            l1_fcache_y[14+cycle_offset] <= i_AMU_P14[31:16];
            //Updating z l1 cache
            l1_fcache_z[0+cycle_offset] <= i_AMU_P0[47:32];
            l1_fcache_z[1+cycle_offset] <= i_AMU_P1[47:32];
            l1_fcache_z[2+cycle_offset] <= i_AMU_P2[47:32];
            l1_fcache_z[3+cycle_offset] <= i_AMU_P3[47:32];
            l1_fcache_z[4+cycle_offset] <= i_AMU_P4[47:32];
            l1_fcache_z[5+cycle_offset] <= i_AMU_P5[47:32];
            l1_fcache_z[6+cycle_offset] <= i_AMU_P6[47:32];
            l1_fcache_z[7+cycle_offset] <= i_AMU_P7[47:32];
            l1_fcache_z[8+cycle_offset] <= i_AMU_P8[47:32];
            l1_fcache_z[9+cycle_offset] <= i_AMU_P9[47:32];
            l1_fcache_z[10+cycle_offset] <= i_AMU_P10[47:32];
            l1_fcache_z[11+cycle_offset] <= i_AMU_P11[47:32];
            l1_fcache_z[12+cycle_offset] <= i_AMU_P12[47:32];
            l1_fcache_z[13+cycle_offset] <= i_AMU_P13[47:32];
            l1_fcache_z[14+cycle_offset] <= i_AMU_P14[47:32];
        end
        else begin
            hold_cache <=1;
        end
    end
    else if(rst ==0 || state==0) begin
        hold_cache<=0;
        for (index= 0;index<CACHE_FEEDER_MULTIPLIER ;index = index+1) begin
            l1_fcache_x[0+index] <= 0;
            l1_fcache_x[1+index] <= 0;
            l1_fcache_x[2+index] <= 0;
            l1_fcache_x[3+index] <= 0;
            l1_fcache_x[4+index] <= 0;
            l1_fcache_x[5+index] <= 0;
            l1_fcache_x[6+index] <= 0;
            l1_fcache_x[7+index] <= 0;
            l1_fcache_x[8+index] <= 0;
            l1_fcache_x[9+index] <= 0;
            l1_fcache_x[10+index] <=0;
            l1_fcache_x[11+index] <=0;
            l1_fcache_x[12+index] <=0;
            l1_fcache_x[13+index] <=0;
            l1_fcache_x[14+index] <=0;
            //Updating y l1 cache
            l1_fcache_y[0+index] <=  0;
            l1_fcache_y[1+index] <=  0;
            l1_fcache_y[2+index] <=  0;
            l1_fcache_y[3+index] <=  0;
            l1_fcache_y[4+index] <=  0;
            l1_fcache_y[5+index] <=  0;
            l1_fcache_y[6+index] <=  0;
            l1_fcache_y[7+index] <=  0;
            l1_fcache_y[8+index] <=  0;
            l1_fcache_y[9+index] <=  0;
            l1_fcache_y[10+index] <= 0;
            l1_fcache_y[11+index] <= 0;
            l1_fcache_y[12+index] <= 0;
            l1_fcache_y[13+index] <= 0;
            l1_fcache_y[14+index] <= 0;
            //Updating z l1 cache
            l1_fcache_z[0+index] <=  0;
            l1_fcache_z[1+index] <=  0;
            l1_fcache_z[2+index] <=  0;
            l1_fcache_z[3+index] <=  0;
            l1_fcache_z[4+index] <=  0;
            l1_fcache_z[5+index] <=  0;
            l1_fcache_z[6+index] <=  0;
            l1_fcache_z[7+index] <=  0;
            l1_fcache_z[8+index] <=  0;
            l1_fcache_z[9+index] <=  0;
            l1_fcache_z[10+index] <= 0;
            l1_fcache_z[11+index] <= 0;
            l1_fcache_z[12+index] <= 0;
            l1_fcache_z[13+index] <= 0;
            l1_fcache_z[14+index] <= 0;
            //updating i l1 cache
        
        end
    end
end

assign o_initreadtxn = (init_fetch_cache || init_fetch_fcache)?1:0;
wire restart_axi_cache;
assign restart_axi_cache = (i_read_TxnDone && (update_cycle < CACHE_MULTIPLIER-1)&& (only_1read==0) )?1:0;
wire restart_axi_fcache;
assign restart_axi_fcache = (i_read_TxnDone && (update_cycle < CACHE_MULTIPLIER-1)&& (only_1read==0) )?1:0;


always @(posedge clock) begin    //axi addr and owner block
    if (i_read_TxnDone && init_read_owner>0 && only_1read==0) begin
        init_read_owner<=0;
    end
    else if (init_fetch_fcache || init_fetch_cache) begin
        init_fetch_cache <=0;
        init_fetch_fcache <=0;
    end
    else if (state==1) begin
        if (state1_start == 0) begin
            o_readAdress <= ((point_pointer)<<3) +DDR_BASE_ADDRESS;
            point_post_buffer <= point_pointer;
            init_read_owner <=1;
            init_fetch_cache <=1;
        end
        else if (restart_axi_cache) begin
            o_readAdress <= ((point_pointer+cycle_offset)<<3) +DDR_BASE_ADDRESS;
            init_read_owner <=1;
            init_fetch_cache <=1;
        end
    end
    else if ((state == 3) || (((parallel_fetch_feeder_cache == 1)&&(state==5)))&&l1_feeder_cache_window_index==0) begin
        if (state3_start == 0 && init_read_owner ==0) begin
            o_readAdress <= (((feeder_pos<<3))+DDR_BASE_ADDRESS);
            init_read_owner <=2;
            init_fetch_fcache <=1;
        end
        else if (restart_axi_fcache) begin 
            o_readAdress <= (((feeder_pos+cycle_offset)<<3)+DDR_BASE_ADDRESS);
            init_read_owner <=2;
            init_fetch_fcache <=1;
        end
    end
    else if (rst == 0 || state==0) begin
        o_readAdress <= DDR_BASE_ADDRESS;
        init_read_owner <=0;
        init_fetch_fcache <=0;
        init_fetch_cache <=0;
    end
end




always @(posedge clock) begin   //fetch l1 cache (fetch l1 cluster cache )
    if(state ==1)
    begin
        if (state1_start==0)begin   //gives the first start
            state1_start <=1;
        end
    end
    else if (rst==0 || state==0) begin
        state1_start <=0;
    end
    else begin
        state1_start <=0;
    end
    
end


wire[N-1:0] points_to_update;
assign points_to_update = point_pointer-point_pointer_base;
integer i;
always @(posedge clock) begin    //State 2 block (update cluster cache)
    if (state == 2) begin
        if (points_to_update >=AXI_MODULE_OUTPUTS*CACHE_MULTIPLIER-1) begin
            l1_cache_window_index <=0;
        end
        else begin
            //l1_cache_window_index <= l1_cache_window_index + points_to_update;
            for (i = 0 ;i<CORE_NUMBER ; i = i +1 ) begin
            if (i == 0) begin
                cache_x = l1_cache_x[points_to_update];
                cache_y = l1_cache_y[points_to_update];
                cache_z = l1_cache_z[points_to_update];
                cache_i = l1_cache_i[points_to_update];
            end
            else begin
                cache_x = cache_x + (l1_cache_x[i+points_to_update]<<(i*N));
                cache_y = cache_y + (l1_cache_y[i+points_to_update]<<(i*N));
                cache_z = cache_z + (l1_cache_z[i+points_to_update]<<(i*N));
                cache_i = cache_i + (l1_cache_i[i+points_to_update]<<(i*N));
            end
        end
        end
    end
    else if (rst ==0 || state==0) begin
            l1_cache_window_index <=0;
            cache_x <= 0;
            cache_y <= 0;
            cache_z <= 0;
            cache_i <= 0;
    end
end


wire state3_finish;
assign state3_finish = (i_read_TxnDone && (update_cycle+1 >= CACHE_FEEDER_MULTIPLIER-1) && only_1read==0 )?1:0;
always @(posedge clock) begin  //state 3 block (Fetch feeder l1 cache)
    if ((state == 3) || (((parallel_fetch_feeder_cache == 1)&&(state==5)))&&l1_feeder_cache_window_index==0) begin
        if (state3_start==0 && (init_read_owner ==0))begin   //gives the first start
            state3_start <=1;
            feeder_l1_cache_status <=1;
        end
        else if (state3_finish) begin  //module finish, cleaning
            state3_start <=0;
            if (feeder_pos + AXI_MODULE_OUTPUTS> i_pointcloud_size ) begin
                feeder_pos<=0;
            end
            else begin
                feeder_pos <= feeder_pos + (update_cycle+1)*AXI_MODULE_OUTPUTS;  //Update feeder_pos
            end
        end
    end
    else if (init_read_owner == 2 && i_read_TxnDone && only_1read==0) begin
        if (feeder_pos + AXI_MODULE_OUTPUTS> i_pointcloud_size ) begin
                feeder_pos<=0;
            end
            else begin
                feeder_pos <= feeder_pos + (update_cycle)*AXI_MODULE_OUTPUTS;  //Update feeder_pos
            end
    end
    else if(state ==0) begin
        feeder_pos<=0;
    end
    else if (rst==0 || state==0) begin
        state3_start <=0;
        feeder_pos <=0;
        feeder_l1_cache_status <=0;
    end
    else begin
        state3_start <=0;
    end 
end



always @(posedge clock) begin //state 4 block (Update feeder cache) 
    if ((state == 4 || parallel_update_feeder_cache == 1)&& update_cache==0) begin
        
        for (i = 0 ;i<DISTANCE_MODULES ; i = i +1 ) begin
            if (i == 0) begin
                cache_feeder_x = l1_fcache_x[l1_feeder_cache_window_index];
                cache_feeder_y = l1_fcache_y[l1_feeder_cache_window_index];
                cache_feeder_z = l1_fcache_z[l1_feeder_cache_window_index];
            end
            else begin
                cache_feeder_x = cache_feeder_x + (l1_fcache_x[i+l1_feeder_cache_window_index]<<(i*N));
                cache_feeder_y = cache_feeder_y + (l1_fcache_y[i+l1_feeder_cache_window_index]<<(i*N));
                cache_feeder_z = cache_feeder_z + (l1_fcache_z[i+l1_feeder_cache_window_index]<<(i*N));
            end
        end

        if ((l1_feeder_cache_window_index+DISTANCE_MODULES) >=(AXI_MODULE_OUTPUTS*CACHE_FEEDER_MULTIPLIER)) begin
            l1_feeder_cache_window_index <=0;
        end
        else begin
            l1_feeder_cache_window_index <= l1_feeder_cache_window_index + DISTANCE_MODULES;           
        end
    end
        else if (rst ==0 || state==0) begin
            l1_feeder_cache_window_index <=0;
            cache_feeder_x <=0;
            cache_feeder_y <=0;
            cache_feeder_z <=0;
    end
end





always @(posedge clock) begin //state 5 block (Signal handling)   //mark for debug
    if (rst == 1) begin
        if (state==5) begin
             //if((update_cache||stored_update_cache) && (i_read_TxnDone && (update_cycle+1 >= CACHE_FEEDER_MULTIPLIER-1) && (start_new_trans==0)))  //if needs to update cache and its not in a axi transaction
            if((update_cache||stored_update_cache))
            begin
                parallel_fetch_feeder_cache <=0;
                parallel_update_feeder_cache <=0;
                start_state5 <=0;
            end
            else if (start_state5 == 0) begin
                parallel_fetch_feeder_cache <= 1;
                if ((l1_feeder_cache_window_index) <(AXI_MODULE_OUTPUTS*CACHE_FEEDER_MULTIPLIER)) begin
                        parallel_update_feeder_cache <=1;
                end
                else begin
                        parallel_update_feeder_cache <=0;
                end
                start_state5 <=1;
            end
            else if ((l1_feeder_cache_window_index+DISTANCE_MODULES) >=(AXI_MODULE_OUTPUTS*CACHE_FEEDER_MULTIPLIER)) begin
                parallel_update_feeder_cache <= 0;
                parallel_fetch_feeder_cache <= 1;
            end
            else if (i_read_TxnDone && (update_cycle+1 >= CACHE_FEEDER_MULTIPLIER-1)&&init_read_owner==2) begin
                parallel_update_feeder_cache <=1;
                parallel_fetch_feeder_cache <= 1;
            end
            else if (Controller_done) begin
                start_state5 <=0;
                parallel_fetch_feeder_cache <=0;
                parallel_update_feeder_cache <=0;
            end 
        end
        //else begin
                //parallel_fetch_feeder_cache <=0;
                //parallel_update_feeder_cache <=0;
                //delay_state5<=0;
        //end
    end
    else begin
        parallel_fetch_feeder_cache <=0;
        parallel_update_feeder_cache <=0;
        start_state5 <=0;
    end
end





always @(posedge clock) begin
    if (rst==1) begin
        if (state== 6) begin
            if(o_initwritetxn)begin
                o_initwritetxn <=0;
            end
            else if ((state6_start==0) && (read_fifo ==0) && (whait_axi ==0)) begin
                read_fifo <= 1;
            end
            else if (read_fifo ==1) begin
                state6_start<=1;
                read_fifo <=0;
            end
            else if (state6_start==1)begin   //gives the first start
                noise_points <= noise_points +1;
                o_write_address <=DDR_BASE_ADDRESS+(outlier_from_fifo<<3);
                o_initwritetxn <=1;
                o_write_payload <= 0;
                state6_start <=0;
                whait_axi <=1;
            end
            else if (i_write_TxnDone) begin
                whait_axi <=0;
            end
            else if (fifo_empty) begin
                read_fifo <=0;
            end
        end
    else if(state==0) begin
        state6_start <=0;
        read_fifo <=0;
        whait_axi <=0;
        noise_points<=0;
        o_initwritetxn<=0;
        o_write_address<=0;
        o_write_payload <=0;
    end
    
    end
    else if (rst==0 || state==0) begin
        state6_start <=0;
        read_fifo <=0;
        whait_axi <=0;
        noise_points<=0;
        o_initwritetxn<=0;
        o_write_address<=0;
        o_write_payload <=0;
    end
end




always @(posedge clock) begin
    if (rst == 1) begin
      case (state)
          0:begin //Start
              if (i_start) begin
                  state <= 1;
                  starting <=1;
                  o_finish <=0;
                  pause <=1;
              end
              else
              begin
               reset <=1;
              end
          end 
          1:begin //Fetch l1 cache
              if (i_read_TxnDone && (update_cycle+1 >= CACHE_MULTIPLIER-1) &&(state1_start==1)&& only_1read == 0) begin   //Se recebeu uma trançasao, e nao precisa de fazer mais nenhuma transaçao
                  next_state<=2;
                  state<=7;
              end
          end
          2:begin // update cluster cache
                if((points_to_update) >=(AXI_MODULE_OUTPUTS*CACHE_MULTIPLIER-1))
                begin
                   state <=1;
                end
                else if(starting)
                begin
                    cache_updated <= 1;
                    state<=3;
                end
                else
                begin
                    cache_updated <= 1;
                    state <= 5;
                end
                block_1cycle <= 1;
          end
          3:begin //Fetch feeder cache
              if (state3_finish) begin   //Se recebeu uma trançasao, e nao precisa de fazer mais nenhuma transaçao
                  state<=4;
              end
          end
          4: begin //Update feeder cache
                if((l1_feeder_cache_window_index+DISTANCE_MODULES) >=(AXI_MODULE_OUTPUTS*CACHE_FEEDER_MULTIPLIER)) begin
                    state<=3;
                end
                else if (starting) begin
                    starting <=0;
                    state <= 7;
                    next_state <=5;
                    reset <=0;
                end
                else begin
                    state <= 5;
                end
                
                  
          end
          5: begin //signal handling
              if (Controller_done) begin
                  state <=6;
              end
              else if(update_cache)begin
                  pause <=1;
                  if (init_read_owner ==0) begin
                      state<=2;
                  end
                  else begin
                      stored_update_cache <=1;
                  end
              end
              else if (stored_update_cache) begin
                  if (i_read_TxnDone && (update_cycle+1 >= CACHE_FEEDER_MULTIPLIER-1)) begin
                      state <=2;
                      stored_update_cache <=0;
                  end
              end
              else if (parallel_update_feeder_cache && ((l1_feeder_cache_window_index+DISTANCE_MODULES) <(AXI_MODULE_OUTPUTS*CACHE_FEEDER_MULTIPLIER))) begin
                  pause <=0;
              end
              else begin
                  pause <=1;
              end
          end
          6:begin // Finish state
              if (fifo_empty == 1) begin
                  state <= 7;
                  next_state <=0;
                  o_finish <=noise_points+1;
              end
              else begin
                  
              end
          end
          7:begin // whait clock
              state <= next_state;
          end
          default: state<=0;
      endcase
    end
    else
    begin
        state <=0;
        starting <= 0;
        stored_update_cache <=0;
        o_finish <=0;
        reset<=1;
        pause <=1;
    end
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
        .point_cloud_size(i_pointcloud_size),
        .read_fifo(read_fifo),
        .filter_selector(i_filtertype),
        .cache_updated(cache_update),
        .pause(pause),
        .outlier_pos_fifo(outlier_from_fifo),
        .point_pos(point_pointer),
        .empty(fifo_empty),
        .update_cache(update_cache),
        .done(Controller_done)
    );
endmodule