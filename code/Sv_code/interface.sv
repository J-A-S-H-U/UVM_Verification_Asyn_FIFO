interface intfc(input bit wclk, rclk, w_rst_n, r_rst_n);

parameter depth=256, data_width=8, ptr_width=8; // parameters

parameter wclk_width=4; //Write clock width
parameter rclk_width=10; //read clock width
logic w_en, r_en;
logic [ptr_width:0] rptr_sync, wptr_sync, waddr, wptr,raddr, rptr;
bit full, empty;
logic [data_width-1:0] data_in,data_out;

modport driver ( input wclk,rclk, w_rst_n, r_rst_n);
modport monitor( input wclk,rclk, w_rst_n, r_rst_n);
modport coverage (input wclk,rclk, w_rst_n, r_rst_n, data_in,data_out,r_en,w_en,full,empty);
		
endinterface
