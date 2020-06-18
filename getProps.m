function [Properties] = getProps(pressure)

global saturated;

index = 1;

% Saturated(:,1) is temperature, Saturated(:,2) is pressure
while saturated(index,2) < pressure
    index = index + 1;
end

Properties(1,:) = saturated(index,:);