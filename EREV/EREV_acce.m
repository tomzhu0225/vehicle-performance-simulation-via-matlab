%during accelration test we assume the ICE doesn't start
%0-100test
EREV_maxspeed
L=36

% Define the initial condition
v0 = [0];

% Define the time range over which to solve the ODE
tspan = [0, 30];

% Call ode45 to solve the ODE
[tp,vp] = ode45(@accep, tspan, v0);
[ti,vi] = ode45(@accei, tspan, v0);
%plot(tp,vp)

plot(ti,vi*3.6, 'linewidth', 1.1, 'markerfacecolor', [100, 50, 151]/255)
set(gca, 'linewidth', 1.1, 'fontsize', 16, 'fontname', 'times')
xlabel('time(s)')
legend('Battery drain mode','Normal mode')
title('Acceleration')
vp_mask=vp<100/3.6;
last_one_p = find(vp_mask, 1, 'last');
tp(last_one_p)
vi_mask=vi<100/3.6;
last_one_i = find(vi_mask, 1, 'last');
ti(last_one_i)
function dvdt = accep(t,v1)
    motor_rpm_p = evalin('base', 'motor_rpm_p')
    motor_torque_p = evalin('base', 'motor_torque_p')
    motor_eff_rpm_p = evalin('base', 'motor_eff_rpm_p')
    L = evalin('base', 'L')
    motor_eff_torque_p = evalin('base', 'motor_eff_torque_p')
    motor_eff_p = evalin('base', 'motor_eff_p')
    motor_num = evalin('base', 'motor_num')
    m_vp=evalin('base', 'm_vp')
    m_wp=evalin('base', 'm_wp')
    m_mp=evalin('base', 'm_mp')
    rou_air=evalin('base', 'rou_air')
    SCx=evalin('base', 'SCx')
    Crr=evalin('base', 'Crr')
    rpm=(v1*3.6/L)    
    T=interp1(motor_rpm_p,motor_torque_p,rpm);
    %eta_p=interp2(motor_eff_rpm_p,motor_eff_torque_p,motor_eff_p,rpm,T);
    %m_eq_m=m_mp*(120*pi/L)^2*eta_p
    m_eq_m=m_mp*(120*pi/L)^2*0.9
    m=m_vp+m_wp+m_eq_m
    eta_p=0.9
    alpha=0
    g=9.8
    
    dvdt =(1/m)*(motor_num*(120*pi*T*eta_p)/(L)-0.5*rou_air*SCx*v1^2-m_vp*g*Crr/1000*cos(0))
end
function dvdt = accei(t,v1)
    motor_rpm_i = evalin('base', 'motor_rpm_i')
    motor_torque_i = evalin('base', 'motor_torque_i')
    motor_eff_rpm_i = evalin('base', 'motor_eff_rpm_i')
    L = evalin('base', 'L')
    motor_eff_torque_i = evalin('base', 'motor_eff_torque_i')
    motor_eff_i = evalin('base', 'motor_eff_i')
    motor_num = evalin('base', 'motor_num')
    m_vi=evalin('base', 'm_vi')
    m_wi=evalin('base', 'm_wi')
    m_mi=evalin('base', 'm_mi')
    rou_air=evalin('base', 'rou_air')
    SCx=evalin('base', 'SCx')
    Crr=evalin('base', 'Crr')
    rpm=(v1*3.6/L)    
    T=interp1(motor_rpm_i,motor_torque_i,rpm);
    %eta_i=interp2(motor_eff_rpm_i,motor_eff_torque_i,motor_eff_i,rpm,T);
    %m_eq_m=m_mi*(120*pi/L)^2*eta_i
    m_eq_m=m_mi*(120*pi/L)^2*0.9
    m=m_vi+m_wi+m_eq_m

    alpha=0
    g=9.8
    eta_i=0.9
    dvdt =(1/m)*(motor_num*(120*pi*T*eta_i)/(L)-0.5*rou_air*SCx*v1^2-m_vi*g*Crr/1000*cos(0))
end