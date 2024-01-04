%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%COPYRIGHT  ? 2013 
%THE REGENTS OF THE UNIVERSITY OF MICHIGAN 
%ALL RIGHTS RESERVED 
%PERMISSION IS GRANTED TO USE, COPY AND REDISTRIBUTE THIS SOFTWARE FOR NONCOMMERCIAL EDUCATION AND RESEARCH PURPOSES, SO LONG AS NO FEE IS CHARGED, 
%AND SO LONG AS THE COPYRIGHT NOTICE ABOVE, THIS GRANT OF PERMISSION, AND THE DISCLAIMER BELOW APPEAR IN ALL COPIES MADE; 
%AND SO LONG AS THE NAME OF THE UNIVERSITY OF MICHIGAN IS NOT USED IN ANY ADVERTISING OR PUBLICITY PERTAINING TO THE USE OR DISTRIBUTION OF THIS 
%SOFTWARE WITHOUT SPECIFIC, WRITTEN PRIOR AUTHORIZATION. PERMISSION TO MODIFY OR OTHERWISE CREATE DERIVATIVE WORKS OF THIS SOFTWARE IS NOT GRANTED. 

%THIS USE OF THIS SOFTWARE REQUIRES MATLAB(TM) AND SIMULINK(TM), A LICENSED PRODUCT OF THE MATHWORKS, INC.  
%THE SOFTWARE USER IS SOLELY RESOPNSIBLE FOR OBTAINTING AN APPROPRIATE LICENSE FOR MATLAB(TM) AND SIMULINK(TM).  
%NO LICENSE TO MATLAB(TM) AND SIMULINK(TM) IS GRANTED, INFERRED OR IMPLIED BY THE DISTRIBUTION OF THIS SOFTWARE. 

%THIS SOFTWARE IS PROVIDED AS IS, WITHOUT REPRESENTATION AS TO ITS FITNESS FOR ANY PURPOSE, AND WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS 
%OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. 
%THE REGENTS OF THE UNIVERSITY OF MICHIGAN SHALL NOT BE LIABLE FOR ANY DAMAGES, INCLUDING SPECIAL, INDIRECT, INCIDENTAL, OR CONSEQUENTIAL DAMAGES, 
%WITH RESPECT TO ANY CLAIM ARISING OUT OF OR IN CONNECTION WITH THE USE OF THE SOFTWARE, EVEN IF IT HAS BEEN OR IS HEREAFTER ADVISED OF THE POSSIBILITY 
%OF SUCH DAMAGES.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all

Cc=62.7; %J/K, Lumped Cell Core Heat Capacity
Cs=4.5; %J/K, Lumped Cell Surface (Casing) Heat Capacity
Rc=1.94; %K/W, conduction resistance; 
Ru = 15; %K/W, convection resistance; for natural convection, this number is above 10

load('V_avgC20.mat'); % open circuit voltage
load('r_rc_rc_scale_cap_A123_26650.mat'); % parameters for the electrical model
load('dUdT'); %dU/dT for entropic heat calculation, from paper of Dr. Forgez
C_bat=3.2;  % battery capacity

%% Discharge
time=4000;
Ts_0=25; % initial battery surface temperature,
Tc_0=25; % initial battery core temperature, 
Tf = 25; % ambient temperature
SOC_0 = 0.9; % initial SOC;
options=[];
t = 0:0.1:time; % simulation time; don't over-discharge/charge the battery!
t = t';
I = 3.2*ones(length(t),1);  % current input, + for discharge, - for charge
V_T_stop=2.5; %Discharge stop voltage

%RF=1
RF=1;
ut=[t I]; % simulation input
[ts,xs,y]=sim('Battery_Electrothermal_Model_discharge.slx', t, options, ut);
Tc= y(:,1); % simulated battery core temperature;
Ts= y(:,2); % simulated battery surface temperature;
SOC1= y(:,3); % simulated battery SOC;
V_T1= y(:,4); % simulated battery voltages;
cap1=C_bat*SOC1; %battery capacity matrix

%RF=1.2
RF=1.2;
ut=[t I]; % simulation input
[ts,xs,y]=sim('Battery_Electrothermal_Model_discharge.slx', t, options, ut);
Tc= y(:,1); % simulated battery core temperature;
Ts= y(:,2); % simulated battery surface temperature;
SOC12= y(:,3); % simulated battery SOC;
V_T12= y(:,4); % simulated battery voltages;
cap12=C_bat*SOC1; %battery capacity matrix

%RF=1.4
RF=1.4;
ut=[t I]; % simulation input
[ts,xs,y]=sim('Battery_Electrothermal_Model_discharge.slx', t, options, ut);
Tc= y(:,1); % simulated battery core temperature;
Ts= y(:,2); % simulated battery surface temperature;
SOC14= y(:,3); % simulated battery SOC;
V_T14= y(:,4); % simulated battery voltages;
cap14=C_bat*SOC1; %battery capacity matrix

%RF=1.6
RF=1.6;
ut=[t I]; % simulation input
[ts,xs,y]=sim('Battery_Electrothermal_Model_discharge.slx', t, options, ut);
Tc= y(:,1); % simulated battery core temperature;
Ts= y(:,2); % simulated battery surface temperature;
SOC16= y(:,3); % simulated battery SOC;
V_T16= y(:,4); % simulated battery voltages;
cap16=C_bat*SOC1; %battery capacity matrix

%RF=1.8
RF=1.8;
ut=[t I]; % simulation input
[ts,xs,y]=sim('Battery_Electrothermal_Model_discharge.slx', t, options, ut);
Tc= y(:,1); % simulated battery core temperature;
Ts= y(:,2); % simulated battery surface temperature;
SOC18= y(:,3); % simulated battery SOC;
V_T18= y(:,4); % simulated battery voltages;
cap18=C_bat*SOC1; %battery capacity matrix

%RF=2
RF=2;
ut=[t I]; % simulation input
[ts,xs,y]=sim('Battery_Electrothermal_Model_discharge.slx', t, options, ut);
Tc= y(:,1); % simulated battery core temperature;
Ts= y(:,2); % simulated battery surface temperature;
SOC2= y(:,3); % simulated battery SOC;
V_T2= y(:,4); % simulated battery voltages;
cap2=C_bat*SOC1; %battery capacity matrix

maxLength = max([length(V_T1), length(V_T12), length(V_T14), length(V_T16), length(V_T18), length(V_T2)]);
V_T1(length(V_T1)+1:maxLength) = V_T_stop;
V_T12(length(V_T12)+1:maxLength) = V_T_stop;
V_T14(length(V_T14)+1:maxLength) = V_T_stop;
V_T16(length(V_T16)+1:maxLength) = V_T_stop;
V_T18(length(V_T18)+1:maxLength) = V_T_stop;
V_T2(length(V_T2)+1:maxLength) = V_T_stop;

figure
plot(cap1,V_T1,cap12,V_T12,cap14,V_T14,cap16,V_T16,cap18,V_T18,cap2,V_T2)
title('Voltage vs. Capacity (CC Discharging)')
xlabel('Capacity (Ah)')
ylabel('Voltage (V)')
legend('Cycle 1','Cycle 15','Cycle 30','Cycle 45','Cycle 60','Cycle 75')
hold on

%% Charge

Ts_0=25; % initial battery surface temperature,
Tc_0=25; % initial battery core temperature, 
Tf = 25; % ambient temperature
SOC_0 = 0.1; % initial SOC;
options=[];
t = 0:0.1:time; % simulation time; don't over-discharge/charge the battery!
t = t';
I = -3.2*ones(length(t),1);  % current input, + for discharge, - for charge
V_T_stop=4.2; %Charge stop voltage

%RF=1
RF=1;
ut=[t I]; % simulation input
[ts,xs,y]=sim('Battery_Electrothermal_Model_charge.slx', t, options, ut);
Tc= y(:,1); % simulated battery core temperature;
Ts= y(:,2); % simulated battery surface temperature;
SOC1= y(:,3); % simulated battery SOC;
V_T1= y(:,4); % simulated battery voltages;
cap1=cap;%C_bat*SOC1; %battery capacity matrix

%RF=1.2
RF=1.2;
ut=[t I]; % simulation input
[ts,xs,y]=sim('Battery_Electrothermal_Model_charge.slx', t, options, ut);
Tc= y(:,1); % simulated battery core temperature;
Ts= y(:,2); % simulated battery surface temperature;
SOC12= y(:,3); % simulated battery SOC;
V_T12= y(:,4); % simulated battery voltages;
cap12=cap;%C_bat*SOC1; %battery capacity matrix

%RF=1.4
RF=1.4;
ut=[t I]; % simulation input
[ts,xs,y]=sim('Battery_Electrothermal_Model_charge.slx', t, options, ut);
Tc= y(:,1); % simulated battery core temperature;
Ts= y(:,2); % simulated battery surface temperature;
SOC14= y(:,3); % simulated battery SOC;
V_T14= y(:,4); % simulated battery voltages;
cap14=cap;%C_bat*SOC1; %battery capacity matrix

%RF=1.6
RF=1.6;
ut=[t I]; % simulation input
[ts,xs,y]=sim('Battery_Electrothermal_Model_charge.slx', t, options, ut);
Tc= y(:,1); % simulated battery core temperature;
Ts= y(:,2); % simulated battery surface temperature;
SOC16= y(:,3); % simulated battery SOC;
V_T16= y(:,4); % simulated battery voltages;
cap16=cap;%C_bat*SOC1; %battery capacity matrix

%RF=1.8
RF=1.8;
ut=[t I]; % simulation input
[ts,xs,y]=sim('Battery_Electrothermal_Model_charge.slx', t, options, ut);
Tc= y(:,1); % simulated battery core temperature;
Ts= y(:,2); % simulated battery surface temperature;
SOC18= y(:,3); % simulated battery SOC;
V_T18= y(:,4); % simulated battery voltages;
cap18=cap;%C_bat*SOC1; %battery capacity matrix

%RF=2
RF=2;
ut=[t I]; % simulation input
[ts,xs,y]=sim('Battery_Electrothermal_Model_charge.slx', t, options, ut);
Tc= y(:,1); % simulated battery core temperature;
Ts= y(:,2); % simulated battery surface temperature;
SOC2= y(:,3); % simulated battery SOC;
V_T2= y(:,4); % simulated battery voltages;
cap2=cap;%C_bat*SOC1; %battery capacity matrix

maxLength = max([length(V_T1), length(V_T12), length(V_T14), length(V_T16), length(V_T18), length(V_T2)]);
V_T1(length(V_T1)+1:maxLength) = V_T_stop;
V_T12(length(V_T12)+1:maxLength) = V_T_stop;
V_T14(length(V_T14)+1:maxLength) = V_T_stop;
V_T16(length(V_T16)+1:maxLength) = V_T_stop;
V_T18(length(V_T18)+1:maxLength) = V_T_stop;
V_T2(length(V_T2)+1:maxLength) = V_T_stop;

figure
plot(cap1,V_T1,cap12,V_T12,cap14,V_T14,cap16,V_T16,cap18,V_T18,cap2,V_T2)
title('Voltage vs. Capacity (CC Charging)')
xlabel('Capacity (Ah)')
ylabel('Voltage (V)')
legend('Cycle 1','Cycle 15','Cycle 30','Cycle 45','Cycle 60','Cycle 75')
hold on

%cap_mat=[trapz(cap1,V_T1);trapz(cap12,V_T12);trapz(cap14,V_T14);trapz(cap16,V_T16);trapz(cap18,V_T18);trapz(cap2,V_T2)]
%cycle_mat=[
%figure
%plot(1,trapz(cap1,V_T1),15,trapz(cap12,V_T12),30,tapz(cap14,V_T14),45,trapz(cap16,V_T16),60,trapz(cap18,V_T18),75,trapz(cap2,V_T2))