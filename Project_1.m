clc; clear; close all;

x = linspace(0.01,.5,1000);
ang = linspace(deg2rad(5),deg2rad(90),850 + 1);

max_values = zeros([3,1000]);

for count = 1:1:1000
    diameter = x(count); %%Diameter of curved mirror (in meters)

    dist = sin(pi/2) .* ( diameter ./ sin(ang)); %%Law of sines 
    %%Above equation finds minimum distance between mirrors such that they do not cast shadows on their neighbors when the sun is higher than 5 deg from the ground
    %%Note: dist = inf when the sun is on the horizon (hence starting the count at 5 deg to prevent large numbers)

    site_height = 12.5; %%meters ; where width is measured perpendicular to sun travel (E to W)
    site_width = 12.5; %%meters ; where height is measured parallel to sun travel (N to S)
    day_length = 12; %%hours
    time_in_sun = day_length * (pi - 2.*ang) / (pi);
    circumfrence_mirror = (2*pi*(diameter/2)) / 2;

    num_mirrors = floor(site_height ./ dist); %%Use absurdly large site_height to minimize edge effects

    p_mirror = (1360/1000) * (diameter * site_width);  %%Kilowatts per mirror

    p_generated = num_mirrors * p_mirror .* time_in_sun; %%KWh
    %%Above formula does not take into consideration partial coverage!!!
    %%Above formula does not take into consideration varying solar irradience due to time of day
    %%Above formula assumes mirror is near equator
    
    [max_p_generated, max_index] = max(p_generated);
    
    max_values(1,count) = diameter;
    max_values(2,count) = max_p_generated;
    max_values(3,count) = rad2deg(ang(max_index));
    
end

plot(max_values(1,:),max_values(2,:))

[trash_variable, global_max_index] = max(max_values(2,:));
max_values(:,global_max_index) %The numbers you really care about


