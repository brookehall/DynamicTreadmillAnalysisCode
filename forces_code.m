clear;
clc;
[events_file, ~] = uigetfile('*.mat','Select events file');
load(events_file);
[forces_file, ~] = uigetfile('*.csv','Select forces file');
[forces_data, text_data] = xlsread(forces_file);

forces_samp_rate = forces_data(1,1);
kinematics_samp_rate = 100;

bodymass = str2num(cell2mat(inputdlg('Enter participant body mass (kg)')));
g = 9.81;

forces.right_force.x = forces_data(5:size(forces_data),13)/(bodymass*g); %13
forces.right_force.y = -forces_data(5:size(forces_data),14)/(bodymass*g); %14
forces.right_force.z = forces_data(5:size(forces_data),12)/(bodymass*g); %12
forces.right_cop.x = -forces_data(5:size(forces_data),19)/1000; %19
forces.right_cop.z = -forces_data(5:size(forces_data),18)/1000; %18
forces.left_force.x = forces_data(5:size(forces_data),4)/(bodymass*g); %4
forces.left_force.y = -forces_data(5:size(forces_data),5)/(bodymass*g); %5
forces.left_force.z = forces_data(5:size(forces_data),3)/(bodymass*g); %3
forces.left_cop.x = -forces_data(5:size(forces_data),10)/1000; %10
forces.left_cop.z = -forces_data(5:size(forces_data),9)/1000; %9

time_col = forces_data(:,1);
[b,a] = butter(4,15/(forces_samp_rate/2));
forces.right_force.x = filtfilt(b,a,forces.right_force.x);
forces.right_force.y = filtfilt(b,a,forces.right_force.y);
forces.right_force.z = filtfilt(b,a,forces.right_force.z);
forces.left_force.x = filtfilt(b,a,forces.left_force.x);
forces.left_force.y = filtfilt(b,a,forces.left_force.y);
forces.left_force.z = filtfilt(b,a,forces.left_force.z);
forces.right_cop.x = filtfilt(b,a,forces.right_cop.x);
forces.right_cop.z = filtfilt(b,a,forces.right_cop.z);
forces.left_cop.x = filtfilt(b,a,forces.left_cop.x);
forces.left_cop.z = filtfilt(b,a,forces.left_cop.z);

for jj = 1:3
    if jj == 1
        fld = 'sagittal';
    elseif jj == 2
        fld = 'frontal';
    else
        fld = 'transverse';
    end
    for ii = 1:length(events.rhs)-1
        if jj == 1
            cycles.forces.right_force.x{ii} = forces.right_force.x(events.rhs(ii)*(forces_samp_rate/kinematics_samp_rate):events.rhs(ii+1)*(forces_samp_rate/kinematics_samp_rate));
            cycles.forces.right_force.y{ii} = forces.right_force.y(events.rhs(ii)*(forces_samp_rate/kinematics_samp_rate):events.rhs(ii+1)*(forces_samp_rate/kinematics_samp_rate));
            cycles.forces.right_force.z{ii} = forces.right_force.z(events.rhs(ii)*(forces_samp_rate/kinematics_samp_rate):events.rhs(ii+1)*(forces_samp_rate/kinematics_samp_rate));
            cycles.forces.right_cop.x{ii} = forces.right_cop.x(events.rhs(ii)*(forces_samp_rate/kinematics_samp_rate):events.rhs(ii+1)*(forces_samp_rate/kinematics_samp_rate));
            cycles.forces.right_cop.z{ii} = forces.right_cop.z(events.rhs(ii)*(forces_samp_rate/kinematics_samp_rate):events.rhs(ii+1)*(forces_samp_rate/kinematics_samp_rate));
        end
    end
    for ii = 1:length(events.lhs)-1
        if jj == 1
            cycles.forces.left_force.x{ii} = forces.left_force.x(events.lhs(ii)*(forces_samp_rate/kinematics_samp_rate):events.lhs(ii+1)*(forces_samp_rate/kinematics_samp_rate));
            cycles.forces.left_force.y{ii} = forces.left_force.y(events.lhs(ii)*(forces_samp_rate/kinematics_samp_rate):events.lhs(ii+1)*(forces_samp_rate/kinematics_samp_rate));
            cycles.forces.left_force.z{ii} = forces.left_force.z(events.lhs(ii)*(forces_samp_rate/kinematics_samp_rate):events.lhs(ii+1)*(forces_samp_rate/kinematics_samp_rate));
            cycles.forces.left_cop.x{ii} = forces.left_cop.x(events.lhs(ii)*(forces_samp_rate/kinematics_samp_rate):events.lhs(ii+1)*(forces_samp_rate/kinematics_samp_rate));
            cycles.forces.left_cop.z{ii} = forces.left_cop.z(events.lhs(ii)*(forces_samp_rate/kinematics_samp_rate):events.lhs(ii+1)*(forces_samp_rate/kinematics_samp_rate));
        end
    end
end

for ii = 1:length(events.rhs)-1
    counter = 1;
    for kk = 1:length(cycles.forces.right_force.x{ii})-1
        if kk == 1
            temp_cycles.forces.right_force.x{ii}(1:101) = linspace(cycles.forces.right_force.x{ii}(kk),cycles.forces.right_force.x{ii}(kk+1),101);
        else
            temp_cycles.forces.right_force.x{ii}((kk-1)*100+1:(kk-1)*100+101) = linspace(cycles.forces.right_force.x{ii}(kk),cycles.forces.right_force.x{ii}(kk+1),101);
        end
    end
    for ll = 1:length(cycles.forces.right_force.x{ii})-1:length(temp_cycles.forces.right_force.x{ii})
        norm_cycles.forces.right_force.x{ii}(counter) = temp_cycles.forces.right_force.x{ii}(ll);
        counter = counter + 1;
    end
end

for ii = 1:length(events.rhs)-1
    counter = 1;
    for kk = 1:length(cycles.forces.right_force.y{ii})-1
        if kk == 1
            temp_cycles.forces.right_force.y{ii}(1:101) = linspace(cycles.forces.right_force.y{ii}(kk),cycles.forces.right_force.y{ii}(kk+1),101);
        else
            temp_cycles.forces.right_force.y{ii}((kk-1)*100+1:(kk-1)*100+101) = linspace(cycles.forces.right_force.y{ii}(kk),cycles.forces.right_force.y{ii}(kk+1),101);
        end
    end
    for ll = 1:length(cycles.forces.right_force.y{ii})-1:length(temp_cycles.forces.right_force.y{ii})
        norm_cycles.forces.right_force.y{ii}(counter) = temp_cycles.forces.right_force.y{ii}(ll);
        counter = counter + 1;
    end
end

for ii = 1:length(events.rhs)-1
    counter = 1;
    for kk = 1:length(cycles.forces.right_force.z{ii})-1
        if kk == 1
            temp_cycles.forces.right_force.z{ii}(1:101) = linspace(cycles.forces.right_force.z{ii}(kk),cycles.forces.right_force.z{ii}(kk+1),101);
        else
            temp_cycles.forces.right_force.z{ii}((kk-1)*100+1:(kk-1)*100+101) = linspace(cycles.forces.right_force.z{ii}(kk),cycles.forces.right_force.z{ii}(kk+1),101);
        end
    end
    for ll = 1:length(cycles.forces.right_force.z{ii})-1:length(temp_cycles.forces.right_force.z{ii})
        norm_cycles.forces.right_force.z{ii}(counter) = temp_cycles.forces.right_force.z{ii}(ll);
        counter = counter + 1;
    end
end

for ii = 1:length(events.rhs)-1
    counter = 1;
    for kk = 1:length(cycles.forces.right_cop.x{ii})-1
        if kk == 1
            temp_cycles.forces.right_cop.x{ii}(1:101) = linspace(cycles.forces.right_cop.x{ii}(kk),cycles.forces.right_cop.x{ii}(kk+1),101);
        else
            temp_cycles.forces.right_cop.x{ii}((kk-1)*100+1:(kk-1)*100+101) = linspace(cycles.forces.right_cop.x{ii}(kk),cycles.forces.right_cop.x{ii}(kk+1),101);
        end
    end
    for ll = 1:length(cycles.forces.right_cop.x{ii})-1:length(temp_cycles.forces.right_cop.x{ii})
        norm_cycles.forces.right_cop.x{ii}(counter) = temp_cycles.forces.right_cop.x{ii}(ll);
        counter = counter + 1;
    end
end

for ii = 1:length(events.rhs)-1
    counter = 1;
    for kk = 1:length(cycles.forces.right_cop.z{ii})-1
        if kk == 1
            temp_cycles.forces.right_cop.z{ii}(1:101) = linspace(cycles.forces.right_cop.z{ii}(kk),cycles.forces.right_cop.z{ii}(kk+1),101);
        else
            temp_cycles.forces.right_cop.z{ii}((kk-1)*100+1:(kk-1)*100+101) = linspace(cycles.forces.right_cop.z{ii}(kk),cycles.forces.right_cop.z{ii}(kk+1),101);
        end
    end
    for ll = 1:length(cycles.forces.right_cop.z{ii})-1:length(temp_cycles.forces.right_cop.z{ii})
        norm_cycles.forces.right_cop.z{ii}(counter) = temp_cycles.forces.right_cop.z{ii}(ll);
        counter = counter + 1;
    end
end

for ii = 1:length(events.lhs)-1
    counter = 1;
    for kk = 1:length(cycles.forces.left_force.x{ii})-1
        if kk == 1
            temp_cycles.forces.left_force.x{ii}(1:101) = linspace(cycles.forces.left_force.x{ii}(kk),cycles.forces.left_force.x{ii}(kk+1),101);
        else
            temp_cycles.forces.left_force.x{ii}((kk-1)*100+1:(kk-1)*100+101) = linspace(cycles.forces.left_force.x{ii}(kk),cycles.forces.left_force.x{ii}(kk+1),101);
        end
    end
    for ll = 1:length(cycles.forces.left_force.x{ii})-1:length(temp_cycles.forces.left_force.x{ii})
        norm_cycles.forces.left_force.x{ii}(counter) = temp_cycles.forces.left_force.x{ii}(ll);
        counter = counter + 1;
    end
end

for ii = 1:length(events.lhs)-1
    counter = 1;
    for kk = 1:length(cycles.forces.left_force.y{ii})-1
        if kk == 1
            temp_cycles.forces.left_force.y{ii}(1:101) = linspace(cycles.forces.left_force.y{ii}(kk),cycles.forces.left_force.y{ii}(kk+1),101);
        else
            temp_cycles.forces.left_force.y{ii}((kk-1)*100+1:(kk-1)*100+101) = linspace(cycles.forces.left_force.y{ii}(kk),cycles.forces.left_force.y{ii}(kk+1),101);
        end
    end
    for ll = 1:length(cycles.forces.left_force.y{ii})-1:length(temp_cycles.forces.left_force.y{ii})
        norm_cycles.forces.left_force.y{ii}(counter) = temp_cycles.forces.left_force.y{ii}(ll);
        counter = counter + 1;
    end
end

for ii = 1:length(events.lhs)-1
    counter = 1;
    for kk = 1:length(cycles.forces.left_force.z{ii})-1
        if kk == 1
            temp_cycles.forces.left_force.z{ii}(1:101) = linspace(cycles.forces.left_force.z{ii}(kk),cycles.forces.left_force.z{ii}(kk+1),101);
        else
            temp_cycles.forces.left_force.z{ii}((kk-1)*100+1:(kk-1)*100+101) = linspace(cycles.forces.left_force.z{ii}(kk),cycles.forces.left_force.z{ii}(kk+1),101);
        end
    end
    for ll = 1:length(cycles.forces.left_force.z{ii})-1:length(temp_cycles.forces.left_force.z{ii})
        norm_cycles.forces.left_force.z{ii}(counter) = temp_cycles.forces.left_force.z{ii}(ll);
        counter = counter + 1;
    end
end

for ii = 1:length(events.lhs)-1
    counter = 1;
    for kk = 1:length(cycles.forces.left_cop.x{ii})-1
        if kk == 1
            temp_cycles.forces.left_cop.x{ii}(1:101) = linspace(cycles.forces.left_cop.x{ii}(kk),cycles.forces.left_cop.x{ii}(kk+1),101);
        else
            temp_cycles.forces.left_cop.x{ii}((kk-1)*100+1:(kk-1)*100+101) = linspace(cycles.forces.left_cop.x{ii}(kk),cycles.forces.left_cop.x{ii}(kk+1),101);
        end
    end
    for ll = 1:length(cycles.forces.left_cop.x{ii})-1:length(temp_cycles.forces.left_cop.x{ii})
        norm_cycles.forces.left_cop.x{ii}(counter) = temp_cycles.forces.left_cop.x{ii}(ll);
        counter = counter + 1;
    end
end

for ii = 1:length(events.lhs)-1
    counter = 1;
    for kk = 1:length(cycles.forces.left_cop.z{ii})-1
        if kk == 1
            temp_cycles.forces.left_cop.z{ii}(1:101) = linspace(cycles.forces.left_cop.z{ii}(kk),cycles.forces.left_cop.z{ii}(kk+1),101);
        else
            temp_cycles.forces.left_cop.z{ii}((kk-1)*100+1:(kk-1)*100+101) = linspace(cycles.forces.left_cop.z{ii}(kk),cycles.forces.left_cop.z{ii}(kk+1),101);
        end
    end
    for ll = 1:length(cycles.forces.left_cop.z{ii})-1:length(temp_cycles.forces.left_cop.z{ii})
        norm_cycles.forces.left_cop.z{ii}(counter) = temp_cycles.forces.left_cop.z{ii}(ll);
        counter = counter + 1;
    end
end

for ii = 1:length(cycles.forces.right_force.x)
    cycles.forces.right_force.x_max(1,ii) = max(cycles.forces.right_force.x{ii});
    cycles.forces.right_force.x_min(1,ii) = min(cycles.forces.right_force.x{ii});
    cycles.forces.right_force.y_max(1,ii) = max(cycles.forces.right_force.y{ii});
    cycles.forces.right_force.y_min(1,ii) = min(cycles.forces.right_force.y{ii});
    cycles.forces.right_force.z_max(1,ii) = max(cycles.forces.right_force.z{ii});
    cycles.forces.right_force.z_min(1,ii) = min(cycles.forces.right_force.z{ii});
end

for ii = 1:length(cycles.forces.left_force.x)
    cycles.forces.left_force.x_max(1,ii) = max(cycles.forces.left_force.x{ii});
    cycles.forces.left_force.x_min(1,ii) = min(cycles.forces.left_force.x{ii});
    cycles.forces.left_force.y_max(1,ii) = max(cycles.forces.left_force.y{ii});
    cycles.forces.left_force.y_min(1,ii) = min(cycles.forces.left_force.y{ii});
    cycles.forces.left_force.z_max(1,ii) = max(cycles.forces.left_force.z{ii});
    cycles.forces.left_force.z_min(1,ii) = min(cycles.forces.left_force.z{ii});
end

for ii = 1:length(norm_cycles.forces.right_force.x)
    temp_all_cycles.right_force.x(ii,:) = norm_cycles.forces.right_force.x{ii};
    temp_all_cycles.right_force.y(ii,:) = norm_cycles.forces.right_force.y{ii};
    temp_all_cycles.right_force.z(ii,:) = norm_cycles.forces.right_force.z{ii};
end

for ii = 1:length(norm_cycles.forces.left_force.x)
    temp_all_cycles.left_force.x(ii,:) = norm_cycles.forces.left_force.x{ii};
    temp_all_cycles.left_force.y(ii,:) = norm_cycles.forces.left_force.y{ii};
    temp_all_cycles.left_force.z(ii,:) = norm_cycles.forces.left_force.z{ii};
end

for ii = 1:size(temp_all_cycles.right_force.x,2)
    norm_cycles.forces.right_force.x_avg_all(1,ii) = mean(temp_all_cycles.right_force.x(1:size(temp_all_cycles.right_force.x,1),ii));
    norm_cycles.forces.right_force.y_avg_all(1,ii) = mean(temp_all_cycles.right_force.y(1:size(temp_all_cycles.right_force.y,1),ii));
    norm_cycles.forces.right_force.z_avg_all(1,ii) = mean(temp_all_cycles.right_force.z(1:size(temp_all_cycles.right_force.z,1),ii));
end

for ii = 1:size(temp_all_cycles.left_force.x,2)
    norm_cycles.forces.left_force.x_avg_all(1,ii) = mean(temp_all_cycles.left_force.x(1:size(temp_all_cycles.left_force.x,1),ii));
    norm_cycles.forces.left_force.y_avg_all(1,ii) = mean(temp_all_cycles.left_force.y(1:size(temp_all_cycles.left_force.y,1),ii));
    norm_cycles.forces.left_force.z_avg_all(1,ii) = mean(temp_all_cycles.left_force.z(1:size(temp_all_cycles.left_force.z,1),ii));
end

for ii = 1:size(temp_all_cycles.right_force.x,2)
    norm_cycles.forces.right_force.x_avg_first_five(1,ii) = mean(temp_all_cycles.right_force.x(1:5,ii));
    norm_cycles.forces.right_force.y_avg_first_five(1,ii) = mean(temp_all_cycles.right_force.y(1:5,ii));
    norm_cycles.forces.right_force.z_avg_first_five(1,ii) = mean(temp_all_cycles.right_force.z(1:5,ii));
end

for ii = 1:size(temp_all_cycles.left_force.x,2)
    norm_cycles.forces.left_force.x_avg_first_five(1,ii) = mean(temp_all_cycles.left_force.x(1:5,ii));
    norm_cycles.forces.left_force.y_avg_first_five(1,ii) = mean(temp_all_cycles.left_force.y(1:5,ii));
    norm_cycles.forces.left_force.z_avg_first_five(1,ii) = mean(temp_all_cycles.left_force.z(1:5,ii));
end

for ii = 1:size(temp_all_cycles.right_force.x,2)
    norm_cycles.forces.right_force.x_avg_last_five(1,ii) = mean(temp_all_cycles.right_force.x(size(temp_all_cycles.right_force.x,1)-4:size(temp_all_cycles.right_force.x,1),ii));
    norm_cycles.forces.right_force.y_avg_last_five(1,ii) = mean(temp_all_cycles.right_force.y(size(temp_all_cycles.right_force.y,1)-4:size(temp_all_cycles.right_force.y,1),ii));
    norm_cycles.forces.right_force.z_avg_last_five(1,ii) = mean(temp_all_cycles.right_force.z(size(temp_all_cycles.right_force.z,1)-4:size(temp_all_cycles.right_force.z,1),ii));
end

for ii = 1:size(temp_all_cycles.left_force.x,2)
    norm_cycles.forces.left_force.x_avg_last_five(1,ii) = mean(temp_all_cycles.left_force.x(size(temp_all_cycles.left_force.x,1)-4:size(temp_all_cycles.left_force.x,1),ii));
    norm_cycles.forces.left_force.y_avg_last_five(1,ii) = mean(temp_all_cycles.left_force.y(size(temp_all_cycles.left_force.y,1)-4:size(temp_all_cycles.left_force.y,1),ii));
    norm_cycles.forces.left_force.z_avg_last_five(1,ii) = mean(temp_all_cycles.left_force.z(size(temp_all_cycles.left_force.z,1)-4:size(temp_all_cycles.left_force.z,1),ii));
end

output.forces = forces;
output.norm_cycles = norm_cycles;
output.cycles = cycles;
savename = strrep(forces_file,'.csv','_forces');
save(savename,'output');