class barrel_wr_monitor extends uvm_monitor;
  `uvm_component_utils(barrel_wr_monitor)

  barrel_wr_agt_config m_cfg;
  virtual barrel_if.WR_MON_MP vif;
  uvm_analysis_port #(write_xtn) mon_port;

  extern function new(string name = "barrel_wr_monitor", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task collect_data();
endclass: barrel_wr_monitor

function barrel_wr_monitor::new(string name = "barrel_wr_monitor", uvm_component parent);
  super.new(name, parent);
endfunction: new

function void barrel_wr_monitor::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db #(barrel_wr_agt_config)::get(this, "", "barrel_wr_agt_config", m_cfg))
     `uvm_fatal("barrel_wr_monitor", "Failed to get the config object")
  mon_port = new("mon_port", this);
endfunction: build_phase

function void barrel_wr_monitor::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  vif = m_cfg.vif;
endfunction: connect_phase

task barrel_wr_monitor::run_phase(uvm_phase phase);
  super.run_phase(phase);
  forever begin
    collect_data();
  end
endtask: run_phase

task barrel_wr_monitor::collect_data();
  write_xtn mon_data;
  mon_data = write_xtn::type_id::create("mon_data");
  @(vif.wr_mon_cb)
  mon_data.data = vif.wr_mon_cb.data;
  mon_data.shift = vif.wr_mon_cb.shift;
  mon_data.dir = vif.wr_mon_cb.dir;
  mon_port.write(mon_data);
 
   `uvm_info("WRITE_MONITOR", "Got write data", UVM_LOW)
  mon_data.print();
endtask: collect_data

