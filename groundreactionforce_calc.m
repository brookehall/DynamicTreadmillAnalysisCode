%% Load in each participant's force file
for ii = 1:length(group_one)
    for rr = 1:length(trials)
        data = load(['C:\Users\hallbl\OneDrive - Kennedy Krieger\Control Study\Updated\',(group_one{ii}),'\New Session\',(trials{rr}),'_forces_forces.mat']);
        grf.(group_one{ii}).(trials{rr}).norm_cycles.right = data.output.norm_cycles.forces.right_force.x_avg_all;
        grf.(group_one{ii}).(trials{rr}).norm_cycles.left = data.output.norm_cycles.forces.left_force.x_avg_all;
    end
end

% Calculate group average
for i = 1:length(group_one)
    for r = 1:length(trials)
        for j = 1:101
            grf.group_average.(trials{r}).norm_cycles.right(1,j) = mean(grf.(group_one{i}).(trials{r}).norm_cycles.right(:,j));
            grf.group_average.(trials{r}).norm_cycles.left(1,j) = mean(grf.(group_one{i}).(trials{r}).norm_cycles.left(:,j));
        end
    end
end

% Calculate group sem
for i = 1:length(group_one)
    if i ~= 10
        for r = 1:length(trials)
            grf.group_sem.table.(trials{r}).left(i,:) = grf.(group_one{i}).(trials{r}).norm_cycles.left;
            grf.group_sem.table.(trials{r}).right(i,:) = grf.(group_one{i}).(trials{r}).norm_cycles.right;
        end
    end
end

for r = 1:length(trials)
    if r ~= 4
        grf.group_sem.table.(trials{r}).left(10,:) = grf.MLR025.(trials{r}).norm_cycles.left;
        grf.group_sem.table.(trials{r}).right(10,:) = grf.MLR025.(trials{r}).norm_cycles.right;
    end
end

for r = 1:length(trials)
    if r ~= 3
        for j = 1:101
            grf.group_sem.(trials{r}).left(1,j) = std(grf.group_sem.table.(trials{r}).left(:,j))/sqrt(10);
            grf.group_sem.(trials{r}).right(1,j) = std(grf.group_sem.table.(trials{r}).right(:,j))/sqrt(10);
        end
    end
end

for j = 1:101
    grf.group_sem.(trials{3}).left(1,j) = std(grf.group_sem.table.(trials{3}).left(:,j))/sqrt(9);
    grf.group_sem.(trials{3}).right(1,j) = std(grf.group_sem.table.(trials{3}).right(:,j))/sqrt(9);
end

%% Plots

for i = 1:length(group_one)
    for r = 1:length(trials)
        percentage.averages.LHS.(trials{r}) = mean(percentage.RHS_LHS.averages.(group_one{i}).(trials{r}));
        percentage.averages.LTO.(trials{r}) = mean(percentage.RHS_LTO.averages.(group_one{i}).(trials{r}));
        percentage.averages.RTO.(trials{r}) = mean(percentage.RHS_RTO.averages.(group_one{i}).(trials{r}));
    end
end

% SlowHS
figure;
for i = 1:length(group_one)
    p = xline(percentage.averages.LHS.SlowHS,'k');
    hold on;
    t = xline(percentage.averages.LTO.SlowHS,'k');
    hold on;
    m = xline(percentage.averages.RTO.SlowHS,'k');
    hold on;
    b = plot(grf.(group_one{i}).SlowHS.norm_cycles.left);
    b.Color = '#A399FF';
    r = plot(grf.(group_one{i}).SlowHS.norm_cycles.right);
    r.Color = '#FF9999';
    jbfill(1:101,grf.group_average.SlowHS.norm_cycles.left + grf.group_sem.SlowHS.left,grf.group_average.SlowHS.norm_cycles.left - grf.group_sem.SlowHS.left,[0.6 0.6 1],[0.6 0.6 1],1,1);
    hold on;
    x = plot(grf.group_average.SlowHS.norm_cycles.left, 'b');
    hold on;
    jbfill(1:101,grf.group_average.SlowHS.norm_cycles.right + grf.group_sem.SlowHS.right,grf.group_average.SlowHS.norm_cycles.right - grf.group_sem.SlowHS.right,[1 0.6 0.6],[1 0.6 0.6],1,1);
    hold on;
    x = plot(grf.group_average.SlowHS.norm_cycles.right, 'r');
    hold on;
    xlim([-1 102])
    ylim([-0.3 0.3])
    xlabel('% of the gait cycle')
    ylabel('ground reaction force (N)')
    title('SlowHS')
end
saveas(gcf, 'C:\Users\hallbl\OneDrive - Kennedy Krieger\Control Study\Updated\Graphs\Manuscript Figures\Interlimb Paper\Group Ground Reaction Force Plots\Slow.svg');

% FastHS
figure;
for i = 1:length(group_one)
    p = xline(percentage.averages.LHS.FastHS,'k');
    hold on;
    t = xline(percentage.averages.LTO.FastHS,'k');
    hold on;
    m = xline(percentage.averages.RTO.FastHS,'k');
    hold on;
    b = plot(grf.(group_one{i}).FastHS.norm_cycles.left);
    b.Color = '#A399FF';
    r = plot(grf.(group_one{i}).FastHS.norm_cycles.right);
    r.Color = '#FF9999';
    jbfill(1:101,grf.group_average.FastHS.norm_cycles.left + grf.group_sem.FastHS.left,grf.group_average.FastHS.norm_cycles.left - grf.group_sem.FastHS.left,[0.6 0.6 1],[0.6 0.6 1],1,1);
    hold on;
    x = plot(grf.group_average.FastHS.norm_cycles.left, 'b');
    hold on;
    jbfill(1:101,grf.group_average.FastHS.norm_cycles.right + grf.group_sem.FastHS.right,grf.group_average.FastHS.norm_cycles.right - grf.group_sem.FastHS.right,[1 0.6 0.6],[1 0.6 0.6],1,1);
    hold on;
    x = plot(grf.group_average.FastHS.norm_cycles.right, 'r');
    hold on;
    xlim([-1 102])
    ylim([-0.3 0.3])
    xlabel('% of the gait cycle')
    ylabel('ground reaction force (N)')
    title('FastHS')
end
saveas(gcf, 'C:\Users\hallbl\OneDrive - Kennedy Krieger\Control Study\Updated\Graphs\Manuscript Figures\Interlimb Paper\Group Ground Reaction Force Plots\Fast.svg');

% AcceleratingHS
figure;
for i = 1:length(group_one)
    p = xline(percentage.averages.LHS.AcceleratingHS,'k');
    hold on;
    t = xline(percentage.averages.LTO.AcceleratingHS,'k');
    hold on;
    m = xline(percentage.averages.RTO.AcceleratingHS,'k');
    hold on;
    b = plot(grf.(group_one{i}).AcceleratingHS.norm_cycles.left);
    b.Color = '#A399FF';
    r = plot(grf.(group_one{i}).AcceleratingHS.norm_cycles.right);
    r.Color = '#FF9999';
    jbfill(1:101,grf.group_average.AcceleratingHS.norm_cycles.left + grf.group_sem.AcceleratingHS.left,grf.group_average.AcceleratingHS.norm_cycles.left - grf.group_sem.AcceleratingHS.left,[0.6 0.6 1],[0.6 0.6 1],1,1);
    hold on;
    x = plot(grf.group_average.AcceleratingHS.norm_cycles.left, 'b');
    hold on;
    jbfill(1:101,grf.group_average.AcceleratingHS.norm_cycles.right + grf.group_sem.AcceleratingHS.right,grf.group_average.AcceleratingHS.norm_cycles.right - grf.group_sem.AcceleratingHS.right,[1 0.6 0.6],[1 0.6 0.6],1,1);
    hold on;
    x = plot(grf.group_average.AcceleratingHS.norm_cycles.right, 'r');
    hold on;
    xlim([-1 102])
    ylim([-0.3 0.3])
    xlabel('% of the gait cycle')
    ylabel('ground reaction force (N)')
    title('AcceleratingHS')
end
saveas(gcf, 'C:\Users\hallbl\OneDrive - Kennedy Krieger\Control Study\Updated\Graphs\Manuscript Figures\Interlimb Paper\Group Ground Reaction Force Plots\Accelerate.svg');

% DeceleratingHS
figure;
for i = 1:length(group_one)
    p = xline(percentage.averages.LHS.DeceleratingHS,'k');
    hold on;
    t = xline(percentage.averages.LTO.DeceleratingHS,'k');
    hold on;
    m = xline(percentage.averages.RTO.DeceleratingHS,'k');
    hold on;
    b = plot(grf.(group_one{i}).DeceleratingHS.norm_cycles.left);
    b.Color = '#A399FF';
    r = plot(grf.(group_one{i}).DeceleratingHS.norm_cycles.right);
    r.Color = '#FF9999';
    jbfill(1:101,grf.group_average.DeceleratingHS.norm_cycles.left + grf.group_sem.DeceleratingHS.left,grf.group_average.DeceleratingHS.norm_cycles.left - grf.group_sem.DeceleratingHS.left,[0.6 0.6 1],[0.6 0.6 1],1,1);
    hold on;
    x = plot(grf.group_average.DeceleratingHS.norm_cycles.left, 'b');
    hold on;
    jbfill(1:101,grf.group_average.DeceleratingHS.norm_cycles.right + grf.group_sem.DeceleratingHS.right,grf.group_average.DeceleratingHS.norm_cycles.right - grf.group_sem.DeceleratingHS.right,[1 0.6 0.6],[1 0.6 0.6],1,1);
    hold on;
    x = plot(grf.group_average.DeceleratingHS.norm_cycles.right, 'r');
    hold on;
    xlim([-1 102])
    ylim([-0.3 0.3])
    xlabel('% of the gait cycle')
    ylabel('ground reaction force (N)')
    title('DeceleratingHS')
end
saveas(gcf, 'C:\Users\hallbl\OneDrive - Kennedy Krieger\Control Study\Updated\Graphs\Manuscript Figures\Interlimb Paper\Group Ground Reaction Force Plots\Decelerate.svg');