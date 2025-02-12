module coverage #(parameter ptr_width = 8,depth = 256,data_width = 8) 
(intfc  rif_cov);

logic temp_r_en;
logic temp_w_en;
logic temp_clearw;
logic temp_clearr;
logic full_temp;
logic empty_temp;

always_ff @(posedge rif_cov.wclk)
     begin
     temp_clearw <= rif_cov.w_rst_n;
     temp_w_en <= rif_cov.w_en;
	 full_temp<= rif_cov.full;
     end
always_ff @(posedge rif_cov.rclk)
     begin
     temp_clearr <= rif_cov.r_rst_n;
     temp_r_en <= rif_cov.r_en;
	 empty_temp<= rif_cov.empty;
     end

covergroup test_write @(posedge rif_cov.wclk);

c0:coverpoint rif_cov.w_rst_n{
             bins RESET_1 = {1};
			 bins RESET_0 ={0};
			 }
c1:coverpoint rif_cov.empty {
             bins  fifo_empty_1 = {1};
			 bins fifo_empty_0 = {0};
			 }
c2:coverpoint rif_cov.full {
             bins fifo_full_1 = {1};
			 bins fifo_full_0 = {0};
}
			 
c3 : coverpoint rif_cov.w_en {
             bins write_1 = {1};
			 bins write_0 = {0};
			 }

c4 : coverpoint rif_cov.data_in {
             bins wr_data = {[0:255]};
			  }

c10 : coverpoint rif_cov.r_en {
             bins read_1 = {1};
			 bins read_0 = {0};
			 }
			  
read_and_fifo_empty:cross c3,c1;       //done
read_write_fifo_empty:cross c3,c4,c1; //done also fifo_full
read_and_clear:cross c3,c0;      // done
write_and_fifo_full:cross c4,c2;  //done 
write_after_clear:cross temp_clearw,c4;  
read_write_clear:cross c3,c0,c10;   //done
continuos_two_reads:cross temp_r_en,c3; //done
continuos_two_writes:cross temp_w_en,c10; // done
clear_and_fifo_empty:cross c1,c0; //done
commands_while_reset: cross c0,c3,c10;

endgroup

covergroup test_read @(rif_cov.rclk);
c5 : coverpoint rif_cov.r_en {
             bins read_1 = {1};
			 bins read_0 = {0};
			 }
c6: coverpoint rif_cov.r_rst_n {
             bins r_rst_n_high = {1};
			 bins r_rst_n_low = {0};
			 }			 

c7 : coverpoint rif_cov.data_out {
             bins rd_data = {[0:255]};
			  }
			  
c8:coverpoint rif_cov.empty {
             bins  fifo_empty_1 = {1};
			 bins fifo_empty_0 = {0};
			 }
c9:coverpoint rif_cov.full {
             bins fifo_full_1 = {1};
			 bins fifo_full_0 = {0};
}
c11 : coverpoint rif_cov.w_en {
             bins write_1 = {1};
			 bins write_0 = {0};
			 }

read_and_fifo_emptyr:cross c5,c8;       //done
read_write_fifo_empty:cross c11,c5,c8; //done also fifo_full
read_and_clear_read:cross c5,c6;      // done
write_and_fifo_fullr:cross c9,c11;  //done 
read_after_clear_read:cross temp_clearr,c6; 
read_write_clear:cross c5,c6,c11;   //done
continuos_two_reads:cross temp_r_en,c7; //done
continuos_two_writes:cross temp_w_en,c11; // done
clear_and_fifo_empty:cross c6,c8; //done
commands_while_reset: cross c5,c6,c11;

endgroup


test_write test_instw;
test_read  test_instr;

initial begin
  test_instw = new();
  test_instr = new();

 end

endmodule