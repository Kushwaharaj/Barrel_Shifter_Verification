class barrel_wr_driver extends uvm_driver #(write_xtn);
  `uvm_component_utils(barrel_wr_driver)

  barrel_wr_agt_config m_cfg;
  virtual barrel_if.DRV_MP vif;

  extern function new(string name = "barrel_wr_driver", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task send_2_dut(write_xtn xtn);
endclass: barrel_wr_driver

function barrel_wr_driver::new(string name = "barrel_wr_driver", uvm_component parent);
  super.new(name, parent);
endfunction: new

function void barrel_wr_driver::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db #(barrel_wr_agt_config)::get(this, "", "barrel_wr_agt_config", m_cfg))
     `uvm_fatal("barrel_wr_driver", "Failed to get the config object")
endfunction: build_phase

function void barrel_wr_driver::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  vif = m_cfg.vif;
endfunction: connect_phase

task barrel_wr_driver::run_phase(uvm_phase phase);
  super.run_phase(phase);
  forever begin
    seq_item_port.get_next_item(req);
    send_2_dut(req);
    seq_item_port.item_done();
  end
endtask: run_phase

task barrel_wr_driver::send_2_dut(write_xtn xtn);
  @(vif.wr_drv_cb)
  vif.wr_drv_cb.data <= xtn.data;
  vif.wr_drv_cb.shift <= xtn.shift;
  vif.wr_drv_cb.dir <= xtn.dir;
  repeat(1)
    @(vif.wr_drv_cb);
endtask: send_2_dut

