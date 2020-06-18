function [p7Ideal] = getP7Ideal(p4_entrophy)

global superheated_1

index = 1;
while superheated_1(index,14) < p4_entrophy
    index = index + 1;
end

p7Ideal = superheated_1(index,:);