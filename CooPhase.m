clear; clc;

subject_list = {'MLR003','MLR013','MLR016','MLR017','MLR024','MLR005','MLR009','MLR028','MLR032','MLR025'}; %add other participants here
condition_list = {'Baseline_intermediate';'AcceleratingHS';'DeceleratingHS';'FastHS';'SlowHS'}; %add other conditions here

for ii = 1:length(subject_list)
    cd('C:\Users\hallbl\OneDrive - Kennedy Krieger\Control Study\Updated\Data Files')
    load('events_2024Aug21.mat');
    load('limbAngles_2024Sep3.mat');
    for kk = 1:length(events.(subject_list{ii}).Baseline_intermediate.rhs)-1
        maxlag = (events.(subject_list{ii}).Baseline_intermediate.rhs(kk+1)-1)-(events.(subject_list{ii}).Baseline_intermediate.rhs(kk));
        [c, lags] = xcorr(limbAngles.(subject_list{ii}).Baseline_intermediate.kinematics.limb_angles.right(events.(subject_list{ii}).Baseline_intermediate.rhs(kk):events.(subject_list{ii}).Baseline_intermediate.rhs(kk+1)-1), limbAngles.(subject_list{ii}).Baseline_intermediate.kinematics.limb_angles.left(events.(subject_list{ii}).Baseline_intermediate.rhs(kk):events.(subject_list{ii}).Baseline_intermediate.rhs(kk+1)-1),maxlag,'coeff');
        lags = lags/maxlag;
        c = c(find(lags>=0));
        lags = lags(find(lags>=0));
        [maxcorr,ind] = max(c);
        phasing.(subject_list{ii}).baseline.phaseshift(kk,1) = lags(ind);

        clear maxlag maxcorr lags c ind;

    end
    phasing.(subject_list{ii}).baseline.phasing_mean = mean(phasing.(subject_list{ii}).baseline.phaseshift);
end

clear events r lags;

for ii = 1:length(subject_list)
    for jj = 1:length(condition_list)
        cd('C:\Users\hallbl\OneDrive - Kennedy Krieger\Control Study\Updated\Data Files')
    load('events_2024Aug21.mat');
    load('limbAngles_2024Sep3.mat');
   
        if (events.(subject_list{ii}).(condition_list{jj}).rto(1)) < (events.(subject_list{ii}).(condition_list{jj}).rhs(1))
            events.(subject_list{ii}).(condition_list{jj}).rto(1) = [];
        end
        if events.(subject_list{ii}).(condition_list{jj}).lto(1) < events.(subject_list{ii}).(condition_list{jj}).rhs(1)
            events.(subject_list{ii}).(condition_list{jj}).lto(1) = [];
        end
        if events.(subject_list{ii}).(condition_list{jj}).lhs(1) < events.(subject_list{ii}).(condition_list{jj}).rhs(1)
            events.(subject_list{ii}).(condition_list{jj}).lhs(1) = [];
        end
        for kk = 1:length(events.(subject_list{ii}).(condition_list{jj}).rhs)-1
            COO.(subject_list{ii}).(condition_list{jj}).right(kk,1) = (limbAngles.(subject_list{ii}).(condition_list{jj}).kinematics.limb_angles.right(events.(subject_list{ii}).(condition_list{jj}).rhs(kk))+limbAngles.(subject_list{ii}).(condition_list{jj}).kinematics.limb_angles.right(events.(subject_list{ii}).(condition_list{jj}).rto(kk)))/2;
            COO.(subject_list{ii}).(condition_list{jj}).left(kk,1) = (limbAngles.(subject_list{ii}).(condition_list{jj}).kinematics.limb_angles.left(events.(subject_list{ii}).(condition_list{jj}).lhs(kk))+limbAngles.(subject_list{ii}).(condition_list{jj}).kinematics.limb_angles.left(events.(subject_list{ii}).(condition_list{jj}).lto(kk)))/2;
            COO.(subject_list{ii}).(condition_list{jj}).diff(kk,1) = COO.(subject_list{ii}).(condition_list{jj}).right(kk,1)-COO.(subject_list{ii}).(condition_list{jj}).left(kk,1);

            maxlag = (events.(subject_list{ii}).(condition_list{jj}).rhs(kk+1)-1) - (events.(subject_list{ii}).(condition_list{jj}).rhs(kk));
            [c, lags] = xcorr(limbAngles.(subject_list{ii}).(condition_list{jj}).kinematics.limb_angles.right(events.(subject_list{ii}).(condition_list{jj}).rhs(kk):events.(subject_list{ii}).(condition_list{jj}).rhs(kk+1)-1), limbAngles.(subject_list{ii}).(condition_list{jj}).kinematics.limb_angles.left(events.(subject_list{ii}).(condition_list{jj}).rhs(kk):events.(subject_list{ii}).(condition_list{jj}).rhs(kk+1)-1),maxlag,'coeff');
            lags = lags/maxlag;
            c = c(find(lags>=0));
            lags = lags(find(lags>=0));
            [maxcorr,ind] = max(c);
            phasing.(subject_list{ii}).(condition_list{jj}).phaseshift(kk,1) = lags(ind);
            
            
            phasing.(subject_list{ii}).(condition_list{jj}).phaseshift_baselinesubtracted(kk,1) = phasing.(subject_list{ii}).(condition_list{jj}).phaseshift(kk,1)-phasing.(subject_list{ii}).baseline.phasing_mean;
            phasing.(subject_list{ii}).(condition_list{jj}).phasing_mean = mean(phasing.(subject_list{ii}).(condition_list{jj}).phaseshift_baselinesubtracted);
            clear c lags maxlag;
        end
    end
end
