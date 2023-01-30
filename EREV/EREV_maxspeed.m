r_wheel=0.4 %m
displacement=1%L
battery=22 %kwh
%for electric motot
motor_num=4
motor_m_co_p=19 %kg/100nm
motor_m_co_i=37
motor_maxtorque=200;
motor_co=motor_maxtorque/100;
motor_m_p=motor_num*motor_co*motor_m_co_p;
motor_m_i=motor_num*motor_co*motor_m_co_i
motor_rpm_p=[0 235 470 705 940 1175 1410 1645	1880 2115 2350	2585 2820 3055 3290	3525 3760 3995 4230	6000]';
motor_rpm_p=motor_rpm_p/1000;
motor_power_p=motor_co*[0 2	5 7	10	10	10	10	10	10	10	10	10	10	10	10	10	10	10	10]';
motor_torque_p=motor_co*[100	100	100	100	100	80	67	57	50	44	40	36	33	31	29	27	25	24	22	16]';
motor_eff_rpm_p=[0	500	1000	1500	2000	2500	3000	3500	4000	4500	6000]'
motor_eff_rpm_p=motor_eff_rpm_p/1000
motor_eff_torque_p=motor_co*[0.00
1.64
11.48
21.31
31.15
40.98
50.82
60.66
70.49
80.33
90.16
100.00]
motor_eff_p=[0.86	0.86	0.86	0.86	0.86	0.86	0.86	0.86	0.86	0.86	0.86;
0.86	0.83	0.81	0.79	0.78	0.77	0.77	0.76	0.76	0.75	0.75;
0.86	0.86	0.89	0.89	0.90	0.90	0.90	0.90	0.90	0.90	0.90;
0.86	0.81	0.86	0.88	0.90	0.90	0.91	0.91	0.90	0.90	0.90;
0.86	0.76	0.85	0.87	0.88	0.89	0.90	0.90	0.90	0.90	0.90;
0.86	0.72	0.82	0.86	0.87	0.87	0.87	0.87	0.87	0.87	0.87;
0.86	0.68	0.79	0.84	0.84	0.84	0.84	0.84	0.84	0.84	0.84;
0.86	0.65	0.77	0.82	0.82	0.82	0.82	0.82	0.82	0.82	0.82;
0.86	0.62	0.74	0.74	0.74	0.74	0.74	0.74	0.74	0.74	0.74;
0.86	0.59	0.72	0.72	0.72	0.72	0.72	0.72	0.72	0.72	0.72;
0.86	0.56	0.70	0.70	0.70	0.70	0.70	0.70	0.70	0.70	0.70;
0.86	0.53	0.68	0.68	0.68	0.68	0.68	0.68	0.68	0.68	0.68]
motor_rpm_i=[0	1000	2000	3000	4000	5000	6000	7000	8000	9000	10000]';
motor_rpm_i=motor_rpm_i/1000;
motor_power_i=motor_co*[0 10 21 28 28 28 28	28 28 28 27]';
motor_torque_i=motor_co*[100 100 100 88	66 53 44 38	33 29 26]';
motor_eff_rpm_i=[0	500	1000	1500	2000	2500	3000	3500	4000	4500	6000]'
motor_eff_rpm_i=motor_eff_rpm_i/1000
motor_eff_torque_i=motor_co*[0
10
20
30
40
50
60
70
80
90
100
]
motor_eff_i=[0.70	0.70	0.70	0.70	0.70	0.70	0.70	0.70	0.7	0.7	0.7;
0.70	0.77	0.82	0.87	0.88	0.89	0.90	0.91	0.92	0.92	0.92;
0.70	0.81	0.85	0.89	0.91	0.91	0.91	0.91	0.9	0.88	0.8;
0.70	0.82	0.86	0.90	0.91	0.91	0.90	0.88	0.8	0.78	0.78;
0.70	0.82	0.87	0.90	0.91	0.90	0.86	0.80	0.78	0.78	0.78;
0.70	0.82	0.88	0.90	0.90	0.87	0.82	0.78	0.78	0.78	0.78;
0.70	0.81	0.87	0.90	0.88	0.85	0.79	0.78	0.78	0.78	0.78;
0.70	0.80	0.86	0.89	0.87	0.82	0.78	0.78	0.78	0.78	0.78;
0.7	0.79	0.86	0.88	0.85	0.82	0.79	0.78	0.78	0.78	0.78;
0.7	0.78	0.86	0.87	0.82	0.82	0.79	0.78	0.78	0.78	0.78;
0.7	0.78	0.85	0.86	0.81	0.82	0.79	0.78	0.78	0.78	0.78;]
%for battery
battery_m=battery*1000/243 %kg
battery_v=battery*1000/676; %L
%for engine
inertial_per_l_gas=0.085;
inertial_per_nm_p=7.41e-5
inertial_per_nm_i=1.18e-4
eta_gb=0.9;
m_vp=1650+motor_m_p+battery_m+100
m_vi=1650+motor_m_i+battery_m+100
m_wp=0.033*m_vp;
m_wi=0.033*m_vi
m_e=inertial_per_l_gas*displacement;
m_mp=inertial_per_nm_p*motor_maxtorque*motor_num
m_mi=inertial_per_nm_i*motor_maxtorque*motor_num
%m_eq_e=m_e*(120*pi/L)^2*eta_gb
Crr=8.5;
SCx=0.65;
rou_air=1.21;
rpm_gas=1:0.5:6.5;
rpm_gas=rpm_gas';
tor_gas=[77	125	134	139	135	128	122	115	109	102	89 72]';
g=9.8;
v=0:0.1:100;
F_aero=0.5*rou_air*SCx*v.^2;
F_tire_p=m_vp*g*Crr/1000*cos(0);
F_tire_i=m_vi*g*Crr/1000*cos(0);
v_max_p=[]
v_max_i=[]
L_set=10:1:150
for L=L_set
rpm=(v*3.6/L);
T_p=interp1(motor_rpm_p,motor_torque_p,rpm);
eta_p=interp2(motor_eff_rpm_p,motor_eff_torque_p,motor_eff_p,rpm,T_p);
Fr_p=motor_num*(120*pi*T_p.*eta_p)./(L);
T_i=interp1(motor_rpm_i,motor_torque_i,rpm);
eta_i=interp2(motor_eff_rpm_i,motor_eff_torque_i,motor_eff_i,rpm,T_i);
Fr_i=motor_num*(120*pi*T_i.*eta_i)./(L);
F_p=Fr_p - F_aero - F_tire_p;
F_i=Fr_i - F_aero - F_tire_i;

idx_p=find(F_p>0,1,'last');
idx_i=find(F_i>0,1,'last');
v_max_p=[v_max_p;v(idx_p)]
v_max_i=[v_max_i;v(idx_i)]
end
idx_p=find(v_max_p>60,1,'last');
idx_i=find(v_max_i>60,1,'last');
L_p=L_set(idx_p)
L_i=L_set(idx_i)
% plot(L_set,v_max_p)
% 
% hold on
% plot(L_set,v_max_i)
% legend('P','I')
