class write_xtn extends uvm_sequence_item;
  `uvm_object_utils(write_xtn)
  
  rand bit [3:0] data;
  rand bit [1:0] shift;
  rand bit dir;
  bit [3:0] result;
  
  extern function new(string name = "write_xtn");
  extern function void do_print(uvm_printer printer);
endclass: write_xtn

function write_xtn::new(string name = "write_xtn");
  super.new(name);
endfunction: new

function void write_xtn::do_print(uvm_printer printer);
  printer.print_field("data", data, 4, UVM_BIN);
  printer.print_field("shift", shift, 2, UVM_DEC);
  printer.print_field("dir", dir, 1, UVM_DEC);
  printer.print_field("result", result, 4, UVM_BIN);
endfunction: do_print