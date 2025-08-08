class barrel_env extends uvm_env;
  `uvm_component_utils(barrel_env)

  barrel_wr_agt_top wr_agt_top;
  barrel_rd_agt_top rd_agt_top;
  
  barrel_scoreboard sb;
  barrel_env_config env_cfg;

  extern function new(string name = "barrel_env", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);

endclass: barrel_env

function barrel_env::new(string name = "barrel_env", uvm_component parent);
  super.new(name, parent);
endfunction: new

function void barrel_env::build_phase(uvm_phase phase);
  super.build_phase(phase);

  if (!uvm_config_db #(barrel_env_config)::get(this, "", "barrel_env_config", env_cfg))
    `uvm_fatal("BARREL_ENV", "Failed to get barrel_env_config")

  if (env_cfg.has_write_agent) begin
    uvm_config_db #(barrel_wr_agt_config)::set(this, "wr_agt_top*", "barrel_wr_agt_config", env_cfg.m_wr_agent_cfg);
    wr_agt_top = barrel_wr_agt_top::type_id::create("wr_agt_top", this);
  end

  if (env_cfg.has_read_agent) begin
    uvm_config_db #(barrel_rd_agt_config)::set(this, "rd_agt_top*", "barrel_rd_agt_config", env_cfg.m_rd_agent_cfg);
    rd_agt_top = barrel_rd_agt_top::type_id::create("rd_agt_top", this);
  end

  if (env_cfg.has_scoreboard) begin
    sb = barrel_scoreboard::type_id::create("sb", this);
  end
endfunction: build_phase


function void barrel_env::connect_phase(uvm_phase phase);
  super.connect_phase(phase);

  if (env_cfg.has_scoreboard) begin
    wr_agt_top.agnth.monh.mon_port.connect(sb.wr_fifo.analysis_export);
    rd_agt_top.agnth.monh.mon_port.connect(sb.rd_fifo.analysis_export);
  end
endfunction: connect_phase
