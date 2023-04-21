function [k11,k12,k13,k22,k23,k33,theta,phi] = getCoef2D(x,n2d,planeC)



epsilon = 1e-8;
planex  = planeC(1);
planey  = planeC(2);
planez  = planeC(3);
% Normalized plane
temp          = sqrt(planex^2+planey^2+planez^2);
planex        = planex/temp;
planey        = planey/temp;
planez        = planez/temp;

if isempty(x)
    theta2d = linspace(0,2*pi,n2d);
else
    n2d     = length(x);
    theta2d = x;
end

k11     = zeros(n2d,1);
k12     = zeros(n2d,1);
k13     = zeros(n2d,1);
k22     = zeros(n2d,1);
k23     = zeros(n2d,1);
k33     = zeros(n2d,1);
theta   = zeros(n2d,1);
phi     = zeros(n2d,1);
for t = 1:n2d
        thetaTmp = theta2d(t);
        % build the wave vector
        if (abs(planex) <= epsilon)&&(abs(planez) <= epsilon)      % reference/0 "y"
            k(1) = cos(thetaTmp);
            k(2) = 0;
            k(3) = sin(thetaTmp);
        elseif (abs(planez) <= epsilon)&&(abs(planey) <= epsilon)   % reference/0 "x"
            k(1) = 0;
            k(2) = cos(thetaTmp);
            k(3) = sin(thetaTmp);
        else
            temp = sqrt(planex^2+planez^2);
            k(1)=(planez*cos(thetaTmp)-planex*planey*sin(thetaTmp))/temp;
            k(2)=(planex^2+planez^2)*sin(thetaTmp)/temp;
            k(3)=(-planex*cos(thetaTmp)-planey*planez*sin(thetaTmp))/temp;
        end
        if (1 -(abs(k(3))) <= epsilon)
            theta(t) = 0;
            phi(t)   = 0;
        else
            theta(t) = acos(k(3));
            if (k(2) <= epsilon)
                if ((abs(k(1))-abs(sin(theta(t))))<=epsilon)
                    tempo = 0.999999*k(1)/sin(theta(t));
                else
                    tempo = k(1)/sin(theta(t));
                end
                phi(t) = nsign(acos(tempo),k(2));
            else
                phi(t) = nsign(acos(k(1)/sin(theta(t))),k(2));
            end
        end
        
        k11(t)=k(1)*k(1);
        k12(t)=k(1)*k(2);
        k13(t)=k(1)*k(3);
        k22(t)=k(2)*k(2);
        k23(t)=k(2)*k(3);
        k33(t)=k(3)*k(3);
 end