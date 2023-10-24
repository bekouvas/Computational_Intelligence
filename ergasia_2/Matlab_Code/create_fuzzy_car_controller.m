function  fuzzy_car_controller = create_fuzzy_car_controller()

fuzzy_car_controller = newfis('fis');
fuzzy_car_controller = setfis(fuzzy_car_controller, 'impMethod', 'prod');

%% Inputs
fuzzy_car_controller = addvar(fuzzy_car_controller, 'input', 'dV', [0 1]);
fuzzy_car_controller = addvar(fuzzy_car_controller, 'input', 'dH', [0 1]);
fuzzy_car_controller = addvar(fuzzy_car_controller, 'input', 'Theta', [-180 180]);

%% Output
fuzzy_car_controller = addvar(fuzzy_car_controller, 'output', 'dTheta', [-130 130]);

%% Member functions dV (Input)

fuzzy_car_controller = addmf(fuzzy_car_controller,'input',1,'S','trimf', [-0.5 0.08 0.177]);
fuzzy_car_controller = addmf(fuzzy_car_controller,'input',1,'M','trimf', [0.07 0.24 0.85]);
fuzzy_car_controller = addmf(fuzzy_car_controller,'input',1,'L','trimf', [0.73 1 1.5]);

%% Member functions dH (Input)

fuzzy_car_controller = addmf(fuzzy_car_controller,'input',2,'S','trimf', [-0.5 0.08 0.1]);
fuzzy_car_controller = addmf(fuzzy_car_controller,'input',2,'M','trimf', [0.07 0.26 0.85]);
fuzzy_car_controller = addmf(fuzzy_car_controller,'input',2,'L','trimf', [0.73 1 1.5]);

%% Member functions Theta (Input)

fuzzy_car_controller = addmf(fuzzy_car_controller,'input',3,'N','trimf', [-360 -180 -0.2]);
fuzzy_car_controller = addmf(fuzzy_car_controller,'input',3,'ZE','trimf', [-12 0 12]);
fuzzy_car_controller = addmf(fuzzy_car_controller,'input',3,'P','trimf', [0.2 180 360]);

%% Member functions dTheta (Output) 

fuzzy_car_controller = addmf(fuzzy_car_controller,'output',1,'N','trimf',[-130 -45 -0.1]);
fuzzy_car_controller = addmf(fuzzy_car_controller,'output',1,'ZE','trimf', [-45 0 45]);
fuzzy_car_controller = addmf(fuzzy_car_controller,'output',1,'P','trimf', [0.1 45 130]);

%% Rules

%% Theta -> N
rules = [1 1 1 3 1 1;
         1 2 1 3 1 1;
         1 3 1 3 1 1;
         2 1 1 3 1 1;
         2 2 1 3 1 1;
         2 3 1 3 1 1;
         3 1 1 3 1 1;
         3 2 1 3 1 1;
         3 3 1 3 1 1];
     
%% Theta -> ZE
rules = [rules;
         1 1 2 3 1 1;
         1 2 2 3 1 1;
         1 3 2 3 1 1;
         2 1 2 3 1 1;
         2 2 2 2 1 1;
         2 3 2 2 1 1;
         3 1 2 3 1 1;
         3 2 2 1 1 1;
         3 3 2 1 1 1];
     
%% Theta -> P
rules = [rules;
         1 1 3 3 1 1;
         1 2 3 3 1 1;
         1 3 3 3 1 1;
         2 1 3 3 1 1;
         2 2 3 2 1 1;
         2 3 3 1 1 1;
         3 1 3 3 1 1;
         3 2 3 2 1 1;
         3 3 3 1 1 1];
     
fuzzy_car_controller = addrule(fuzzy_car_controller, rules);

end