class barrel_wr_sequencer extends uvm_sequencer #(write_xtn);
  `uvm_component_utils(barrel_wr_sequencer)

  extern function new(string name = "barrel_wr_sequencer", uvm_component parent);
endclass: barrel_wr_sequencer

function barrel_wr_sequencer::new(string name = "barrel_wr_sequencer", uvm_component parent);
  super.new(name, parent);
endfunction: new