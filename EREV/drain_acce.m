clear
EREV_maxspeed
EREV_acce
Maxpower=58.7*displacement
power_elec=Maxpower*0.94*1000
L=36
v0 = [0.1];

% Define the time range over which to solve the ODE
tspan = [0, 30];

[td,vd] = ode45(@accei, tspan, v0);
plot(ti,vi*3.6, 'linewidth', 1.1, 'markerfacecolor', [100, 50, 151]/255)
hold on
vd=interp1(td,vd,ti)
plot(ti,min(vd,vi)*3.6, 'linewidth', 1.1, 'markerfacecolor', [100, 50, 151]/255)
set(gca, 'linewidth', 1.1, 'fontsize', 16, 'fontname', 'times')
xlabel('time(s)')
ylabel('velocity(km/h)')
legend('Normal mode','Battery drain mode')
title('Acceleration')
function dvdt = accei(t,v1)
    L = evalin('base', 'L')
    power_elec = evalin('base', 'power_elec')
    m_vi=evalin('base', 'm_vi')
    m_wi=evalin('base', 'm_wi')
    m_mi=evalin('base', 'm_mi')
    rou_air=evalin('base', 'rou_air')
    SCx=evalin('base', 'SCx')
    Crr=evalin('base', 'Crr')
    
    %eta_i=interp2(motor_eff_rpm_i,motor_eff_torque_i,motor_eff_i,rpm,T);
    %m_eq_m=m_mi*(120*pi/L)^2*eta_i
    m_eq_m=m_mi*(120*pi/L)^2*0.9
    m=m_vi+m_wi+m_eq_m

    alpha=0
    g=9.8
    eta_i=0.9
    
    dvdt =(1/m)*(power_elec*eta_i/v1-0.5*rou_air*SCx*v1^2-m_vi*g*Crr/1000*cos(0))
end