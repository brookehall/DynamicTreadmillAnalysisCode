clear;clc;

%% Write txt files to .csv files
% data = importdata('AcceleratingHS.txt');
% csvwrite('AcceleratingHS.csv',data.data);
% clear data
% 
% data = importdata('DeceleratingHS.txt');
% csvwrite('DeceleratingHS.csv',data.data);
% clear data
% 
% data = importdata('FastHS.txt');
% csvwrite('FastHS.csv',data.data);
% clear data
% 
% data = importdata('SlowHS.txt');
% csvwrite('SlowHS.csv',data.data);
% clear data

%% Main Code Path
load('C:\Users\hallbl\OneDrive - Kennedy Krieger\Control Study\Updated\Data Files\data_compile.mat')
% load('C:\Users\hallbl\OneDrive - Kennedy Krieger\Control Study\Updated\Data Files\averages_2024Aug7.mat')
load('C:\Users\hallbl\OneDrive - Kennedy Krieger\Control Study\Updated\Data Files\averages.mat')
path = ('C:\Users\hallbl\OneDrive - Kennedy Krieger\Control Study\Updated\Speeds\Brooke\ ');
subjects_w25 = {'MLR001';'MLR002';'MLR003';'MLR004';'MLR005';'MLR006';'MLR007';'MLR008';'MLR009';'MLR010';'MLR011';'MLR012';'MLR013';'MLR014';'MLR015';'MLR016';'MLR017';'MLR020';'MLR021';'MLR022';'MLR023';'MLR024';'MLR025';'MLR026';'MLR027';'MLR028';'MLR029';'MLR030';'MLR031';'MLR032';'MLR033';'MLR037';'MLR038';'MLR040';'MLR041';'MLR043';'MLR044';'MLR045';'MLR046';'MLR047';'MLR048'};
subjects = {'MLR001';'MLR002';'MLR003';'MLR004';'MLR005';'MLR006';'MLR007';'MLR008';'MLR009';'MLR010';'MLR011';'MLR012';'MLR013';'MLR014';'MLR015';'MLR016';'MLR017';'MLR020';'MLR021';'MLR022';'MLR023';'MLR024';'MLR026';'MLR027';'MLR028';'MLR029';'MLR030';'MLR031';'MLR032';'MLR033';'MLR037';'MLR038';'MLR040';'MLR041';'MLR043';'MLR044';'MLR045';'MLR046';'MLR047';'MLR048'};
trials = {'AcceleratingHS';'DeceleratingHS';'FastHS';'SlowHS'};
%% Structure to Store Data

speeds = {}; 

% Load the speed data into speeds struct

for i = 1:length(subjects)
    for j = 1:length(trials)
        speeds.(subjects{i}).(trials{j}).total = load(['C:\Users\hallbl\OneDrive - Kennedy Krieger\Control Study\Updated\Speeds\Brooke\', (subjects{i}), '\', (trials{j}),'.csv']);
    end
end

for rr = 1:length(trials)
    if rr ~= 3
    speeds.MLR025.(trials{rr}).total = load(['C:\Users\hallbl\OneDrive - Kennedy Krieger\Control Study\Updated\Speeds\Brooke\MLR025\', (trials{rr}), '.csv']);
    end
end

%% Break the CSV files down into time, beep, and force

for ii = 1:length(subjects_w25)
    speeds.(subjects_w25{ii}).AcceleratingHS.time = speeds.(subjects_w25{ii}).AcceleratingHS.total(:,1);
    speeds.(subjects_w25{ii}).AcceleratingHS.force = speeds.(subjects_w25{ii}).AcceleratingHS.total(:,8);
    speeds.(subjects_w25{ii}).AcceleratingHS.beep = speeds.(subjects_w25{ii}).AcceleratingHS.total(:,11);
    speeds.(subjects_w25{ii}).DeceleratingHS.time = speeds.(subjects_w25{ii}).DeceleratingHS.total(:,1);
    speeds.(subjects_w25{ii}).DeceleratingHS.force = speeds.(subjects_w25{ii}).DeceleratingHS.total(:,8);
    speeds.(subjects_w25{ii}).DeceleratingHS.beep = speeds.(subjects_w25{ii}).DeceleratingHS.total(:,12);
    speeds.(subjects_w25{ii}).SlowHS.time = speeds.(subjects_w25{ii}).SlowHS.total(:,1);
    speeds.(subjects_w25{ii}).SlowHS.force = speeds.(subjects_w25{ii}).SlowHS.total(:,8);
    speeds.(subjects_w25{ii}).SlowHS.beep = speeds.(subjects_w25{ii}).SlowHS.total(:,13);
end
for ii = 1:length(subjects)
    speeds.(subjects{ii}).FastHS.time = speeds.(subjects{ii}).FastHS.total(:,1);
    speeds.(subjects{ii}).FastHS.force = speeds.(subjects{ii}).FastHS.total(:,8);
    speeds.(subjects{ii}).FastHS.beep = speeds.(subjects{ii}).FastHS.total(:,10);
end
%% Filter the Data
fc = 10;
fs =  1000;
[b,a] = butter(4,100/1000,'low');

for i = 1:length(subjects)
    for j = 1:length(trials)
        force_filter.(subjects{i}).(trials{j}) = filtfilt(b,a,speeds.(subjects{i}).(trials{j}).force);
    end
end

for i = 1:length(trials)
    if i ~= 3
        force_filter.MLR025.(trials{i}) = filtfilt(b,a,speeds.MLR025.(trials{i}).force);
    end
end

%% Find initial heel strikes and toeoffs

for i = 1:length(subjects)
    for r = 1:length(trials)
        for j = 2:length(force_filter.(subjects{i}).(trials{r}))
            if (force_filter.(subjects{i}).(trials{r})(j)) >= 25 && (force_filter.(subjects{i}).(trials{r})(j-1)) < 25 && (force_filter.(subjects{i}).(trials{r})(j+1)) >= 25
                speeds.(subjects{i}).(trials{r}).initial_heel_strikes(j,:) = 1;
            elseif (force_filter.(subjects{i}).(trials{r})(j)) < 25 && (force_filter.(subjects{i}).(trials{r})(j-1)) >= 25 && (force_filter.(subjects{i}).(trials{r})(j+1)) < 25
                speeds.(subjects{i}).(trials{r}).initial_toe_offs(j,:) = 1;
            end
        end
    end
end

for r = 1:length(trials)
    if r ~= 3
        for j = 2:length(force_filter.MLR025.(trials{r}))
            if (force_filter.MLR025.(trials{r})(j)) >= 25 && (force_filter.MLR025.(trials{r})(j-1)) < 25 && (force_filter.MLR025.(trials{r})(j+1)) >= 25
                speeds.MLR025.(trials{r}).initial_heel_strikes(j,:) = 1;
            elseif (force_filter.MLR025.(trials{r})(j)) < 25 && (force_filter.MLR025.(trials{r})(j-1)) >= 25 && (force_filter.MLR025.(trials{r})(j+1)) < 25
                speeds.MLR025.(trials{r}).initial_toe_offs(j,:) = 1;
            end
        end
    end
end

%% Find the beeps

for i = 1:length(subjects)
    for j = 1:length(trials)
        for r = 1:length(speeds.(subjects{i}).(trials{j}).beep)
            if (speeds.(subjects{i}).(trials{j}).beep(r)) == 1 
                speeds.(subjects{i}).(trials{j}).beep_on(r,:) = 1;
            elseif (speeds.(subjects{i}).(trials{j}).beep(r)) == 0
                speeds.(subjects{i}).(trials{j}).beep_off(r,:) = 1;
            end
        end
    end
end

for j = 1:length(trials)
    if j ~= 3
        for r = 1:length(speeds.MLR025.(trials{j}).beep)
            if (speeds.MLR025.(trials{j}).beep(r)) == 1
                speeds.MLR025.(trials{j}).beep_on(r,:) = 1;
            elseif (speeds.MLR025.(trials{j}).beep(r)) == 0
                speeds.MLR025.(trials{j}).beep_off(r,:) = 1;
            end
        end
    end
end

%% Put the beeps and the initial heel strikes into one array

for i = 1:length(subjects)
    for j = 1:length(trials)
        speeds.(subjects{i}).(trials{j}).initial_heel_strikes = resize(speeds.(subjects{i}).(trials{j}).initial_heel_strikes,length(speeds.(subjects{i}).(trials{j}).beep_on));
        speeds.(subjects{i}).(trials{j}).heelstrike_beep = [speeds.(subjects{i}).(trials{j}).beep_on,speeds.(subjects{i}).(trials{j}).initial_heel_strikes];
    end
end

for j = 1:length(trials)
    if j ~= 3
        speeds.MLR025.(trials{j}).initial_heel_strikes = resize(speeds.MLR025.(trials{j}).initial_heel_strikes,length(speeds.MLR025.(trials{j}).beep_on));
        speeds.MLR025.(trials{j}).heelstrike_beep = [speeds.MLR025.(trials{j}).beep_on,speeds.MLR025.(trials{j}).initial_heel_strikes];
    end
end

%% Find the sum across rows to get an accuracy proxy

for i = 1:length(subjects)
    for j = 1:length(trials)
        for r = 1:length(speeds.(subjects{i}).(trials{j}).heelstrike_beep)
            speeds.(subjects{i}).(trials{j}).sum(r,:) = sum(speeds.(subjects{i}).(trials{j}).heelstrike_beep(r,:));
        end
    end
end

for j = 1:length(trials)
    if j ~= 3
        for r = 1:length(speeds.MLR025.(trials{j}).heelstrike_beep)
            speeds.MLR025.(trials{j}).sum(r,:) = sum(speeds.MLR025.(trials{j}).heelstrike_beep(r,:));
        end
    end
end

%% Find number of 2's in the heelstrike_beep factors and find the number of 1's in the initial_heel_strikes factors

for i = 1:length(subjects)
    for j = 1:length(trials)
        speeds.(subjects{i}).(trials{j}).total_strides = find(speeds.(subjects{i}).(trials{j}).initial_heel_strikes == 1);
        speeds.(subjects{i}).(trials{j}).success = find(speeds.(subjects{i}).(trials{j}).sum == 2);
    end
end

for j = 1:length(trials)
    if j ~= 3
        speeds.MLR025.(trials{j}).total_strides = find(speeds.MLR025.(trials{j}).initial_heel_strikes == 1);
        speeds.MLR025.(trials{j}).success = find(speeds.MLR025.(trials{j}).sum == 2);
    end
end

%% Success Rate

for i = 1:length(subjects)
    for j = 1:length(trials)
        speeds.(subjects{i}).(trials{j}).success_rate = length(speeds.(subjects{i}).(trials{j}).success) ./ length(speeds.(subjects{i}).(trials{j}).total_strides);
    end
end

for j = 1:length(trials)
    if j ~= 3
        speeds.MLR025.(trials{j}).success_rate = length(speeds.MLR025.(trials{j}).success) ./ length(speeds.MLR025.(trials{j}).total_strides);
    end
end
%% Put together a success rate table

for i = 1:length(subjects)
    for j = 1:length(trials)
        success_table{i,j} = speeds.(subjects{i}).(trials{j}).success_rate;
    end
end

for j = 1:length(trials)
    if j ~= 3
        success_table{31,j} = speeds.MLR025.(trials{j}).success_rate;
    end
end

success_table = [subjects,success_table];
headers = {'Subjects', 'AcceleratingHS', 'DeceleratingHS','FastHS', 'SlowHS'};
success_table = cell2table(success_table,'VariableNames',headers);
% writetable(success_table, 'success_table.csv');

%% Pull out both treadmill belt speeds

for ii = 1:length(subjects_w25)
    speeds.(subjects_w25{ii}).AcceleratingHS.belt_speedl = speeds.(subjects_w25{ii}).AcceleratingHS.total(:,2);
    speeds.(subjects_w25{ii}).AcceleratingHS.belt_speedr = speeds.(subjects_w25{ii}).AcceleratingHS.total(:,3);
    speeds.(subjects_w25{ii}).DeceleratingHS.belt_speedl = speeds.(subjects_w25{ii}).DeceleratingHS.total(:,2);
    speeds.(subjects_w25{ii}).DeceleratingHS.belt_speedr = speeds.(subjects_w25{ii}).DeceleratingHS.total(:,3);
    speeds.(subjects_w25{ii}).SlowHS.belt_speedl = speeds.(subjects_w25{ii}).SlowHS.total(:,2);
    speeds.(subjects_w25{ii}).SlowHS.belt_speedr = speeds.(subjects_w25{ii}).SlowHS.total(:,3);
end
for ii = 1:length(subjects)
    speeds.(subjects{ii}).FastHS.belt_speedl = speeds.(subjects{ii}).FastHS.total(:,2);
    speeds.(subjects{ii}).FastHS.belt_speedr = speeds.(subjects{ii}).FastHS.total(:,3);
end

%% Find the average speed across both belts for each frame

for i = 1:length(subjects)
    for j = 1:length(trials)
        for r = 1:length(speeds.(subjects{i}).(trials{j}).belt_speedl)
            speeds.(subjects{i}).(trials{j}).belt_speed(r,:) = ((speeds.(subjects{i}).(trials{j}).belt_speedl(r,:)) + (speeds.(subjects{i}).(trials{j}).belt_speedr(r,:)))./2;
        end
    end
end

for j = 1:length(trials)
    if j ~= 3
        for r = 1:length(speeds.MLR025.(trials{j}).belt_speedl)
            speeds.MLR025.(trials{j}).belt_speed(r,:) = ((speeds.MLR025.(trials{j}).belt_speedl(r,:)) + (speeds.MLR025.(trials{j}).belt_speedr(r,:)))./2;
        end
    end
end

%% Separate the participants into groups based on speed ratio

group_one = {'MLR003','MLR013','MLR016','MLR017','MLR024','MLR005','MLR009','MLR028','MLR032','MLR025'};

%% Group heelstrikes and belt speed arrays together

for i = 1:length(subjects)
    for j = 1:length(trials)
        speeds.(subjects{i}).(trials{j}).initial_heel_strikes = resize(speeds.(subjects{i}).(trials{j}).initial_heel_strikes,length(speeds.(subjects{i}).(trials{j}).belt_speed));
        speeds.(subjects{i}).(trials{j}).sum = resize(speeds.(subjects{i}).(trials{j}).sum,length(speeds.(subjects{i}).(trials{j}).belt_speed));
        speeds.(subjects{i}).(trials{j}).beltspeed_success = [speeds.(subjects{i}).(trials{j}).belt_speed,speeds.(subjects{i}).(trials{j}).sum];
        speeds.(subjects{i}).(trials{j}).beltspeed_heelstrikes = [speeds.(subjects{i}).(trials{j}).belt_speed,speeds.(subjects{i}).(trials{j}).initial_heel_strikes];
    end
end

for j = 1:length(trials)
    if j ~= 3
        speeds.MLR025.(trials{j}).initial_heel_strikes = resize(speeds.MLR025.(trials{j}).initial_heel_strikes,length(speeds.MLR025.(trials{j}).belt_speed));
        speeds.MLR025.(trials{j}).sum = resize(speeds.MLR025.(trials{j}).sum,length(speeds.MLR025.(trials{j}).belt_speed));
        speeds.MLR025.(trials{j}).beltspeed_success = [speeds.MLR025.(trials{j}).belt_speed,speeds.MLR025.(trials{j}).sum];
        speeds.MLR025.(trials{j}).beltspeed_heelstrikes = [speeds.MLR025.(trials{j}).belt_speed,speeds.MLR025.(trials{j}).initial_heel_strikes];
    end
end

%% Find what speed the treadmill is going at each successful heelstrike

for i = 1:length(subjects)
    for r = 1:length(trials)
        for j = 2:length(speeds.(subjects{i}).(trials{r}).beltspeed_success)
            if (speeds.(subjects{i}).(trials{r}).beltspeed_heelstrikes(j,2)) == 1
                speeds.(subjects{i}).(trials{r}).speed_heelstrikes(j,:) = speeds.(subjects{i}).(trials{r}).beltspeed_heelstrikes(j,1);
            else
            end
        end
    end
end

for r = 1:length(trials)
    if r ~= 3
        for j = 2:length(speeds.MLR025.(trials{r}).beltspeed_success)
            if (speeds.MLR025.(trials{r}).beltspeed_heelstrikes(j,2)) == 1
                speeds.MLR025.(trials{r}).speed_heelstrikes(j,:) = speeds.MLR025.(trials{r}).beltspeed_heelstrikes(j,1);
            else
            end
        end
    end
end

for i = 1:length(subjects)
    for r = 1:length(trials)
        [row,col,HSspeed.(subjects{i}).(trials{r})] = find(speeds.(subjects{i}).(trials{r}).speed_heelstrikes(:,1));
    end
end

for r = 1:length(trials)
    if r ~= 3
        [row,col,HSspeed.MLR025.(trials{r})] = find(speeds.MLR025.(trials{r}).speed_heelstrikes(:,1));
    end
end
%% Breaking the speeds into gait cycle chunks within each participant

for i = 1:length(subjects)
    for r = 1:length(trials)
        heel_strikes.(subjects{i}).(trials{r}) = find(speeds.(subjects{i}).(trials{r}).initial_heel_strikes);
    end
end

for r = 1:length(trials)
    if r ~=3
        heel_strikes.MLR025.(trials{r}) = find(speeds.MLR025.(trials{r}).initial_heel_strikes);
    end
end

for i = 1:length(subjects)
    for r = 1:length(trials)
        for j = 1:length(heel_strikes.(subjects{i}).(trials{r}))-1
            gait_cycles.(subjects{i}).(trials{r}).cycles{j} = num2cell(speeds.(subjects{i}).(trials{r}).belt_speed(heel_strikes.(subjects{i}).(trials{r})(j):heel_strikes.(subjects{i}).(trials{r})(j+1)-1));
        end
    end
end

for r = 1:length(trials)
    if r ~= 3
        for j = 1:length(heel_strikes.MLR025.(trials{r}))-1
            gait_cycles.MLR025.(trials{r}).cycles{j} = num2cell(speeds.MLR025.(trials{r}).belt_speed(heel_strikes.MLR025.(trials{r})(j):heel_strikes.MLR025.(trials{r})(j+1)-1));
        end
    end
end

%% Normalize each gait cycle within each participant

% Change the individual cycles from cells to doubles

for i = 1:length(subjects)
    for r = 1:length(trials)
        for j = 1:length(gait_cycles.(subjects{i}).(trials{r}).cycles)
           gait_cycles.normalized.(subjects{i}).(trials{r}).structured{j} =  cell2mat(gait_cycles.(subjects{i}).(trials{r}).cycles{1,j});
        end
    end
end

for i = 1:length(subjects)
    for r = 1:length(trials)
        for j = 1:length(gait_cycles.normalized.(subjects{i}).(trials{r}).structured)
            gait_cycles.(subjects{i}).(trials{r}).normalized{j} = normalise(gait_cycles.normalized.(subjects{i}).(trials{r}).structured{j});
        end
    end
end

for r = 1:length(trials)
    if r ~= 3
        for j = 1:length(gait_cycles.MLR025.(trials{r}).cycles)
            gait_cycles.normalized.MLR025.(trials{r}).structured{j} =  cell2mat(gait_cycles.MLR025.(trials{r}).cycles{1,j});
        end
    end
end

for r = 1:length(trials)
    if r ~= 3
        for j = 1:length(gait_cycles.normalized.MLR025.(trials{r}).structured)
            gait_cycles.MLR025.(trials{r}).normalized{j} = normalise(gait_cycles.normalized.MLR025.(trials{r}).structured{j});
        end
    end
end
%% Average across all the individual gait cycles to get one gait cycle average per participant

% create a table of all the individual gait cycles within a trial

for i = 1:length(subjects)
    for r = 1:length(trials)
        for j = 1:length(gait_cycles.(subjects{i}).(trials{r}).normalized)
            gait_cycles.(subjects{i}).(trials{r}).combined(j,:) = gait_cycles.(subjects{i}).(trials{r}).normalized{1,j};
        end
    end
end

for r = 1:length(trials)
    if r ~= 3
        for j = 1:length(gait_cycles.MLR025.(trials{r}).normalized)
            gait_cycles.MLR025.(trials{r}).combined(j,:) = gait_cycles.MLR025.(trials{r}).normalized{1,j};
        end
    end
end
% average across each entry to get 101 data points for each trial

for i = 1:length(subjects)
    for r = 1:length(trials)
        for j = 1:101
            gait_cycles.(subjects{i}).(trials{r}).averages(j,:) = mean(nonzeros(gait_cycles.(subjects{i}).(trials{r}).combined(:,j)));
        end
    end
end

for r = 1:length(trials)
    if r ~= 3
        for j = 1:101
            gait_cycles.MLR025.(trials{r}).averages(j,:) = mean(nonzeros(gait_cycles.MLR025.(trials{r}).combined(:,j)));
        end
    end
end
%% Find group average and SEM

group_one_wo25 = {'MLR003','MLR013','MLR016','MLR017','MLR024','MLR005','MLR009','MLR028','MLR032'};

% group each ratio condition together
for i = 1:length(group_one)
    for r = 1:length(trials)
        if r ~=3
            gait_cycles.group_averages.(trials{r}).group_one.table(:,i) = gait_cycles.(group_one{i}).(trials{r}).averages;
        end
    end
end

for i = 1:length(group_one_wo25)
        gait_cycles.group_averages.FastHS.group_one.table(:,4) = gait_cycles.(group_one_wo25{i}).FastHS.averages;
end

for r = 1:length(trials)
    for i = 1:length(gait_cycles.group_averages.(trials{r}).group_one.table)
        gait_cycles.group_averages.(trials{r}).group_one.average(:,i) = mean(nonzeros(gait_cycles.group_averages.(trials{r}).group_one.table(i,:)));
        gait_cycles.group_averages.(trials{r}).group_one.sem(:,i) = std(nonzeros(gait_cycles.group_averages.(trials{r}).group_one.table(i,:)))/sqrt(9);
    end
end

%% Struct Location and Place for the Last 30 Gait Cycles

for i = 1:length(subjects)
    for r = 1:length(trials)
        for j = 1:length(gait_cycles.(subjects{i}).(trials{r}).normalized)
            gait_cycles.(subjects{i}).(trials{r}).last30 = gait_cycles.(subjects{i}).(trials{r}).normalized(1,(length(gait_cycles.(subjects{i}).(trials{r}).normalized)-29):end);
        end
    end
end

for r = 1:length(trials)
    if r ~= 3
        for j = 1:length(gait_cycles.MLR025.(trials{r}).normalized)
            gait_cycles.MLR025.(trials{r}).last30 = gait_cycles.MLR025.(trials{r}).normalized(1,(length(gait_cycles.MLR025.(trials{r}).normalized)-29):end);
        end
    end
end

%% Put the last 30 gait cycles into a table to average 

for i = 1:length(subjects)
    for r = 1:length(trials)
        for j = 1:length(gait_cycles.(subjects{i}).(trials{r}).last30)
            gait_cycles.(subjects{i}).(trials{r}).last30_table(j,:) = gait_cycles.(subjects{i}).(trials{r}).last30{1,j};
        end
    end
end

for r = 1:length(trials)
    if r ~= 3
        for j = 1:length(gait_cycles.MLR025.(trials{r}).last30)
            gait_cycles.MLR025.(trials{r}).last30_table(j,:) = gait_cycles.MLR025.(trials{r}).last30{1,j};
        end
    end
end

%% Find the individual averages down the columns 

for i = 1:length(subjects)
    for r = 1:length(trials)
        for j = 1:101
            gait_cycles.(subjects{i}).(trials{r}).last30_averages(j,:) = mean(nonzeros(gait_cycles.(subjects{i}).(trials{r}).last30_table(:,j)));
        end
    end
end

for r = 1:length(trials)
    if r ~= 3
        for j = 1:101
            gait_cycles.MLR025.(trials{r}).last30_averages(j,:) = mean(nonzeros(gait_cycles.MLR025.(trials{r}).last30_table(:,j)));
        end
    end
end
%% Find group average and SEM

% group each ratio condition together
for i = 1:length(group_one)
    for r = 1:length(group_one_wo25)
        gait_cycles.group_averages.AcceleratingHS.group_one.last30_table(:,i) = gait_cycles.(group_one{i}).AcceleratingHS.last30_averages;
        gait_cycles.group_averages.DeceleratingHS.group_one.last30_table(:,i) = gait_cycles.(group_one{i}).DeceleratingHS.last30_averages;
        gait_cycles.group_averages.FastHS.group_one.last30_table(:,r) = gait_cycles.(group_one_wo25{r}).FastHS.last30_averages;
        gait_cycles.group_averages.SlowHS.group_one.last30_table(:,i) = gait_cycles.(group_one{i}).SlowHS.last30_averages;
    end
end

for r = 1:length(trials)
    for i = 1:length(gait_cycles.group_averages.(trials{r}).group_one.table)
        gait_cycles.group_averages.(trials{r}).group_one.last30_average(:,i) = mean(nonzeros(gait_cycles.group_averages.(trials{r}).group_one.last30_table(i,:)));
        gait_cycles.group_averages.(trials{r}).group_one.last30_sem(:,i) = std(nonzeros(gait_cycles.group_averages.(trials{r}).group_one.last30_table(i,:)))/sqrt(9);
    end
end

%% Struct Location and Place for the first 30 Gait Cycles

for i = 1:length(subjects)
    for r = 1:length(trials)
        for j = 1:length(gait_cycles.(subjects{i}).(trials{r}).normalized)
            gait_cycles.(subjects{i}).(trials{r}).first30 = gait_cycles.(subjects{i}).(trials{r}).normalized(1, 1:30);
        end
    end
end

for r = 1:length(trials)
    if r ~= 3
        for j = 1:length(gait_cycles.MLR025.(trials{r}).normalized)
            gait_cycles.MLR025.(trials{r}).first30 = gait_cycles.MLR025.(trials{r}).normalized(1,(1:30));
        end
    end
end

%% Put the first 30 gait cycles into a table to average 

for i = 1:length(subjects)
    for r = 1:length(trials)
        for j = 1:length(gait_cycles.(subjects{i}).(trials{r}).first30)
            gait_cycles.(subjects{i}).(trials{r}).first30_table(j,:) = gait_cycles.(subjects{i}).(trials{r}).first30{1,j};
        end
    end
end

for r = 1:length(trials)
    if r ~= 3
        for j = 1:length(gait_cycles.MLR025.(trials{r}).first30)
            gait_cycles.MLR025.(trials{r}).first30_table(j,:) = gait_cycles.MLR025.(trials{r}).first30{1,j};
        end
    end
end

%% Find the individual averages down the columns 

for i = 1:length(subjects)
    for r = 1:length(trials)
        for j = 1:101
            gait_cycles.(subjects{i}).(trials{r}).first30_averages(j,:) = mean(nonzeros(gait_cycles.(subjects{i}).(trials{r}).first30_table(:,j)));
        end
    end
end

for r = 1:length(trials)
    if r ~= 3
        for j = 1:101
            gait_cycles.MLR025.(trials{r}).first30_averages(j,:) = mean(nonzeros(gait_cycles.MLR025.(trials{r}).first30_table(:,j)));
        end
    end
end
%% Find group average and SEM

% group each ratio condition together
for i = 1:length(group_one)
    for r = 1:length(group_one_wo25)
        gait_cycles.group_averages.AcceleratingHS.group_one.first30_table(:,i) = gait_cycles.(group_one{i}).AcceleratingHS.first30_averages;
        gait_cycles.group_averages.DeceleratingHS.group_one.first30_table(:,i) = gait_cycles.(group_one{i}).DeceleratingHS.first30_averages;
        gait_cycles.group_averages.FastHS.group_one.first30_table(:,r) = gait_cycles.(group_one_wo25{r}).FastHS.first30_averages;
        gait_cycles.group_averages.SlowHS.group_one.first30_table(:,i) = gait_cycles.(group_one{i}).SlowHS.first30_averages;
    end
end

for r = 1:length(trials)
    for i = 1:length(gait_cycles.group_averages.(trials{r}).group_one.table)
        gait_cycles.group_averages.(trials{r}).group_one.first30_average(:,i) = mean(nonzeros(gait_cycles.group_averages.(trials{r}).group_one.first30_table(i,:)));
        gait_cycles.group_averages.(trials{r}).group_one.first30_sem(:,i) = std(nonzeros(gait_cycles.group_averages.(trials{r}).group_one.first30_table(i,:)))/sqrt(9);
    end
end

%% Calculate all speed events

%% pull kinematic events in
path = ('C:\Users\hallbl\OneDrive - Kennedy Krieger\Control Study\Updated\ ');
subjects_w25 = {'MLR001';'MLR002';'MLR003';'MLR004';'MLR005';'MLR006';'MLR007';'MLR008';'MLR009';'MLR010';'MLR011';'MLR012';'MLR013';'MLR014';'MLR015';'MLR016';'MLR017';'MLR020';'MLR021';'MLR022';'MLR023';'MLR024';'MLR026';'MLR027';'MLR028';'MLR029';'MLR030';'MLR031';'MLR032';'MLR033';'MLR025'};
% subjects = {'MLR001','MLR002','MLR003','MLR004','MLR005','MLR006','MLR007','MLR008','MLR009','MLR010','MLR011','MLR012','MLR013','MLR014','MLR015','MLR016','MLR017','MLR020','MLR021','MLR022','MLR023','MLR024','MLR025','MLR027','MLR028','MLR029','MLR030','MLR031','MLR032','MLR033','MLR037', 'MLR038','MLR040','MLR041','MLR043','MLR045','MLR046','MLR047','MLR048'};
all_trials = {'Baseline_slow';'Baseline_intermediate';'Baseline_fast';'AcceleratingHS';'DeceleratingHS';'FastHS';'SlowHS'};
trials = {'Baseline_intermediate';'AcceleratingHS';'DeceleratingHS';'FastHS';'SlowHS'};
group_one = {'MLR003','MLR013','MLR016','MLR017','MLR024','MLR005','MLR009','MLR028','MLR032','MLR025'};

% group one
for i = 1:length(group_one)
    for r = 1:length(trials)
        events.(group_one{i}).(trials{r}).file = load(['C:\Users\hallbl\OneDrive - Kennedy Krieger\Control Study\Updated\', (group_one{i}), '\New Session\', (trials{r}), '_kinematics_events.mat']);
    end
end

%% Building structs for each event type

% group one
for i = 1:length(group_one)
    for r = 1:length(trials)
        RHS.(group_one{i}).(trials{r}).raw = events.(group_one{i}).(trials{r}).file.events.rhs;
        RTO.(group_one{i}).(trials{r}).raw = events.(group_one{i}).(trials{r}).file.events.rto;
        LHS.(group_one{i}).(trials{r}).raw = events.(group_one{i}).(trials{r}).file.events.lhs;
        LTO.(group_one{i}).(trials{r}).raw = events.(group_one{i}).(trials{r}).file.events.lto;
    end
end

%% Find the distance between RHS and RTO

% group one
for i = 1:length(group_one)
    for r = 1:length(trials)
        RTO.(group_one{i}).(trials{r}).raw = resize(RTO.(group_one{i}).(trials{r}).raw,length(RHS.(group_one{i}).(trials{r}).raw));
        LHS.(group_one{i}).(trials{r}).raw = resize(LHS.(group_one{i}).(trials{r}).raw,length(RHS.(group_one{i}).(trials{r}).raw));
        LTO.(group_one{i}).(trials{r}).raw = resize(LTO.(group_one{i}).(trials{r}).raw,length(RHS.(group_one{i}).(trials{r}).raw));
    end
end

% group one
for i = 1:length(group_one)
    events.(group_one{i}).Baseline_intermediate.combined(:,1) = RHS.(group_one{i}).Baseline_intermediate.raw;
    events.(group_one{i}).Baseline_intermediate.combined(:,2) = RTO.(group_one{i}).Baseline_intermediate.raw;
    events.(group_one{i}).Baseline_intermediate.combined(:,3) = LHS.(group_one{i}).Baseline_intermediate.raw;
    events.(group_one{i}).Baseline_intermediate.combined(:,4) = LTO.(group_one{i}).Baseline_intermediate.raw;

    events.(group_one{i}).AcceleratingHS.combined(:,1) = RHS.(group_one{i}).AcceleratingHS.raw;
    events.(group_one{i}).AcceleratingHS.combined(:,2) = RTO.(group_one{i}).AcceleratingHS.raw;
    events.(group_one{i}).AcceleratingHS.combined(:,3) = LHS.(group_one{i}).AcceleratingHS.raw;
    events.(group_one{i}).AcceleratingHS.combined(:,4) = LTO.(group_one{i}).AcceleratingHS.raw;

    events.(group_one{i}).DeceleratingHS.combined(:,1) = RHS.(group_one{i}).DeceleratingHS.raw;
    events.(group_one{i}).DeceleratingHS.combined(:,2) = RTO.(group_one{i}).DeceleratingHS.raw;
    events.(group_one{i}).DeceleratingHS.combined(:,3) = LHS.(group_one{i}).DeceleratingHS.raw;
    events.(group_one{i}).DeceleratingHS.combined(:,4) = LTO.(group_one{i}).DeceleratingHS.raw;

    events.(group_one{i}).FastHS.combined(:,1) = RHS.(group_one{i}).FastHS.raw;
    events.(group_one{i}).FastHS.combined(:,2) = RTO.(group_one{i}).FastHS.raw;
    events.(group_one{i}).FastHS.combined(:,3) = LHS.(group_one{i}).FastHS.raw;
    events.(group_one{i}).FastHS.combined(:,4) = LTO.(group_one{i}).FastHS.raw;

    events.(group_one{i}).SlowHS.combined(:,1) = RHS.(group_one{i}).SlowHS.raw;
    events.(group_one{i}).SlowHS.combined(:,2) = RTO.(group_one{i}).SlowHS.raw;
    events.(group_one{i}).SlowHS.combined(:,3) = LHS.(group_one{i}).SlowHS.raw;
    events.(group_one{i}).SlowHS.combined(:,4) = LTO.(group_one{i}).SlowHS.raw;
end

%% edit the events

%% group one

trials = {'Baseline_intermediate';'AcceleratingHS';'DeceleratingHS';'FastHS';'SlowHS'};

for i = 1:length(group_one)
    for r = 1:length(trials)
        if ((events.(group_one{i}).(trials{r}).combined(1,1)) < (events.(group_one{i}).(trials{r}).combined(1,4))) && ((events.(group_one{i}).(trials{r}).combined(1,1)) < (events.(group_one{i}).(trials{r}).combined(1,3)))
            events.(group_one{i}).(trials{r}).edited = events.(group_one{i}).(trials{r}).combined;
        else
            events.(group_one{i}).(trials{r}).edited(:,1) =  events.(group_one{i}).(trials{r}).combined(1:end-1,1);
            events.(group_one{i}).(trials{r}).edited(:,4) =  events.(group_one{i}).(trials{r}).combined(1:end-1,4);

            events.(group_one{i}).(trials{r}).edited(:,2) =  events.(group_one{i}).(trials{r}).combined(2:end,2);
            events.(group_one{i}).(trials{r}).edited(:,3) =  events.(group_one{i}).(trials{r}).combined(2:end,3);
        end
    end
end

for i = 1:length(group_one)
    for r = 1:length(trials)
        for j = 1:length(events.(group_one{i}).(trials{r}).edited)
            distance.RHS_RTO.(group_one{i}).(trials{r})(j,1) = abs(events.(group_one{i}).(trials{r}).edited(j,1) - events.(group_one{i}).(trials{r}).edited(j,2));
            distance.RHS_LHS.(group_one{i}).(trials{r})(j,1) = abs(events.(group_one{i}).(trials{r}).edited(j,1) - events.(group_one{i}).(trials{r}).edited(j,3));
            distance.RHS_LTO.(group_one{i}).(trials{r})(j,1) = abs(events.(group_one{i}).(trials{r}).edited(j,1) - events.(group_one{i}).(trials{r}).edited(j,4));

            distance.LHS_RTO.(group_one{i}).(trials{r})(j,1) = abs(events.(group_one{i}).(trials{r}).edited(j,2) - events.(group_one{i}).(trials{r}).edited(j,3));
            distance.LHS_LHS.(group_one{i}).(trials{r})(j,1) = abs(events.(group_one{i}).(trials{r}).edited(j,2) - events.(group_one{i}).(trials{r}).edited(j,2));
            distance.LHS_LTO.(group_one{i}).(trials{r})(j,1) = abs(events.(group_one{i}).(trials{r}).edited(j,2) - events.(group_one{i}).(trials{r}).edited(j,4));
        end
        for j = 1:length(events.(group_one{i}).(trials{r}).edited) - 1
            distance.RHS_RHS.(group_one{i}).(trials{r})(j,1) = abs(events.(group_one{i}).(trials{r}).edited(j,1) - events.(group_one{i}).(trials{r}).edited(j+1,1));
            distance.LHS_LHS.(group_one{i}).(trials{r})(j,1) = abs(events.(group_one{i}).(trials{r}).edited(j,2) - events.(group_one{i}).(trials{r}).edited(j+1,2));
        end
    end
end

for i = 1:length(group_one)
    for r = 1:length(trials)
        for k = 1:length(distance.RHS_RTO.(group_one{i}).(trials{r})) - 1
            percentage.RHS_RTO.(group_one{i}).(trials{r})(k,1) = (distance.RHS_RTO.(group_one{i}).(trials{r})(k,1)/distance.RHS_RHS.(group_one{i}).(trials{r})(k,1))*100;
            percentage.RHS_LHS.(group_one{i}).(trials{r})(k,1) = (distance.RHS_LHS.(group_one{i}).(trials{r})(k,1)/distance.RHS_RHS.(group_one{i}).(trials{r})(k,1))*100;
            percentage.RHS_LTO.(group_one{i}).(trials{r})(k,1) = (distance.RHS_LTO.(group_one{i}).(trials{r})(k,1)/distance.RHS_RHS.(group_one{i}).(trials{r})(k,1))*100;
            
            percentage.LHS_RTO.(group_one{i}).(trials{r})(k,1) = (distance.LHS_RTO.(group_one{i}).(trials{r})(k,1)/distance.LHS_LHS.(group_one{i}).(trials{r})(k,1))*100;
            percentage.LHS_LHS.(group_one{i}).(trials{r})(k,1) = (distance.LHS_LHS.(group_one{i}).(trials{r})(k,1)/distance.LHS_LHS.(group_one{i}).(trials{r})(k,1))*100;
            percentage.LHS_LTO.(group_one{i}).(trials{r})(k,1) = (distance.LHS_LTO.(group_one{i}).(trials{r})(k,1)/distance.LHS_LHS.(group_one{i}).(trials{r})(k,1))*100;
        end
    end
end

for i = 1:length(group_one)
    for r = 1:length(trials)
        percentage.RHS_RTO.averages.(group_one{i}).(trials{r}) = mean(nonzeros(percentage.RHS_RTO.(group_one{i}).(trials{r})(:,1)));
        percentage.RHS_LHS.averages.(group_one{i}).(trials{r}) = mean(nonzeros(percentage.RHS_LHS.(group_one{i}).(trials{r})(:,1)));
        percentage.RHS_LTO.averages.(group_one{i}).(trials{r}) = mean(nonzeros(percentage.RHS_LTO.(group_one{i}).(trials{r})(:,1)));
        
        percentage.LHS_RTO.averages.(group_one{i}).(trials{r}) = mean(nonzeros(percentage.LHS_RTO.(group_one{i}).(trials{r})(:,1)));
        percentage.LHS_LHS.averages.(group_one{i}).(trials{r}) = mean(nonzeros(percentage.LHS_LHS.(group_one{i}).(trials{r})(:,1)));
        percentage.LHS_LTO.averages.(group_one{i}).(trials{r}) = mean(nonzeros(percentage.LHS_LTO.(group_one{i}).(trials{r})(:,1)));
    end
end

for i = 1:length(group_one)
    for r = 1:length(trials)
        percentage.RHS_RTO.l30_averages.(group_one{i}).(trials{r}) = mean(nonzeros(percentage.RHS_RTO.(group_one{i}).(trials{r})(end-29:end,1)));
        percentage.RHS_LHS.l30_averages.(group_one{i}).(trials{r}) = mean(nonzeros(percentage.RHS_LHS.(group_one{i}).(trials{r})(end-29:end,1)));
        percentage.RHS_LTO.l30_averages.(group_one{i}).(trials{r}) = mean(nonzeros(percentage.RHS_LTO.(group_one{i}).(trials{r})(end-29:end,1)));

        percentage.RHS_RTO.f30_averages.(group_one{i}).(trials{r}) = mean(nonzeros(percentage.RHS_RTO.(group_one{i}).(trials{r})(1:30,1)));
        percentage.RHS_LHS.f30_averages.(group_one{i}).(trials{r}) = mean(nonzeros(percentage.RHS_LHS.(group_one{i}).(trials{r})(1:30,1)));
        percentage.RHS_LTO.f30_averages.(group_one{i}).(trials{r}) = mean(nonzeros(percentage.RHS_LTO.(group_one{i}).(trials{r})(1:30,1)));

        percentage.LHS_RTO.l30_averages.(group_one{i}).(trials{r}) = mean(nonzeros(percentage.LHS_RTO.(group_one{i}).(trials{r})(end-29:end,1)));
        percentage.LHS_LHS.l30_averages.(group_one{i}).(trials{r}) = mean(nonzeros(percentage.LHS_LHS.(group_one{i}).(trials{r})(end-29:end,1)));
        percentage.LHS_LTO.l30_averages.(group_one{i}).(trials{r}) = mean(nonzeros(percentage.LHS_LTO.(group_one{i}).(trials{r})(end-29:end,1)));

        percentage.LHS_RTO.f30_averages.(group_one{i}).(trials{r}) = mean(nonzeros(percentage.LHS_RTO.(group_one{i}).(trials{r})(1:30,1)));
        percentage.LHS_LHS.f30_averages.(group_one{i}).(trials{r}) = mean(nonzeros(percentage.LHS_LHS.(group_one{i}).(trials{r})(1:30,1)));
        percentage.LHS_LTO.f30_averages.(group_one{i}).(trials{r}) = mean(nonzeros(percentage.LHS_LTO.(group_one{i}).(trials{r})(1:30,1)));
    end
end
%% Last 30 Plots
% 
% for i = 1:length(group_one)
%     if i ~= 10
%         figure;
%         plot(gait_cycles.(group_one{i}).AcceleratingHS.last30_averages,'k')
%         hold on;
%         p = xline(percentage.RHS_LHS.averages.(group_one{i}).AcceleratingHS,'b');
%         p.Color = '#879693';
%         hold on;
%         t = xline(percentage.RHS_LTO.averages.(group_one{i}).AcceleratingHS,'r');
%         t.Color = '#deae9f';
%         hold on;
%         m = xline(percentage.RHS_RTO.averages.(group_one{i}).AcceleratingHS,'g');
%         m.Color = '#1c4e4f';
%         xlim([-1 101])
%         ylim([0.45 1.05])
%         xlabel('% of Gait Cycle')
%         ylabel('Treadmill Speed (m/s)')
%         title((group_one{i}), 'AcceleratingHS')
%         %saveas(gcf, sprintf('AccHSspeeds_%d.svg', i), 'svg');
%     end
% end
% 
% for i = 1:length(group_one)
%     if i ~= 10
%         figure;
%         plot(gait_cycles.(group_one{i}).DeceleratingHS.last30_averages,'k')
%         hold on;
%         p = xline(percentage.RHS_LHS.averages.(group_one{i}).DeceleratingHS,'b');
%         p.Color = '#879693';
%         hold on;
%         t = xline(percentage.RHS_LTO.averages.(group_one{i}).DeceleratingHS,'r');
%         t.Color = '#deae9f';
%         hold on;
%         m = xline(percentage.RHS_RTO.averages.(group_one{i}).DeceleratingHS,'g');
%         m.Color = '#1c4e4f';
%         xlim([-1 101])
%         ylim([0.45 1.05])
%         xlabel('% of Gait Cycle')
%         ylabel('Treadmill Speed (m/s)')
%         title((group_one{i}), 'DeceleratingHS')
%         %saveas(gcf, sprintf('DecHSspeeds_%d.svg', i), 'svg');
%     end
% end
% 
% for i = 1:length(group_one)
%     if i ~= 10
%         figure;
%         plot(gait_cycles.(group_one{i}).FastHS.last30_averages,'k')
%         hold on;
%         p = xline(percentage.RHS_LHS.averages.(group_one{i}).FastHS,'b');
%         p.Color = '#879693';
%         hold on;
%         t = xline(percentage.RHS_LTO.averages.(group_one{i}).FastHS,'r');
%         t.Color = '#deae9f';
%         hold on;
%         m = xline(percentage.RHS_RTO.averages.(group_one{i}).FastHS,'g');
%         m.Color = '#1c4e4f';
%         xlim([-1 101])
%         ylim([0.45 1.05])
%         xlabel('% of Gait Cycle')
%         ylabel('Treadmill Speed (m/s)')
%         title((group_one{i}), 'FastHS')
%         %saveas(gcf, sprintf('FastHSspeeds_%d.svg', i), 'svg');
%     end
% end
% 
% for i = 1:length(group_one)
%     if i ~= 10
%         figure;
%         plot(gait_cycles.(group_one{i}).SlowHS.last30_averages,'k')
%         hold on;
%         p = xline(percentage.RHS_LHS.averages.(group_one{i}).SlowHS,'b');
%         p.Color = '#879693';
%         hold on;
%         t = xline(percentage.RHS_LTO.averages.(group_one{i}).SlowHS,'r');
%         t.Color = '#deae9f';
%         hold on;
%         m = xline(percentage.RHS_RTO.averages.(group_one{i}).SlowHS,'g');
%         m.Color = '#1c4e4f';
%         xlim([-1 101])
%         ylim([0.45 1.05])
%         xlabel('% of Gait Cycle')
%         ylabel('Treadmill Speed (m/s)')
%         title((group_one{i}), 'SlowHS')
%         %saveas(gcf, sprintf('SlowHSspeeds_%d.svg', i), 'svg');
%     end
% end

%% Find treadmill speed at each event

% group one

% RHS

% for i = 1:length(group_one)
%     if i ~= 10
%         for r = 1:length(trials)
%             treadmill_speeds.RHS.(group_one{i}).(trials{r})(:,1) = gait_cycles.(group_one{i}).(trials{r}).last30_averages(1);
%         end
%     end
% end
% 
% for r = 1:length(trials)
%     if r ~= 3
%         treadmill_speeds.RHS.MLR025.(trials{r})(:,1) = gait_cycles.MLR025.(trials{r}).last30_averages(1);
%     end
% end
% 
% for i = 1:length(group_one)
%     if i ~=10
%         for r = 1:length(trials)
%             treadmill_speeds.RHS.group_one(r,i) = num2cell(treadmill_speeds.RHS.(group_one{i}).(trials{r}));
%         end
%     end
% end
% 
% for r = 1:length(trials)
%     if r ~= 3
%         treadmill_speeds.RHS.group_one(r,10) = num2cell(treadmill_speeds.RHS.MLR025.(trials{r}));
%     end
% end
% 
% 
% treadmill_speeds.RHS.group_one = num2cell(treadmill_speeds.RHS.group_one);
% 
% RHSSpeed_table = [trials,treadmill_speeds.RHS.group_one];
% headers = {'Trial', 'MLR003', 'MLR013','MLR016', 'MLR017', 'MLR024','MLR005','MLR009','MLR028','MLR032','MLR025'};
% RHSSpeed_table = cell2table(RHSSpeed_table,'VariableNames',headers);
% %writetable(RHSSpeed_table, 'RHSSpeed_table.csv');

% LTO

for i = 1:length(group_one)
    for r = 1:length(trials)
        percentage.RHS_LTO.rounded.(group_one{i}).(trials{r}) = round(percentage.RHS_LTO.l30_averages.(group_one{i}).(trials{r}));

        percentage.LHS_LTO.rounded.(group_one{i}).(trials{r}) = round(percentage.LHS_LTO.l30_averages.(group_one{i}).(trials{r}));
    end
end

for i = 1:length(group_one)
    for r = 1:length(trials)
        for t = percentage.RHS_LTO.rounded.(group_one{i}).(trials{r})
            y.LTO.(group_one{i}).(trials{r})(t,1) = percentage.RHS_LTO.rounded.(group_one{i}).(trials{r});

            y.LTO_LHS.(group_one{i}).(trials{r})(t,1) = percentage.LHS_LTO.rounded.(group_one{i}).(trials{r});
        end
    end
end

for i = 1:length(group_one)
    for r = 1:length(trials)
        percentage.groupAverages.f30.LHS_RTO.(trials{r}) = mean(percentage.LHS_RTO.f30_averages.(group_one{i}).(trials{r}));
        percentage.groupAverages.l30.LHS_RTO.(trials{r}) = mean(percentage.LHS_RTO.l30_averages.(group_one{i}).(trials{r}));

        percentage.groupAverages.f30.LHS_LTO.(trials{r}) = mean(percentage.LHS_LTO.f30_averages.(group_one{i}).(trials{r}));
        percentage.groupAverages.l30.LHS_LTO.(trials{r}) = mean(percentage.LHS_LTO.l30_averages.(group_one{i}).(trials{r}));

        percentage.groupAverages.f30.RHS_RTO.(trials{r}) = mean(percentage.RHS_RTO.f30_averages.(group_one{i}).(trials{r}));
        percentage.groupAverages.l30.RHS_RTO.(trials{r}) = mean(percentage.RHS_RTO.l30_averages.(group_one{i}).(trials{r}));

        percentage.groupAverages.f30.RHS_LTO.(trials{r}) = mean(percentage.RHS_LTO.f30_averages.(group_one{i}).(trials{r}));
        percentage.groupAverages.l30.RHS_LTO.(trials{r}) = mean(percentage.RHS_LTO.l30_averages.(group_one{i}).(trials{r}));
    end
end

trials = {'AcceleratingHS','DeceleratingHS','FastHS','SlowHS'};

for i = 1:length(group_one)
    if i ~= 10
        for r = 1:length(trials)
            y.LTO.(group_one{i}).(trials{r}) = resize(y.LTO.(group_one{i}).(trials{r}), length(gait_cycles.(group_one{i}).(trials{r}).last30_averages));
            for j = 1:length(gait_cycles.(group_one{i}).(trials{r}).last30_averages)
                array.LTO.(group_one{i}).(trials{r}) = [gait_cycles.(group_one{i}).(trials{r}).last30_averages,y.LTO.(group_one{i}).(trials{r})];
            end
        end
    end
end

for r = 1:length(trials)
    if r ~= 3
        y.LTO.MLR025.(trials{r}) = resize(y.LTO.MLR025.(trials{r}), length(gait_cycles.MLR025.(trials{r}).last30_averages));
        for j = 1:length(gait_cycles.(group_one{i}).(trials{r}).last30_averages)
            array.LTO.MLR025.(trials{r}) = [gait_cycles.MLR025.(trials{r}).last30_averages,y.LTO.MLR025.(trials{r})];
        end
    end
end

for i = 1:length(group_one)
    if i ~= 10
        for r = 1:length(trials)
            for j = 1:length(array.LTO.(group_one{i}).(trials{r}))
                array.LTO.(group_one{i}).combined(j,1) = percentage.RHS_LTO.rounded.(group_one{i}).(trials{r});
            end
        end
    end
end

for r = 1:length(trials)
    if r ~= 3
        for j = 1:length(array.LTO.MLR025.(trials{r}))
            array.LTO.MLR025.combined(j,1) = percentage.RHS_LTO.rounded.MLR025.(trials{r});
        end
    end
end

for i = 1:length(group_one)
    if i ~= 10
        for r = 1:length(trials)
            for j = 1:length(array.LTO.(group_one{i}).(trials{r}))
                if (array.LTO.(group_one{i}).(trials{r})(j,2) ~= 0)
                    treadmill_speeds.LTO.(group_one{i}).(trials{r})(:,1) = array.LTO.(group_one{i}).(trials{r})(j,1);
                end
            end
        end
    end
end

for r = 1:length(trials)
    if r ~= 3
        for j = 1:length(array.LTO.MLR025.(trials{r}))
            if (array.LTO.MLR025.(trials{r})(j,2) ~= 0)
                treadmill_speeds.LTO.MLR025.(trials{r})(:,1) = array.LTO.MLR025.(trials{r})(j,1);
            end
        end
    end
end

for i = 1:length(group_one)
    if i ~=10
        for r = 1:length(trials)
            treadmill_speeds.LTO.group_one(r,i) = num2cell(treadmill_speeds.LTO.(group_one{i}).(trials{r}));
        end
    end
end

for r = 1:length(trials)
    if r ~= 3
        treadmill_speeds.LTO.group_one(r,10) = num2cell(treadmill_speeds.LTO.MLR025.(trials{r}));
    end
end

treadmill_speeds.LTO.group_one = num2cell(treadmill_speeds.LTO.group_one);

% LTOSpeed_table = [trials,treadmill_speeds.LTO.group_one];
% headers = {'Trial', 'MLR003', 'MLR013','MLR016', 'MLR017', 'MLR024','MLR005','MLR009','MLR028','MLR032','MLR025'};
% LTOSpeed_table = cell2table(LTOSpeed_table,'VariableNames',headers);
%writetable(LTOSpeed_table, 'LTOSpeed_table.csv');

%% LHS

for i = 1:length(group_one)
    for r = 1:length(trials)
        percentage.RHS_LHS.rounded.(group_one{i}).(trials{r}) = round(percentage.RHS_LHS.l30_averages.(group_one{i}).(trials{r}));
    end
end

for i = 1:length(group_one)
    for r = 1:length(trials)
        for t = percentage.RHS_LHS.rounded.(group_one{i}).(trials{r})
            y.LHS.(group_one{i}).(trials{r})(t,1) = percentage.RHS_LHS.rounded.(group_one{i}).(trials{r});
        end
    end
end

for i = 1:length(group_one)
    if i ~= 10
        for r = 1:length(trials)
            y.LHS.(group_one{i}).(trials{r}) = resize(y.LHS.(group_one{i}).(trials{r}), length(gait_cycles.(group_one{i}).(trials{r}).last30_averages));
            for j = 1:length(gait_cycles.(group_one{i}).(trials{r}).last30_averages)
                array.LHS.(group_one{i}).(trials{r}) = [gait_cycles.(group_one{i}).(trials{r}).last30_averages,y.LHS.(group_one{i}).(trials{r})];
            end
        end
    end
end

for r = 1:length(trials)
    if r ~= 3
        y.LHS.MLR025.(trials{r}) = resize(y.LHS.MLR025.(trials{r}), length(gait_cycles.MLR025.(trials{r}).last30_averages));
        for j = 1:length(gait_cycles.(group_one{i}).(trials{r}).last30_averages)
            array.LHS.MLR025.(trials{r}) = [gait_cycles.MLR025.(trials{r}).last30_averages,y.LHS.MLR025.(trials{r})];
        end
    end
end

for i = 1:length(group_one)
    if i ~= 10
        for r = 1:length(trials)
            for j = 1:length(array.LHS.(group_one{i}).(trials{r}))
                array.LHS.(group_one{i}).combined(j,1) = percentage.RHS_LHS.rounded.(group_one{i}).(trials{r});
            end
        end
    end
end

for r = 1:length(trials)
    if r ~= 3
        for j = 1:length(array.LHS.MLR025.(trials{r}))
            array.LHS.MLR025.combined(j,1) = percentage.RHS_LHS.rounded.MLR025.(trials{r});
        end
    end
end

for i = 1:length(group_one)
    if i ~= 10
        for r = 1:length(trials)
            for j = 1:length(array.LHS.(group_one{i}).(trials{r}))
                if (array.LHS.(group_one{i}).(trials{r})(j,2) ~= 0)
                    treadmill_speeds.LHS.(group_one{i}).(trials{r})(:,1) = array.LHS.(group_one{i}).(trials{r})(j,1);
                end
            end
        end
    end
end

for r = 1:length(trials)
    if r ~= 3
        for j = 1:length(array.LHS.MLR025.(trials{r}))
            if (array.LHS.MLR025.(trials{r})(j,2) ~= 0)
                treadmill_speeds.LHS.MLR025.(trials{r})(:,1) = array.LHS.MLR025.(trials{r})(j,1);
            end
        end
    end
end

for i = 1:length(group_one)
    if i ~=10
        for r = 1:length(trials)
            treadmill_speeds.LHS.group_one(r,i) = num2cell(treadmill_speeds.LHS.(group_one{i}).(trials{r}));
        end
    end
end

for r = 1:length(trials)
    if r ~= 3
        treadmill_speeds.LHS.group_one(r,10) = num2cell(treadmill_speeds.LHS.MLR025.(trials{r}));
    end
end

treadmill_speeds.LHS.group_one = num2cell(treadmill_speeds.LHS.group_one);

% LHSSpeed_table = [trials,treadmill_speeds.LHS.group_one];
% headers = {'Trial', 'MLR003', 'MLR013','MLR016', 'MLR017', 'MLR024','MLR005','MLR009','MLR028','MLR032','MLR025'};
% LHSSpeed_table = cell2table(LHSSpeed_table,'VariableNames',headers);
%writetable(LHSSpeed_table, 'LHSSpeed_table.csv');

%% RTO

for i = 1:length(group_one)
    for r = 1:length(trials)
        percentage.RHS_RTO.rounded.(group_one{i}).(trials{r}) = round(percentage.RHS_RTO.l30_averages.(group_one{i}).(trials{r}));
    end
end

for i = 1:length(group_one)
    for r = 1:length(trials)
        for t = percentage.RHS_RTO.rounded.(group_one{i}).(trials{r})
            y.RTO.(group_one{i}).(trials{r})(t,1) = percentage.RHS_RTO.rounded.(group_one{i}).(trials{r});
        end
    end
end

for i = 1:length(group_one)
    if i ~= 10
        for r = 1:length(trials)
            y.RTO.(group_one{i}).(trials{r}) = resize(y.RTO.(group_one{i}).(trials{r}), length(gait_cycles.(group_one{i}).(trials{r}).last30_averages));
            for j = 1:length(gait_cycles.(group_one{i}).(trials{r}).last30_averages)
                array.RTO.(group_one{i}).(trials{r}) = [gait_cycles.(group_one{i}).(trials{r}).last30_averages,y.RTO.(group_one{i}).(trials{r})];
            end
        end
    end
end

for r = 1:length(trials)
    if r ~= 3
        y.RTO.MLR025.(trials{r}) = resize(y.RTO.MLR025.(trials{r}), length(gait_cycles.MLR025.(trials{r}).last30_averages));
        for j = 1:length(gait_cycles.(group_one{i}).(trials{r}).last30_averages)
            array.RTO.MLR025.(trials{r}) = [gait_cycles.MLR025.(trials{r}).last30_averages,y.RTO.MLR025.(trials{r})];
        end
    end
end

for i = 1:length(group_one)
    if i ~= 10
        for r = 1:length(trials)
            for j = 1:length(array.RTO.(group_one{i}).(trials{r}))
                array.RTO.(group_one{i}).combined(j,1) = percentage.RHS_LHS.rounded.(group_one{i}).(trials{r});
            end
        end
    end
end

for r = 1:length(trials)
    if r ~= 3
        for j = 1:length(array.RTO.MLR025.(trials{r}))
            array.RTO.MLR025.combined(j,1) = percentage.RHS_LHS.rounded.MLR025.(trials{r});
        end
    end
end

for i = 1:length(group_one)
    if i ~= 10
        for r = 1:length(trials)
            for j = 1:length(array.RTO.(group_one{i}).(trials{r}))
                if (array.RTO.(group_one{i}).(trials{r})(j,2) ~= 0)
                    treadmill_speeds.RTO.(group_one{i}).(trials{r})(:,1) = array.RTO.(group_one{i}).(trials{r})(j,1);
                end
            end
        end
    end
end

for r = 1:length(trials)
    if r ~= 3
        for j = 1:length(array.RTO.MLR025.(trials{r}))
            if (array.RTO.MLR025.(trials{r})(j,2) ~= 0)
                treadmill_speeds.RTO.MLR025.(trials{r})(:,1) = array.RTO.MLR025.(trials{r})(j,1);
            end
        end
    end
end

for i = 1:length(group_one)
    if i ~=10
        for r = 1:length(trials)
            treadmill_speeds.RTO.group_one(r,i) = num2cell(treadmill_speeds.RTO.(group_one{i}).(trials{r}));
        end
    end
end

for r = 1:length(trials)
    if r ~= 3
        treadmill_speeds.RTO.group_one(r,10) = num2cell(treadmill_speeds.RTO.MLR025.(trials{r}));
    end
end

treadmill_speeds.RTO.group_one = num2cell(treadmill_speeds.RTO.group_one);

% LHSSpeed_table = [trials,treadmill_speeds.RTO.group_one];
% headers = {'Trial', 'MLR003', 'MLR013','MLR016', 'MLR017', 'MLR024','MLR005','MLR009','MLR028','MLR032','MLR025'};
% LHSSpeed_table = cell2table(LHSSpeed_table,'VariableNames',headers);
%writetable(LHSSpeed_table, 'LHSSpeed_table.csv');




% RTO

for i = 1:length(group_one)
    for r = 1:length(trials)
        percentage.RHS_RTO.last30.(group_one{i}).(trials{r}) = percentage.RHS_RTO.l30_averages.(group_one{i}).(trials{r});
        percentage.RHS_RTO.first30.(group_one{i}).(trials{r}) = percentage.RHS_RTO.f30_averages.(group_one{i}).(trials{r});
    end
end

% save percentage.mat

% for i = 1:length(group_one)
%     for r = 1:length(trials)
%         for t = 1:length(percentage.RHS_RTO.last30.(group_one{i}).(trials{r}))
%             y.RTO.(group_one{i}).(trials{r})(t,:) = percentage.RHS_RTO.last30.(group_one{i}).(trials{r});
%             %y.RTO.first30.(group_one{i}).(trials{r})(t,1) = percentage.RHS_RTO.first30.(group_one{i}).(trials{r});
%         end
%     end
% end
% 
% for i = 1:length(group_one)
%     if i ~= 10
%         for r = 1:length(trials)
%             y.RTO.(group_one{i}).(trials{r}) = resize(y.RTO.(group_one{i}).(trials{r}), length(gait_cycles.(group_one{i}).(trials{r}).last30_averages));
%             %y.RTO.first30.(group_one{i}).(trials{r}) = resize(y.RTO.first30.(group_one{i}).(trials{r}), length(gait_cycles.(group_one{i}).(trials{r}).first30_averages));
%         end
%     end
% end
% for i = 1:length(group_one)
%     if i ~= 10
%         for r = 1:length(trials)
%             for j = 1:length(gait_cycles.(group_one{i}).(trials{r}).last30_averages)
%                 array.RTO.(group_one{i}).(trials{r}) = [gait_cycles.(group_one{i}).(trials{r}).last30_averages,y.RTO.(group_one{i}).(trials{r})];
%                 %array.RTO.first30.(group_one{i}).(trials{r}) = [gait_cycles.(group_one{i}).(trials{r}).first30_averages,y.RTO.first30.(group_one{i}).(trials{r})];
%             end
%         end
%     end
% end
% 
% 
% for r = 1:length(trials)
%     if r ~= 3
%         y.RTO.MLR025.(trials{r}) = resize(y.RTO.MLR025.(trials{r}), length(gait_cycles.MLR025.(trials{r}).last30_averages));
%         %y.RTO.first30.MLR025.(trials{r}) = resize(y.RTO.first30.MLR025.(trials{r}), length(gait_cycles.MLR025.(trials{r}).first30_averages));
%         for j = 1:length(gait_cycles.(group_one{i}).(trials{r}).last30_averages)
%             array.RTO.last30.MLR025.(trials{r}) = [gait_cycles.MLR025.(trials{r}).last30_averages,y.RTO.MLR025.(trials{r})];
%             %array.RTO.first30.MLR025.(trials{r}) = [gait_cycles.MLR025.(trials{r}).first30_averages,y.RTO.first30.MLR025.(trials{r})];
%         end
%     end
% end
% 
% for i = 1:length(group_one)
%     if i ~= 10
%         for r = 1:length(trials)
%             for j = 1:length(array.RTO.last30.(group_one{i}).(trials{r}))
%                 array.RTO.last30.(group_one{i}).combined(j,1) = percentage.RHS_RTO.last30.(group_one{i}).(trials{r});
%                 array.RTO.first30.(group_one{i}).combined(j,1) = percentage.RHS_RTO.first30.(group_one{i}).(trials{r});
%             end
%         end
%     end
% end
% 
% for r = 1:length(trials)
%     if r ~= 3
%         for j = 1:length(array.RTO.last30.MLR025.(trials{r}))
%             array.RTO.last30.MLR025.combined(j,1) = percentage.RHS_RTO.last30.MLR025.(trials{r});
%             array.RTO.first30.MLR025.combined(j,1) = percentage.RHS_RTO.first30.MLR025.(trials{r});
%         end
%     end
% end
% 
% for i = 1:length(group_one)
%     if i ~= 10
%         for r = 1:length(trials)
%             for j = 1:length(array.RTO.last30.(group_one{i}).(trials{r}))
%                 if (array.RTO.last30.(group_one{i}).(trials{r})(j,2) ~= 0)
%                     treadmill_speeds.RTO.(group_one{i}).(trials{r})(:,1) = array.RTO.last30.(group_one{i}).(trials{r})(j,1);
%                     %treadmill_speeds.RTO.first30.(group_one{i}).(trials{r})(:,1) = array.RTO.first30.(group_one{i}).(trials{r})(j,1);
%                 end
%             end
%         end
%     end
% end
% 
% for r = 1:length(trials)
%     if r ~= 3
%         for j = 1:length(array.RTO.last30.MLR025.(trials{r}))
%             if (array.RTO.last30.MLR025.(trials{r})(j,2) ~= 0)
%                 treadmill_speeds.RTO.MLR025.(trials{r})(:,1) = array.RTO.last30.MLR025.(trials{r})(j,1);
%                 %treadmill_speeds.RTO.first30.MLR025.(trials{r})(:,1) = array.RTO.first30.MLR025.(trials{r})(j,1);
%             end
%         end
%     end
% end
% 
% for i = 1:length(group_one)
%     if i ~=10
%         for r = 1:length(trials)
%             treadmill_speeds.RTO.group_one(r,i) = num2cell(treadmill_speeds.RTO.last30.(group_one{i}).(trials{r}));
%             %treadmill_speeds.RTO.first30.group_one(r,i) = num2cell(treadmill_speeds.RTO.first30.(group_one{i}).(trials{r}));
%         end
%     end
% end
% 
% for r = 1:length(trials)
%     if r ~= 3
%         treadmill_speeds.RTO.group_one(r,10) = num2cell(treadmill_speeds.RTO.last30.MLR025.(trials{r}));
%         %treadmill_speeds.RTO.first30.group_one(r,10) = num2cell(treadmill_speeds.RTO.first30.MLR025.(trials{r}));
%     end
% end

% treadmill_speeds.RTO.last30.group_one = num2cell(treadmill_speeds.RTO.last30.group_one);
% treadmill_speeds.RTO.first30.group_one = num2cell(treadmill_speeds.RTO.first30.group_one);

% RTOSpeed_table = [trials,treadmill_speeds.RTO.group_one];
% headers = {'Trial', 'MLR003', 'MLR013','MLR016', 'MLR017', 'MLR024','MLR005','MLR009','MLR028','MLR032','MLR025'};
% RTOSpeed_table = cell2table(RTOSpeed_table,'VariableNames',headers);
%writetable(RTOSpeed_table, 'RTOSpeed_table.csv');

%% Pull out the gait cycle percentages for each person and trial

for i = 1:length(group_one)
    if i ~= 10
        for r = 1:length(trials)
            LTOPercent_tableL30(r,i) = percentage.RHS_LTO.l30_averages.(group_one{i}).(trials{r});
            LTOPercent_tableF30(r,i) = percentage.RHS_LTO.f30_averages.(group_one{i}).(trials{r});
        end
    end
end

for r = 1:length(trials)
    if r ~= 3
        LTOPercent_tableL30(r,10) = percentage.RHS_LTO.l30_averages.MLR025.(trials{r});
        LTOPercent_tableF30(r,10) = percentage.RHS_LTO.f30_averages.MLR025.(trials{r});
    end
end
% 
% % LTOPercent_tableL30 = num2cell(LTOPercent_tableL30);
% % LTOPercent_tableF30 = num2cell(LTOPercent_tableF30);
% % 
% % LTOPercent_tableL30 = [trials,LTOPercent_tableL30];
% % LTOPercent_tableF30 = [trials,LTOPercent_tableF30];
% 
% headers = {'Trial', 'MLR003', 'MLR013','MLR016', 'MLR017', 'MLR024','MLR005','MLR009','MLR028','MLR032','MLR025'};
% LTOPercent_tableL30 = cell2table(LTOPercent_tableL30,'VariableNames',headers);
% writetable(LTOPercent_tableL30, 'LTOPercent_tableL30.csv');
% LTOPercent_tableF30 = cell2table(LTOPercent_tableF30,'VariableNames',headers);
%writetable(LTOPercent_tableF30, 'LTOPercent_tableF30.csv');

% LHS
for i = 1:length(group_one)
    if i ~= 10
        for r = 1:length(trials)
            LHSPercent_tableL30(r,i) = percentage.RHS_LHS.l30_averages.(group_one{i}).(trials{r});
            LHSPercent_tableF30(r,i) = percentage.RHS_LHS.f30_averages.(group_one{i}).(trials{r});
        end
    end
end

for r = 1:length(trials)
    if r ~= 3
        LHSPercent_tableL30(r,10) = percentage.RHS_LHS.l30_averages.MLR025.(trials{r});
        LHSPercent_tableF30(r,10) = percentage.RHS_LHS.f30_averages.MLR025.(trials{r});
    end
end

LHSPercent_tableL30 = num2cell(LHSPercent_tableL30);
LHSPercent_tableF30 = num2cell(LHSPercent_tableF30);

% LHSPercent_tableL30 = [trials,LHSPercent_tableL30];
% LHSPercent_tableF30 = [trials,LHSPercent_tableF30];
% 
% headers = {'Trial', 'MLR003', 'MLR013','MLR016', 'MLR017', 'MLR024','MLR005','MLR009','MLR028','MLR032','MLR025'};
% LHSPercent_tableL30 = cell2table(LHSPercent_tableL30,'VariableNames',headers);
% writetable(LHSPercent_tableL30, 'LHSPercent_tableL30.csv');
% LHSPercent_tableF30 = cell2table(LHSPercent_tableF30,'VariableNames',headers);
% writetable(LHSPercent_tableF30, 'LHSPercent_tableF30.csv');

%RTO
for i = 1:length(group_one)
    if i ~= 10
        for r = 1:length(trials)
            RTOPercent_tableL30(r,i) = percentage.RHS_RTO.l30_averages.(group_one{i}).(trials{r});
            RTOPercent_tableF30(r,i) = percentage.RHS_RTO.f30_averages.(group_one{i}).(trials{r});
        end
    end
end

for r = 1:length(trials)
    if r ~= 3
        RTOPercent_tableL30(r,10) = percentage.RHS_RTO.l30_averages.MLR025.(trials{r});
        RTOPercent_tableF30(r,10) = percentage.RHS_RTO.f30_averages.MLR025.(trials{r});
    end
end

RTOPercent_tableL30 = num2cell(RTOPercent_tableL30);
RTOPercent_tableF30 = num2cell(RTOPercent_tableF30);

% RTOPercent_tableL30 = [trials,RTOPercent_tableL30];
% RTOPercent_tableF30 = [trials,RTOPercent_tableF30];
% 
% headers = {'Trial', 'MLR003', 'MLR013','MLR016', 'MLR017', 'MLR024','MLR005','MLR009','MLR028','MLR032','MLR025'};
% RTOPercent_tableL30 = cell2table(RTOPercent_tableL30,'VariableNames',headers);
% writetable(RTOPercent_tableL30, 'RTOPercent_tableL30.csv');
% RTOPercent_tableF30 = cell2table(RTOPercent_tableF30,'VariableNames',headers);
% writetable(RTOPercent_tableF30, 'RTOPercent_tableF30.csv');

for i = 1:length(group_one)
    if i ~= 10
        for r = 1:length(trials)
            LHSPercent_table(r,i) = percentage.RHS_LHS.l30_averages.(group_one{i}).(trials{r});
        end
    end
end

for r = 1:length(trials)
    if r ~= 3
        LHSPercent_table(r,10) = percentage.RHS_LHS.l30_averages.MLR025.(trials{r});
    end
end

% LHSPercent_table = num2cell(LHSPercent_table);
% 
% LHSPercent_table = [trials,LHSPercent_table];
% headers = {'Trial', 'MLR003', 'MLR013','MLR016', 'MLR017', 'MLR024','MLR005','MLR009','MLR028','MLR032','MLR025'};
% LHSPercent_table = cell2table(LHSPercent_table,'VariableNames',headers);
% %writetable(LHSPercent_table, 'LHSPercent_table.csv');

for i = 1:length(group_one)
    if i ~= 10
        for r = 1:length(trials)
            RTOPercent_table(r,i) = percentage.RHS_RTO.averages.(group_one{i}).(trials{r});
        end
    end
end

for r = 1:length(trials)
    if r ~= 3
        RTOPercent_table(r,10) = percentage.RHS_RTO.l30_averages.MLR025.(trials{r});
    end
end

RTOPercent_table = num2cell(RTOPercent_table);
% 
% RTOPercent_table = [trials,RTOPercent_table];
% headers = {'Trial', 'MLR003', 'MLR013','MLR016', 'MLR017', 'MLR024','MLR005','MLR009','MLR028','MLR032','MLR025'};
% RTOPercent_table = cell2table(RTOPercent_table,'VariableNames',headers);
% writetable(RTOPercent_table, 'RTOPercent_table.csv');

for i = 1:length(group_one)
    for r = 1:length(trials)
        lhs_table.(trials{r})(i,1) = percentage.RHS_LHS.l30_averages.(group_one{i}).(trials{r});
        lto_table.(trials{r})(i,1) = percentage.RHS_LTO.l30_averages.(group_one{i}).(trials{r});
        rto_table.(trials{r})(i,1) = percentage.RHS_RTO.l30_averages.(group_one{i}).(trials{r});
    end
end

for r = 1:length(trials)
    lhs_table.l30_averages.(trials{r}) = mean(nonzeros(lhs_table.(trials{r})));
    lto_table.l30_averages.(trials{r}) = mean(nonzeros(lto_table.(trials{r})));
    rto_table.l30_averages.(trials{r}) = mean(nonzeros(rto_table.(trials{r})));
end
%% figures
figure;
jbfill(1:101,gait_cycles.group_averages.AcceleratingHS.group_one.last30_average + gait_cycles.group_averages.AcceleratingHS.group_one.last30_sem,gait_cycles.group_averages.AcceleratingHS.group_one.last30_average - gait_cycles.group_averages.AcceleratingHS.group_one.last30_sem,[0.7333 0.7333 0.7333],[0.7333 0.7333 0.7333],1,1);
hold on;
x = plot(gait_cycles.group_averages.AcceleratingHS.group_one.last30_average, 'k');
hold on;
p = xline(lto_table.l30_averages.AcceleratingHS, '--', 'LineWidth', 1.0); %xline(5,'--r');
p.Color = '#000000';
hold on;
t = xline(lhs_table.l30_averages.AcceleratingHS, '--', 'LineWidth', 1.0);
t.Color = '#000000';
hold on;
m = xline(rto_table.l30_averages.AcceleratingHS, '--', 'LineWidth', 1.0);
m.Color = '#000000';
xlim([-1 102])
ylim([0.45 1.05])
xlabel('% gait cycle')
ylabel('treadmill speed (m/s)')
title('Accelerate')
saveas(gcf, 'C:\Users\hallbl\OneDrive - Kennedy Krieger\Control Study\Updated\Graphs\Manuscript Figures\Speed plots\All_events\Group One\Group Plots\AcceleratingHS_l30_2025Mar19.svg');

figure;
jbfill(1:101,gait_cycles.group_averages.DeceleratingHS.group_one.last30_average + gait_cycles.group_averages.DeceleratingHS.group_one.last30_sem,gait_cycles.group_averages.DeceleratingHS.group_one.last30_average - gait_cycles.group_averages.DeceleratingHS.group_one.last30_sem,[0.7333 0.7333 0.7333],[0.7333 0.7333 0.7333],1,1);
hold on;
x = plot(gait_cycles.group_averages.DeceleratingHS.group_one.last30_average, 'k');
hold on;
p = xline(lto_table.l30_averages.DeceleratingHS, '--', 'LineWidth', 1.0);
p.Color = '#000000';
hold on;
t = xline(lhs_table.l30_averages.DeceleratingHS, '--', 'LineWidth', 1.0);
t.Color = '#000000';
hold on;
m = xline(rto_table.l30_averages.DeceleratingHS, '--', 'LineWidth', 1.0);
m.Color = '#000000';
xlim([-1 102])
ylim([0.45 1.05])
xlabel('% gait cycle')
ylabel('treadmill speed (m/s)')
title('Decelerate')
saveas(gcf, 'C:\Users\hallbl\OneDrive - Kennedy Krieger\Control Study\Updated\Graphs\Manuscript Figures\Speed plots\All_events\Group One\Group Plots\DeceleratingHS_l30_2025Mar19.svg');

figure;
jbfill(1:101,gait_cycles.group_averages.FastHS.group_one.last30_average + gait_cycles.group_averages.FastHS.group_one.last30_sem,gait_cycles.group_averages.FastHS.group_one.last30_average - gait_cycles.group_averages.FastHS.group_one.last30_sem,[0.7333 0.7333 0.7333],[0.7333 0.7333 0.7333],1,1);
hold on;
x = plot(gait_cycles.group_averages.FastHS.group_one.last30_average, 'k');
hold on;
p = xline(lto_table.l30_averages.FastHS, '--', 'LineWidth', 1.0);
p.Color = '#000000';
hold on;
t = xline(lhs_table.l30_averages.FastHS, '--', 'LineWidth', 1.0);
t.Color = '#000000';
hold on;
m = xline(rto_table.l30_averages.FastHS, '--', 'LineWidth', 1.0);
m.Color = '#000000';
xlim([-1 102])
ylim([0.45 1.05])
xlabel('% gait cycle')
ylabel('treadmill speed (m/s)')
title('Fast')
saveas(gcf, 'C:\Users\hallbl\OneDrive - Kennedy Krieger\Control Study\Updated\Graphs\Manuscript Figures\Speed plots\All_events\Group One\Group Plots\Fast_2025Mar19.svg');

figure;
jbfill(1:101,gait_cycles.group_averages.SlowHS.group_one.last30_average + gait_cycles.group_averages.SlowHS.group_one.last30_sem,gait_cycles.group_averages.SlowHS.group_one.last30_average - gait_cycles.group_averages.SlowHS.group_one.last30_sem,[0.7333 0.7333 0.7333],[0.7333 0.7333 0.7333],1,1);
hold on;
x = plot(gait_cycles.group_averages.SlowHS.group_one.last30_average, 'k');
hold on;
p = xline(lto_table.l30_averages.SlowHS, '--', 'LineWidth', 1.0);
p.Color = '#000000';
hold on;
t = xline(lhs_table.l30_averages.SlowHS, '--', 'LineWidth', 1.0);
t.Color = '#000000';
hold on;
m = xline(rto_table.l30_averages.SlowHS, '--', 'LineWidth', 1.0);
m.Color = '#000000';
xlim([-1 102])
ylim([0.45 1.05])
xlabel('% gait cycle')
ylabel('treadmill speed (m/s)')
title('Slow')
saveas(gcf, 'C:\Users\hallbl\OneDrive - Kennedy Krieger\Control Study\Updated\Graphs\Manuscript Figures\Speed plots\All_events\Group One\Group Plots\SlowHS_2025Mar19.svg');
 
%% Visual to see if adding the individual traces of the speeds looks good
 
figure;
for i = 1:length(group_one)
    jbfill(1:101,gait_cycles.group_averages.AcceleratingHS.group_one.last30_average + gait_cycles.group_averages.AcceleratingHS.group_one.last30_sem,gait_cycles.group_averages.AcceleratingHS.group_one.last30_average - gait_cycles.group_averages.AcceleratingHS.group_one.last30_sem,[0.7333 0.7333 0.7333],[0.7333 0.7333 0.7333],1,1);
    hold on;
    x = plot(gait_cycles.group_averages.AcceleratingHS.group_one.last30_average, 'k');
    hold on;
    p = xline(lto_table.l30_averages.AcceleratingHS, '--', 'LineWidth', 1.0);
    p.Color = '#000000';
    hold on;
    t = xline(lhs_table.l30_averages.AcceleratingHS, '--', 'LineWidth', 1.0);
    t.Color = '#000000';
    hold on;
    m = xline(rto_table.l30_averages.AcceleratingHS, '--', 'LineWidth', 1.0);
    m.Color = '#000000';
    hold on;
    c = plot(gait_cycles.(group_one{i}).AcceleratingHS.last30_averages);
    c.Color = '#e0e0e0';
    xlim([-1 102])
    ylim([0.45 1.05])
    xlabel('% gait cycle')
    ylabel('treadmill speed (m/s)')
    title('Accelerate')
end
saveas(gcf, 'C:\Users\hallbl\OneDrive - Kennedy Krieger\Control Study\Updated\Graphs\Manuscript Figures\Speed plots\All_events\Group One\Group Plots\AcceleratingHS_l30Wtraces_2025May06.svg');

figure;
for i = 1:length(group_one)
    jbfill(1:101,gait_cycles.group_averages.DeceleratingHS.group_one.last30_average + gait_cycles.group_averages.DeceleratingHS.group_one.last30_sem,gait_cycles.group_averages.DeceleratingHS.group_one.last30_average - gait_cycles.group_averages.DeceleratingHS.group_one.last30_sem,[0.7333 0.7333 0.7333],[0.7333 0.7333 0.7333],1,1);
    hold on;
    x = plot(gait_cycles.group_averages.DeceleratingHS.group_one.last30_average, 'k');
    hold on;
    p = xline(lto_table.l30_averages.DeceleratingHS, '--', 'LineWidth', 1.0);
    p.Color = '#000000';
    hold on;
    t = xline(lhs_table.l30_averages.DeceleratingHS, '--', 'LineWidth', 1.0);
    t.Color = '#000000';
    hold on;
    m = xline(rto_table.l30_averages.DeceleratingHS, '--', 'LineWidth', 1.0);
    m.Color = '#000000';
    hold on;
    c = plot(gait_cycles.(group_one{i}).DeceleratingHS.last30_averages);
    c.Color = '#e0e0e0';
    xlim([-1 102])
    ylim([0.45 1.05])
    xlabel('% gait cycle')
    ylabel('treadmill speed (m/s)')
    title('Decelerate')
end
saveas(gcf, 'C:\Users\hallbl\OneDrive - Kennedy Krieger\Control Study\Updated\Graphs\Manuscript Figures\Speed plots\All_events\Group One\Group Plots\DeceleratingHS_l30Wtraces_2025May06.svg');

figure;
for i = 1:length(group_one)
    if i ~= 10
        jbfill(1:101,gait_cycles.group_averages.FastHS.group_one.last30_average + gait_cycles.group_averages.FastHS.group_one.last30_sem,gait_cycles.group_averages.FastHS.group_one.last30_average - gait_cycles.group_averages.FastHS.group_one.last30_sem,[0.7333 0.7333 0.7333],[0.7333 0.7333 0.7333],1,1);
        hold on;
        x = plot(gait_cycles.group_averages.FastHS.group_one.last30_average, 'k');
        hold on;
        p = xline(lto_table.l30_averages.FastHS, '--', 'LineWidth', 1.0);
        p.Color = '#000000';
        hold on;
        t = xline(lhs_table.l30_averages.FastHS, '--', 'LineWidth', 1.0);
        t.Color = '#000000';
        hold on;
        m = xline(rto_table.l30_averages.FastHS, '--', 'LineWidth', 1.0);
        m.Color = '#000000';
        hold on;
        c = plot(gait_cycles.(group_one{i}).FastHS.last30_averages);
        c.Color = '#e0e0e0';
        xlim([-1 102])
        ylim([0.45 1.05])
        xlabel('% gait cycle')
        ylabel('treadmill speed (m/s)')
        title('Fast')
    end
end
saveas(gcf, 'C:\Users\hallbl\OneDrive - Kennedy Krieger\Control Study\Updated\Graphs\Manuscript Figures\Speed plots\All_events\Group One\Group Plots\FastHS_l30Wtraces_2025Mar19.svg');

figure;
for i = 1:length(group_one)
    jbfill(1:101,gait_cycles.group_averages.SlowHS.group_one.last30_average + gait_cycles.group_averages.SlowHS.group_one.last30_sem,gait_cycles.group_averages.SlowHS.group_one.last30_average - gait_cycles.group_averages.SlowHS.group_one.last30_sem,[0.7333 0.7333 0.7333],[0.7333 0.7333 0.7333],1,1);
    hold on;
    x = plot(gait_cycles.group_averages.SlowHS.group_one.last30_average, 'k');
    hold on;
    p = xline(lto_table.l30_averages.SlowHS, '--', 'LineWidth', 1.0);
    p.Color = '#000000';
    hold on;
    t = xline(lhs_table.l30_averages.SlowHS, '--', 'LineWidth', 1.0);
    t.Color = '#000000';
    hold on;
    m = xline(rto_table.l30_averages.SlowHS, '--', 'LineWidth', 1.0);
    m.Color = '#000000';
    hold on;
    c = plot(gait_cycles.(group_one{i}).SlowHS.last30_averages);
    c.Color = '#e0e0e0';
    xlim([-1 102])
    ylim([0.45 1.05])
    xlabel('% gait cycle')
    ylabel('treadmill speed (m/s)')
    title('Slow')
end
saveas(gcf, 'C:\Users\hallbl\OneDrive - Kennedy Krieger\Control Study\Updated\Graphs\Manuscript Figures\Speed plots\All_events\Group One\Group Plots\SlowHS_l30Wtraces_2025Mar19.svg');