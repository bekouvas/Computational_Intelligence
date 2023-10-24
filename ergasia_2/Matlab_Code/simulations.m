clc
clear

% constant speed u (m/s)
u = 0.05;

% desired location [(m) (m)]
p_d = [10, 3.2];

% input ranges
dv_range = [0 1];
dh_range = [0 1];
theta_range = [-180 180];

% output range
dtheta_range = [-130 130];

% initial starting angles
theta_init = [0 -45 -90];

% define maximum position values
x_max = 10;
y_max = 4;

% define max number of iterations
N = 1000;

% starting location
p_init = [4 0.4];

% define obstacle points
p_obs = [5 0; 5 1; 6 1; 6 2; 7 2; 7 3; 10 3];

car_controller = create_fuzzy_car_controller();

[x, y] = run_fis(p_init, theta_init(1), car_controller);

figure;
hold on;box on;
axis([0 10 0 4]);
plot(x, y, 'k');
plot(p_obs(:,1), p_obs(:,2), 'k');
plot(10,3.2,'r*')
xlabel('$x$', 'Interpreter', 'Latex');
ylabel('$y$', 'Interpreter', 'Latex');
title('$Trajectory\ for\ \theta_0 = 0$', 'Interpreter', 'Latex');

[x, y] = run_fis(p_init, theta_init(2), car_controller);

figure;
hold on;box on;
axis([0 10 0 4]);
plot(x, y, 'k');
plot(p_obs(:,1), p_obs(:,2), 'k');
plot(10,3.2,'r*')
xlabel('$x$', 'Interpreter', 'Latex');
ylabel('$y$', 'Interpreter', 'Latex');
title('$Trajectory\ for\ \theta_0 = -45$', 'Interpreter', 'Latex');


[x, y] = run_fis(p_init, theta_init(3), car_controller);

figure;
hold on;box on;
axis([0 10 0 4]);
plot(x, y, 'k');
plot(p_obs(:,1), p_obs(:,2), 'k');
plot(10,3.2,'r*')
xlabel('$x$', 'Interpreter', 'Latex');
ylabel('$y$', 'Interpreter', 'Latex');
title('$Trajectory\ for\ \theta_0 = -90$', 'Interpreter', 'Latex');


function [dH, dV] = calcDist(x, y)

    if      (y < 1), dH = 5 - x;
    elseif  (y < 2), dH = 6 - x;
    elseif  (y < 3), dH = 7 - x;
    else           , dH = inf;
    end

    if      (x < 5), dV = y;
    elseif  (x < 6), dV = y - 1;
    elseif  (x < 7), dV = y - 2;
    else           , dV = y - 3;
    end
end

function res = chkBounds(x, y)

    res = (x < 10 & ...
            x > 0 & ...
            y < 4 & ...
            y > 0);
end

function [dh, dv] = normDist(dH, dV)   
    dh = min(1, max(0, dH));
    dv = min(1, max(0, dV));
end

function [x, y] = run_fis(p0, theta0, flc)
    
    % max number of iterations
    N = 1000;

    % car speed
    u = 0.05;

    x = zeros(N, 1);
    y = zeros(N, 1);

    i = 1;
    x(i) = p0(1);
    y(i) = p0(2);
    theta = theta0;

    while chkBounds(x(i), y(i)) && i < N
        [dH, dV] = calcDist(x(i), y(i));
        [dh, dv] = normDist(dH, dV);

        dtheta = evalfis(flc, [dv dh theta]);
        
        i = i + 1;
        
        theta = theta + dtheta;
        if      theta >  180, theta = 180;
        elseif  theta < -180, theta = -180;
        end

        x(i) =  x(i-1) + u*cosd(theta);
        y(i) =  y(i-1) + u*sind(theta);
        
       
    end

    x = x(1:i);
    y = y(1:i);
end