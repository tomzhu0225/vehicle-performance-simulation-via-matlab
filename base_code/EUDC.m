
maxspeed
consump
idle=0.750
idle_consu=0.243*displacement/3600 %kg/s
timestep=1
m_open=m_v+m_w
t_EUDC=[0
20
25
27
36
38
46
48
61
63
111
114
115
117
188
201
202
204
251
286
316
336
337
338
346
362
370
380
400]
speed_EUDC=[0
0
15
15
35
35
50
50
70
70
70
59
59
50
50
70
70
70
70
100
100
120
120
120
120
80
50
0
0]
gear_EUDC=[0
1
0
2
0
3
0
4
0
5
5
5
0
4
4
4
0
5
5
5
5
5
5
5
5
5
0
0
0]
v_EUDC=speed_EUDC/3.6
a_EUDC=[]
for i=1:length(t_EUDC)-1
    a=(v_EUDC(i+1)-v_EUDC(i))/(t_EUDC(i+1)-t_EUDC(i))
    a_EUDC=[a_EUDC;a]
end
t_interp=[0:timestep:399]'
v_interp = interp1(t_EUDC, v_EUDC,t_interp )

Fr_EUDC=[]
Consu_EUDC=[]
a_interp=[]
gear_interp=[]
m_interp=[]
for i=1:timestep:400
    idx = find(t_EUDC >= i,1);
    a=a_EUDC(idx-1);
    gear=gear_EUDC(idx-1);
    a_interp=[a_interp;a];
    gear_interp=[gear_interp;gear];
end
L1=[0;L]
L_interp=L1(gear_interp+1);
g1_mask=gear_interp==0;
m_eq_e=m_e*(120*pi./L_interp).^2*eta_gb;
m_close=m_v+m_w+m_eq_e;
m_close(isinf(m_close))=0;
m_interp=g1_mask*m_open+m_close

F_aeroEUDC=0.5*rou_air*SCx*v_interp.^2;
F_tireEUDC=m_v*g*Crr/1000*cos(0);
Fr_interp=F_tireEUDC*ones(size(F_aeroEUDC))+F_aeroEUDC+m_interp.*a_interp;
torque_interp=Fr_interp.*L_interp/(120*pi*eta_gb);
BMEP_interp=0.126*torque_interp./displacement;
rpm_interp=v_interp*3.6./L_interp;
idle_mask=gear_interp==0;
reduce_mask=torque_interp<0;
power_interp=Fr_interp.*v_interp/eta_gb;
consu_interp=zeros(size(t_interp));
for i=1:length(t_interp)
    consu_interp(i)=interp2(N,PME,consumption_table,rpm_interp(i)*1000,BMEP_interp(i))/(1000*3600*1000);
end
gas_interp=consu_interp.*power_interp;
gas_interp(isnan(gas_interp))=0;
gas_interp_startstop=gas_interp
gas_interp1=gas_interp+idle_mask.*idle_consu;
gas_interp(gas_interp==0)=idle_consu
cfuel = cumtrapz(t_interp,gas_interp);
gas_interp_startstop(gas_interp1==0)=idle_consu
cfuel_startstop_L=cumtrapz(t_interp,gas_interp_startstop)/rho_gas
cfuel_L=cfuel/rho_gas
L_EUDC=cfuel(end)/rho_gas
L_EUDC_startstop=cfuel_startstop_L(end)
dist=6.9549
consump_kkilo=100/dist*L_EUDC
consump_kkilo_startstop=100/dist*L_EUDC_startstop
plot([0:timestep:399],gas_interp)
yyaxis left
plot([0:timestep:399],v_interp, 'linewidth', 1.1, 'markerfacecolor', [255, 50, 151]/255)
ylabel('velocity(m/s)')
yyaxis right
plot([0:timestep:399],cfuel_L, 'linewidth', 1.1, 'markerfacecolor', [100, 50, 151]/255)
hold on
plot([0:timestep:399],cfuel_startstop_L, 'linewidth', 1.1, 'markerfacecolor', [100, 50, 151]/255)
set(gca, 'linewidth', 1.1, 'fontsize', 16, 'fontname', 'times')
xlabel('time(s)')
ylabel('fuel consumption(L)')
%axis([-0.5 0.5 -0.5 0.5 -2 2]);
title('EUDC')
legend('Velocity (m/s)', 'without startstop system', 'with startstop system','Location', 'northwest')