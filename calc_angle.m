function [joint_angle] = calc_angle(x,y)
    vec1 = [x(:,2)-x(:,1), y(:,2)-y(:,1), zeros(size(x,1),1)];
    vec2 = [x(:,3)-x(:,1), y(:,3)-y(:,1), zeros(size(x,1),1)];
    crossprod = cross(vec1,vec2,2);
    joint_angle = atan2d(crossprod(:,3),dot(vec1,vec2,2));
end