function R = getRadiusTicks(theta,tR,varargin)

narginchk(2,5);

fig = figure;
hold on;
switch(nargin)
    case 2
        [tx,ty] = head2Tail(tR.*cos(theta),tR.*sin(theta));
        
        tRmax = max(tR);
        
        plot(tx, ty);
        
    case 3
        % varargin{1} -- negative value
        [xpos,ypos] = head2Tail(tR.*cos(theta),tR.*sin(theta));
        [xneg,yneg] = head2Tail(varargin{1}.*cos(theta),varargin{1}.*sin(theta));
        
        tRmax = max(max(tR),max(varargin{1}));
        
        plot(xpos,ypos);
        plot(xneg,yneg);
        
    case 4
        % varargin{1} -- min value
        % varargin{2} -- average value
        [xmax,ymax] = head2Tail(tR.*cos(theta),tR.*sin(theta));
        [xmin,ymin] = head2Tail(varargin{1}.*cos(theta),varargin{1}.*sin(theta));
        [xavg,yavg] = head2Tail(varargin{2}.*cos(theta),varargin{2}.*sin(theta));
        
        tRmax = max([max(tR),max(varargin{1}),max(varargin{2})]);
        
        plot(xmax,ymax);
        plot(xmin,ymin);
        plot(xavg,yavg);
        
    case 5
        % varargin{1} -- min positive value
        % varargin{2} -- min negative value
        % varargin{3} -- average value
        [xmax,ymax]   = head2Tail(tR.*cos(theta),tR.*sin(theta));
        [xminp,yminp] = head2Tail(varargin{1}.*cos(theta),varargin{1}.*sin(theta));
        [xminn,yminn] = head2Tail(varargin{2}.*cos(theta),varargin{2}.*sin(theta));
        [xavg,yavg] = head2Tail(varargin{3}.*cos(theta),varargin{3}.*sin(theta));

        tRmax = max([max(tR),max(varargin{1}),max(varargin{2}),max(varargin{2})]);
        
        plot(xmax,ymax);
        plot(xminp,yminp);
        plot(xminn,yminn);
        plot(xavg,yavg);

end
hold off

Xlim = get(gca, 'XLim');
Ylim = get(gca, 'YLim');

if max(Xlim) > max(Ylim)
    R    = get(gca, 'XTick');
    Maxlim = max(Xlim);
else
    R = get(gca, 'YTick');
    Maxlim = max(Ylim);
end

R = R(ceil(length(R)/2):end);

if tRmax > Maxlim
    if abs(unique(roundN(diff(R)/2,6))) >= 1
        dlt = roundN(unique(diff(R))/2,0);
    else
        dlt = unique(roundN(diff(R),6))/2;
    end
    Maxlim = ceil(tRmax/dlt)*dlt;
    R = 0:dlt:Maxlim;
else
    if abs(unique(roundN(diff(R)/2,6))) >= 1
        dlt = roundN(unique(diff(R))/2,0);
    else
        dlt = unique(roundN(diff(R),6))/2;
    end
    Maxlim = ceil(Maxlim/dlt)*dlt;
    R = 0:dlt:Maxlim;
end

delete(fig);