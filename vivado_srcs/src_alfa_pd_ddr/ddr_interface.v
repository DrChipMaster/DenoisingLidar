

module ddr_interface #(parameter N = 16,
                    DISTANCE_MODULES = 1,
                    CORE_NUMBER = 16,
                    CACHE_MULTIPLIER=1,
                    AXI_MODULE_OUTPUTS = 15                    
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
                     output reg[15:0] o_finish,
                    //AXI lite Module
                    input clock,
                    input rst
                    );


reg[N*CORE_NUMBER-1:0] l1_cache_x[15*CACHE_MULTIPLIER-1:0];
reg[N*CORE_NUMBER-1:0] l1_cache_y[15*CACHE_MULTIPLIER-1:0];
reg[N*CORE_NUMBER-1:0] l1_cache_z[15*CACHE_MULTIPLIER-1:0];
reg[N*CORE_NUMBER-1:0] l1_cache_i[15*CACHE_MULTIPLIER-1:0];


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
reg[6:0] next_state;


reg read_fifo;
reg reset;
reg cache_updated;
reg pause;

reg updating_l1cache;
reg updating_l1_feeder_cache;
reg[1:0] feeder_l1_cache_status  //0 -> outdated; 1-> updating; 2->updated; 
reg[1:0] cluster_l1_cache_status  //0 -> outdated; 1-> updating; 2->updated; 

reg[8:0] l1cache_window_index;
reg[8:0] l1_feeder_cache_window_index;


wire[N*2-1:0] point_pos;
wire[N-1:0] outlier_from_fifo;
wire update_cache;
wire Controller_done;
wire fifo_empty;
reg[CACHE_MULTIPLIER-1:0] update_cycle;

wire[CACHE_MULTIPLIER-1:0] cycle_offset;


assign cycle_offset = update_cycle * AXI_MODULE_OUTPUTS;
reg[15:0] noise_points;

always @(posedge clock) begin
    if(i_read_TxnDone && updating_l1cache)
    begin
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
end

always @(posedge clock) begin
     if(i_read_TxnDone && (updating_l1cache or updating_l1_feeder_cache))
     begin
            update_cycle <= update_cycle + 1;
     end
     else if (!updating_l1cache and !updating_l1_feeder_cache) begin
            update_cycle <=0;
     end
end

always @(posedge clock) begin
    if (i_read_TxnDone and updating_l1_feeder_cache)
    begin
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
        //Ufpdating y l1 cache
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
        //Ufpdating z l1 cache
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
        //ufpdating i l1 cache
        l1_fcache_i[0+cycle_offset] <= i_AMU_P0[63:48];
        l1_fcache_i[1+cycle_offset] <= i_AMU_P1[63:48];
        l1_fcache_i[2+cycle_offset] <= i_AMU_P2[63:48];
        l1_fcache_i[3+cycle_offset] <= i_AMU_P3[63:48];
        l1_fcache_i[4+cycle_offset] <= i_AMU_P4[63:48];
        l1_fcache_i[5+cycle_offset] <= i_AMU_P5[63:48];
        l1_fcache_i[6+cycle_offset] <= i_AMU_P6[63:48];
        l1_fcache_i[7+cycle_offset] <= i_AMU_P7[63:48];
        l1_fcache_i[8+cycle_offset] <= i_AMU_P8[63:48];
        l1_fcache_i[9+cycle_offset] <= i_AMU_P9[63:48];
        l1_fcache_i[10+cycle_offset] <= i_AMU_P10[63:48];
        l1_fcache_i[11+cycle_offset] <= i_AMU_P11[63:48];
        l1_fcache_i[12+cycle_offset] <= i_AMU_P12[63:48];
        l1_fcache_i[13+cycle_offset] <= i_AMU_P13[63:48];
        l1_fcache_i[14+cycle_offset] <= i_AMU_P14[63:48];
    end
end


reg state1_start;
always @(posedge clock) begin   //fetch l1 cache
    if(state ==1)
    begin
        if(o_initreadtxn)begin
            o_initreadtxn <=0;
        end
        else if (state1_start==0)begin   //gives the first start
            o_readAdress <= point_pointer +2 + cycle_offset;
            o_initreadtxn <=1;
            state1_start <=1;
        end
        else if (i_read_TxnDone and update_cycle+1 < CACHE_MULTIPLIER-1) begin // keeps starting untill cache is full
            o_readAdress <= point_pointer +2 + cycle_offset+AXI_MODULE_OUTPUTS;
            o_initreadtxn <=1;
        end 
        else if (i_read_TxnDone and update_cycle+1 >= CACHE_MULTIPLIER-1) begin  //module finish, cleaning
            state1_start <=0;
        end
    end
    else if (rst==0) begin
        state1_start <=0;
    end
end



integer i;
always @(posedge clock) begin    //State 2 block
    if (state == 2) begin
        for (i = l1_cache_window_index ;i<l1_cache_window_index+CORE_NUMBER ; i = i +1 ) begin
            if (i == l1_cache_window_index) begin
                cache_x = l1_cache_x[0];
                cache_y = l1_cache_y[0];
                cache_z = l1_cache_z[0];
                cache_i = l1_cache_i[0];
            end
            else begin
                cache_x = cache_x + (l1_cache_x[i-l1_cache_window_index]<<((i-l1_cache_window_index)*N));
                cache_y = cache_y + (l1_cache_y[i-l1_cache_window_index]<<((i-l1_cache_window_index)*N));
                cache_z = cache_z + (l1_cache_z[i-l1_cache_window_index]<<((i-l1_cache_window_index)*N));
                cache_i = cache_i + (l1_cache_i[i-l1_cache_window_index]<<((i-l1_cache_window_index)*N));
            end
        end
        if (l1_cache_window_index+CORE_NUMBER >=AXI_MODULE_OUTPUTS*CACHE_MULTIPLIER) begin
            l1_cache_window_index <=0;
        end
        else begin
            l1_cache_window_index <= l1_cache_window_index + CORE_NUMBER;
        end
    end
end


reg state3_start;
always @(posedge clock) begin  //state 3 block (Fetch feeder l1 cache)
    if (state == 3) begin
        if(o_initreadtxn)begin
            o_initreadtxn <=0;
        end
        else if (state3_start==0)begin   //gives the first start
            o_readAdress <= feeder_pos;
            o_initreadtxn <=1;
            state3_start <=1;
            feeder_pos <= feeder_pos + AXI_MODULE_OUTPUTS;
        end
        else if (i_read_TxnDone and update_cycle+1 < CACHE_MULTIPLIER-1) begin // keeps starting untill cache is full
            o_readAdress <= feeder_pos;
            o_initreadtxn <=1;
            feeder_pos <= feeder_pos + AXI_MODULE_OUTPUTS;
        end 
        else if (i_read_TxnDone and update_cycle+1 >= CACHE_MULTIPLIER-1) begin  //module finish, cleaning
            state3_start <=0;
        end
    end
    else if (rst==0) begin
        state3_start <=0;
        feeder_pos <=0;
    end
end




always @(posedge clock) begin //state 4 block (Update feeder cache) 
    if (state == 4) begin
        for (i = l1_feeder_cache_window_index ;i<l1_feeder_cache_window_index+DISTANCE_MODULES ; i = i +1 ) begin
            if (i == l1_feeder_cache_window_index) begin
                cache_x = l1_cache_x[0];
                cache_y = l1_cache_y[0];
                cache_z = l1_cache_z[0];
            end
            else begin
                cache_x = cache_x + (l1_cache_x[i-l1_feeder_cache_window_index]<<((i-l1_feeder_cache_window_index)*N));
                cache_y = cache_y + (l1_cache_y[i-l1_feeder_cache_window_index]<<((i-l1_feeder_cache_window_index)*N));
                cache_z = cache_z + (l1_cache_z[i-l1_feeder_cache_window_index]<<((i-l1_feeder_cache_window_index)*N));
            end
        end
        if (l1_feeder_cache_window_index+CORE_NUMBER >=AXI_MODULE_OUTPUTS*CACHE_MULTIPLIER) begin
            l1_feeder_cache_window_index <=0;
        end
        else begin
            l1_feeder_cache_window_index <= l1_feeder_cache_window_index + CORE_NUMBER;
        end
    end
end



reg parallel_fetch_feeder_cache;
reg parallel_update_feeder_cache;
always @(posedge clock) begin
    if (state ==5) begin
        
    end
end







always @(posedge clock) begin
    if (rst == 1) begin
      case (state)
          0:begin //Start
              if (i_start) begin
                  state <= 1;
                  starting <=1;
                  noise_points<=0;
              end
          end 
          1:begin //Fetch l1 cache
              if (i_read_TxnDone and update_cycle+1 >= CACHE_MULTIPLIER-1) begin   //Se recebeu uma trançasao, e nao precisa de fazer mais nenhuma transaçao
                  state<=2;
              end
          end
          2:begin // update cluster cache
                if(l1_cache_window_index+CORE_NUMBER >=15*CACHE_MULTIPLIER)
                begin
                   state <=1;
                end
                else if(starting)
                begin
                    state<=3;
                end
                else
                begin
                    state <= 5;
                end
          end
          3:begin //Fetch feeder cache
              if (i_read_TxnDone and update_cycle+1 >= CACHE_MULTIPLIER-1) begin   //Se recebeu uma trançasao, e nao precisa de fazer mais nenhuma transaçao
                  state<=4;
              end
          end
          4: begin //Update feeder cache
                if(l1_feeder_cache_window_index+CORE_NUMBER >=15*CACHE_MULTIPLIER) begin
                    state<=3;
                end
                else if (starting) begin
                    starting <=0;
                    state <= 7;
                    next_state <=5;
                end
                else begin
                    state <= 5;
                end
                
                  
          end
          5: begin //signal handling  
              if(update_cache)begin
                  pause <=1;
                  state<=2;
              end
              else if (Controller_done) begin
                  state <=6;
              end
              else if(l1_feeder_cache_window_index+CORE_NUMBER >=15*CACHE_MULTIPLIER) begin
                  pause <=1;
                  state<=3;
              end
              else begin
                  pause <=0;
              end
          end
          6:begin // Finish state
              if (fifo_empty == 1) begin
                  read_fifo <=0;
                  state <= 7;
                  next_state <=0;
                  o_finish <=noise_points;
              end
              else begin
                  noise_points <= noise_points +1;
                  read_fifo <=1;
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