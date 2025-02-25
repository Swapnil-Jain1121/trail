`include "2_Memory_handshake.v";
module tb_memory();
    //1kb memory with 16 bit width
    //width = 16, depth = 64, addr_width = 6
    parameter WIDTH      = 16;
    parameter DEPTH      = 16;
    parameter ADDR_WIDTH = 4;
    
    reg clk_i, rst_i;
    reg [ADDR_WIDTH-1:0] addr_i;
    reg [WIDTH-1:0] wdata_i;
    wire [WIDTH-1:0] rdata_o;
    reg wr_rd_i;
    reg valid_i;
    wire ready_o;
    integer i;
    
    memory #(.DEPTH(16), .ADDR_WIDTH(4), .WIDTH(WIDTH)) DUT(clk_i, rst_i, addr_i, wdata_i, rdata_o, wr_rd_i, valid_i, ready_o);
    
    always #5 clk_i = ~clk_i;
    
    initial begin
        clk_i = 0;
        rst_i = 1;
        #20;
        rst_i = 0;
        
        //now apply the stimulus
        //write and read to first 1/4 location
        write_memory(0,DEPTH/4);
        read_memory(0,DEPTH/4);
        
        //write and read to second 1/4 location
        write_memory(DEPTH/4,DEPTH/4);
        read_memory(DEPTH/4,DEPTH/4);
        
        //write and read to third 1/4 location
        write_memory(DEPTH/2,DEPTH/4);
        read_memory(DEPTH/2,DEPTH/4);
        
        //write and read to last 1/4 location
        write_memory(3*DEPTH/2,DEPTH/4);
        read_memory(3*DEPTH/2,DEPTH/4);
        
        #100;
        $finish;
    end
    
    task write_memory(input [ADDR_WIDTH-1:0] start_location, input [ADDR_WIDTH:0] num_location);
        begin
            for(i = start_location; i<start_location+num_location; i = i+1) begin
                @(posedge clk_i);
                //memory is synchronous design, all operation should be done on posedge of clk_i
                addr_i        = i;
                wdata_i       = $random;
                wr_rd_i       = 1;
                valid_i       = 1;
                wait (ready_o == 1);
            end
            @(posedge clk_i);
            addr_i  = 0;
            wdata_i = 0;
            wr_rd_i = 0;
            valid_i = 0;
        end
    endtask
    
    
    task read_memory(input [ADDR_WIDTH-1:0] start_location, input [ADDR_WIDTH-1:0] num_location);
        begin
            for(i = start_location; i<start_location+num_location; i = i+1) begin
                @(posedge clk_i);
                //memory is synchronous design, all operation should be done on posedge of clk_i
                addr_i        = i;
                wr_rd_i       = 0;
                valid_i       = 1;
                wait (ready_o == 1);
            end
            @(posedge clk_i);
            addr_i     = 0;
            // rdata_o = 0;
            wr_rd_i    = 0;
            valid_i    = 0;
        end
    endtask
    //
endmodule
