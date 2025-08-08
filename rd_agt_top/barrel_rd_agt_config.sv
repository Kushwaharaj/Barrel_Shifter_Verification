class barrel_rd_agt_config extends uvm_object;
  `uvm_object_utils(barrel_rd_agt_config)
  
  extern function new(string name = "barrel_rd_agt_config");
  uvm_active_passive_enum is_active = UVM_PASSIVE;
  virtual barrel_if vif;

endclass: barrel_rd_agt_config

function barrel_rd_agt_config::new(string name = "barrel_rd_agt_config");
  super.new(name);
endfunction:new