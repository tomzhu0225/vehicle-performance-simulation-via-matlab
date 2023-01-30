maxspeed
V_cruise=[50 ;90; 120]/3.6;
LHV_gas=44.7e+3;%kj/kg
rho_gas=0.72;%kg/l
N = [1000	1500	2000	2500	3000	3500	4000	4500	5000];
P=[8.1	19.6	28.1	36.4	42.4	46.9	51.1	54.2	57.1	58.7	55.9	49.0]*displacement;
PME=[0.1 0.25 0.5 1 2 3 4 5 6 7 8 9  10 11 12];

consumption_table=[3255	3278	3345	3458	3615	3818	4065	4358	4695;
1632	1626	1634	1674	1728	1875	2034	2158	2295;
818	806	798	811	826	921	1018	1068	1122;
410	400	390	393	395	452	510	529	548;
320	338	355	353	350	353	355	383	410;
271	274	276	289	301	306	310	331	351;
255	255	255	262	269	272	275	280	284;
249	249	249	250	251	254	256	264	272;
247	243	239	242	244	246	248	258	268;
246	240	233	234	234	238	241	251	261;
245	238	230	231	232	236	239	246	252;
255	242	229	229	228	234	240	244	248;
257	242	226	227	227	229	230	238	246;
261	243	224	225	225	227	229	237	244;
262	243	223	224	224	226	227	234	240];


rpm_cruise=V_cruise*3.6./L';
consumption=zeros(3,5);
Fr_cruise=m_v*g*Crr/1000*cos(alpha).*ones(3,1)+0.5*rou_air*SCx*V_cruise.^2
torque_cruise=Fr_cruise*L'/(120*pi*eta_gb)
BMEP=0.126*(torque_cruise/displacement)

for i=1:3
    for j=1:length(L)
        rpm_cruise(i,j)
        consumption(i,j)=interp2(N,PME,consumption_table,rpm_cruise(i,j)*1000,BMEP(i,j))
    end
end
dist=100e3
Energy=Fr_cruise*dist*ones(1,length(L))/eta_gb
gas_M=consumption.*Energy/(1000*3600)
gas_L=gas_M/(rho_gas*1000)%in liter
CO2=1/(1.92+1)*gas_L*0.72/12*44*10;% 