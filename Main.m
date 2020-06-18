%%%%% NOTE: I FOUND A CALCULATION ERROR AFTER SUBMITTING THE ASSIGNMENT. EFFICENCY DECRASED BY ~0.01 ACROSS THE BOARD

clc; clear; close all;

global superheated_10;
global superheated_1;
global saturated;

superheated_10 = readmatrix('Superheated_Steam_Table_20_bar');
superheated_1 = readmatrix('Superheated_Steam_Table_1_bar');
saturated = readmatrix('Saturated_Steam_Table');

%Declerations to understand getProp() easily
temp = 1; pres = 2;
l_dens = 3;  l_vol = 4;  l_enthalpy = 6;  l_entrophy = 7;
g_dens = 10; g_vol = 11; g_enthalpy = 13; g_entrophy = 14;

% Project Requirement Declerations
pump_eff = 0.65;
turbine_eff = 0.8;
power_in = 910*60*60; %kWh converted to kw*s
power_in_modified = power_in * 0.16; %0.16 is the average efficency of solar panels as specified by the USA gov't
% min_cycle_eff = 0.2;
% min_pres = 0.1; %MPa, not bar
% max_pres = 5;

%Point 1 and all other points annotated as p#
p1 = getProps(0.1); %Gets properties of saturated liquid at a given pressure (MPa)

p2 = linspace(0,0,16); 
p2(pres) = 1; %MPa
p2(l_enthalpy) = p1(l_enthalpy) + p1(l_vol) * ( p2(pres) - p1(pres) ) / pump_eff;

% p3 is calculated later
a = size([500:5:750]);
matrix = zeros([1,a(2)]);
count = 1;

for x = 500:5:750 %From 227 to 600 degC
    
    p4 = get_SH_Props(x,10);

    %Assuming s_5 = s_5g (p5 is on the saturation line)
    p5 = getP5Ideal(p4(g_entrophy));
    if p5(pres) > 0.1 
        p5_real_enthalpy = p4(g_enthalpy) - turbine_eff * (p4(g_enthalpy) - p5(g_enthalpy));

        p3 = p5; %P5(3) through p5(9) is technically on the saturated liquid line and p5(10) through p5(16) is on the saturated gas line
        p6 = p3; %Assumption is made because Question 6 on the "Advance rankine cycle" numerical sheet also assumes this

        p7 = linspace(0,0,16);
        p7_ref = getProps(0.1);
        p7_quality = (p4(g_entrophy) - p7_ref(l_entrophy) ) / ( p7_ref(g_entrophy) - p7_ref(l_entrophy) );

        p7s_enthalpy = p7_ref(l_enthalpy) + p7_quality * (p7_ref(g_enthalpy) - p7_ref(l_enthalpy));

        %Not sure if this is right, but this is literally the only equation I could find
        p7_real_enthalpy = p4(g_enthalpy) - turbine_eff * (p4(g_enthalpy) - p7s_enthalpy);

        %Calculate mass fraction
        mass_fraction = ( p3(l_enthalpy) - p2(l_enthalpy) ) / ( p5_real_enthalpy - p6(l_enthalpy) );

        mass_flow_rate = power_in_modified / ( (p4(g_enthalpy) - p3(l_enthalpy)) * 55.509 ); %The 55.09 converts kw/mol to kw/kg for water
        Work_in_1_2 = mass_flow_rate * ( ( p2(l_enthalpy) - p1(l_enthalpy) ) * 55.509);
        Heat_in_3_4 = power_in_modified;
        Work_out_4_5 = mass_flow_rate * ( (p5_real_enthalpy - p4(g_enthalpy) ) * 55.509);
        Work_out_5_7 = mass_flow_rate * (1 - mass_fraction) * ( (p7_real_enthalpy - p5_real_enthalpy ) * 55.509);
        
        Net_work = -(Work_in_1_2 + Work_out_4_5 + Work_out_5_7);
        efficency =  Net_work / Heat_in_3_4 ;
        
        matrix(count) = efficency;
        count = count + 1;
    end
end

t=1:a(2);
plot(500:5:750,matrix(t))
xlabel('Temperature (K)')
ylabel('Efficency (%)')
