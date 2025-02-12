class scb_fifo;

	//creating mailbox handle
    mailbox mon2scb;
	
	//used to count the number of transactions
    int scb_transactions,flag;
	
	//array to use as local memory
    bit [7:0] ref_fifo[$];
	logic [7:0] check_fifo;
	int pass_count,fail_count;
	//constructor
    function new(mailbox mon2scb);
      //getting the mailbox handles from  environment 
      this.mon2scb = mon2scb;
    endfunction
	
	//stores wdata and compare data_out with stored data
    task main;
	$display("------------INSIDE SCOREBOARD:MAIN TASK--------------------");
    forever begin
	 trans_fifo trans;// transaction class handle
	  trans=new();//transaction class object
      mon2scb.get(trans); 
	  if(trans.mflag)
	  
	  begin
		if(trans.w_en && !trans.full) 
		 begin
			ref_fifo.push_front(trans.data_in);//reference queue
			$display($time,"[SCB-PASS][Scb-transfer =%0d] Scoreboard data written",scb_transactions);
	        pass_count++;
		 end
		if(trans.r_en && !trans.empty)
		 begin
		
			check_fifo=trans.data_in;
			if(check_fifo !== trans.data_in)
			 begin
				$error("[SCB-FAIL][Scb-transfer =%0d] Test Failed",scb_transactions );
				fail_count++;
			 end
		    else 
			 begin
			  $display($time,"[SCB-PASS][Scb-transfer =%0d] Test Passed succesfully",scb_transactions);
			  pass_count++;
			 end
		 end
		 $display("--------------------------------------------------------------------------------");
      scb_transactions++;
	 end
	 else flag = trans.mflag;
    end
	$display("[SCOREBOARD] No.of Testes Passed = %d and No.of Tests failed=%0d",pass_count,fail_count);
  endtask
endclass