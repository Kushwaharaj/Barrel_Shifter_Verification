package barrel_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    `include "write_xtn.sv"
    `include "barrel_wr_agt_config.sv"
    `include "barrel_rd_agt_config.sv"
    `include "barrel_env_config.sv"
    `include "barrel_wr_driver.sv"
    `include "barrel_wr_monitor.sv"
    `include "barrel_wr_sequencer.sv"
    `include "barrel_wr_agent.sv"
    `include "barrel_wr_agt_top.sv"
    `include "barrel_wr_seqs.sv"
    
    `include "barrel_rd_monitor.sv"
    `include "barrel_rd_agent.sv"
    `include "barrel_rd_agt_top.sv"

    `include "barrel_scoreboard.sv"
    `include "barrel_env.sv"

    `include "barrel_test.sv"

endpackage