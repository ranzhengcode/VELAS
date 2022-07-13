function [X,Y] = longlat2Cartesian(long,lat,flag)

%{  
    Author:   Aleš Bezděk, Josef Sebera
    Modified: Zheng Ran
    
    Ref:
        [1]. Bezděk A, Sebera J, Matlab script for 3D visualizing geodata on a rotating globe, Computers & Geosciences,2013(56):127-130.

        [2]. Bezděk A, Sebera J, 2013. MATLAB script for visualizing geoid height and other elevation data on rotating 3D globe. EGU General Assembly, Vienna, Austria, 7–12 April; Geophysical Research Abstracts, Vol. 15, EGU2013-5142.

        [3]. Snyder, John P., Voxland, Philip M.,An Album of Map Projections, U.S. Geological Survey (1989)
%}

R      = 1;
switch flag
    case {'Gall-Peters','GP','gp'} 
        X = R*long/sqrt(2);
        Y = R*sqrt(2)*sin(lat);
    case {'Hammer-Aitoff','HA','ha'}
        t = sqrt(1+cos(lat).*cos(long/2));
        X = R*2*sqrt(2)*cos(lat).*sin(long/2)./t;
        Y = R*sqrt(2)*sin(lat)./t;
    case {'Mollweide','M','m'}
        
        % Have to use interative scheme to get intermediate variable "theta".
        %   cos(theta) changed to cos(2*theta) -thanks Zhigang Xu! Dec 2006.
        %
        %The program has a divide by zero
        %error when theta= (pi/2).  I've introduced the variable "notpoles"
        %to handle this exception, although there are certainly other ways to
        % deal with the special cases = Kevin Lewis Feb 2011
        % (my note - I'm just taking this as is)
        %  May/2012 - added a bunch more 'notpoles' references (thanks to M. Losch)
        theta    = (asin(lat*2/pi)+lat)/2;
        notpoles = find(abs(theta)<pi/2);  % kevin lewis 2011
        dt       = -(2*theta+sin(2*theta)-pi*sin(lat))./(2+2*cos(2*theta));
        k        = 1;
        
        while any(abs(dt(notpoles))>.001) && k<15
            theta(notpoles) = theta(notpoles)+dt(notpoles);  % fixed May 2012
            dt = -(2*theta+sin(2*theta)-pi*sin(lat))./(2+2*cos(2*theta));
            k = k+1;
        end
        if k == 15
            warning('Iterative coordinate conversion is not converging!'); 
        end
        theta(notpoles) = theta(notpoles)+dt(notpoles);  % fixed May 2012
        
        X = R*2*sqrt(2)*long.*cos(theta)/pi;
        Y = R*sqrt(2)*sin(theta);
        
    case {'Robinson','R','r'}
        % Table of scaling values needed for Robinson projection copied from the wikipedia entry for the robinson projection
        Rob=[...
            00 	1.0000 	0.0000;
            05 	0.9986 	0.0620;
            10 	0.9954 	0.1240;
            15 	0.9900 	0.1860;
            20 	0.9822 	0.2480;
            25 	0.9730 	0.3100;
            30 	0.9600 	0.3720;
            35 	0.9427 	0.4340;
            40 	0.9216 	0.4958;
            45 	0.8962 	0.5571;
            50 	0.8679 	0.6176;
            55 	0.8350 	0.6769;
            60 	0.7986 	0.7346;
            65 	0.7597 	0.7903;
            70 	0.7186 	0.8435;
            75 	0.6732 	0.8936;
            80 	0.6213 	0.9394;
            85 	0.5722 	0.9761;
            90 	0.5322 	1.0000];
        Rob(:,1) = Rob(:,1)*pi/180;
        Rob(:,3) = Rob(:,3);
        Robo     = [flipud(Rob); Rob(2:end,:).*repmat([-1 1 -1],18,1) ];
        % Use splines to interpolate this to many more points - then we can use
        % linear interpolate below and both the forward and reverse maps will be identical
        tRob      = (pi/2:-.05*pi/180:-pi/2)';
        tRob(:,2) = interp1(Robo(:,1),Robo(:,2),tRob(:,1));
        tRob(:,3) = interp1(Robo(:,1),Robo(:,3),tRob(:,1));
        
        X         = 0.8487*R*interp1(tRob(:,1),tRob(:,2),lat).*long;  
        Y         = 1.3523*R*interp1(tRob(:,1),tRob(:,3),lat);

end