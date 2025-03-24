clear; clc;

subjects = {'MLR001','MLR002','MLR003','MLR004','MLR005','MLR006','MLR007','MLR008','MLR009','MLR010','MLR011','MLR012','MLR013','MLR014','MLR015','MLR016','MLR017','MLR021','MLR022','MLR023','MLR024','MLR025','MLR027','MLR028','MLR029','MLR030','MLR032','MLR033', 'MLR037', 'MLR038','MLR040','MLR041','MLR044','MLR045','MLR046','MLR047','MLR048'}; % 'MLR043',
trial_list = {'Baseline_slow';'Baseline_intermediate';'Baseline_fast';'AcceleratingHS';'DeceleratingHS';'FastHS';'SlowHS'};
subfolders = {'New Session'};

for ii = 1:length(subjects)
    % cd('S:\Banks\DynamicTread\MLR057\Session 1');
    % cd(subjects{ii});
    % cd(subfolders{ii});
    for jj = 1:length(trial_list)
        load(['C:\Users\hallbl\OneDrive - Kennedy Krieger\Control Study\Updated\',(subjects{ii}),'\New Session\',(trial_list{jj})]);
        for kk = 1:length(output.cycles.forces.right_force.x)
            output.cycles.forces.right_force.x_pos_impulse(1,kk) = trapz(output.cycles.forces.right_force.x{kk}(output.cycles.forces.right_force.x{kk}>0))/1000;
            output.cycles.forces.right_force.x_neg_impulse(1,kk) = trapz(output.cycles.forces.right_force.x{kk}(output.cycles.forces.right_force.x{kk}<0))/1000;
        end
        for kk = 1:length(output.cycles.forces.left_force.x)
            output.cycles.forces.left_force.x_pos_impulse(1,kk) = trapz(output.cycles.forces.left_force.x{kk}(output.cycles.forces.left_force.x{kk}>0))/1000;
            output.cycles.forces.left_force.x_neg_impulse(1,kk) = trapz(output.cycles.forces.left_force.x{kk}(output.cycles.forces.left_force.x{kk}<0))/1000;
        end
        save(trial_list{jj},'output');
        clear output
    end
end
