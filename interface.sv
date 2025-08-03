interface count_ifc(input bit clk);
  // Internal counters inside interface
  logic [1 : 0] main_counter;
  logic [3:0] loser_count;
  logic [3:0] winner_count;

  // Control and status signals
  logic [1:0] control;    // Control Bus 
  logic INIT;             // Initialization signal likewise of Load              // Synchronous active-high reset added
  logic [1:0] load_value; // Parallel loaded input
  logic [1:0] WHO;        // WHO signal to indicate winner or loser
  logic GAMEOVER; 
  logic LOSER, WINNER;

  // Modports Declarations
  modport driver(output control, INIT, load_value,
                 input WHO, GAMEOVER, LOSER, WINNER);
  modport dut(input control, INIT, load_value,
              output WHO, GAMEOVER, LOSER, WINNER);
endinterface

