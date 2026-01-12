# Simulation and Verification

This document presents the functional and timing verification performed at
different stages of the design flow using Vivado.

## Behavioral (RTL) Simulation
Behavioral simulation was performed to verify correct RTL functionality and
instruction execution before synthesis.

![Behavioral Simulation Waveform](images/behav_sim_wave.png)

*Tcl Console Output:*
![Behavioral Simulation Tcl](images/behav_sim_tcl.png)

**Result:** PASS

---

## Post-Synthesis Functional Simulation
Functional simulation was performed after synthesis to ensure logical correctness
was preserved through synthesis.

![Post-Synthesis Functional Waveform](images/post_synth_func_wave.png)

*Tcl Console Output:*
![Post-Synthesis Functional Tcl](images/post_synth_func_tcl.png)

**Result:** PASS

---

## Post-Synthesis Timing Simulation
Timing simulation was performed after synthesis to verify timing behavior with
synthesized delays.

![Post-Synthesis Timing Waveform](images/post_synth_timing_wave.png)

*Tcl Console Output:*
![Post-Synthesis Timing Tcl](images/post_synth_timing_tcl.png)

**Result:** PASS

---

## Post-Implementation Functional Simulation
Functional simulation was performed after implementation to verify correctness
with placement and routing effects included.

![Post-Implementation Functional Waveform](images/post_impl_func_wave.png)

*Tcl Console Output:*
![Post-Implementation Functional Tcl](images/post_impl_func_tcl.png)

**Result:** PASS

---

## Post-Implementation Timing Simulation
Post-implementation timing simulation was performed to validate timing closure
under routed delays.

![Post-Implementation Timing Waveform](images/post_impl_timing_wave.png)

*Tcl Console Output:*
![Post-Implementation Timing Tcl](images/post_impl_timing_tcl.png)

**Result:** PASS

