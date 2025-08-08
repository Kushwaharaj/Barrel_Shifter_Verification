class barrel_rd_monitor extends uvm_monitor;
  `uvm_component_utils(barrel_rd_monitor)

  barrel_rd_agt_config m_cfg;
  virtual barrel_if.RD_MON_MP vif;
  uvm_analysis_port #(write_xtn) mon_port;

  extern function new(string name = "barrel_rd_monitor", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task collect_data();
endclass: barrel_rd_monitor

function barrel_rd_monitor::new(string name = "barrel_rd_monitor", uvm_component parent);
 super.new(name, parent);
endfunction:new

function void barrel_rd_monitor::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db #(barrel_rd_agt_config)::get(this,"", "barrel_rd_agt_config", m_cfg))
    `uvm_fatal("barrel_rd_monitor", "Failed to get the config object")
  mon_port = new("mon_port",this);
endfunction: build_phase

function void barrel_rd_monitor::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  vif = m_cfg.vif;
endfunction: connect_phase

task barrel_rd_monitor::run_phase(uvm_phase phase);
  forever
    begin
      collect_data();
    end
endtask: run_phase

task barrel_rd_monitor::collect_data();
  write_xtn mon_data;
  mon_data = write_xtn::type_id::create("mon_data");

  @(vif.rd_mon_cb);
  mon_data.data = vif.rd_mon_cb.data;
  mon_data.shift = vif.rd_mon_cb.shift;
  mon_data.dir = vif.rd_mon_cb.dir;
  mon_data.result = vif.rd_mon_cb.result;
  mon_port.write(mon_data);
  repeat(1)
    @(vif.rd_mon_cb);
  `uvm_info("READ_MONITOR", "Got read data", UVM_LOW)
  mon_data.print();
endtask