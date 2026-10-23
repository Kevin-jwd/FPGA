# Stopwatch KiCad RTL schematic

Open **stopwatch_rtl.kicad_sch** in KiCad 9 or later (validated with KiCad 10).
All symbols are embedded; no external symbol library is required. Keep all five schematic files together.

1. Top-level RTL module connections.
2. fnd_controller internal module connections.
3. Four independent button debouncers.
4. Exact FPGA I/O pin assignments extracted from the active XDC.
5. main_controller behavioral groups, mode transitions, counters, display selection and LED assignments.

This is a functional RTL schematic for the current source, not a gate-level synthesis netlist or a PCB-ready Basys3 reproduction.
Grouped vector pins on the RTL pages represent complete signal vectors. Detail sheets are documentation views of the same instances,
not additional hardware. Net labels are local to each page. The FPGA I/O page uses actual package pin numbers.

## Source details

- FPGA: xc7a35tcpg236-1, Basys3.
- Clock: 100 MHz at W5; tick: 1 kHz, one 100 MHz clock cycle wide.
- Reset: active high, constrained to R2 / SW15.
- Buttons: btn[0]=left, btn[1]=right, btn[2]=up, btn[3]=down.
- The debouncer's internal instance names do not consistently match physical button names; connections follow indices and XDC.
- sw[7:0] and fnd_digit_select.clk are declared and connected but unused in their module logic.
- main_controller and display scan logic use posedge tick as their clock, exactly as in the source.
- Display outputs are active low; decimal point is seg[7].
- No behavioral corrections were made to the Verilog. The drawing documents existing code, including its current counter/state assignments.

Regenerate with `python generate_schematic.py`. The script reads the project's active XDC for the pin map;
the RTL module definitions and layout are explicitly described in the script.
