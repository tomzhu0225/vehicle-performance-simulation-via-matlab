ECE
EUDC
L_urban_NEDC=4.15*L_ECE 
L_urban_NEDC_ss=4.15*L_ECE_startstop %ss stands for startstop
L_ex_NEDC=L_EUDC
L_ex_NEDC_ss=L_EUDC_startstop
dist_urban=4*0.9941
dist_ex=6.9549
consump_NEDC_kkilo=100/(dist_ex+dist_urban)*(L_urban_NEDC+L_ex_NEDC)
consump_NEDC_kkilo_ss=100/(dist_ex+dist_urban)*(L_urban_NEDC_ss+L_ex_NEDC_ss)
consump_NEDC_ur=100/(dist_urban)*L_urban_NEDC
consump_NEDC_ur_ss=100/(dist_urban)*L_urban_NEDC_ss
consump_NEDC_ex=100/(dist_ex)*L_ex_NEDC
consump_NEDC_ex_ss=100/(dist_ex)*L_ex_NEDC_ss