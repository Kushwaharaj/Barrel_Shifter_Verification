class barrel_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(barrel_scoreboard)

  uvm_tlm_analysis_fifo #(write_xtn) wr_fifo;
  uvm_tlm_analysis_fifo #(write_xtn) rd_fifo;
  barrel_env_config env_cfg;
  write_xtn wr_data;
  write_xtn rd_data;
  write_xtn cov_data;
  int data_verified_count;

  covergroup barrel_cov;
  option.per_instance = 1;

   DATA: coverpoint cov_data.data {
                                 bins all_values[] = {[0:15]};
                                 }

  SHIFT: coverpoint cov_data.shift {
                                bins NO_SHIFT = {2'b00};
                                bins SHIFT_1 = {2'b01};
                                bins SHIFT_2 = {2'b10};
                                bins SHIFT_3 = {2'b11};
                                   }

  DIR: coverpoint cov_data.dir {
                               bins LEFT = {1'b0};
                               bins RIGHT = {1'b1};
  }

  DATA_X_SHIFT_X_DIR: cross DATA, SHIFT, DIR;
endgroup

  function new(string name = "barrel_scoreboard", uvm_component parent);
    super.new(name,parent);
    barrel_cov = new();
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(barrel_env_config)::get(this,"","barrel_env_config", env_cfg))
      `uvm_fatal("barrel_scoreboard", "Failed to get the env_config")
    if(env_cfg.has_write_agent)
      wr_fifo = new("wr_fifo", this);
    if(env_cfg.has_read_agent)  
      rd_fifo = new("rd_fifo", this);
    wr_data = write_xtn::type_id::create("wr_data");
    rd_data = write_xtn::type_id::create("rd_data");
    cov_data = write_xtn::type_id::create("cov_data");
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    fork
      begin
        forever 
         begin
          wr_fifo.get(wr_data);
          `uvm_info("SB_WRITE", "Got write data", UVM_LOW)
          wr_data.print();
         end
      end
      begin
        forever 
         begin
          rd_fifo.get(rd_data);
          `uvm_info("SB_READ", "Got read data", UVM_LOW)
          rd_data.print();
          check_data(wr_data,rd_data);
          cov_data = wr_data;
          barrel_cov.sample();
         end
      end
    join
  endtask

  function void check_data(write_xtn wdata, write_xtn rdata);
    bit [3:0] expected;
    expected = get_expected_result(wdata.data, wdata.shift, wdata.dir);
    if (rdata.result === expected)
      `uvm_info("SB_MATCH","MATCHED", UVM_LOW)
    else
      `uvm_info("SB_MISMATCH","MISMATCH",UVM_LOW)
    data_verified_count++;
  endfunction

  function bit [3:0] get_expected_result(bit [3:0] data, bit [1:0] shift, bit dir);
    bit [3:0] result;
    if (dir == 1'b0) begin
      case (shift)
        2'b00: result = data;
        2'b01: result = {data[2:0], 1'b0};
        2'b10: result = {data[1:0], 2'b00};
        2'b11: result = {data[0], 3'b000};
      endcase
    end else begin
      case (shift)
        2'b00: result = data;
        2'b01: result = {1'b0, data[3:1]};
        2'b10: result = {2'b00, data[3:2]};
        2'b11: result = {3'b000, data[3]};
      endcase
    end
    return result;
  endfunction

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("SB_REPORT", $sformatf("Total comparisons: %0d", data_verified_count), UVM_LOW)
  endfunction

endclass
