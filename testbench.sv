`timescale 1ns/1ps

module tb_GAME;

  logic clk;
  initial clk = 0;
  always #5 clk = ~clk;

  // Instantiate interface
  count_ifc my_ifc(clk);

  // Instantiate DUT
  GAME dut(.x(my_ifc));

  initial begin
    // Apply reset
    //my_ifc.rst = 1;
    my_ifc.INIT = 0;
    my_ifc.control = 2'b00;
    my_ifc.load_value = 2'b01;

    #20;
    //my_ifc.rst = 0;    // Release reset
    my_ifc.INIT = 1;   // Initialize game with load_value

    #10;
    my_ifc.INIT = 0;

    // Test increment and decrement operations
    repeat (10) @(posedge clk) my_ifc.control = 2'b00; // +1
    repeat (10) @(posedge clk) my_ifc.control = 2'b01; // +2
    repeat (10) @(posedge clk) my_ifc.control = 2'b10; // -1
    repeat (10) @(posedge clk) my_ifc.control = 2'b11; // -2
    
    wait(my_ifc.GAMEOVER == 1'b1);
    assert(my_ifc.WHO == 2'b01 && my_ifc.GAMEOVER == 1'b1) $display("Loser Test Passed");
    else $display("Loser Test Failed");
    #50;
    $finish;
  end
  initial
  begin
	#40
	@(posedge my_ifc.clk)
	assert property(@(posedge my_ifc.clk) my_ifc.control == 2'b00 |-> my_ifc.main_counter == $past(my_ifc.main_counter,1) + 1);
	

   end
  initial begin
    $monitor("Time = %0t,INIT = %0b, control = %0b, main_counter = %0d,loser_count= %0d, winner_count=%0d,WHO =%b,LOSER = %0b, WINNER =  %0b, GAMEOVER = %0b",
              $time, my_ifc.INIT, my_ifc.control, 
              my_ifc.main_counter, my_ifc.loser_count, my_ifc.winner_count,
              my_ifc.WHO, my_ifc.LOSER, my_ifc.WINNER, my_ifc.GAMEOVER);
  end

endmodule
