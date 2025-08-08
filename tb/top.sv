module top;
   	
    import barrel_pkg::*;
    import uvm_pkg::*;

   	// Generate clock signal
	bit clock;  
	always 
		#10 clock=!clock;

	barrel_if in0(clock);
   
	barrel_shifter dut(.clk(clock),
	               .data(in0.data),
                   .shift(in0.shift),
                   .dir(in0.dir),
                   .result(in0.result)
	);
	
        initial
		 begin
			
			`ifdef VCS
         		$fsdbDumpvars(0, top);
        		`endif
            
			uvm_config_db #(virtual barrel_if)::set(null, "*", "vif", in0);
	    	run_test();
		 end
// Left Shift Assertions
property left_shift_0;
  @(posedge clock)
    in0.dir == 0 && in0.shift == 2'b00 |=> in0.result == in0.data;
endproperty

property left_shift_1;
  @(posedge clock)
    in0.dir == 0 && in0.shift == 2'b01 |=> in0.result == {in0.data[2:0], 1'b0};
endproperty

property left_shift_2;
  @(posedge clock)
    in0.dir == 0 && in0.shift == 2'b10 |=> in0.result == {in0.data[1:0], 2'b00};
endproperty

property left_shift_3;
  @(posedge clock)
    in0.dir == 0 && in0.shift == 2'b11 |=> in0.result == {in0.data[0], 3'b000};
endproperty

// Right Shift Assertions
property right_shift_0;
  @(posedge clock)
    in0.dir == 1 && in0.shift == 2'b00 |=> in0.result == in0.data;
endproperty

property right_shift_1;
  @(posedge clock)
    in0.dir == 1 && in0.shift == 2'b01 |=> in0.result == {1'b0, in0.data[3:1]};
endproperty

property right_shift_2;
  @(posedge clock)
    in0.dir == 1 && in0.shift == 2'b10 |=> in0.result == {2'b00, in0.data[3:2]};
endproperty

property right_shift_3;
  @(posedge clock)
    in0.dir == 1 && in0.shift == 2'b11 |=> in0.result == {3'b000, in0.data[3]};
endproperty

// Bind assertions
A1: assert property(left_shift_0);
A2: assert property(left_shift_1);
A3: assert property(left_shift_2);
A4: assert property(left_shift_3);

A5: assert property(right_shift_0);
A6: assert property(right_shift_1);
A7: assert property(right_shift_2);
A8: assert property(right_shift_3);
		

endmodule
