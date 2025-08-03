# Counter_Game

This is a Verilog-based counter game module along with its interface and testbench. The game simulates counters that increment or decrement based on control inputs, and tracks winning and losing conditions with single-cycle pulse signals.

## How the Game Works

The game revolves around a 2-bit main counter which can be incremented or decremented by 1 or 2 steps depending on the control signals. The gameplay logic includes:

- The counter starts at a **load value** set during initialization.
- Control inputs determine how the counter changes each clock cycle:
  - `00`: Increment by 1
  - `01`: Increment by 2
  - `10`: Decrement by 1
  - `11`: Decrement by 2
- When the counter reaches **0 (all zeros)**, the `LOSER` signal pulses high for exactly one clock cycle, and the loser count increments.
- When the counter reaches **3 (all ones)**, the `WINNER` signal pulses high for exactly one clock cycle, and the winner count increments.
- Once either the loser or winner count reaches 15 (`4'b1111`), the game declares a `GAMEOVER`, and the `WHO` signal indicates the winner:
  - `10` means the winner has reached 15
  - `01` means the loser has reached 15
- Upon game over, all counters and signals reset automatically to start a new game.

This simple design simulates a competitive counter game where players can influence the counter increments or decrements, and the system tracks the winner and loser status in a synchronized manner.

## Features

- 2-bit main counter with variable increment/decrement steps
- Signals `LOSER` and `WINNER` pulse high for exactly one clock cycle on reaching min/max counter values
- Keeps track of winner and loser counts (4-bit counters)
- `GAMEOVER` and `WHO` signals indicate game status and result
- Reset and initialization logic to start the game with a load value

## Files

- `GAME.sv` - Main Verilog module implementing the game logic
- `count_ifc.sv` - Interface definition for signals and clock
- `tb_GAME.sv` - Testbench to simulate and verify game behavior

## How to run

1. Use a SystemVerilog simulator (like ModelSim, Questa, VCS, etc.)
2. Compile all files together
3. Run the testbench `tb_GAME` to see simulation results and waveform output
4. Observe signals like `LOSER`, `WINNER`, `WHO`, and `GAMEOVER` in waveform viewer

---

Feel free to contribute or open issues if you find bugs or want enhancements!
