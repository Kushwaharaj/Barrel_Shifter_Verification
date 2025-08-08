class barrel_rd_agent extends uvm_agent;
 `uvm_component_utils(barrel_rd_agent)
  
  barrel_rd_monitor monh;
  barrel_rd_agt_config m_cfg;

  extern function new(string name= "barrel_rd_agent",uvm_component parent);
  extern function void build_phase(uvm_phase phase);

endclass:barrel_rd_agent

function barrel_rd_agent::new(string name="barrel_rd_agent",uvm_component parent);
  super.new(name,parent);
endfunction:new

function void barrel_rd_agent::build_phase(uvm_phase phase);
  if(!uvm_config_db #(barrel_rd_agt_config)::get(this,"","barrel_rd_agt_config",m_cfg))
   `uvm_fatal("barrel_rd_agent","failed to get the config object")
   super.build_phase(phase);
   
  	if(m_cfg.is_active == UVM_PASSIVE) 
		  monh = barrel_rd_monitor::type_id::create("monh",this);
endfunction

