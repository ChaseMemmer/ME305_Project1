function [p5Ideal] = getP5Ideal(p4_entrophy)

global saturated

index = 1;
while saturated(index,14) > p4_entrophy
    index = index + 1;
end

p5Ideal = saturated(index,:);