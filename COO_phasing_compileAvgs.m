%% Load in the phasing and center of oscillation data
% cd = (C:\Users\hallbl\OneDrive - Kennedy Krieger\Control Study\Updated\) 

subject_list = {'MLR003','MLR013','MLR016','MLR017','MLR024','MLR005','MLR009','MLR028','MLR032','MLR025'};
condition_list = {'AcceleratingHS';'DeceleratingHS';'FastHS';'SlowHS'};

%% Compile it into one struct
phaseCOO_compile = {};

for i = 1:length(subject_list)
    for r = 1:length(condition_list)
        phaseCOO_compile.(subject_list{i}).(condition_list{r}).COO.right = COO.(subject_list{i}).(condition_list{r}).right;  
        phaseCOO_compile.(subject_list{i}).(condition_list{r}).COO.left = COO.(subject_list{i}).(condition_list{r}).left;
        phaseCOO_compile.(subject_list{i}).(condition_list{r}).COO.diff = COO.(subject_list{i}).(condition_list{r}).diff;

        phaseCOO_compile.(subject_list{i}).(condition_list{r}).phasing = phasing.(subject_list{i}).(condition_list{r}).phaseshift_baselinesubtracted;  
        phaseCOO_compile.(subject_list{i}).(condition_list{r}).phase_mean = phasing.(subject_list{i}).(condition_list{r}).phasing_mean;
    end
end
%% Put each of the metrics into a group array

for i = 1:length(subject_list)
    for r = 1:length(condition_list)
        for j = 1:77 %190
            phaseCOO_compile.group_one.(condition_list{r}).COO.right(j,i) = phaseCOO_compile.(subject_list{i}).(condition_list{r}).COO.right(j,:);
            phaseCOO_compile.group_one.(condition_list{r}).COO.left(j,i) = phaseCOO_compile.(subject_list{i}).(condition_list{r}).COO.left(j,:);
            phaseCOO_compile.group_one.(condition_list{r}).COO.diff(j,i) = phaseCOO_compile.(subject_list{i}).(condition_list{r}).COO.diff(j,:);
            %phaseCOO_compile.group_one.(condition_list{r}).phase_mean(j,i) = phaseCOO_compile.(subject_list{i}).(condition_list{r}).phase_mean(j,:);
            phaseCOO_compile.group_one.(condition_list{r}).phasing(j,i) = phaseCOO_compile.(subject_list{i}).(condition_list{r}).phasing(j,:);
        end
    end
end

%% Find the average across the participants

for r = 1:length(condition_list)
    for j = 1:length(phaseCOO_compile.group_one.(condition_list{r}).COO.right)
        phaseCOO_compile.group_one.(condition_list{r}).averages.COO.right(j,1) = mean(nonzeros(phaseCOO_compile.group_one.(condition_list{r}).COO.right(j,:)));
        phaseCOO_compile.group_one.(condition_list{r}).averages.COO.left(j,1) = mean(nonzeros(phaseCOO_compile.group_one.(condition_list{r}).COO.left(j,:)));
        phaseCOO_compile.group_one.(condition_list{r}).averages.COO.diff(j,1) = mean(nonzeros(phaseCOO_compile.group_one.(condition_list{r}).COO.diff(j,:)));
        %phaseCOO_compile.group_one.(condition_list{r}).averages.phase_mean(j,1) = mean(nonzeros(phaseCOO_compile.group_one.(condition_list{r}).phase_mean(j,:)));
        phaseCOO_compile.group_one.(condition_list{r}).averages.phasing(j,1) = mean(nonzeros(phaseCOO_compile.group_one.(condition_list{r}).phasing(j,:)));
    end
end

%% sem across participants

for r = 1:length(condition_list)
    for j = 1:length(phaseCOO_compile.group_one.(condition_list{r}).COO.right)
        phaseCOO_compile.group_one.(condition_list{r}).sem.COO.right(j,1) = std(nonzeros(phaseCOO_compile.group_one.(condition_list{r}).COO.right(j,:)))./sqrt(10);
        phaseCOO_compile.group_one.(condition_list{r}).sem.COO.left(j,1) = std(nonzeros(phaseCOO_compile.group_one.(condition_list{r}).COO.left(j,:)))./sqrt(10);
        phaseCOO_compile.group_one.(condition_list{r}).sem.COO.diff(j,1) = std(nonzeros(phaseCOO_compile.group_one.(condition_list{r}).COO.diff(j,:)))./sqrt(10);
        phaseCOO_compile.group_one.(condition_list{r}).sem.phasing(j,1) = std(nonzeros(phaseCOO_compile.group_one.(condition_list{r}).phasing(j,:)))./sqrt(10);
        %phaseCOO_compile.group_one.(condition_list{r}).sem.phase_shift(j,1) = std(nonzeros(phaseCOO_compile.group_one.(condition_list{r}).phasing(j,:)))./sqrt(10);
    end
end

%% Pull out the last 30 strides 

for i = 1:length(subject_list)
    for r = 1:length(condition_list)
        phaseCOO_compile.group_one.(condition_list{r}).last30.COO.right(:,i) = phaseCOO_compile.(subject_list{i}).(condition_list{r}).COO.right(end-29:end);
        phaseCOO_compile.group_one.(condition_list{r}).last30.COO.left(:,i) = phaseCOO_compile.(subject_list{i}).(condition_list{r}).COO.left(end-29:end);
        phaseCOO_compile.group_one.(condition_list{r}).last30.COO.diff(:,i) = phaseCOO_compile.(subject_list{i}).(condition_list{r}).COO.diff(end-29:end);
        phaseCOO_compile.group_one.(condition_list{r}).last30.phasing(:,i) = phaseCOO_compile.(subject_list{i}).(condition_list{r}).phasing(end-29:end);
        %phaseCOO_compile.group_one.(condition_list{r}).last30.phase_shift(:,i) = phaseCOO_compile.(subject_list{i}).(condition_list{r}).phase_mean(end-29:end);

        phaseCOO_compile.group_one.(condition_list{r}).first30.COO.right(:,i) = phaseCOO_compile.(subject_list{i}).(condition_list{r}).COO.right(1:30);
        phaseCOO_compile.group_one.(condition_list{r}).first30.COO.left(:,i) = phaseCOO_compile.(subject_list{i}).(condition_list{r}).COO.left(1:30);
        phaseCOO_compile.group_one.(condition_list{r}).first30.COO.diff(:,i) = phaseCOO_compile.(subject_list{i}).(condition_list{r}).COO.diff(1:30);
        phaseCOO_compile.group_one.(condition_list{r}).first30.phasing(:,i) = phaseCOO_compile.(subject_list{i}).(condition_list{r}).phasing(1:30);
    end
end

%% Pull out first 30 strides

for i = 1:length(subject_list)
    for r = 1:length(condition_list)
        phaseCOO_compile.group_one.(condition_list{r}).first30.COO.right(:,i) = phaseCOO_compile.(subject_list{i}).(condition_list{r}).COO.right(1:30);
        phaseCOO_compile.group_one.(condition_list{r}).first30.COO.left(:,i) = phaseCOO_compile.(subject_list{i}).(condition_list{r}).COO.left(1:30);
        phaseCOO_compile.group_one.(condition_list{r}).first30.COO.diff(:,i) = phaseCOO_compile.(subject_list{i}).(condition_list{r}).COO.diff(1:30);
        phaseCOO_compile.group_one.(condition_list{r}).first30.phasing(:,i) = phaseCOO_compile.(subject_list{i}).(condition_list{r}).phasing(1:30);
        %phaseCOO_compile.group_one.(condition_list{r}).last30.phase_shift(:,i) = phaseCOO_compile.(subject_list{i}).(condition_list{r}).phase_mean(end-29:end);
    end
end
%% Average the last 30 strides

for r = 1:length(condition_list)
    for j = 1:length(phaseCOO_compile.group_one.AcceleratingHS.last30.COO.diff) % change back to AcceleratingHS
        phaseCOO_compile.group_one.(condition_list{r}).averages.last30.COO.right(j,1) = mean(nonzeros(phaseCOO_compile.group_one.(condition_list{r}).last30.COO.right(j,:)));
        phaseCOO_compile.group_one.(condition_list{r}).averages.last30.COO.left(j,1) = mean(nonzeros(phaseCOO_compile.group_one.(condition_list{r}).last30.COO.left(j,:)));
        phaseCOO_compile.group_one.(condition_list{r}).averages.last30.COO.diff(j,1) = mean(nonzeros(phaseCOO_compile.group_one.(condition_list{r}).last30.COO.diff(j,:)));
        phaseCOO_compile.group_one.(condition_list{r}).averages.last30.phasing(j,1) = mean(nonzeros(phaseCOO_compile.group_one.(condition_list{r}).last30.phasing(j,:)));
        %phaseCOO_compile.group_one.(condition_list{r}).averages.last30.phase_shift(j,1) = mean(nonzeros(phaseCOO_compile.group_one.(condition_list{r}).last30.phase_shift(j,:)));
    end
end

%% Average first 30 strides

for r = 1:length(condition_list)
    for j = 1:length(phaseCOO_compile.group_one.AcceleratingHS.first30.COO.diff) % change back to AcceleratingHS
        phaseCOO_compile.group_one.(condition_list{r}).averages.first30.COO.right(j,1) = mean(nonzeros(phaseCOO_compile.group_one.(condition_list{r}).first30.COO.right(j,:)));
        phaseCOO_compile.group_one.(condition_list{r}).averages.first30.COO.left(j,1) = mean(nonzeros(phaseCOO_compile.group_one.(condition_list{r}).first30.COO.left(j,:)));
        phaseCOO_compile.group_one.(condition_list{r}).averages.first30.COO.diff(j,1) = mean(nonzeros(phaseCOO_compile.group_one.(condition_list{r}).first30.COO.diff(j,:)));
        phaseCOO_compile.group_one.(condition_list{r}).averages.first30.phasing(j,1) = mean(nonzeros(phaseCOO_compile.group_one.(condition_list{r}).first30.phasing(j,:)));
        %phaseCOO_compile.group_one.(condition_list{r}).averages.last30.phase_shift(j,1) = mean(nonzeros(phaseCOO_compile.group_one.(condition_list{r}).last30.phase_shift(j,:)));
    end
end

%% Average sem of the last 30 strides

for r = 1:length(condition_list)
    for j = 1:length(phaseCOO_compile.group_one.AcceleratingHS.last30.COO.diff) % Change back to AcceleratingHS
        phaseCOO_compile.group_one.(condition_list{r}).sem.last30.COO.right(j,1) = std(nonzeros(phaseCOO_compile.group_one.(condition_list{r}).last30.COO.right(j,:)))./sqrt(10);
        phaseCOO_compile.group_one.(condition_list{r}).sem.last30.COO.left(j,1) = std(nonzeros(phaseCOO_compile.group_one.(condition_list{r}).last30.COO.left(j,:)))./sqrt(10);
        phaseCOO_compile.group_one.(condition_list{r}).sem.last30.COO.diff(j,1) = std(nonzeros(phaseCOO_compile.group_one.(condition_list{r}).last30.COO.diff(j,:)))./sqrt(10);
        phaseCOO_compile.group_one.(condition_list{r}).sem.last30.phasing(j,1) = std(nonzeros(phaseCOO_compile.group_one.(condition_list{r}).last30.phasing(j,:)))./sqrt(10);
        %phaseCOO_compile.group_one.(condition_list{r}).sem.last30.phase_shift(j,1) = std(nonzeros(phaseCOO_compile.group_one.(condition_list{r}).last30.phase_shift(j,:)))./sqrt(10);
    end
end

%% Overall last30 SEM and average

for r = 1:length(condition_list)
    phaseCOO_compile.group_one.(condition_list{r}).total_average.last30.COO.right = mean(nonzeros(phaseCOO_compile.group_one.(condition_list{r}).last30.COO.right));
    phaseCOO_compile.group_one.(condition_list{r}).total_average.last30.COO.left = mean(nonzeros(phaseCOO_compile.group_one.(condition_list{r}).last30.COO.left));
    phaseCOO_compile.group_one.(condition_list{r}).total_average.last30.COO.diff = mean(nonzeros(phaseCOO_compile.group_one.(condition_list{r}).last30.COO.diff));
    phaseCOO_compile.group_one.(condition_list{r}).total_average.last30.phasing = mean(nonzeros(phaseCOO_compile.group_one.(condition_list{r}).last30.phasing));
    %phaseCOO_compile.group_one.(condition_list{r}).total_average.last30.phase_shift = mean(nonzeros(phaseCOO_compile.group_one.(condition_list{r}).last30.phase_shift));

    phaseCOO_compile.group_one.(condition_list{r}).total_sem.last30.COO.right = std(nonzeros(phaseCOO_compile.group_one.(condition_list{r}).last30.COO.right))./sqrt(10);
    phaseCOO_compile.group_one.(condition_list{r}).total_sem.last30.COO.left = std(nonzeros(phaseCOO_compile.group_one.(condition_list{r}).last30.COO.left))./sqrt(10);
    phaseCOO_compile.group_one.(condition_list{r}).total_sem.last30.COO.diff = std(nonzeros(phaseCOO_compile.group_one.(condition_list{r}).last30.COO.diff))./sqrt(10);
    phaseCOO_compile.group_one.(condition_list{r}).total_sem.last30.phasing = std(nonzeros(phaseCOO_compile.group_one.(condition_list{r}).last30.phasing))./sqrt(10);
    %phaseCOO_compile.group_one.(condition_list{r}).total_sem.last30.phase_shift = std(nonzeros(phaseCOO_compile.group_one.(condition_list{r}).last30.phase_shift))./sqrt(10);
end

%% Overall first 30 average

for r = 1:length(condition_list)
    phaseCOO_compile.group_one.(condition_list{r}).total_average.first30.COO.right = mean(nonzeros(phaseCOO_compile.group_one.(condition_list{r}).first30.COO.right));
    phaseCOO_compile.group_one.(condition_list{r}).total_average.first30.COO.left = mean(nonzeros(phaseCOO_compile.group_one.(condition_list{r}).first30.COO.left));
    phaseCOO_compile.group_one.(condition_list{r}).total_average.first30.COO.diff = mean(nonzeros(phaseCOO_compile.group_one.(condition_list{r}).first30.COO.diff));
    phaseCOO_compile.group_one.(condition_list{r}).total_average.first30.phasing = mean(nonzeros(phaseCOO_compile.group_one.(condition_list{r}).first30.phasing));
    %phaseCOO_compile.group_one.(condition_list{r}).total_average.last30.phase_shift = mean(nonzeros(phaseCOO_compile.group_one.(condition_list{r}).last30.phase_shift));

    phaseCOO_compile.group_one.(condition_list{r}).total_sem.first30.COO.right = std(nonzeros(phaseCOO_compile.group_one.(condition_list{r}).first30.COO.right))./sqrt(10);
    phaseCOO_compile.group_one.(condition_list{r}).total_sem.first30.COO.left = std(nonzeros(phaseCOO_compile.group_one.(condition_list{r}).first30.COO.left))./sqrt(10);
    phaseCOO_compile.group_one.(condition_list{r}).total_sem.first30.COO.diff = std(nonzeros(phaseCOO_compile.group_one.(condition_list{r}).first30.COO.diff))./sqrt(10);
    phaseCOO_compile.group_one.(condition_list{r}).total_sem.first30.phasing = std(nonzeros(phaseCOO_compile.group_one.(condition_list{r}).first30.phasing))./sqrt(10);
end

%% Individual averages
for i = 1:length(subject_list)
    for r = 1:length(condition_list)
        indivAvgs.(subject_list{i}).(condition_list{r}).COO.first30.right = mean(nonzeros(phaseCOO_compile.(subject_list{i}).(condition_list{r}).COO.right(1:30)));  
        indivAvgs.(subject_list{i}).(condition_list{r}).COO.first30.left = mean(nonzeros(phaseCOO_compile.(subject_list{i}).(condition_list{r}).COO.left(1:30))); 
        indivAvgs.(subject_list{i}).(condition_list{r}).COO.last30.right = mean(nonzeros(phaseCOO_compile.(subject_list{i}).(condition_list{r}).COO.right(end-29:end)));  
        indivAvgs.(subject_list{i}).(condition_list{r}).COO.last30.left = mean(nonzeros(phaseCOO_compile.(subject_list{i}).(condition_list{r}).COO.left(end-29:end)));

        indivAvgs.(subject_list{i}).(condition_list{r}).COO_diff.first30 = mean(nonzeros(phaseCOO_compile.(subject_list{i}).(condition_list{r}).COO.diff(1:30)));  
        indivAvgs.(subject_list{i}).(condition_list{r}).COO_diff.last30 = mean(nonzeros(phaseCOO_compile.(subject_list{i}).(condition_list{r}).COO.diff(end-29:end)));  

        indivAvgs.(subject_list{i}).(condition_list{r}).phase.first30 = mean(nonzeros(phaseCOO_compile.(subject_list{i}).(condition_list{r}).phasing(1:30)));  
        indivAvgs.(subject_list{i}).(condition_list{r}).phase.last30 = mean(nonzeros(phaseCOO_compile.(subject_list{i}).(condition_list{r}).phasing(end-29:end)));  
    end
end

% save COO.mat
% save phasing.mat
% save phaseCOO_compile.mat
% save indivAvgs

%% Figure code

figure;
jbfill(1:190,phaseCOO_compile.group_one.AcceleratingHS.averages.COO.right' + phaseCOO_compile.group_one.AcceleratingHS.sem.COO.right',phaseCOO_compile.group_one.AcceleratingHS.averages.COO.right' - phaseCOO_compile.group_one.AcceleratingHS.sem.COO.right',[1 0.6 0.6],[1 0.6 0.6],1,1);
hold on;
c = plot(phaseCOO_compile.group_one.AcceleratingHS.averages.COO.right,'r');
hold on;
jbfill(1:190,phaseCOO_compile.group_one.AcceleratingHS.averages.COO.left' + phaseCOO_compile.group_one.AcceleratingHS.sem.COO.left',phaseCOO_compile.group_one.AcceleratingHS.averages.COO.left' - phaseCOO_compile.group_one.AcceleratingHS.sem.COO.left',[0.6 0.6 1],[0.6 0.6 1],1,1);
hold on;
c = plot(phaseCOO_compile.group_one.AcceleratingHS.averages.COO.left,'b');
hold on;
xlabel('stride number')
ylabel('Center of Oscillation')
title('AcceleratingHS')
xlim([0 200])
ylim([0 10]) 
z = scatter(195,(phaseCOO_compile.group_one.AcceleratingHS.total_average.last30.COO.right), 'MarkerEdgeColor',[1 0 0]);
t = errorbar(195,phaseCOO_compile.group_one.AcceleratingHS.total_average.last30.COO.right,phaseCOO_compile.group_one.AcceleratingHS.total_sem.last30.COO.right);
t.Color = '#FF0000';
z = scatter(195,(phaseCOO_compile.group_one.AcceleratingHS.total_average.last30.COO.left), 'MarkerEdgeColor',[0 0 1]);
t = errorbar(195,phaseCOO_compile.group_one.AcceleratingHS.total_average.last30.COO.left,phaseCOO_compile.group_one.AcceleratingHS.total_sem.last30.COO.left);
t.Color = '#0000FF';
%saveas(gcf, 'C:\Users\hallbl\OneDrive - Kennedy Krieger\Control Study\Updated\Graphs\Manuscript Figures\Time_series\Interlimb Paper\Center of Oscillation\AcceleratingHS.svg');

figure;
jbfill(1:190,phaseCOO_compile.group_one.DeceleratingHS.averages.COO.right' + phaseCOO_compile.group_one.DeceleratingHS.sem.COO.right',phaseCOO_compile.group_one.DeceleratingHS.averages.COO.right' - phaseCOO_compile.group_one.DeceleratingHS.sem.COO.right',[1 0.6 0.6],[1 0.6 0.6],1,1);
hold on;
c = plot(phaseCOO_compile.group_one.DeceleratingHS.averages.COO.right,'r');
hold on;
jbfill(1:190,phaseCOO_compile.group_one.DeceleratingHS.averages.COO.left' + phaseCOO_compile.group_one.DeceleratingHS.sem.COO.left',phaseCOO_compile.group_one.DeceleratingHS.averages.COO.left' - phaseCOO_compile.group_one.DeceleratingHS.sem.COO.left',[0.6 0.6 1],[0.6 0.6 1],1,1);
hold on;
c = plot(phaseCOO_compile.group_one.DeceleratingHS.averages.COO.left,'b');
hold on;
xlabel('stride number')
ylabel('Center of Oscillation')
title('DeceleratingHS')
xlim([0 200])
ylim([0 10])
z = scatter(195,(phaseCOO_compile.group_one.DeceleratingHS.total_average.last30.COO.right), 'MarkerEdgeColor',[1 0 0]);
t = errorbar(195,phaseCOO_compile.group_one.DeceleratingHS.total_average.last30.COO.right,phaseCOO_compile.group_one.DeceleratingHS.total_sem.last30.COO.right);
t.Color = '#FF0000';
z = scatter(195,(phaseCOO_compile.group_one.DeceleratingHS.total_average.last30.COO.left), 'MarkerEdgeColor',[0 0 1]);
t = errorbar(195,phaseCOO_compile.group_one.DeceleratingHS.total_average.last30.COO.left,phaseCOO_compile.group_one.DeceleratingHS.total_sem.last30.COO.left);
t.Color = '#0000FF';
%saveas(gcf, 'C:\Users\hallbl\OneDrive - Kennedy Krieger\Control Study\Updated\Graphs\Manuscript Figures\Time_series\Interlimb Paper\Center of Oscillation\DeceleratingHS.svg');

figure;
jbfill(1:190,phaseCOO_compile.group_one.FastHS.averages.COO.right' + phaseCOO_compile.group_one.FastHS.sem.COO.right',phaseCOO_compile.group_one.FastHS.averages.COO.right' - phaseCOO_compile.group_one.FastHS.sem.COO.right',[1 0.6 0.6],[1 0.6 0.6],1,1);
hold on;
c = plot(phaseCOO_compile.group_one.FastHS.averages.COO.right,'r');
hold on;
jbfill(1:190,phaseCOO_compile.group_one.FastHS.averages.COO.left' + phaseCOO_compile.group_one.FastHS.sem.COO.left',phaseCOO_compile.group_one.FastHS.averages.COO.left' - phaseCOO_compile.group_one.FastHS.sem.COO.left',[0.6 0.6 1],[0.6 0.6 1],1,1);
hold on;
c = plot(phaseCOO_compile.group_one.FastHS.averages.COO.left,'b');
hold on;
xlabel('stride number')
ylabel('Center of Oscillation')
title('FastHS')
xlim([0 200])
ylim([0 10])
z = scatter(195,(phaseCOO_compile.group_one.FastHS.total_average.last30.COO.right), 'MarkerEdgeColor',[1 0 0]);
t = errorbar(195,phaseCOO_compile.group_one.FastHS.total_average.last30.COO.right,phaseCOO_compile.group_one.FastHS.total_sem.last30.COO.right);
t.Color = '#FF0000';
z = scatter(195,(phaseCOO_compile.group_one.FastHS.total_average.last30.COO.left), 'MarkerEdgeColor',[0 0 1]);
t = errorbar(195,phaseCOO_compile.group_one.FastHS.total_average.last30.COO.left,phaseCOO_compile.group_one.FastHS.total_sem.last30.COO.left);
t.Color = '#0000FF';
%saveas(gcf, 'C:\Users\hallbl\OneDrive - Kennedy Krieger\Control Study\Updated\Graphs\Manuscript Figures\Time_series\Interlimb Paper\Center of Oscillation\FastHS.svg');

figure;
jbfill(1:190,phaseCOO_compile.group_one.SlowHS.averages.COO.right' + phaseCOO_compile.group_one.SlowHS.sem.COO.right',phaseCOO_compile.group_one.SlowHS.averages.COO.right' - phaseCOO_compile.group_one.SlowHS.sem.COO.right',[1 0.6 0.6],[1 0.6 0.6],1,1);
hold on;
c = plot(phaseCOO_compile.group_one.SlowHS.averages.COO.right,'r');
hold on;
jbfill(1:190,phaseCOO_compile.group_one.SlowHS.averages.COO.left' + phaseCOO_compile.group_one.SlowHS.sem.COO.left',phaseCOO_compile.group_one.SlowHS.averages.COO.left' - phaseCOO_compile.group_one.SlowHS.sem.COO.left',[0.6 0.6 1],[0.6 0.6 1],1,1);
hold on;
c = plot(phaseCOO_compile.group_one.SlowHS.averages.COO.left,'b');
hold on;
xlabel('stride number')
ylabel('Center of Oscillation')
title('SlowHS')
xlim([0 200])
ylim([0 10])
z = scatter(195,(phaseCOO_compile.group_one.SlowHS.total_average.last30.COO.right), 'MarkerEdgeColor',[1 0 0]);
t = errorbar(195,phaseCOO_compile.group_one.SlowHS.total_average.last30.COO.right,phaseCOO_compile.group_one.SlowHS.total_sem.last30.COO.right);
t.Color = '#FF0000';
z = scatter(195,(phaseCOO_compile.group_one.SlowHS.total_average.last30.COO.left), 'MarkerEdgeColor',[0 0 1]);
t = errorbar(195,phaseCOO_compile.group_one.SlowHS.total_average.last30.COO.left,phaseCOO_compile.group_one.SlowHS.total_sem.last30.COO.left);
t.Color = '#0000FF';
%saveas(gcf, 'C:\Users\hallbl\OneDrive - Kennedy Krieger\Control Study\Updated\Graphs\Manuscript Figures\Time_series\Interlimb Paper\Center of Oscillation\SlowHS.svg');

figure;
jbfill(1:190,phaseCOO_compile.group_one.AcceleratingHS.averages.phasing' + phaseCOO_compile.group_one.AcceleratingHS.sem.phasing',phaseCOO_compile.group_one.AcceleratingHS.averages.phasing' - phaseCOO_compile.group_one.AcceleratingHS.sem.phasing',[0.7 0.7 0.7],[0.7 0.7 0.7],1,1);
hold on;
c = plot(phaseCOO_compile.group_one.AcceleratingHS.averages.phasing,'k');
hold on;
xlabel('stride number')
ylabel('Phasing')
title('AcceleratingHS')
xlim([0 200])
ylim([-0.1 0.1])
z = scatter(195,(phaseCOO_compile.group_one.AcceleratingHS.total_average.last30.phasing), 'MarkerEdgeColor',[0 0 0]);
t = errorbar(195,phaseCOO_compile.group_one.AcceleratingHS.total_average.last30.phasing,phaseCOO_compile.group_one.AcceleratingHS.total_sem.last30.phasing);
t.Color = '#000000';
%saveas(gcf, 'C:\Users\hallbl\OneDrive - Kennedy Krieger\Control Study\Updated\Graphs\Manuscript Figures\Time_series\Interlimb Paper\Phasing\AcceleratingHS.svg');

figure;
jbfill(1:190,phaseCOO_compile.group_one.DeceleratingHS.averages.phasing' + phaseCOO_compile.group_one.DeceleratingHS.sem.phasing',phaseCOO_compile.group_one.DeceleratingHS.averages.phasing' - phaseCOO_compile.group_one.DeceleratingHS.sem.phasing',[0.7 0.7 0.7],[0.7 0.7 0.7],1,1);
hold on;
c = plot(phaseCOO_compile.group_one.DeceleratingHS.averages.phasing,'k');
hold on;
xlabel('stride number')
ylabel('Phasing')
title('DeceleratingHS')
xlim([0 200])
ylim([-0.1 0.1])
z = scatter(195,(phaseCOO_compile.group_one.DeceleratingHS.total_average.last30.phasing), 'MarkerEdgeColor',[0 0 0]);
t = errorbar(195,phaseCOO_compile.group_one.DeceleratingHS.total_average.last30.phasing,phaseCOO_compile.group_one.DeceleratingHS.total_sem.last30.phasing);
t.Color = '#000000';
%saveas(gcf, 'C:\Users\hallbl\OneDrive - Kennedy Krieger\Control Study\Updated\Graphs\Manuscript Figures\Time_series\Interlimb Paper\Phasing\DeceleratingHS.svg');

figure;
jbfill(1:190,phaseCOO_compile.group_one.FastHS.averages.phasing' + phaseCOO_compile.group_one.FastHS.sem.phasing',phaseCOO_compile.group_one.FastHS.averages.phasing' - phaseCOO_compile.group_one.FastHS.sem.phasing',[0.7 0.7 0.7],[0.7 0.7 0.7],1,1);
hold on;
c = plot(phaseCOO_compile.group_one.FastHS.averages.phasing,'k');
hold on;
xlabel('stride number')
ylabel('Phasing')
title('FastHS')
xlim([0 200])
ylim([-0.1 0.1])
z = scatter(195,(phaseCOO_compile.group_one.FastHS.total_average.last30.phasing), 'MarkerEdgeColor',[0 0 0]);
t = errorbar(195,phaseCOO_compile.group_one.FastHS.total_average.last30.phasing,phaseCOO_compile.group_one.FastHS.total_sem.last30.phasing);
t.Color = '#000000';
%saveas(gcf, 'C:\Users\hallbl\OneDrive - Kennedy Krieger\Control Study\Updated\Graphs\Manuscript Figures\Time_series\Interlimb Paper\Phasing\FastHS.svg');

figure;
jbfill(1:190,phaseCOO_compile.group_one.SlowHS.averages.phasing' + phaseCOO_compile.group_one.SlowHS.sem.phasing',phaseCOO_compile.group_one.SlowHS.averages.phasing' - phaseCOO_compile.group_one.SlowHS.sem.phasing',[0.7 0.7 0.7],[0.7 0.7 0.7],1,1);
hold on;
c = plot(phaseCOO_compile.group_one.SlowHS.averages.phasing,'k');
hold on;
xlabel('stride number')
ylabel('Phasing')
title('SlowHS')
xlim([0 200])
ylim([-0.1 0.1])
z = scatter(195,(phaseCOO_compile.group_one.SlowHS.total_average.last30.phasing), 'MarkerEdgeColor',[0 0 0]);
t = errorbar(195,phaseCOO_compile.group_one.SlowHS.total_average.last30.phasing,phaseCOO_compile.group_one.SlowHS.total_sem.last30.phasing);
t.Color = '#000000';
%saveas(gcf, 'C:\Users\hallbl\OneDrive - Kennedy Krieger\Control Study\Updated\Graphs\Manuscript Figures\Time_series\Interlimb Paper\Phasing\SlowHS.svg');

figure;
jbfill(1:190,phaseCOO_compile.group_one.AcceleratingHS.averages.phase_shift' + phaseCOO_compile.group_one.AcceleratingHS.sem.phase_shift',phaseCOO_compile.group_one.AcceleratingHS.averages.phase_shift' - phaseCOO_compile.group_one.AcceleratingHS.sem.phase_shift',[0.7 0.7 0.7],[0.7 0.7 0.7],1,1);
hold on;
c = plot(phaseCOO_compile.group_one.AcceleratingHS.averages.phase_shift,'k');
hold on;
xlabel('stride number')
ylabel('phase_shift')
title('AcceleratingHS')
xlim([0 200])
ylim([-0.2 0.35])
z = scatter(195,(phaseCOO_compile.group_one.AcceleratingHS.total_average.last30.phase_shift), 'MarkerEdgeColor',[0 0 0]);
t = errorbar(195,phaseCOO_compile.group_one.AcceleratingHS.total_average.last30.phase_shift,phaseCOO_compile.group_one.AcceleratingHS.total_sem.last30.phase_shift);
t.Color = '#000000';
% saveas(gcf, 'C:\Users\hallbl\OneDrive - Kennedy Krieger\Control Study\Updated\Graphs\Manuscript Figures\Time_series\Interlimb Paper\phase_shift\AcceleratingHS.svg');
% 
% figure;
% jbfill(1:190,phaseCOO_compile.group_one.DeceleratingHS.averages.phase_shift' + phaseCOO_compile.group_one.DeceleratingHS.sem.phase_shift',phaseCOO_compile.group_one.DeceleratingHS.averages.phase_shift' - phaseCOO_compile.group_one.DeceleratingHS.sem.phase_shift',[0.7 0.7 0.7],[0.7 0.7 0.7],1,1);
% hold on;
% c = plot(phaseCOO_compile.group_one.DeceleratingHS.averages.phase_shift,'k');
% hold on;
% xlabel('stride number')
% ylabel('phase_shift')
% title('DeceleratingHS')
% xlim([0 200])
% ylim([-0.2 0.35])
% z = scatter(195,(phaseCOO_compile.group_one.DeceleratingHS.total_average.last30.phase_shift), 'MarkerEdgeColor',[0 0 0]);
% t = errorbar(195,phaseCOO_compile.group_one.DeceleratingHS.total_average.last30.phase_shift,phaseCOO_compile.group_one.DeceleratingHS.total_sem.last30.phase_shift);
% t.Color = '#000000';
% saveas(gcf, 'C:\Users\hallbl\OneDrive - Kennedy Krieger\Control Study\Updated\Graphs\Manuscript Figures\Time_series\Interlimb Paper\phase_shift\DeceleratingHS.svg');
% 
% figure;
% jbfill(1:190,phaseCOO_compile.group_one.FastHS.averages.phase_shift' + phaseCOO_compile.group_one.FastHS.sem.phase_shift',phaseCOO_compile.group_one.FastHS.averages.phase_shift' - phaseCOO_compile.group_one.FastHS.sem.phase_shift',[0.7 0.7 0.7],[0.7 0.7 0.7],1,1);
% hold on;
% c = plot(phaseCOO_compile.group_one.FastHS.averages.phase_shift,'k');
% hold on;
% xlabel('stride number')
% ylabel('phase_shift')
% title('FastHS')
% xlim([0 200])
% ylim([-0.2 0.35])
% z = scatter(195,(phaseCOO_compile.group_one.FastHS.total_average.last30.phase_shift), 'MarkerEdgeColor',[0 0 0]);
% t = errorbar(195,phaseCOO_compile.group_one.FastHS.total_average.last30.phase_shift,phaseCOO_compile.group_one.FastHS.total_sem.last30.phase_shift);
% t.Color = '#000000';
% saveas(gcf, 'C:\Users\hallbl\OneDrive - Kennedy Krieger\Control Study\Updated\Graphs\Manuscript Figures\Time_series\Interlimb Paper\phase_shift\FastHS.svg');
% 
% figure;
% jbfill(1:190,phaseCOO_compile.group_one.SlowHS.averages.phase_shift' + phaseCOO_compile.group_one.SlowHS.sem.phase_shift',phaseCOO_compile.group_one.SlowHS.averages.phase_shift' - phaseCOO_compile.group_one.SlowHS.sem.phase_shift',[0.7 0.7 0.7],[0.7 0.7 0.7],1,1);
% hold on;
% c = plot(phaseCOO_compile.group_one.SlowHS.averages.phase_shift,'k');
% hold on;
% xlabel('stride number')
% ylabel('phase_shift')
% title('SlowHS')
% xlim([0 200])
% ylim([-0.2 0.35])
% z = scatter(195,(phaseCOO_compile.group_one.SlowHS.total_average.last30.phase_shift), 'MarkerEdgeColor',[0 0 0]);
% t = errorbar(195,phaseCOO_compile.group_one.SlowHS.total_average.last30.phase_shift,phaseCOO_compile.group_one.SlowHS.total_sem.last30.phase_shift);
% t.Color = '#000000';
% saveas(gcf, 'C:\Users\hallbl\OneDrive - Kennedy Krieger\Control Study\Updated\Graphs\Manuscript Figures\Time_series\Interlimb Paper\phase_shift\SlowHS.svg');

figure;
jbfill(1:190,phaseCOO_compile.group_one.AcceleratingHS.averages.COO.diff' + phaseCOO_compile.group_one.AcceleratingHS.sem.COO.diff',phaseCOO_compile.group_one.AcceleratingHS.averages.COO.diff' - phaseCOO_compile.group_one.AcceleratingHS.sem.COO.diff',[0.7 0.7 0.7],[0.7 0.7 0.7],1,1);
hold on;
c = plot(phaseCOO_compile.group_one.AcceleratingHS.averages.COO.diff,'k');
hold on;
xlabel('stride number')
ylabel('Center of Oscillation Difference')
title('AcceleratingHS')
xlim([0 200])
ylim([-6 8])
z = scatter(195,(phaseCOO_compile.group_one.AcceleratingHS.total_average.last30.COO.diff), 'MarkerEdgeColor',[0 0 0]);
t = errorbar(195,phaseCOO_compile.group_one.AcceleratingHS.total_average.last30.COO.diff,phaseCOO_compile.group_one.AcceleratingHS.total_sem.last30.COO.diff);
t.Color = '#000000';
saveas(gcf, 'C:\Users\hallbl\OneDrive - Kennedy Krieger\Control Study\Updated\Graphs\Manuscript Figures\Time_series\Interlimb Paper\Center of Oscillation Difference\AcceleratingHS.svg');

figure;
jbfill(1:190,phaseCOO_compile.group_one.DeceleratingHS.averages.COO.diff' + phaseCOO_compile.group_one.DeceleratingHS.sem.COO.diff',phaseCOO_compile.group_one.DeceleratingHS.averages.COO.diff' - phaseCOO_compile.group_one.DeceleratingHS.sem.COO.diff',[0.7 0.7 0.7],[0.7 0.7 0.7],1,1);
hold on;
c = plot(phaseCOO_compile.group_one.DeceleratingHS.averages.COO.diff,'k');
hold on;
xlabel('stride number')
ylabel('Center of Oscillation Difference')
title('DeceleratingHS')
xlim([0 200])
ylim([-6 8])
z = scatter(195,(phaseCOO_compile.group_one.DeceleratingHS.total_average.last30.COO.diff), 'MarkerEdgeColor',[0 0 0]);
t = errorbar(195,phaseCOO_compile.group_one.DeceleratingHS.total_average.last30.COO.diff,phaseCOO_compile.group_one.DeceleratingHS.total_sem.last30.COO.diff);
t.Color = '#000000';
saveas(gcf, 'C:\Users\hallbl\OneDrive - Kennedy Krieger\Control Study\Updated\Graphs\Manuscript Figures\Time_series\Interlimb Paper\Center of Oscillation Difference\DeceleratingHS.svg');

figure;
jbfill(1:190,phaseCOO_compile.group_one.FastHS.averages.COO.diff' + phaseCOO_compile.group_one.FastHS.sem.COO.diff',phaseCOO_compile.group_one.FastHS.averages.COO.diff' - phaseCOO_compile.group_one.FastHS.sem.COO.diff',[0.7 0.7 0.7],[0.7 0.7 0.7],1,1);
hold on;
c = plot(phaseCOO_compile.group_one.FastHS.averages.COO.diff,'k');
hold on;
xlabel('stride number')
ylabel('Center of Oscillation Difference')
title('FastHS')
xlim([0 200])
ylim([-6 8])
z = scatter(195,(phaseCOO_compile.group_one.FastHS.total_average.last30.COO.diff), 'MarkerEdgeColor',[0 0 0]);
t = errorbar(195,phaseCOO_compile.group_one.FastHS.total_average.last30.COO.diff,phaseCOO_compile.group_one.FastHS.total_sem.last30.COO.diff);
t.Color = '#000000';
saveas(gcf, 'C:\Users\hallbl\OneDrive - Kennedy Krieger\Control Study\Updated\Graphs\Manuscript Figures\Time_series\Interlimb Paper\Center of Oscillation Difference\FastHS.svg');

figure;
jbfill(1:190,phaseCOO_compile.group_one.SlowHS.averages.COO.diff' + phaseCOO_compile.group_one.SlowHS.sem.COO.diff',phaseCOO_compile.group_one.SlowHS.averages.COO.diff' - phaseCOO_compile.group_one.SlowHS.sem.COO.diff',[0.7 0.7 0.7],[0.7 0.7 0.7],1,1);
hold on;
c = plot(phaseCOO_compile.group_one.SlowHS.averages.COO.diff,'k');
hold on;
xlabel('stride number')
ylabel('Center of Oscillation Difference')
title('SlowHS')
xlim([0 200])
ylim([-6 8])
z = scatter(195,(phaseCOO_compile.group_one.SlowHS.total_average.last30.COO.diff), 'MarkerEdgeColor',[0 0 0]);
t = errorbar(195,phaseCOO_compile.group_one.SlowHS.total_average.last30.COO.diff,phaseCOO_compile.group_one.SlowHS.total_sem.last30.COO.diff);
t.Color = '#000000';
saveas(gcf, 'C:\Users\hallbl\OneDrive - Kennedy Krieger\Control Study\Updated\Graphs\Manuscript Figures\Time_series\Interlimb Paper\Center of Oscillation Difference\SlowHS.svg');
