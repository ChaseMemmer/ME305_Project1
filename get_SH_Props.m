function [Properties] = get_SH_Props(temperature, pressure)

global superheated_10;
global superheated_1;

index = 1;

if pressure == 10
    % Superheated(:,1) is temperature. Pressure is always 1 MPa
    while superheated_10(index,1) < temperature
        index = index + 1;
    end

    Properties(1,:) = superheated_10(index,:);
end

if pressure == 1
    % Superheated(:,1) is temperature. Pressure is always 1 MPa
    while superheated_1(index,1) < temperature
        index = index + 1;
    end

    Properties(1,:) = superheated_1(index,:);
end