# vhdl_boundflasher

**REQUIREMENT**: Implement the bound flasher system with 16-bit LEDs.

The system’s operation is based on three input signals: 
- Clock
- Reset
- Flick

**The system’s specifications**:
- Clock signal is provided for system inspire of function status. The function operates state’s transition at positive edge of the clock signal.
- Reset signal: 
  - LOW-ACTIVE Reset = 0: System is restarted to Initial State.
  - HIGH-ACTIVE Reset = 1: System is started with Initial State.
- Flick signal: special input for controlling state transfer.

**At the initial state, all LEDs are OFF. If flick signal is ACTIVE (set 1), the flasher starts operating**:
1. The LEDs are turned ON gradually from LEDs [0] to LEDs [5].
2. The LEDs are turned OFF gradually from LEDs [5] **(max)** to LEDs [0] **(min)**.
3. The LEDs are turned ON gradually from LEDs [0] to LEDs [10].
4. The LEDs are turned OFF gradually from LEDs [10] **(max)** to LEDs [5] **(min)**.
5. The LEDs are turned ON gradually from LEDs [5] to LEDs [15].
6. Finally, the LEDs are turned OFF gradually from LEDs [15] to LEDs [0], return to initial state.

**Additional condition**: 
- At each kickback point (LEDs [5] and LEDs [10]), if flick signal is ACTIVE, the LEDs will turn OFF gradually again to the min LEDs of the previous state, then continue operation as above description. 
- For simple, kickback point is considered only when the LEDs are turned ON gradually, except the first state.
