clear 
clc

fuzzy_car_controller = create_fuzzy_car_controller();

figure;
plotmf(fuzzy_car_controller, 'input' , 1);
title('Membership Functions of dV');

figure;
plotmf(fuzzy_car_controller, 'input' , 2);
hl = title('Membership Functions of dH');

figure;
plotmf(fuzzy_car_controller, 'input' , 3);
hl = title('Membership Functions of theta');

figure;
plotmf(fuzzy_car_controller, 'output' , 1);
hl = title('Membership Functions of dtheta');

%ruleview(fuzzy_car_controller);
