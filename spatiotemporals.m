
%Simplifying the trajectories code to make it less clunky.
%Take in the input from raw excel file and breaking it into the trajectories is all its doing. 
clc; clear;
homepath = cd;

[kinematics_file, ~] = uigetfile('*.csv','Select kinematic data file');
[kinematic_data, ~] = xlsread(kinematics_file);

kinematics_samp_rate = kinematic_data(1,1);
    
%define markers and forces
%coordinate system:  AP:  x (positive = forward), vertical:  y (positive =
%up), ML:  z (positive = right)

%legs = {'Right','Left'};
%slow_leg = listdlg('PromptString','Indicate slow leg?','SelectionMode','single','ListString',legs);

%Make sure there are no missing values in the required columns before
%passing to function. 
%No need to beak into slow and fast. Will be retained as left and right. 
trajectories = get_trajectories_tied_markerset(kinematic_data(5:size(kinematic_data,1),:));
% Order of markers:Pelvis,Trochanter,Knee,Ankle,MT2,Heel,MT5,Vertical,Pelvis Center, Pelvis Horizontal

%calculate joint angles

%Vertex of the angle [2,3,4,2,9] 
%Vertex at the bottom [3,4,5,5,1]
%Vertex at the top [8,2,3,8,10]

%These have been converted into tables already.Can use the field name instead of column numbers. 
angle2 = {'tro','knee','ankle','tro','pelvis_center'};
bottom = {'knee','ankle','mt2','mt2','hip'};
top = {'pelvis_vertical','tro','knee','pelvis_vertical','pelvis_lateral'};
forward = questdlg('Do you want to compute sagittal angles?','Sagittal',"Yes","No","Yes");
if forward == "Yes"
    joint_angles.sagittal.left = cell2mat(arrayfun(@(i,j,k) calc_angle(trajectories.left.x{:,[i,j,k]},trajectories.left.y{:,[i,j,k]}),angle2,bottom,top,'uni',false));
    joint_angles.sagittal.right = cell2mat(arrayfun(@(i,j,k) calc_angle(trajectories.right.x{:,[i,j,k]},trajectories.right.y{:,[i,j,k]}),angle2,bottom,top,'uni',false));
    %joint_angles.sagittal.fast = cell2mat(arrayfun(@(i,j,k) calc_angle(trajectories.fast_x(:,[i,j,k]),trajectories.fast_y(:,[i,j,k])),angle2,top,bottom,'uni',false));
    %joint_angles.sagittal.slow = cell2mat(arrayfun(@(i,j,k) calc_angle(trajectories.slow_x(:,[i,j,k]),trajectories.slow_y(:,[i,j,k])),[2,3,4,2],[3,4,5,5],[8,2,3,8],'uni',false));    
    %joint_angles.sagittal.slow = [joint_angles.sagittal.slow, calc_angle([trajectories.fast_x(:,9),trajectories.slow_x(:,1),trajectories.fast_x(:,10)],...
                                                                         %[trajectories.fast_y(:,9),trajectories.slow_y(:,1),trajectories.fast_y(:,10)])];      
speed = {'left';'right'};
    for i = 1:size(speed,1)
        joint_angles.sagittal.(speed{i})(joint_angles.sagittal.(speed{i})(:,1)<0,1) =  joint_angles.sagittal.(speed{i})(joint_angles.sagittal.(speed{i})(:,1)<0,1) +360;
        joint_angles.sagittal.(speed{i})(:,1) = -(joint_angles.sagittal.(speed{i})(:,1)-180);
        
        joint_angles.sagittal.(speed{i})(joint_angles.sagittal.(speed{i})(:,2)>0,2)= joint_angles.sagittal.(speed{i})(joint_angles.sagittal.(speed{i})(:,2)>0,2)-360;
        joint_angles.sagittal.(speed{i})(:,2) = (joint_angles.sagittal.(speed{i})(:,2)+180);
        
        joint_angles.sagittal.(speed{i})(:,3) = (-joint_angles.sagittal.(speed{i})(:,3)+90);
        
        joint_angles.sagittal.(speed{i})(joint_angles.sagittal.(speed{i})(:,4)<0,4) =  joint_angles.sagittal.(speed{i})(joint_angles.sagittal.(speed{i})(:,4)<0,4) +360;
        joint_angles.sagittal.(speed{i})(:,4) = -(joint_angles.sagittal.(speed{i})(:,4)-180);
    end
    %Adjustments to make them real angles. 
end

%detect gait events
%Repeat for frontal and transverse angles when required. Not being
    %computed here. But the function to compute the angles itself should be
    %pretty similar. The major changes will come in the post-calc
    %adjustments. 
    
%detect gait events

events.rhs = 0;
events.lhs = 0;
events.rto = 0;
events.lto = 0;
shscounter = 1;
fhscounter = 1;
stocounter = 1;
ftocounter = 1;

min_length = min([length(joint_angles.sagittal.left(:,4)) length(joint_angles.sagittal.right(:,4))]);

for ii = 5:min_length-4
    if joint_angles.sagittal.right(ii,4) > joint_angles.sagittal.right(ii-1,4) && joint_angles.sagittal.right(ii,4) > joint_angles.sagittal.right(ii+1,4) && joint_angles.sagittal.right(ii,4) > mean(joint_angles.sagittal.right(ii-4:ii-1,4)) && joint_angles.sagittal.right(ii,4) > mean(joint_angles.sagittal.right(ii+1:ii+4,4)) && shscounter==stocounter   %% lhscounter-rhscounter ==1 if left leg is slower. 
        events.rhs(shscounter,1) = ii;
        shscounter = shscounter + 1;
    end
    if joint_angles.sagittal.left(ii,4) > joint_angles.sagittal.left(ii-1,4) && joint_angles.sagittal.left(ii,4) > joint_angles.sagittal.left(ii+1,4) && joint_angles.sagittal.left(ii,4) > mean(joint_angles.sagittal.left(ii-4:ii-1,4)) && joint_angles.sagittal.left(ii,4) > mean(joint_angles.sagittal.left(ii+1:ii+4,4)) && fhscounter==ftocounter %% rhscounter == lhscounter if left leg is slower. 
        events.lhs(fhscounter,1) = ii;
        fhscounter = fhscounter + 1;
    end
    if joint_angles.sagittal.right(ii,4) < joint_angles.sagittal.right(ii-1,4) && joint_angles.sagittal.right(ii,4) < joint_angles.sagittal.right(ii+1,4) && joint_angles.sagittal.right(ii,4) < mean(joint_angles.sagittal.right(ii-4:ii-1,4)) && joint_angles.sagittal.right(ii,4) < mean(joint_angles.sagittal.right(ii+1:ii+4,4)) && shscounter + fhscounter > 2 && shscounter-stocounter==1
        events.rto(stocounter,1) = ii;
        stocounter = stocounter + 1;
    end
    
    if joint_angles.sagittal.left(ii,4) < joint_angles.sagittal.left(ii-1,4) && joint_angles.sagittal.left(ii,4) < joint_angles.sagittal.left(ii+1,4) && joint_angles.sagittal.left(ii,4) < mean(joint_angles.sagittal.left(ii-4:ii-1,4)) && joint_angles.sagittal.left(ii,4) < mean(joint_angles.sagittal.left(ii+1:ii+4,4)) && shscounter + fhscounter > 2 && fhscounter-ftocounter==1
        events.lto(ftocounter,1) = ii;
        ftocounter = ftocounter + 1;
    end
end


%events = create_events(joint_angles.sagittal.slow(:,4),joint_angles.sagittal.fast(:,4));

check = questdlg('Do you want to check limb angles?','Figureplot',"Yes","No","No");
while check == "Yes"
    fig = figure;
    plot(joint_angles.sagittal.right(:,4),'b');
    title({'Green - Right event';'Black - Left event'})
    hold on;
    plot(joint_angles.sagittal.left(:,4),'r');

    scatter(events.rhs,joint_angles.sagittal.right(events.rhs,4),'g');
    scatter(events.lhs,joint_angles.sagittal.left(events.lhs,4),'k');
    scatter(events.rto,joint_angles.sagittal.right(events.rto,4),'g');
    scatter(events.lto,joint_angles.sagittal.left(events.lto,4),'k');
    pause;
    events = edit_events(events,fig);
    close all; 
    check = questdlg('Do you want to check limb angles?','Figureplot',"Yes","No","No");
end

num_cycles = min(length(events.lhs),length(events.rhs));

if events.rhs(1) < events.lhs(1)
    first_event = 1;
else
    first_event = 2;
end

if events.rto(1) < events.rhs(1) && events.rto(1) < events.lhs(1)
    events.rto(1) = [];
end

if events.lto(1) < events.lhs(1) && events.lto(1) < events.rhs(1)
    events.lto(1) = [];
end

%calculate spatiotemporals

right = table;
left = table;

bodycentricx_right = trajectories.right.x.ankle - trajectories.right.x.tro;
bodycentricx_left = trajectories.left.x.ankle - trajectories.left.x.tro;

right.steplength = trajectories.right.x.ankle(events.rhs(2:num_cycles-1)) - trajectories.left.x.ankle(events.rhs(2:num_cycles-1));
left.steplength = trajectories.left.x.ankle(events.lhs(2:num_cycles-1)) - trajectories.right.x.ankle(events.lhs(2:num_cycles-1));

right.stepwidth = abs(trajectories.right.z.ankle(events.rhs(2:num_cycles-1)) - trajectories.left.z.ankle(events.rhs(2:num_cycles-1)));
left.stepwidth = abs(trajectories.left.z.ankle(events.lhs(2:num_cycles-1)) - trajectories.right.z.ankle(events.lhs(2:num_cycles-1)));

right.stridetime = (events.rhs(3:num_cycles) - events.rhs(2:num_cycles-1))/kinematics_samp_rate;
left.stridetime = (events.lhs(3:num_cycles) - events.lhs(2:num_cycles-1))/kinematics_samp_rate;

if first_event == 1
    right.stancetime = (events.rto(2:num_cycles-1) - events.rhs(2:num_cycles-1))/kinematics_samp_rate; 
    left.stancetime = (events.lto(3:num_cycles) - events.lhs(2:num_cycles-1))/kinematics_samp_rate;    
    
    right.steptime = (events.lhs(2:num_cycles-1) - events.rhs(2:num_cycles-1))/kinematics_samp_rate;
    left.steptime = (events.rhs(3:num_cycles) - events.lhs(2:num_cycles-1))/kinematics_samp_rate;
    
    right.doublesupporttime = (events.rto(2:num_cycles-1) - events.lhs(2:num_cycles-1))/kinematics_samp_rate;
    left.doublesupporttime = (events.lto(2:num_cycles-1) - events.rhs(2:num_cycles-1))/kinematics_samp_rate; 

    right.swingtime = (events.rhs(3:num_cycles) - events.rto(2:num_cycles-1))/kinematics_samp_rate;
    left.swingtime = (events.lhs(2:num_cycles-1) - events.lto(2:num_cycles-1))/kinematics_samp_rate;
else
    right.stancetime = (events.rto(3:num_cycles) - events.rhs(2:num_cycles-1))/kinematics_samp_rate; 
    left.stancetime = (events.lto(2:num_cycles-1) - events.lhs(2:num_cycles-1))/kinematics_samp_rate;

    left.steptime = (events.rhs(2:num_cycles-1) - events.lhs(2:num_cycles-1))/kinematics_samp_rate;
    right.steptime = (events.lhs(3:num_cycles) - events.rhs(2:num_cycles-1))/kinematics_samp_rate;
    
    left.doublesupporttime = (events.lto(2:num_cycles-1) - events.rhs(2:num_cycles-1))/kinematics_samp_rate;
    right.doublesupporttime = (events.rto(2:num_cycles-1) - events.lhs(2:num_cycles-1))/kinematics_samp_rate;

    right.swingtime = (events.rhs(2:num_cycles-1) - events.rto(2:num_cycles-1))/kinematics_samp_rate;
    left.swingtime = (events.lhs(3:num_cycles) - events.lto(2:num_cycles-1))/kinematics_samp_rate; 
end

% right.swingtime = (events.rhs(3:num_cycles) - events.rto(2:num_cycles-1))/kinematics_samp_rate;
% left.swingtime = (events.lhs(3:num_cycles) - events.lto(2:num_cycles-1))/kinematics_samp_rate;

right.alphaangle = joint_angles.sagittal.right(events.rhs(2:num_cycles-1),4);
left.alphaangle = joint_angles.sagittal.left(events.lhs(2:num_cycles-1),4);

right.betaangle = joint_angles.sagittal.right(events.rto(2:num_cycles-1),4);
left.betaangle = joint_angles.sagittal.left(events.lto(2:num_cycles-1),4);

right.gammaangle = right.alphaangle - right.betaangle;
left.gammaangle = left.alphaangle - left.betaangle; 

spatiotemporals.right = right;
spatiotemporals.left = left;
spatiotemporals.steplengthasymmetry = (spatiotemporals.left.steplength-spatiotemporals.right.steplength)./(spatiotemporals.left.steplength+spatiotemporals.right.steplength);

var_names = {'lhip','ltro','lknee','llm','rhip','rtro','rknee','rlm'};
fnames = trajectories.left.x.Properties.VariableNames;
spatiotemporals.contributions_to_step_length.left =array2table([trajectories.left.x{events.lhs(2:num_cycles-1),fnames(1:4)} - ...
                                                                trajectories.left.x{events.lhs(2:num_cycles-1),fnames([9,1:3])},...
                                                                -trajectories.right.x{events.lhs(2:num_cycles-1),fnames(1:4)} + ...
                                                               trajectories.right.x{events.lhs(2:num_cycles-1),fnames([9,1:3])}]./left.steplength,'VariableNames',var_names);
                                                           

spatiotemporals.contributions_to_step_length.right =array2table([trajectories.right.x{events.rhs(2:num_cycles-1),fnames(1:4)} - ...
                                                                trajectories.right.x{events.rhs(2:num_cycles-1),fnames([9,1:3])},...
                                                                -trajectories.left.x{events.rhs(2:num_cycles-1),fnames(1:4)} + ...
                                                               trajectories.left.x{events.rhs(2:num_cycles-1),fnames([9,1:3])}]./right.steplength,'VariableNames',var_names([5:8,1:4]));
                                                           
                                                           
%The line below replaces the joint asymmetries calculation detailed in the commented portion of previous code.                                 
spatiotemporals.contributions_to_step_length.jointasymmetries = array2table(spatiotemporals.contributions_to_step_length.left{:,:} - ...
                                    spatiotemporals.contributions_to_step_length.right{:,var_names([5:8,1:4])},'VariableNames',...
                                    {'lead_hip','lead_tro','lead_knee','lead_lm'...
                                    'trail_hip','trail_tro','trail_knee','trail_lm'});   
                                
% The line below replaces the asymmetry indx calculation detailed in the commented potion of previous code. 
spatiotemporals.contributions_to_step_length.asymmetryindex = sum(abs(spatiotemporals.contributions_to_step_length.jointasymmetries{:,:}),2);

%Converting joint angles to table form. 
joint_angles.sagittal.right = array2table(joint_angles.sagittal.right,'VariableNames',{'tro','knee','ankle','limb','pelvis'});
joint_angles.sagittal.left = array2table(joint_angles.sagittal.left,'VariableNames',{'tro','knee','ankle','limb','pelvis'});

%Collate kinematics together. 
kinematics.trajectories = trajectories;
kinematics.joint_angles= joint_angles;
%kinematics.step_length_contributions = step_length_contributions; 

%Save the files 
savename1 = strrep(kinematics_file,'.csv','_kinematics');
save(savename1,'kinematics');

savename2 = strrep(kinematics_file,'.csv','_spatiotemporals');
save(savename2,'spatiotemporals');

savename3 = strrep(kinematics_file,'.csv','_events');
save(savename3,'events');
