%input
displacement=1.2 
m_v=2136 %mass of the vehicle
L1=7.05 %first gear ratio L1=v/(rpm/1000)
Crr=8.5 %tire inertial coefficient
SCx=0.65 %frontal area * drag coefficient
slope=0 %driving slop
topgear=6
%engine mapping
rpm_gas=1:0.5:6.5
tor_gas=[77	125	134	139	135	128	122	115	109	102	89 72]
inertial_per_l_gas=0.085 %engine inertial
eta_gb=0.9 %transmission efficiency
rpm=5.5 %Max power rpm

alpha=asin(0.05)*pi/180
m_w=0.033*m_v
m_e=inertial_per_l_gas*displacement
%m_eq_e=m_e*(120*pi/L)^2*eta_gb
rou_air=1.21
index_gas=rpm/0.5-1
g=9.8
syms v
Fr=(120*pi*displacement*tor_gas(index_gas)*eta_gb)/(v*3.6/rpm)
F_aero=0.5*rou_air*SCx*v^2
F_tire=m_v*g*Crr/1000*cos(alpha)
F_slope=m_v*g*slope
solved_v = vpa(solve(Fr - F_aero - F_tire - F_slope, v));
v_max=solved_v(1)
L5=double(solved_v(1)*3.6/rpm);
k=(L5-L1)/(topgear-1);
a=(L5/L1)^(1/(topgear-1));
K=zeros(topgear,1);
K(1)=L1;
A=zeros(topgear,1);
A(1)=L1;
L=zeros(topgear,1);
for i=2:topgear
    K(i)=K(i-1)+k;
    A(i)=A(i-1)*a;
end
L=(K+A)/2;

