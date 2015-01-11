vlog -work work C:/Users/Jeffrey/Documents/Lab 3/simulation/modelsim/g19_lab3Q1Timing.vwf.vt
vsim -novopt -c -t 1ps -L cycloneii_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.g19_Tempo_vlg_vec_tst
onerror {resume}
add wave {g19_Tempo_vlg_vec_tst/i1/bpm}
add wave {g19_Tempo_vlg_vec_tst/i1/bpm[7]}
add wave {g19_Tempo_vlg_vec_tst/i1/bpm[6]}
add wave {g19_Tempo_vlg_vec_tst/i1/bpm[5]}
add wave {g19_Tempo_vlg_vec_tst/i1/bpm[4]}
add wave {g19_Tempo_vlg_vec_tst/i1/bpm[3]}
add wave {g19_Tempo_vlg_vec_tst/i1/bpm[2]}
add wave {g19_Tempo_vlg_vec_tst/i1/bpm[1]}
add wave {g19_Tempo_vlg_vec_tst/i1/bpm[0]}
add wave {g19_Tempo_vlg_vec_tst/i1/beat_gate}
add wave {g19_Tempo_vlg_vec_tst/i1/beat_gate[0]}
add wave {g19_Tempo_vlg_vec_tst/i1/clk}
add wave {g19_Tempo_vlg_vec_tst/i1/reset}
add wave {g19_Tempo_vlg_vec_tst/i1/tempo_enable}
run -all
