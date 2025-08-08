interface barrel_if(input bit clock);
  logic [3:0] data;
  logic [1:0] shift;
  logic dir;
  logic [3:0] result;

  clocking wr_drv_cb @(posedge clock);
    default input #1 output #0;
    output data;
    output shift;
    output dir;
  endclocking: wr_drv_cb

  clocking wr_mon_cb @(posedge clock);
    default input #1 output #0;
    input data;
    input shift;
    input dir;
  endclocking: wr_mon_cb

  clocking rd_mon_cb @(posedge clock);
    default input #1 output #0;
    input result;
    input data;
    input shift;
    input dir;
  endclocking: rd_mon_cb

  modport DRV_MP(clocking wr_drv_cb);
  modport WR_MON_MP(clocking wr_mon_cb);
  modport RD_MON_MP(clocking rd_mon_cb);

endinterface:barrel_if