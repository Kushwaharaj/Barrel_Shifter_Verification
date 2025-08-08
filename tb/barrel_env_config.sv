class barrel_env_config extends uvm_object;
  `uvm_object_utils(barrel_env_config)

  bit has_scoreboard = 1;
  bit has_functional_coverage = 0;
  bit has_write_agent = 1;
  bit has_read_agent = 1;

  barrel_wr_agt_config m_wr_agent_cfg;
  barrel_rd_agt_config m_rd_agent_cfg;

  extern function new(string name = "barrel_env_config");
endclass: barrel_env_config

function barrel_env_config::new(string name = "barrel_env_config");
  super.new(name);
endfunction: new
