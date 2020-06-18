function [g_temperature, g_enthalpy, g_entrophy] = find_P4(p5_enthalpy, p5_entrophy)

global superheated;

% Initial declerations
efficiency = 1;
p4 = [0 0 0];

% Definitions to make reading code easier
% SH = Super Heated
SH_temperature = 1;
SH_enthalpy = 6;
SH_entrophy = 7;

temperature = 1;
enthalpy = 2;
entrophy = 3;

% *****************************************************************
index = 1;
while superheated(index,7) < p5_entrophy
    index = index + 1;
end

% Starts with p4(entrophy) = p5(entrophy), but steadily deacreases ...
% ... p4(entrophy) till efficency is 0.8
while efficiency > 0.8
    index = index - 1;
    p4 = [superheated(index,SH_temperature) superheated(index, SH_enthalpy) superheated(index, SH_entrophy)];
    p5_ideal_enthalpy = getP5Ideal(p4(entrophy));
    efficiency = -1 * (p5_enthalpy - p4(enthalpy)) / (p4(enthalpy) - p5_ideal_enthalpy);
end

% Return Statements because I don't know matlab
g_temperature = p4(temperature);
g_enthalpy = p4(enthalpy);
g_entrophy = p4(entrophy);
