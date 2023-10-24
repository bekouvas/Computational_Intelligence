%%
close all; 
clear all;

data = csvread('epileptic_seizure_data.csv',1,1);
norm_data = data(:,1:end-1);
norm_data = normalize(norm_data);
data = [norm_data(:,1:end) data(:,end)];
% mean = mean(data);

% Evaluation function
Rsq = @(ypred,y) 1-sum((ypred-y).^2)/sum((y-mean(y)).^2);

parameters = zeros(4,5,2);
parameters(:,:,1) = [5 5 5 5 5; 7 7 7 7 7; 9 9 9 9 9; 11 11 11 11 11];
parameters(:,:,2) = [0.2 0.4 0.6 0.8 1; 0.2 0.4 0.6 0.8 1; 0.2 0.4 0.6 0.8 1; 0.2 0.4 0.6 0.8 1];

k = 5;

[idx,weights] = relieff(data(:,1:end-1),data(:,end),6);

mf_name = strings(500000,1);
for i = 1:50000
    mf_name(i) = "mf_"+i;
end
counter = 0;
counter2 = 0;

OA_k_fold = zeros(5,1);
rules_k_fold = zeros(5,1);

all_OA = zeros(4,5);
rules = zeros(4,5);
kept_f = zeros(4,5);

for p = 1:4
    for q = 1:5
        
        kept_features = parameters(p,q,1);
        aktina_r = parameters(p,q,2);

        part_for_kfold1 = cvpartition(data(:,end),'KFold',5,'Stratify',true);
        
        metrics_of_cross_val = zeros(k,4);
        
        for repetition = 1:part_for_kfold1.NumTestSets
            
            counter2 = counter2 + 1;
            endiamesa_training_data = data(training(part_for_kfold1,repetition),:);
            testing_data = data(test(part_for_kfold1,repetition),:);

            part_for_kfold2 = cvpartition(endiamesa_training_data(:,end),'KFold',4,'Stratify',true);
            training_data = endiamesa_training_data(training(part_for_kfold2,2),:);
            checking_data = endiamesa_training_data(test(part_for_kfold2,2),:);
            
            training_data = [training_data(:, idx(1:kept_features)) training_data(:,end)];
            checking_data = [checking_data(:, idx(1:kept_features)) checking_data(:,end)];
            testing_data = [testing_data(:, idx(1:kept_features)) testing_data(:,end)];
            
            [c1,sig1]=subclust(training_data(training_data(:,end)==1,:),aktina_r);
            [c2,sig2]=subclust(training_data(training_data(:,end)==2,:),aktina_r);
            [c3,sig3]=subclust(training_data(training_data(:,end)==3,:),aktina_r);
            [c4,sig4]=subclust(training_data(training_data(:,end)==4,:),aktina_r);
            [c5,sig5]=subclust(training_data(training_data(:,end)==5,:),aktina_r);
            num_rules=size(c1,1)+size(c2,1)+size(c3,1)+size(c4,1)+size(c5,1);
            
            my_fis=newfis('FIS_SC','sugeno');
            
            names_in = {};
            for i= 1:size(training_data,2)-1
                names_in{i} = "in" + i;
            end
            
            for i= 1:size(training_data,2)-1
                my_fis = addvar(my_fis,'input',names_in{i},[0 1]);
            end
            my_fis=addvar(my_fis,'output','out1',[0 1]);
            
            for i=1:size(training_data,2)-1
                for j=1:size(c1,1)
                    counter = counter + 1;
                    my_fis=addmf(my_fis,'input',i,mf_name(counter,1),'gaussmf',[sig1(i) c1(j,i)]);
                end
                for j=1:size(c2,1)
                    counter = counter + 1;
                    my_fis=addmf(my_fis,'input',i,mf_name(counter,1),'gaussmf',[sig2(i) c2(j,i)]);
                end
                for j=1:size(c3,1)
                    counter = counter + 1;
                    my_fis=addmf(my_fis,'input',i,mf_name(counter,1),'gaussmf',[sig3(i) c3(j,i)]);
                end
                for j=1:size(c4,1)
                    counter = counter + 1;
                    my_fis=addmf(my_fis,'input',i,mf_name(counter,1),'gaussmf',[sig4(i) c4(j,i)]);
                end
                for j=1:size(c5,1)
                    counter = counter + 1;
                    my_fis=addmf(my_fis,'input',i,mf_name(counter,1),'gaussmf',[sig5(i) c5(j,i)]);
                end
            end
            counter = 0;
            
            params=[zeros(1,size(c1,1)) zeros(1,size(c2,1))+0.25 zeros(1,size(c3,1))+0.5 zeros(1,size(c4,1))+0.75 ones(1,size(c5,1))];
            for i=1:num_rules
                counter = counter + 1;
                my_fis=addmf(my_fis,'output',1,mf_name(counter,1),'constant',params(i));
            end
            counter = 0;
            
            ruleList=zeros(num_rules,size(training_data,2));
            for i=1:size(ruleList,1)
                ruleList(i,:)=i;
            end
            ruleList=[ruleList ones(num_rules,2)];
            my_fis=addrule(my_fis,ruleList);
            
            [trnFis,trnError,~,valFis,valError]=anfis(training_data,my_fis,[100 0 0.01 0.9 1.1],[],checking_data);

            Y=evalfis(testing_data(:,1:end-1),valFis);
            Y=round(Y);

            for i=1:size(Y,1)
                if Y(i) < 1
                    Y(i) = 1;
                elseif Y(i) > 5
                    Y(i) = 5;
                end
            end
            diff=testing_data(:,end)-Y;
            
            
            Error_matrix = zeros(5);
            Error_matrix = confusionmat(testing_data(:,end),Y);
            N = size(testing_data,1);
            OA = sum(diag(Error_matrix))/N;
            OA_k_fold(repetition,1) = OA;
            rules_k_fold(repetition,1) = size(valFis.Rules,2);
            
        end

        all_OA(p,q) = sum(OA_k_fold(:,1))/k;
        kept_f(p,q) = kept_features;
        rules(p,q) = sum(rules_k_fold(:,1))/k;
        
    end
end


%% PLOTS
% OA - Rules
figure();
scatter(reshape(all_OA,1,[]),reshape(rules,1,[])); grid on;
xlabel("OA"); 
ylabel("NR");
title("OA relevant to NR ");

% OA - Features
figure();
scatter(reshape(all_OA,1,[]),reshape(kept_f,1,[])); grid on;
xlabel("OA"); 
ylabel("NF");
title("OA relevant to NF ");

% OA - r
figure();
scatter(reshape(all_OA,1,[]),reshape(parameters(:,:,2),1,[])); grid on;
xlabel("OA"); 
ylabel("Cluster radius");
title("OA relevant to Cluster radius ");

% surface OA - r - features
figure();
surf(all_OA(:,:),parameters(:,:,2),parameters(:,:,1)); grid on;
xlabel("OA"); ylabel("r"); zlabel("NF");
title("OA surface relevant to r and NF.");


