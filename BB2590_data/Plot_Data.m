%%
% COPYRIGHT  2015
% THE REGENTS OF THE UNIVERSITY OF MICHIGAN
% ALL RIGHTS RESERVED
% 
% PERMISSION IS GRANTED TO USE, COPY AND REDISTRIBUTE THIS SOFTWARE FOR NONCOMMERCIAL EDUCATION AND RESEARCH
% PURPOSES, SO LONG AS NO FEE IS CHARGED, AND SO LONG AS THE COPYRIGHT NOTICE ABOVE, THIS GRANT OF PERMISSION, 
% AND THE DISCLAIMER BELOW APPEAR IN ALL COPIES MADE; AND SO LONG AS THE NAME OF THE UNIVERSITY OF MICHIGAN IS NOT 
% USED IN ANY ADVERTISING OR PUBLICITY PERTAINING TO THE USE OR DISTRIBUTION OF THIS SOFTWARE WITHOUT SPECIFIC, 
% WRITTEN PRIOR AUTHORIZATION.  PERMISSION TO MODIFY OR OTHERWISE CREATE DERIVATIVE WORKS OF THIS SOFTWARE 
% IS NOT GRANTED.
% 
% THIS USE OF THIS SOFTWARE REQUIRES MATLAB(TM) AND SIMULINK(TM), A LICENSED PRODUCT OF THE MATHWORKS, INC. 
% THE SOFTWARE USER IS SOLELY RESOPNSIBLE FOR OBTAINTING AN APPROPRIATE LICENSE FOR MATLAB(TM) AND SIMULINK(TM).  
% NO LICENSE TO MATLAB(TM) AND SIMULINK(TM) IS GRANTED, INFERRED OR IMPLIED BY THE DISTRIBUTION OF THIS SOFTWARE.
% 
% THIS SOFTWARE IS PROVIDED AS IS, WITHOUT REPRESENTATION AS TO ITS FITNESS FOR ANY PURPOSE, AND WITHOUT WARRANTY 
% OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
% FITNESS FOR A PARTICULAR PURPOSE. THE REGENTS OF THE UNIVERSITY OF MICHIGAN SHALL NOT BE LIABLE FOR ANY DAMAGES,
% INCLUDING SPECIAL, INDIRECT, INCIDENTAL, OR CONSEQUENTIAL DAMAGES, WITH RESPECT TO ANY CLAIM ARISING OUT OF OR IN
% CONNECTION WITH THE USE OF THE SOFTWARE, EVEN IF IT HAS BEEN OR IS HEREAFTER ADVISED OF THE POSSIBILITY OF SUCH 
% DAMAGES.

% References:
% 1) Maximum power estimation of lithium-ion batteries accounting for thermal and electrical constraints
% Y Kim, S Mohan, JB Siegel, AG Stefanopoulou - ASME 2013 Dynamic Systems and Control Conference, 2013
% 
% 2) Keeping Ground Robots on the Move through Battery and Mission Management
% Tulga Ersal, Youngki Kim, John Broderick, Tianyou Guo, Amir Sadrpour, Anna Stefanopoulou, 
% Jason Siegel, Dawn Tilbury, Ella Atkins, Huei Peng, Jionghua Judy Jin, A Galip Ulsoy, ASME Dynamic Systems and Control Magazine, 2014
%%
clear all
close all

%% Plot OCV data
load('data/V_avgC20.mat')
SOC=0:0.001:1;
figure(1)
plot(SOC,V_avgC20)
xlabel('SOC')
ylabel('Open circuit voltage')

%% plot parametrization data of interest
load('data\all_0C.mat') % the files to load here are data corresponding to pulse trains at various temperatures
%   I         421587x1             3372696  double       Current            
%   T_f       421587x1             3372696  double       Air Temperature       
%   T_s       421587x1             3372696  double       Battery Surface Temperature      
%   V         421587x1             3372696  double       Battery Voltage       
%   t         421587x1             3372696  double       Time (s)
figure(2)
Qcap=2.16;
DT=max(diff(t));
subplot(4,1,1)
SOC=1+cumsum(I/3600)/Qcap*DT;
plot(t,I)
ylabel('Current (A)')
subplot(4,1,2)
plot(t,V)
ylabel('Coltage (V)')
ylim([3,4.5])

subplot(4,1,3)
plot(t,T_f,t,T_s)
legend('air temperature','battery surface temperature')
ylabel('Temperatuere (^oC)')

subplot(414)
plot(t,SOC)
xlabel('Time (s)')
ylabel('SOC')
%% drive cycle
clear all
load('data/BB2590_drivecycle.mat')
LW = 1.5; % linewidth

t1 = time/60;

figure
set(gca,'FontSize',12)
subplot(211)
plot(t1,V)
xlabel('Time (mins)')
ylabel('Voltage (V)')

subplot(212)
plot(t1,I)
xlabel('Time (mins)')
ylabel('Current (A)')

figure
set(gca,'FontSize',12)
subplot(3,1,[1 2]);
plot(t1,Tamb,'LineWidth',LW);hold on
plot(t1,T_f1,'r--','LineWidth',LW);hold on
plot(t1,T_f2,'m-.','LineWidth',LW);hold on
plot(t1,T_tab,'b:','LineWidth',LW);hold on
plot(t1,T_s2,'g--','LineWidth',LW);hold on
plot(t1,T_s1,'k-.','LineWidth',LW);hold on

ylabel('Temperature(^oC)');

legend('Ambient','Fluid 1','Fluid 2','Tab','Surf 2','Surf 1',1);
grid on;

subplot(3, 1, 3)
plot(t1,I,'LineWidth',1);
xlabel('Time(mins)');
ylabel('Current(A)');

