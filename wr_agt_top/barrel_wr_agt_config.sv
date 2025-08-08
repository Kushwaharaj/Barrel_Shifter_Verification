class barrel_wr_agt_config extends uvm_object;
  `uvm_object_utils(barrel_wr_agt_config)
  uvm_active_passive_enum is_active = UVM_ACTIVE;
  virtual barrel_if vif;
  extern function new(string name = "barrel_wr_agt_config");
endclass: barrel_wr_agt_config

function barrel_wr_agt_config::new(string name="barrel_wr_agt_config");
  super.new(name);
endfunction:new