%Simplifying trajectory filling

function trajectories = get_trajectories_tied_Brooke_markerset(kinematic_data)
    %Columns are ordered as
    %hip,tro,lek,lm,mt2,hee,mt5,trochantervertical,pelviscenter,pelvislateral
    %left_columns = [16,22,25,34,43,40,46];
    %right_columns = [49,55,58,67,76,73,79];
    columns = [70,73,19,25,31,28,58;  
               76,79,37,43,49,46,67]; 
    
    %Filter raw trajectory data through a 4th order butterworth filter.
    %Cutoff frequency fc = 6
    %Sampling frequency Fs = 100
    time_col = kinematic_data(:,1);
    [b,a] = butter(4,6/(100/2));
    kinematic_data = filtfilt(b,a,kinematic_data);
    
    TM = [-1 0;1 1;-1 -1]; %Transformation matrix to flip vicon coordinates to usual cartesian
    vert_TM = [0 50 0]; %The offset required for the pelvis vertical. 
    Pel_lat_TM = [0 0 50;0 0 -50];  %The offset requred for the pelvis lateral.
    
    %We want the lateral shift to be 50cms +ve for the right leg and 50cms 
    %-ve for the left. However, there ia a negative sign outside the
    %assignment matrix to account for vikon to euclidian coordinates.
    %Therefore there is a switch in sign in the offsets required. 
    
    speed = {'left','right'};
    coord = {'x','y','z'};
    
    for j=1:2
        for i=1:3
            t = array2table(TM(i,1) * [kinematic_data(:,(columns(j,:)+TM(i,2))),...
                            kinematic_data(:,(columns(j,2)+TM(i,2)))+vert_TM(i),...
                            mean([kinematic_data(:,(columns(1,1)+TM(i,2))),kinematic_data(:,(columns(2,1)+TM(i,2)))],2),...
                            mean([kinematic_data(:,(columns(1,1)+TM(i,2))),kinematic_data(:,(columns(2,1)+TM(i,2)))],2) + Pel_lat_TM(j,i)]/1000,...
                            'VariableNames',{'hip','tro','knee','ankle','mt2','heel','mt5','pelvis_vertical','pelvis_center','pelvis_lateral'});
            trajectories.(speed{j}).(coord{i})=t;      
        end
    
    end                    
       %{ 
       leg.(coord{j}) = cell2struct(arrayfun(@(i) [TM(i,1) * [kinematic_data(:,(columns(j,:)+TM(i,2))),...
                                              kinematic_data(:,(columns(j,2)+TM(i,2)))+vert_TM(i),...
                                              mean([kinematic_data(:,(columns(1,1)+TM(i,2))),kinematic_data(:,(columns(2,1)+TM(i,2)))],2),...
                                              mean([kinematic_data(:,(columns(1,1)+TM(i,2))),kinematic_data(:,(columns(2,1)+TM(i,2)))],2) + Pel_lat_TM(j,i)]/1000],[1,2,3],'uni',false),{'x','y','z'},2);
%}
end
                                
        