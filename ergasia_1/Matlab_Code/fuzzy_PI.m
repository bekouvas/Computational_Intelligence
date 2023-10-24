clear
clc

fuzzy_controller = create_fuzzy_pi();

figure;
plotmf(fuzzy_controller, 'input' , 1);
title('Membership Functions of E');

figure;
plotmf(fuzzy_controller, 'input' , 2);
hl = title('Membership Functions of dE');

figure;
plotmf(fuzzy_controller, 'output' , 1);
hl = title('Membership Functions of dU');

