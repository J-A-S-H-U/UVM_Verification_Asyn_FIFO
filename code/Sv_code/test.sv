
`include "environment.sv"
program test(intfc vif);
	environment env;
	//virtual intfc vif;
	initial
    begin	
		env = new(vif); //creating environment
		env.gen.count =512;//burst
		env.gen.size =1; // creating multiple bursts
		env.run();
	end
 endprogram