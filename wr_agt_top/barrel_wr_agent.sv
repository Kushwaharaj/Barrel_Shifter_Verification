class barrel_wr_agent extends uvm_agent;
  `uvm_component_utils(barrel_wr_agent)

  barrel_wr_driver drvh;
  barrel_wr_monitor monh;
  barrel_wr_sequencer seqrh;
  barrel_wr_agt_config m_cfg;

  extern function new(string name = "barrel_wr_agent", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
endclass: barrel_wr_agent

function barrel_wr_agent::new(string name = "barrel_wr_agent", uvm_component parent);
  super.new(name, parent);
endfunction: new

function void barrel_wr_agent::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db #(barrel_wr_agt_config)::get(this, "", "barrel_wr_agt_config",m_cfg))
     `uvm_fatal("barrel_wr_agent", "Failed to get the config object")
  monh = barrel_wr_monitor::type_id::create("monh", this);
  if(m_cfg.is_active == UVM_ACTIVE)
    begin
        drvh = barrel_wr_driver::type_id::create("drvh", this);
        seqrh = barrel_wr_sequencer::type_id::create("seqrh", this);
    end
endfunction: build_phase

function void barrel_wr_agent::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if(m_cfg.is_active == UVM_ACTIVE)
    drvh.seq_item_port.connect(seqrh.seq_item_export);
endfunction: connect_phase


