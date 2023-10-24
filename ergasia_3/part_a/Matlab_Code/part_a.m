clear;
clc;

%% Import Data
data = importdata('airfoil_self_noise.dat');
[m, n] = size(data);

%Split data (60% training, 20% validation, 20% test)
[training_data, validation_data, test_data] = split_scale(data,1);

%% Create Models

epochs = 200;

% Model A
model_a = genfis1(training_data, 2, 'gbellmf', 'constant');
% Model B
model_b = genfis1(training_data, 3, 'gbellmf', 'constant');
%Model C
model_c = genfis1(training_data, 2, 'gbellmf', 'linear');
%Model D
model_d = genfis1(training_data, 3, 'gbellmf', 'linear');

%% Train models
[model_a, train_error_a, ~, chkFIS_a, cv_error_a] = anfis(training_data, model_a, epochs, NaN, validation_data);
[model_b, train_error_b, ~, chkFIS_b, cv_error_b] = anfis(training_data, model_b, epochs, NaN, validation_data);
[model_c, train_error_c, ~, chkFIS_c, cv_error_c] = anfis(training_data, model_c, epochs, NaN, validation_data);
[model_d, train_error_d, ~, chkFIS_d, cv_error_d] = anfis(training_data, model_d, epochs, NaN, validation_data);

%% Evaluate models
evaluated_model_a = evalfis(test_data(:,1:end-1), model_a);
evaluated_model_b = evalfis(test_data(:,1:end-1), model_b);
evaluated_model_c = evalfis(test_data(:,1:end-1), model_c);
evaluated_model_d = evalfis(test_data(:,1:end-1), model_d);

%% Plots

%% Membership Functions
membership_functions = figure('Position',[0 0 500 1000]);
for k=1:5
    subplot(5, 1, k);
    plotmf(model_a, 'input', k);
    title('Model A Membership Functions');
    ylabel('Degrees');
end
saveas(membership_functions, 'membership_functions_model_a.png');        
close(membership_functions);

membership_functions = figure('Position',[0 0 500 1000]);
for k=1:5
    subplot(5, 1, k);
    plotmf(model_b, 'input', k);
    title('Model B Membership Functions');
    ylabel('Degrees');
end
saveas(membership_functions, 'membership_functions_model_b.png');        
close(membership_functions);

membership_functions = figure('Position',[0 0 500 1000]);
for k=1:5
    subplot(5, 1, k);
    plotmf(model_c, 'input', k);
    title('Model C Membership Functions');
    ylabel('Degrees');
end
saveas(membership_functions, 'membership_functions_model_c.png');        
close(membership_functions);

membership_functions = figure('Position',[0 0 500 1000]);
for k=1:5
    subplot(5, 1, k);
    plotmf(model_d, 'input', k);
    title('Model D Membership Functions');
    ylabel('Degrees');
end
saveas(membership_functions, 'membership_functions_model_d.png');        
close(membership_functions);

%% Learning Curves
learning_curve = figure;
plot(1:length(train_error_a), [train_error_a, cv_error_a]);
title('Learning Curve Model A');
legend('Training Error', 'Cross Validation Error');
saveas(learning_curve,'learning_curves_model_a.png');
close(learning_curve);

learning_curve = figure;
plot(1:length(train_error_b), [train_error_b, cv_error_b]);
title('Learning Curve Model B');
legend('Training Error', 'Cross Validation Error');
saveas(learning_curve,'learning_curves_model_b.png');
close(learning_curve);

learning_curve = figure;
plot(1:length(train_error_c), [train_error_c, cv_error_c]);
title('Learning Curve Model C');
legend('Training Error', 'Cross Validation Error');
saveas(learning_curve,'learning_curves_model_c.png');
close(learning_curve);

learning_curve = figure;
plot(1:length(train_error_d), [train_error_d, cv_error_d]);
title('Learning Curve Model D');
legend('Training Error', 'Cross Validation Error');
saveas(learning_curve,'learning_curves_model_d.png');
close(learning_curve);

%% Prediction Error & Metrics

prediction_error = figure;
plot(1:length(evaluated_model_a), evaluated_model_a, 'Color', 'b');
hold on;
plot(1:length(evaluated_model_a), test_data(:, end), 'Color', 'r');
title('Predictions Model A');
legend('Predicted Value', 'Real Value');
saveas(prediction_error, 'Predictions_error_model_a.png');
close(prediction_error);

RMSE = 0;
for l=1:size(test_data, 1)
    RMSE = RMSE + ( test_data(l, size(test_data, 2)) - evaluated_model_a(l))^2;
end

RMSE = sqrt(RMSE/size(test_data, 1));
sy2 = std(test_data(:, size(test_data, 2)), 1)^2;
NMSE = (RMSE^2)/sy2;
NDEI = sqrt(NMSE);
SSres = size(data, 1)*(RMSE^2);
SStot = size(data, 1)*sy2;
R2 = 1 - SSres/SStot;
error_txt = [RMSE NMSE NDEI R2];
dlmwrite('metrics_model_a.txt',error_txt);



prediction_error = figure;
plot(1:length(evaluated_model_b), evaluated_model_b, 'Color', 'b');
hold on;
plot(1:length(evaluated_model_b), test_data(:, end), 'Color', 'r');
title('Predictions Model B');
legend('Predicted Value', 'Real Value');
saveas(prediction_error, 'Predictions_error_model_b.png');
close(prediction_error);

RMSE = 0;
for l=1:size(test_data, 1)
    RMSE = RMSE + ( test_data(l, size(test_data, 2)) - evaluated_model_b(l))^2;
end

RMSE = sqrt(RMSE/size(test_data, 1));
sy2 = std(test_data(:, size(test_data, 2)), 1)^2;
NMSE = (RMSE^2)/sy2;
NDEI = sqrt(NMSE);
SSres = size(data, 1)*(RMSE^2);
SStot = size(data, 1)*sy2;
R2 = 1 - SSres/SStot;
error_txt = [RMSE NMSE NDEI R2];
dlmwrite('metrics_model_b.txt',error_txt);



prediction_error = figure;
plot(1:length(evaluated_model_c), evaluated_model_c, 'Color', 'b');
hold on;
plot(1:length(evaluated_model_c), test_data(:, end), 'Color', 'r');
title('Predictions Model C');
legend('Predicted Value', 'Real Value');
saveas(prediction_error, 'Predictions_error_model_c.png');
close(prediction_error);

RMSE = 0;
for l=1:size(test_data, 1)
    RMSE = RMSE + ( test_data(l, size(test_data, 2)) - evaluated_model_c(l))^2;
end

RMSE = sqrt(RMSE/size(test_data, 1));
sy2 = std(test_data(:, size(test_data, 2)), 1)^2;
NMSE = (RMSE^2)/sy2;
NDEI = sqrt(NMSE);
SSres = size(data, 1)*(RMSE^2);
SStot = size(data, 1)*sy2;
R2 = 1 - SSres/SStot;
error_txt = [RMSE NMSE NDEI R2];
dlmwrite('metrics_model_c.txt',error_txt);



prediction_error = figure;
plot(1:length(evaluated_model_d), evaluated_model_d, 'Color', 'b');
hold on;
plot(1:length(evaluated_model_d), test_data(:, end), 'Color', 'r');
title('Predictions Model D');
legend('Predicted Value', 'Real Value');
saveas(prediction_error, 'Predictions_error_model_d.png');
close(prediction_error);

RMSE = 0;
for l=1:size(test_data, 1)
    RMSE = RMSE + ( test_data(l, size(test_data, 2)) - evaluated_model_d(l))^2;
end

RMSE = sqrt(RMSE/size(test_data, 1));
sy2 = std(test_data(:, size(test_data, 2)), 1)^2;
NMSE = (RMSE^2)/sy2;
NDEI = sqrt(NMSE);
SSres = size(data, 1)*(RMSE^2);
SStot = size(data, 1)*sy2;
R2 = 1 - SSres/SStot;
error_txt = [RMSE NMSE NDEI R2];
dlmwrite('metrics_model_d.txt',error_txt);