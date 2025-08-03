module GAME(count_ifc x);

  // Registers to detect edge on main_counter conditions
  logic prev_main_counter_00, prev_main_counter_11;

  always @(posedge x.clk) begin
    if (x.INIT) begin
      // Reset all signals and counters
      x.main_counter <= x.load_value;
      x.WHO <= 2'b00;
      x.LOSER <= 1'b0;
      x.WINNER <= 1'b0;
      x.GAMEOVER <= 1'b0;
      x.loser_count <= 4'b0000;
      x.winner_count <= 4'b0000;
      prev_main_counter_00 <= 1'b0;
      prev_main_counter_11 <= 1'b0;
    end  
    else begin
      case (x.control)
        2'b00: x.main_counter <= x.main_counter + 1;
        2'b01: x.main_counter <= x.main_counter + 2;
        2'b10: x.main_counter <= x.main_counter - 1;
        2'b11: x.main_counter <= x.main_counter - 2;
      endcase
    end
  end

  always @(posedge x.clk) begin
    if (x.INIT) begin
      x.LOSER <= 1'b0;
      x.WINNER <= 1'b0;
      x.loser_count <= 4'b0000;
      x.winner_count <= 4'b0000;
      prev_main_counter_00 <= 1'b0;
      prev_main_counter_11 <= 1'b0;
    end else begin
      // Pulse LOSER exactly 1 cycle on rising condition of main_counter == 00
      if (x.main_counter == 2'b00 && !prev_main_counter_00) begin
        x.LOSER <= 1'b1;
        x.loser_count <= x.loser_count + 1;
      end else begin
        x.LOSER <= 1'b0;
      end

      // Pulse WINNER exactly 1 cycle on rising condition of main_counter == 11
      if (x.main_counter == 2'b11 && !prev_main_counter_11) begin
        x.WINNER <= 1'b1;
        x.winner_count <= x.winner_count + 1;
      end else begin
        x.WINNER <= 1'b0;
      end

      // Update previous state flags
      prev_main_counter_00 <= (x.main_counter == 2'b00);
      prev_main_counter_11 <= (x.main_counter == 2'b11);
    end
  end

  always @(posedge x.clk) begin
    if (x.INIT) begin
      x.WHO <= 2'b00;
      x.GAMEOVER <= 1'b0;
    end else begin
      if (x.winner_count == 4'b1111) begin
        x.WHO <= 2'b10;
        x.GAMEOVER <= 1'b1;
      end else if (x.loser_count == 4'b1111) begin
        x.WHO <= 2'b01;
        x.GAMEOVER <= 1'b1;
      end

      if (x.GAMEOVER == 1'b1) begin
        // Restart the game synchronously
        x.WHO <= 2'b00;
        x.LOSER <= 1'b0;
        x.WINNER <= 1'b0;
        x.GAMEOVER <= 1'b0;
        x.loser_count <= 4'b0000;
        x.winner_count <= 4'b0000;
      end
    end
  end

endmodule
