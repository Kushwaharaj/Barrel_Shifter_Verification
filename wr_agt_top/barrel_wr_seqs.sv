class barrel_wr_seqs extends uvm_sequence #(write_xtn);
  `uvm_object_utils(barrel_wr_seqs)

  extern function new(string name = "barrel_wr_seqs");
endclass: barrel_wr_seqs

function barrel_wr_seqs::new(string name = "barrel_wr_seqs");
  super.new(name);
endfunction: new

class barrel_wr_seq1 extends barrel_wr_seqs;
 `uvm_object_utils(barrel_wr_seq1)

  extern function new(string name = "barrel_wr_seq1");
  extern task body();
endclass: barrel_wr_seq1

function barrel_wr_seq1::new(string name = "barrel_wr_seq1");
  super.new(name);
endfunction: new

task barrel_wr_seq1::body();
  req = write_xtn::type_id::create("req");
  start_item(req);
  assert(req.randomize with {data inside{[0:7]};});
  finish_item(req);
endtask: body

class barrel_wr_seq2 extends barrel_wr_seqs;
 `uvm_object_utils(barrel_wr_seq2)

  extern function new(string name = "barrel_wr_seq2");
  extern task body();
endclass: barrel_wr_seq2

function barrel_wr_seq2::new(string name = "barrel_wr_seq2");
  super.new(name);
endfunction: new

task barrel_wr_seq2::body();
  req = write_xtn::type_id::create("req");
  start_item(req);
  assert(req.randomize with {data inside{[8:15]};});
  finish_item(req);
endtask: body
