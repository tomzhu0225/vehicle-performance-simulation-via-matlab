gear_select=4
m_eq_e=m_e*(120*pi/L(gear_select))^2*eta_gb
m=m_v+m_w+m_eq_e

% Define the initial condition
v0 = [80/3.6];

% Define the time range over which to solve the ODE
tspan = [0, 10];

% Call ode45 to solve the ODE
[t,v1] = ode45(@acce1, tspan, v0);
plot(t,v1)
v1_mask=v1<120/3.6
last_one = find(v1_mask, 1, 'last');
t(last_one)
function dvdt = acce1(t,v1)
    rpm_gas = evalin('base', 'rpm_gas')
    tor_gas = evalin('base', 'tor_gas')
    displacement = evalin('base', 'displacement')
    L = evalin('base', 'L')
    eta_gb = evalin('base', 'eta_gb')
    m = evalin('base', 'm')
    m_v=evalin('base', 'm_v')
    rou_air=evalin('base', 'rou_air')
    SCx=evalin('base', 'SCx')
    Crr=evalin('base', 'Crr')
    gear_select=evalin('base', 'gear_select')
    alpha=0
    g=9.8
    interp_tor_gas = interp1(rpm_gas, tor_gas, v1*3.6/L(gear_select))
    dvdt =(1/m)*((120*pi*displacement*interp_tor_gas*eta_gb)/(L(gear_select))-0.5*rou_air*SCx*v1^2-m_v*g*Crr/1000*cos(alpha))
end
