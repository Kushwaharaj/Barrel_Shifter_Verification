class barrel_base_test extends uvm_test;
  `uvm_component_utils(barrel_base_test)

  barrel_env envh;
  barrel_env_config env_cfg;
  barrel_wr_agt_config m_wr_agent_cfg;
  barrel_rd_agt_config m_rd_agent_cfg;

  bit has_write_agent = 1;
  bit has_read_agent = 1;

  extern function new(string name = "barrel_base_test", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task config_barrel();
  extern function void end_of_elaboration_phase(uvm_phase phase);
endclass: barrel_base_test

function barrel_base_test::new(string name = "barrel_base_test", uvm_component parent);
  super.new(name,parent);
endfunction

function void barrel_base_test::build_phase(uvm_phase phase);
  super.build_phase(phase);

  env_cfg = barrel_env_config::type_id::create("env_cfg");
  config_barrel();

  uvm_config_db #(barrel_env_config)::set(this, "*", "barrel_env_config", env_cfg);
  envh = barrel_env::type_id::create("envh", this);
endfunction

task barrel_base_test::config_barrel();
  if (has_write_agent) begin
    m_wr_agent_cfg = barrel_wr_agt_config::type_id::create("m_wr_agent_cfg");
    if (!uvm_config_db #(virtual barrel_if)::get(this, "", "vif", m_wr_agent_cfg.vif))
      `uvm_fatal("VIF CONFIG", "Failed to get the write vif")
    m_wr_agent_cfg.is_active = UVM_ACTIVE;
    env_cfg.m_wr_agent_cfg = m_wr_agent_cfg;
  end

  if (has_read_agent) begin
    m_rd_agent_cfg = barrel_rd_agt_config::type_id::create("m_rd_agent_cfg");
    if (!uvm_config_db #(virtual barrel_if)::get(this, "", "vif", m_rd_agent_cfg.vif))
      `uvm_fatal("VIF CONFIG", "Failed to get read vif")
    m_rd_agent_cfg.is_active = UVM_PASSIVE;
    env_cfg.m_rd_agent_cfg = m_rd_agent_cfg;
  end

  env_cfg.has_write_agent = has_write_agent;
  env_cfg.has_read_agent = has_read_agent;
endtask

function void barrel_base_test::end_of_elaboration_phase(uvm_phase phase);
  uvm_top.print_topology();
endfunction

class barrel_test_seq1 extends barrel_base_test;
   `uvm_component_utils(barrel_test_seq1)
   barrel_wr_seq1 seq1;
   extern function new(string name="barrel_test_seq1",uvm_component parent);
   extern function void build_phase(uvm_phase phase);
   extern task run_phase(uvm_phase phase);

endclass

function barrel_test_seq1::new(string name="barrel_test_seq1",uvm_component parent);
    super.new(name,parent);
endfunction

function void barrel_test_seq1::build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction

task barrel_test_seq1::run_phase(uvm_phase phase);
 begin
   phase.raise_objection(this);
   repeat(2) 
    begin
     seq1 = barrel_wr_seq1::type_id::create("seq1");
     seq1.start(envh.wr_agt_top.agnth.seqrh);
    end
   phase.drop_objection(this);
 end
endtask


class barrel_test_seq2 extends barrel_base_test;
   `uvm_component_utils(barrel_test_seq2)
   barrel_wr_seq2 seq2;
   extern function new(string name="barrel_test_seq2",uvm_component parent);
   extern function void build_phase(uvm_phase phase);
   extern task run_phase(uvm_phase phase);

endclass

function barrel_test_seq2::new(string name="barrel_test_seq2",uvm_component parent);
    super.new(name,parent);
endfunction

function void barrel_test_seq2::build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction

task barrel_test_seq2::run_phase(uvm_phase phase);
 begin
   phase.raise_objection(this);
   repeat(2) 
    begin
     seq2 = barrel_wr_seq2::type_id::create("seq2");
     seq2.start(envh.wr_agt_top.agnth.seqrh);
    end
   phase.drop_objection(this);
 end
endtask

