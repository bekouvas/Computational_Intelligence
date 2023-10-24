clc
clear

%% System to controll

Gp = zpk([], [-0.1 -10], 25);

%% Classical controller

c = 0.18;
K  = 50;
Kp = K/25;
Ki = c*Kp;

Gc = zpk(-c, 0, Kp);

open_loop = Gc*Gp;
closed_loop = feedback(open_loop, 1,-1);

time = (0:0.01:5)';
u = 50*ones(length(time),1);
y = lsim(closed_loop, u, time);
figure;
lsim(closed_loop, u, time);
stepinfo(y,time)

%% Fuzzy Controller

fuzzy_controller = create_fuzzy_pi();
[A,B,C,D] = tf2ss(25, poly([-0.1 -10]));
time = (0:0.01:5)';

% Avariables
ke = 1.2;
k1 = 18;
a = 0.31;
kd = a*ke;

initialvector = [0;0];
y_fuz = numerical_solution(time,initialvector,A,B,C,fuzzy_controller,ke,kd,k1,@input_one);

% Plot
figure;
plot(time, [y y_fuz]);
legend('Classic controller', 'Fuzzy controller');
title('Classic PI vs Fuzzy PI controller');
xlabel('Time');

fprintf('Displaying charachteristics of classic controller: \n');
stepinfo(y, time)

fprintf('Displaying charachteristics of fuzzy controller: \n');
stepinfo(y_fuz, time)

%% Rule stimulation

ruleview(fuzzy_controller);

%% 3D Surface

figure;
gensurf(fuzzy_controller)
title('3D output surface of FZ-PI');

%% Scenarios

time = (0:0.01:20);
r2 = input_two_classic(time);
r3 = input_three_classic(time);

y2 = lsim(closed_loop, r2, time);
y3 = lsim(closed_loop, r3, time);

y_fuz2 = numerical_solution(time,initialvector,A,B,C,fuzzy_controller,ke,kd,k1,@input_two);
y_fuz3 = numerical_solution(time,initialvector,A,B,C,fuzzy_controller,ke,kd,k1,@input_three);


figure;
plot(time, r2(:), 'b',time, y2(:), 'g', time, y_fuz2(:),'r');
legend('Reference signal', 'Classic controller', 'Fuzzy controller');
title('Classic vs Fuzzy controller');

figure;
plot(time, r3(:), 'b',time, y3(:), 'g', time, y_fuz3(:),'r');
legend('Reference signal', 'Classic controller', 'Fuzzy controller');
title('Classic vs Fuzzy controller');

%% Inputs

function r = input_one(t)
    r = 50;
end

function r = input_two_classic(time)
r = zeros(length(time),1);

for  i = 1:length(time)
    t = time(i);
    if t<5
        r(i) = 50;
    elseif t>=5 && t<10
        r(i) = 20;
    else
        r(i) = 40;
    end
end
end

function r = input_two(t)
if t<5
    r = 50;
elseif t>=5 && t<10
    r = 20;
else
    r = 40;
end

end

function r = input_three_classic(time)
r = zeros(length(time),1);

for  i = 1:length(time)
    t = time(i);
    if t<5
        r(i) = 10*t;
    elseif t>=5 && t<10
        r(i) = 50;
    else
        r(i) = -5*(t-10)+50;
    end
end

end

function r = input_three(t)
if t<5
    r = 10*t;
elseif t>=5 && t<10
    r = 50;
else
    r = -5*(t-10)+50;
end

end