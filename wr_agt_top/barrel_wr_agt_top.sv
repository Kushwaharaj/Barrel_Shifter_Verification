class barrel_wr_agt_top extends uvm_env;
  `uvm_component_utils(barrel_wr_agt_top)

  barrel_wr_agent agnth;
  barrel_env_config env_cfg;

  extern function new(string name = "barrel_wr_agt_top", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
endclass: barrel_wr_agt_top

function barrel_wr_agt_top::new(string name = "barrel_wr_agt_top", uvm_component parent);
  super.new(name, parent);
endfunction: new

function void barrel_wr_agt_top::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db #(barrel_env_config)::get(this, "", "barrel_env_config", env_cfg))
     `uvm_fatal("barrel_wr_monitor", "Failed to get the config object")
  if(env_cfg.has_write_agent)
     agnth = barrel_wr_agent::type_id::create("agnth", this);
endfunction: build_phase
