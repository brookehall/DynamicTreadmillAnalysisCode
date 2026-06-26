clear; clc;

%% load in relevant data

load("C:\Users\hallbl\OneDrive - Kennedy Krieger\Control Study\Updated\Data Files\data_compile.mat")
load("C:\Users\hallbl\OneDrive - Kennedy Krieger\Control Study\Updated\Data Files\averages.mat")
load("C:\Users\hallbl\OneDrive - Kennedy Krieger\Control Study\Updated\Data Files\asymmetries_2025June11.mat")
load("C:\Users\hallbl\OneDrive - Kennedy Krieger\Control Study\Updated\Data Files\phaseCOO_compile.mat")

%% Make scatter plots

% Swing time and phasing
for i = 1:length(subject_list)
    swingtime_slow(i,1) = asymmetries.(subject_list{i}).SlowHS.swing_time.last30;
    swingtime_fast(i,1) = asymmetries.(subject_list{i}).FastHS.swing_time.last30;
    swingtime_acc(i,1) = asymmetries.(subject_list{i}).AcceleratingHS.swing_time.last30;
    swingtime_dec(i,1) = asymmetries.(subject_list{i}).DeceleratingHS.swing_time.last30;
end

swingtime = [swingtime_slow,swingtime_fast,swingtime_acc,swingtime_dec];

for i = 1:length(subject_list)
    phasing_slow(i,1) = mean(nonzeros(phaseCOO_compile.(subject_list{i}).SlowHS.phasing(end-29:end)));
    phasing_fast(i,1) = mean(nonzeros(phaseCOO_compile.(subject_list{i}).FastHS.phasing(end-29:end)));
    phasing_acc(i,1) = mean(nonzeros(phaseCOO_compile.(subject_list{i}).AcceleratingHS.phasing(end-29:end)));
    phasing_dec(i,1) = mean(nonzeros(phaseCOO_compile.(subject_list{i}).DeceleratingHS.phasing(end-29:end)));
end

phasing = [phasing_slow,phasing_fast,phasing_acc,phasing_dec];

for i = 1:length(subject_list)
    coo_slow(i,1) = indivAvgs.(subject_list{i}).SlowHS.COO_diff.last30;
    coo_fast(i,1) = indivAvgs.(subject_list{i}).FastHS.COO_diff.last30;
    coo_acc(i,1) = indivAvgs.(subject_list{i}).AcceleratingHS.COO_diff.last30;
    coo_dec(i,1) = indivAvgs.(subject_list{i}).DeceleratingHS.COO_diff.last30;
end

coo = [coo_slow,coo_fast,coo_acc,coo_dec];

for i = 1:length(subject_list)
    stance_slow(i,1) = asymmetries.(subject_list{i}).SlowHS.stance_time.last30;
    stance_fast(i,1) = asymmetries.(subject_list{i}).FastHS.stance_time.last30;
    stance_acc(i,1) = asymmetries.(subject_list{i}).AcceleratingHS.stance_time.last30;
    stance_dec(i,1) = asymmetries.(subject_list{i}).DeceleratingHS.stance_time.last30;
end

stance = [stance_slow,stance_fast,stance_acc,stance_dec];

for i = 1:length(subject_list)
    dst_slow(i,1) = asymmetries.(subject_list{i}).SlowHS.double_support_time.last30;
    dst_fast(i,1) = asymmetries.(subject_list{i}).FastHS.double_support_time.last30;
    dst_acc(i,1) = asymmetries.(subject_list{i}).AcceleratingHS.double_support_time.last30;
    dst_dec(i,1) = asymmetries.(subject_list{i}).DeceleratingHS.double_support_time.last30;
end

dst = [dst_slow,dst_fast,dst_acc,dst_dec];

for i = 1:length(subject_list)
    lla_slow(i,1) = asymmetries.(subject_list{i}).SlowHS.alpha_angle.last30;
    lla_fast(i,1) = asymmetries.(subject_list{i}).FastHS.alpha_angle.last30;
    lla_acc(i,1) = asymmetries.(subject_list{i}).AcceleratingHS.alpha_angle.last30;
    lla_dec(i,1) = asymmetries.(subject_list{i}).DeceleratingHS.alpha_angle.last30;
end

lla = [lla_slow,lla_fast,lla_acc,lla_dec];

for i = 1:length(subject_list)
    tla_slow(i,1) = asymmetries.(subject_list{i}).SlowHS.beta_angle.last30;
    tla_fast(i,1) = asymmetries.(subject_list{i}).FastHS.beta_angle.last30;
    tla_acc(i,1) = asymmetries.(subject_list{i}).AcceleratingHS.beta_angle.last30;
    tla_dec(i,1) = asymmetries.(subject_list{i}).DeceleratingHS.beta_angle.last30;
end

tla = [tla_slow,tla_fast,tla_acc,tla_dec];

figure;
x = scatter(swingtime,phasing);
x(1).MarkerFaceColor = [0.56 0.8 1];
x(2).MarkerFaceColor = [1 0.46 1];
x(3).MarkerFaceColor = [1 0.69 0.38];
x(4).MarkerFaceColor = [1 0.87 0.46];
xlabel('swing time asymmetry')
ylabel('phase shift')
% xlim([-0.2 0.3])
% ylim([-0.1 0.07])
saveas(gcf, 'C:\Users\hallbl\OneDrive - Kennedy Krieger\Control Study\Updated\Manuscripts\Current\Updated Interlimb Figures\ScatterPlots\swingPhase_2025June11.svg');

figure;
x = scatter(stance,phasing);
x(1).MarkerFaceColor = [0.56 0.8 1];
x(2).MarkerFaceColor = [1 0.46 1];
x(3).MarkerFaceColor = [1 0.69 0.38];
x(4).MarkerFaceColor = [1 0.87 0.46];
xlabel('stance time asymmetry')
ylabel('phase shift')
saveas(gcf, 'C:\Users\hallbl\OneDrive - Kennedy Krieger\Control Study\Updated\Manuscripts\Current\Updated Interlimb Figures\ScatterPlots\stancePhase_2025June11.svg');

figure;
x = scatter(dst,phasing);
x(1).MarkerFaceColor = [0.56 0.8 1];
x(2).MarkerFaceColor = [1 0.46 1];
x(3).MarkerFaceColor = [1 0.69 0.38];
x(4).MarkerFaceColor = [1 0.87 0.46];
xlabel('double support time asymmetry')
ylabel('phase shift')
saveas(gcf, 'C:\Users\hallbl\OneDrive - Kennedy Krieger\Control Study\Updated\Manuscripts\Current\Updated Interlimb Figures\ScatterPlots\dstPhase_2025June11.svg');

figure;
x = scatter(lla,phasing);
x(1).MarkerFaceColor = [0.56 0.8 1];
x(2).MarkerFaceColor = [1 0.46 1];
x(3).MarkerFaceColor = [1 0.69 0.38];
x(4).MarkerFaceColor = [1 0.87 0.46];
xlabel('leading limb angle asymmetry')
ylabel('phase shift')
saveas(gcf, 'C:\Users\hallbl\OneDrive - Kennedy Krieger\Control Study\Updated\Manuscripts\Current\Updated Interlimb Figures\ScatterPlots\llaPhase_2025June11.svg');

figure;
x = scatter(tla,phasing);
x(1).MarkerFaceColor = [0.56 0.8 1];
x(2).MarkerFaceColor = [1 0.46 1];
x(3).MarkerFaceColor = [1 0.69 0.38];
x(4).MarkerFaceColor = [1 0.87 0.46];
xlabel('trailing limb angle asymmetry')
ylabel('phase shift')
saveas(gcf, 'C:\Users\hallbl\OneDrive - Kennedy Krieger\Control Study\Updated\Manuscripts\Current\Updated Interlimb Figures\ScatterPlots\tlaPhase_2025June11.svg');

figure;
scatter(swingtime_slow,phasing_slow, 'MarkerEdgeColor',[0.25 0.65 1], 'MarkerFaceColor', [0.56 0.8 1], 'LineWidth', 0.5)
xlabel('swing time asymmetry')
ylabel('phase shift')
xlim([-0.2 0.3])
ylim([-0.1 0.07])
title("slow")
saveas(gcf, 'C:\Users\hallbl\OneDrive - Kennedy Krieger\Control Study\Updated\Manuscripts\Current\Updated Interlimb Figures\ScatterPlots\swingphaseSlow_2025June11.svg');

figure;
scatter(swingtime_fast,phasing_fast, 'MarkerEdgeColor',[1 0 1], 'MarkerFaceColor', [1 0.46 1], 'LineWidth', 0.5)
xlabel('swing time asymmetry')
ylabel('phase shift')
xlim([-0.2 0.3])
ylim([-0.1 0.07])
title("fast")
saveas(gcf, 'C:\Users\hallbl\OneDrive - Kennedy Krieger\Control Study\Updated\Manuscripts\Current\Updated Interlimb Figures\ScatterPlots\swingphaseFast_2025June11.svg');

figure;
scatter(swingtime_acc,phasing_acc,'MarkerEdgeColor',[1 0.5 0], 'MarkerFaceColor', [1 0.69 0.38], 'LineWidth', 0.5)
xlabel('swing time asymmetry')
ylabel('phase shift')
xlim([-0.2 0.3])
ylim([-0.1 0.07])
title("accelerate")
saveas(gcf, 'C:\Users\hallbl\OneDrive - Kennedy Krieger\Control Study\Updated\Manuscripts\Current\Updated Interlimb Figures\ScatterPlots\swingphaseAcc_2025June11.svg');

figure;
scatter(swingtime_dec,phasing_dec,'MarkerEdgeColor',[1 0.75 0], 'MarkerFaceColor', [1 0.87 0.46], 'LineWidth', 0.5)
xlabel('swing time asymmetry')
ylabel('phase shift')
xlim([-0.2 0.3])
ylim([-0.1 0.07])
title("decelerate")
saveas(gcf, 'C:\Users\hallbl\OneDrive - Kennedy Krieger\Control Study\Updated\Manuscripts\Current\Updated Interlimb Figures\ScatterPlots\swingphaseDec_2025June11.svg');

%% COO & LLA
for i = 1:length(subject_list)
    lla_slow(i,1) = asymmetries.(subject_list{i}).SlowHS.alpha_angle.last30;
    lla_fast(i,1) = asymmetries.(subject_list{i}).FastHS.alpha_angle.last30;
    lla_acc(i,1) = asymmetries.(subject_list{i}).AcceleratingHS.alpha_angle.last30;
    lla_dec(i,1) = asymmetries.(subject_list{i}).DeceleratingHS.alpha_angle.last30;
end

lla = [lla_slow,lla_fast,lla_acc,lla_dec];

for i = 1:length(subject_list)
    stance_slow(i,1) = asymmetries.(subject_list{i}).SlowHS.stance_time.last30;
    stance_fast(i,1) = asymmetries.(subject_list{i}).FastHS.stance_time.last30;
    stance_acc(i,1) = asymmetries.(subject_list{i}).AcceleratingHS.stance_time.last30;
    stance_dec(i,1) = asymmetries.(subject_list{i}).DeceleratingHS.stance_time.last30;
end

stance = [stance_slow,stance_fast,stance_acc,stance_dec];

for i = 1:length(subject_list)
    swing_slow(i,1) = asymmetries.(subject_list{i}).SlowHS.swing_time.last30;
    swing_fast(i,1) =asymmetries.(subject_list{i}).FastHS.swing_time.last30;
    swing_acc(i,1) = asymmetries.(subject_list{i}).AcceleratingHS.swing_time.last30;
    swing_dec(i,1) = asymmetries.(subject_list{i}).DeceleratingHS.swing_time.last30;
end

swing = [swing_slow,swing_fast,swing_acc,swing_dec];

for i = 1:length(subject_list)
    dst_slow(i,1) = asymmetries.(subject_list{i}).SlowHS.double_support_time.last30;
    dst_fast(i,1) = asymmetries.(subject_list{i}).FastHS.double_support_time.last30;
    dst_acc(i,1) = asymmetries.(subject_list{i}).AcceleratingHS.double_support_time.last30;
    dst_dec(i,1) = asymmetries.(subject_list{i}).DeceleratingHS.double_support_time.last30;
end

dst = [dst_slow,dst_fast,dst_acc,dst_dec];

figure;
y = scatter(dst,coo);
y(1).MarkerFaceColor = [0.56 0.8 1];
y(2).MarkerFaceColor = [1 0.46 1];
y(3).MarkerFaceColor = [1 0.69 0.38];
y(4).MarkerFaceColor = [1 0.87 0.46];
xlabel('double support time asymmetry')
ylabel('Center of Oscillation Difference')
saveas(gcf, 'C:\Users\hallbl\OneDrive - Kennedy Krieger\Control Study\Updated\Manuscripts\Current\Updated Interlimb Figures\ScatterPlots\dstCOO_2025June11.svg');

figure;
y = scatter(swing,coo);
y(1).MarkerFaceColor = [0.56 0.8 1];
y(2).MarkerFaceColor = [1 0.46 1];
y(3).MarkerFaceColor = [1 0.69 0.38];
y(4).MarkerFaceColor = [1 0.87 0.46];
xlabel('swing time asymmetry')
ylabel('Center of Oscillation Difference')
saveas(gcf, 'C:\Users\hallbl\OneDrive - Kennedy Krieger\Control Study\Updated\Manuscripts\Current\Updated Interlimb Figures\ScatterPlots\swingCOO_2025June11.svg');

figure;
y = scatter(stance,coo);
y(1).MarkerFaceColor = [0.56 0.8 1];
y(2).MarkerFaceColor = [1 0.46 1];
y(3).MarkerFaceColor = [1 0.69 0.38];
y(4).MarkerFaceColor = [1 0.87 0.46];
xlabel('stance time asymmetry')
ylabel('Center of Oscillation Difference')
saveas(gcf, 'C:\Users\hallbl\OneDrive - Kennedy Krieger\Control Study\Updated\Manuscripts\Current\Updated Interlimb Figures\ScatterPlots\stanceCOO_2025June11.svg');



figure;
y = scatter(lla,coo);
y(1).MarkerFaceColor = [0.56 0.8 1];
y(2).MarkerFaceColor = [1 0.46 1];
y(3).MarkerFaceColor = [1 0.69 0.38];
y(4).MarkerFaceColor = [1 0.87 0.46];
xlabel('leading limb angle asymmetry')
ylabel('Center of Oscillation Difference')
% xlim([-0.6 0.21])
% ylim([-10 20])
saveas(gcf, 'C:\Users\hallbl\OneDrive - Kennedy Krieger\Control Study\Updated\Manuscripts\Current\Updated Interlimb Figures\ScatterPlots\llaCOO_2025June11.svg');

figure;
scatter(lla_slow,coo_slow, 'MarkerEdgeColor',[0.25 0.65 1], 'MarkerFaceColor', [0.56 0.8 1], 'LineWidth', 0.5)
xlabel('leading limb angle asymmetry')
ylabel('center of oscillation difference')
xlim([-0.6 0.21])
ylim([-10 20])
title("slow")
saveas(gcf, 'C:\Users\hallbl\OneDrive - Kennedy Krieger\Control Study\Updated\Manuscripts\Current\Updated Interlimb Figures\ScatterPlots\llacooSlow_2025June11.svg');

figure;
scatter(lla_fast,coo_fast, 'MarkerEdgeColor',[1 0 1], 'MarkerFaceColor', [1 0.46 1], 'LineWidth', 0.5)
xlabel('leading limb angle asymmetry')
ylabel('center of oscillation difference')
xlim([-0.6 0.21])
ylim([-10 20])
title("fast")
saveas(gcf, 'C:\Users\hallbl\OneDrive - Kennedy Krieger\Control Study\Updated\Manuscripts\Current\Updated Interlimb Figures\ScatterPlots\llacooFast_2025June11.svg');

figure;
scatter(lla_acc,coo_acc, 'MarkerEdgeColor',[1 0.5 0], 'MarkerFaceColor', [1 0.69 0.38], 'LineWidth', 0.5)
xlabel('leading limb angle asymmetry')
ylabel('center of oscillation difference')
xlim([-0.6 0.21])
ylim([-10 20])
title("accelerate")
saveas(gcf, 'C:\Users\hallbl\OneDrive - Kennedy Krieger\Control Study\Updated\Manuscripts\Current\Updated Interlimb Figures\ScatterPlots\llacooAcc_2025June11.svg');

figure;
scatter(lla_dec,coo_dec, 'MarkerEdgeColor',[1 0.75 0], 'MarkerFaceColor', [1 0.87 0.46], 'LineWidth', 0.5)
xlabel('leading limb angle asymmetry')
ylabel('center of oscillation difference')
xlim([-0.6 0.21])
ylim([-10 20])
title("decelerate")
saveas(gcf, 'C:\Users\hallbl\OneDrive - Kennedy Krieger\Control Study\Updated\Manuscripts\Current\Updated Interlimb Figures\ScatterPlots\llacooDec_2025June11.svg');

%% COO & TLA
for i = 1:length(subject_list)
    tla_slow(i,1) = asymmetries.(subject_list{i}).SlowHS.beta_angle.last30;
    tla_fast(i,1) = asymmetries.(subject_list{i}).FastHS.beta_angle.last30;
    tla_acc(i,1) = asymmetries.(subject_list{i}).AcceleratingHS.beta_angle.last30;
    tla_dec(i,1) = asymmetries.(subject_list{i}).DeceleratingHS.beta_angle.last30;
end

tla = [tla_slow,tla_fast,tla_acc,tla_dec];

figure;
y = scatter(tla,coo);
y(1).MarkerFaceColor = [0.56 0.8 1];
y(2).MarkerFaceColor = [1 0.46 1];
y(3).MarkerFaceColor = [1 0.69 0.38];
y(4).MarkerFaceColor = [1 0.87 0.46];
xlabel('trailing limb angle asymmetry')
ylabel('Center of Oscillation Difference')
% xlim([-0.6 0.21])
% ylim([-10 20])
saveas(gcf, 'C:\Users\hallbl\OneDrive - Kennedy Krieger\Control Study\Updated\Manuscripts\Current\Updated Interlimb Figures\ScatterPlots\tlaCOO_2025June11.svg');

figure;
scatter(tla_slow,coo_slow, 'MarkerEdgeColor',[0.25 0.65 1], 'MarkerFaceColor', [0.56 0.8 1], 'LineWidth', 0.5)
xlabel('trailing limb angle asymmetry')
ylabel('center of oscillation difference')
xlim([-0.4 0.61])
ylim([-10 20])
title("slow")
saveas(gcf, 'C:\Users\hallbl\OneDrive - Kennedy Krieger\Control Study\Updated\Manuscripts\Current\Updated Interlimb Figures\ScatterPlots\tlacooSlow_2025June11.svg');

figure;
scatter(tla_fast,coo_fast, 'MarkerEdgeColor',[1 0 1], 'MarkerFaceColor', [1 0.46 1], 'LineWidth', 0.5)
xlabel('trailing limb angle asymmetry')
ylabel('center of oscillation difference')
xlim([-0.4 0.61])
ylim([-10 20])
title("fast")
saveas(gcf, 'C:\Users\hallbl\OneDrive - Kennedy Krieger\Control Study\Updated\Manuscripts\Current\Updated Interlimb Figures\ScatterPlots\tlacooFast_2025June11.svg');

figure;
scatter(tla_acc,coo_acc, 'MarkerEdgeColor',[1 0.5 0], 'MarkerFaceColor', [1 0.69 0.38], 'LineWidth', 0.5)
xlabel('trailing limb angle asymmetry')
ylabel('center of oscillation difference')
xlim([-0.4 0.61])
ylim([-10 20])
title("accelerate")
saveas(gcf, 'C:\Users\hallbl\OneDrive - Kennedy Krieger\Control Study\Updated\Manuscripts\Current\Updated Interlimb Figures\ScatterPlots\tlacooAcc_2025June11.svg');

figure;
scatter(tla_dec,coo_dec, 'MarkerEdgeColor',[1 0.75 0], 'MarkerFaceColor', [1 0.87 0.46], 'LineWidth', 0.5)
xlabel('trailing limb angle asymmetry')
ylabel('center of oscillation difference')
xlim([-0.4 0.61])
ylim([-10 20])
title("decelerate")
saveas(gcf, 'C:\Users\hallbl\OneDrive - Kennedy Krieger\Control Study\Updated\Manuscripts\Current\Updated Interlimb Figures\ScatterPlots\tlacooDec_2025June11.svg');