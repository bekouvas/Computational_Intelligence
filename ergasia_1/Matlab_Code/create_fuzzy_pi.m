function fuzzy_controller = create_fuzzy_pi()

fuzzy_controller = newfis('fis');

%% Inputs
fuzzy_controller = addvar(fuzzy_controller, 'input', 'E', [-1 1]);
fuzzy_controller = addvar(fuzzy_controller, 'input', 'dE', [-1 1]);

%% Output
fuzzy_controller = addvar(fuzzy_controller, 'output', 'dU', [-1 1]);

%% Member functions E (Input)
fuzzy_controller = addmf(fuzzy_controller,'input',1,'NL','trimf', [-3/2 -1 -1/2]);
fuzzy_controller = addmf(fuzzy_controller,'input',1,'NM','trimf', [-7/6 -2/3 -1/6]);
fuzzy_controller = addmf(fuzzy_controller,'input',1,'NS','trimf', [-5/6 -1/3 1/6]);
fuzzy_controller = addmf(fuzzy_controller,'input',1,'ZR','trimf', [-1/2 0 1/2]);
fuzzy_controller = addmf(fuzzy_controller,'input',1,'PS','trimf', [-1/6 1/3 5/6]);
fuzzy_controller = addmf(fuzzy_controller,'input',1,'PM','trimf', [1/6 2/3 7/6]);
fuzzy_controller = addmf(fuzzy_controller,'input',1,'PL','trimf', [1/2 1 3/2]);

%% Member functions dE (Input)
fuzzy_controller = addmf(fuzzy_controller,'input',2,'NL','trimf', [-3/2 -1 -1/2]);
fuzzy_controller = addmf(fuzzy_controller,'input',2,'NM','trimf', [-7/6 -2/3 -1/6]);
fuzzy_controller = addmf(fuzzy_controller,'input',2,'NS','trimf', [-5/6 -1/3 1/6]);
fuzzy_controller = addmf(fuzzy_controller,'input',2,'ZR','trimf', [-1/2 0 1/2]);
fuzzy_controller = addmf(fuzzy_controller,'input',2,'PS','trimf', [-1/6 1/3 5/6]);
fuzzy_controller = addmf(fuzzy_controller,'input',2,'PM','trimf', [1/6 2/3 7/6]);
fuzzy_controller = addmf(fuzzy_controller,'input',2,'PL','trimf', [1/2 1 3/2]);

%% Member functions dU (Output)
fuzzy_controller = addmf(fuzzy_controller,'output',1,'NV','trimf',[-1.25 -1 -0.75]);
fuzzy_controller = addmf(fuzzy_controller,'output',1,'NL','trimf', [-1 -0.75 -0.5]);
fuzzy_controller = addmf(fuzzy_controller,'output',1,'NM','trimf', [-0.75 -0.5 -0.25]);
fuzzy_controller = addmf(fuzzy_controller,'output',1,'NS','trimf', [-0.5 -0.25 0]);
fuzzy_controller = addmf(fuzzy_controller,'output',1,'ZR','trimf', [-0.25 0 0.25]);
fuzzy_controller = addmf(fuzzy_controller,'output',1,'PS','trimf', [0 0.25 0.5]);
fuzzy_controller = addmf(fuzzy_controller,'output',1,'PM','trimf', [0.25 0.5 0.75]);
fuzzy_controller = addmf(fuzzy_controller,'output',1,'PL','trimf', [0.5 0.75 1]);
fuzzy_controller = addmf(fuzzy_controller,'output',1,'PV', 'trimf', [0.75 1 1.25]);

%% Rules
rules = [1 7 5 1 1;
         2 7 6 1 1;
         3 7 7 1 1;
         4 7 8 1 1;
         5 7 9 1 1;
         6 7 9 1 1;
         7 7 9 1 1];
    
rules = [rules;
         1 6 4 1 1;
         2 6 5 1 1;
         3 6 6 1 1;
         4 6 7 1 1;
         5 6 8 1 1;
         6 6 9 1 1;
         7 6 9 1 1];
     
rules = [rules;
         1 5 3 1 1;
         2 5 4 1 1;
         3 5 5 1 1;
         4 5 6 1 1;
         5 5 7 1 1;
         6 5 8 1 1;
         7 5 9 1 1];
     
rules = [rules;
         1 4 2 1 1;
         2 4 3 1 1;
         3 4 4 1 1;
         4 4 5 1 1;
         5 4 6 1 1;
         6 4 7 1 1;
         7 4 8 1 1];

rules = [rules;
         1 3 1 1 1;
         2 3 2 1 1;
         3 3 3 1 1;
         4 3 4 1 1;
         5 3 5 1 1;
         6 3 6 1 1;
         7 3 7 1 1];

rules = [rules;
         1 2 1 1 1;
         2 2 1 1 1;
         3 2 2 1 1;
         4 2 3 1 1;
         5 2 4 1 1;
         6 2 5 1 1;
         7 2 6 1 1];
     
 rules = [rules;
         1 1 1 1 1;
         2 1 1 1 1;
         3 1 1 1 1;
         4 1 2 1 1;
         5 1 3 1 1;
         6 1 4 1 1;
         7 1 5 1 1]; 
     
fuzzy_controller = addrule(fuzzy_controller, rules);

end