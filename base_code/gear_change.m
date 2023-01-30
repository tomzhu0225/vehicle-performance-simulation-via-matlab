maxspeed
gear_change_time=0.5; %gear change time
idle_rpm=1.5;
v_slip=L(1)*1.5/3.6;
m_open=m_v+m_w;

%config the solver
tstart = 0;
tfinal = 100;
v0 = [0];
tout = tstart;
vout = v0.';
rpmout= 0;
teout = [];
veout = [];
ieout = [];

refine=4
% options = odeset('Events',@events)

options = odeset('Events',@events,'MaxStep',1e-2);
for i=1:length(L)
    m_eq_e=m_e*(120*pi/L(i))^2*eta_gb
    m_close=m_v+m_w+m_eq_e
    [t,v,te,ve,ie] = ode23(@(t,v) acce2(t,v,i),[tstart tfinal],v0,options)
    nt = length(t);
    tout = [tout; t(2:nt)];
    vout = [vout; v(2:nt,:)];
    rpmout=[rpmout;v(2:nt,:)*3.6/L(i)]
    teout = [teout; te];          % Events at tstart are never reported.
    veout = [veout; ve];
    ieout = [ieout; ie];
    if i<length(L)
    %new initial for gear change
    v0(1) = v(nt)
%     options = odeset(options,'InitialStep',t(nt)-t(nt-refine),...
%         'MaxStep',t(nt)-t(1));
    tstart = t(nt);
    t_gearchangeend=tstart+gear_change_time
    [t,v] = ode45(@gear_c, [tstart,t_gearchangeend], v0);
    %new start time after gear change
    nt = length(t);
    tstart =t_gearchangeend;
    v0(1) = v(nt)
    tout = [tout; t(2:nt)];
    vout = [vout; v(2:nt,:)];
    rpmout=[rpmout;1.5*ones(size(v(2:nt,:)))];
    end
end
yyaxis left
plot(tout,vout, 'linewidth', 1.1, 'markerfacecolor', [255, 50, 151]/255)
ylabel('velocity(m/s)')
yyaxis right
rpm_mask=rpmout>1.5
rpmout=rpmout.*rpm_mask
rpmout=rpmout+(rpm_mask==0)*1.5
plot(tout,1000*rpmout, 'linewidth', 1.1, 'markerfacecolor', [100, 50, 151]/255)
set(gca, 'linewidth', 1.1, 'fontsize', 16, 'fontname', 'times')
xlabel('time(s)')
ylabel('rpm')
%axis([-0.5 0.5 -0.5 0.5 -2 2]);
title('acceleration')

colormap jet
%calculate distance
cdistance = cumtrapz(tout,vout);
T = table(tout,cdistance,'VariableNames',{'Time','CumulativeDistance'})    
cdistance_mask=cdistance<1000
last_one = find(cdistance_mask, 1, 'last');
tout(last_one)
function dvdt = gear_c(t,v1)
    displacement = evalin('base', 'displacement')
    eta_gb = evalin('base', 'eta_gb')
    m_v=evalin('base', 'm_v')
    rou_air=evalin('base', 'rou_air')
    SCx=evalin('base', 'SCx')
    Crr=evalin('base', 'Crr')
    alpha=0
    v_slip=evalin('base', 'v_slip')
    v_change=evalin('base', 'v_change')
    m_open=evalin('base', 'm_open')
    m_close=evalin('base', 'm_close')
    g=9.8
    dvdt =(1/m_open)*(-0.5*rou_air*SCx*v1^2-m_v*g*Crr/1000*cos(alpha))
    end
    function dvdt = acce2(t,v1,i)
    rpm_gas = evalin('base', 'rpm_gas');
    tor_gas = evalin('base', 'tor_gas');
    displacement = evalin('base', 'displacement');
    L = evalin('base', 'L');
    eta_gb = evalin('base', 'eta_gb')    ;
    m_v=evalin('base', 'm_v');
    rou_air=evalin('base', 'rou_air');
    SCx=evalin('base', 'SCx');
    Crr=evalin('base', 'Crr');
    alpha=0;
    v_slip=evalin('base', 'v_slip');
    v_change=evalin('base', 'v_change');
    m_open=evalin('base', 'm_open');
    m_close=evalin('base', 'm_close');
    idle_rpm=evalin('base', 'idle_rpm');
    g=9.8;
    rpm=v1*3.6/L(i);
    if v1<v_slip
        interp_tor_gas = interp1(rpm_gas, tor_gas, idle_rpm);
        dvdt =(1/m_open)*((120*pi*displacement*interp_tor_gas*eta_gb)/(L(1))-0.5*rou_air*SCx*v1^2-m_v*g*Crr/1000*cos(alpha));
    else
        interp_tor_gas = interp1(rpm_gas, tor_gas, v1*3.6/L(i));
        dvdt =(1/m_close)*((120*pi*displacement*interp_tor_gas*eta_gb)/(L(i))-0.5*rou_air*SCx*v1^2-m_v*g*Crr/1000*cos(alpha));
    end
    end
    function [value, isterminal, direction] = events(t, v1)
    L = evalin('base', 'L')
    i = evalin('base', 'i')
    value = v1*3.6/(L(i)) - 5.5;
    if i<length(L)
    isterminal = 1;
    else
    isterminal = 0;    
    end
    direction = 1;
    end