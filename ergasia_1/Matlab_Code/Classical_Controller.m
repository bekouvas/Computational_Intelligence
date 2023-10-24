clear;
clc;

%% Selected Variables 
c = 0.18;
K  = 50;
Kp = K/25;
Ki = c*Kp;

%% Transfer Functions
Gp = zpk([], [-0.1 -10], 25);
Gc = zpk(-c, 0, Kp);

%% Open Loop System
open_loop = Gc*Gp;

%% Topos Rizwn
figure;
rlocus(open_loop);

%% Closed Loop System
closed_loop = feedback(open_loop, 1,-1);
figure;
step(closed_loop);

%% Closed Loop System Response Info
stepinfo(closed_loop)

