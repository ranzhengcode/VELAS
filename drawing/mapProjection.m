function [handle,X,Y,data] = mapProjection(data,theta,phi,proname,varargin)

% lat   [pi/2,-pi/2]
% long  [-pi,pi]

flag              = 'Mollweide'; % name={'Gall-Peters','Robinson','Hammer-Aitoff','Mollweide'};
nmesh             = 7;
cmap              = 'viridis';
lineStyle         = '--';
font.fontname     = 'Times New Roman';
font.fontweight   = 'Bold';
font.fontcolor    = 'k';
font.fontsize     = 13;
switch(nargin)
    case 5
        flag      = varargin{1};
    case 6
        flag      = varargin{1};
        nmesh     = varargin{2};
    case 7
        flag      = varargin{1};
        nmesh     = varargin{2};
        cmap      = varargin{3};
    case 8
        flag      = varargin{1};
        nmesh     = varargin{2};
        cmap      = varargin{3};
        lineStyle = varargin{4}; 
    case 9
        flag      = varargin{1};
        nmesh     = varargin{2};
        cmap      = varargin{3};
        lineStyle = varargin{4}; 
        font      = varargin{5};
end

lat  = fliplr((pi/2-theta)');
long = fliplr((pi-phi)');
data = fliplr(data');
[X,Y]  = longlat2Cartesian(long,lat,flag);  %First find the points outside

[MM,NN] = size(X);
figname = ['The ',flag,' projection of ',proname];
figure('Position',[396.20 103.40 1220.75 863.18],...
                    'Color','w','Name',figname,...
                    'NumberTitle','off');
handle = pcolor(X,Y,data);
lenD   = length(unique(data(:)));
if lenD >  8192
  lenD = 8192;
end
cmap   = interpColormap(cmap,lenD);
colormap(cmap);
shading interp;

hold on;

locX   = round(linspace(1,NN,nmesh));
locY   = round(linspace(1,MM,nmesh));
Xlabel = linspace(-180,180,nmesh);
Ylabel = fliplr(linspace(-90,90,nmesh));

lcolor = 0.95*ones(1,3);
plot(X(:,locX),Y(:,locX),'Color',lcolor,'LineStyle',lineStyle);
plot(X(locY,:)',Y(locY,:)','Color',lcolor,'LineStyle',lineStyle);
hold off;

switch(flag)
    case {'Gall-Peters','GP','gp','Robinson','R','r'}
        xAxis = X(locY,1);
        yAxis = Y(locY,1);
        for k = 1:nmesh
            text(xAxis(k)-0.3,yAxis(k)+0.02,num2str(Ylabel(k)),'Color',font.fontcolor,'FontWeight',font.fontweight,'FontSize',font.fontsize,'FontName',font.fontname);
        end
        
        xAxis = X(end,locX);
        yAxis = Y(end,locX);
        for k = 1:nmesh
            text(xAxis(k)-0.05,yAxis(k)-0.1,num2str(Xlabel(k)),'Color',font.fontcolor,'FontWeight',font.fontweight,'FontSize',font.fontsize,'FontName',font.fontname);
        end
    case {'Hammer-Aitoff','HA','ha','Mollweide','M','m'}
        %
        xAxis = X(locY,1);
        yAxis = Y(locY,1);
        for k = 1:nmesh
            str = num2str(num2str(Ylabel(k)));
            len = length(str);
            switch(len)
                case 1
                    text(xAxis(k)-0.3,yAxis(k),str,'Color',font.fontcolor,'FontWeight',font.fontweight,'FontSize',font.fontsize,'FontName',font.fontname);
                case 2
                    if k == 1
                        text(xAxis(k)-0.06,yAxis(k)+0.1,str,'Color',font.fontcolor,'FontWeight',font.fontweight,'FontSize',font.fontsize,'FontName',font.fontname);
                    elseif k == nmesh
                        text(xAxis(k)-0.1,yAxis(k)-0.1,str,'Color',font.fontcolor,'FontWeight',font.fontweight,'FontSize',font.fontsize,'FontName',font.fontname);
                    else
                        text(xAxis(k)-0.3,yAxis(k),str,'Color',font.fontcolor,'FontWeight',font.fontweight,'FontSize',font.fontsize,'FontName',font.fontname);
                    end
                case 3
                    if k == 1
                        text(xAxis(k)-0.06,yAxis(k)+0.1,str,'Color',font.fontcolor,'FontWeight',font.fontweight,'FontSize',font.fontsize,'FontName',font.fontname);
                    elseif k == nmesh
                        text(xAxis(k)-0.1,yAxis(k)-0.1,str,'Color',font.fontcolor,'FontWeight',font.fontweight,'FontSize',font.fontsize,'FontName',font.fontname);
                    else
                        if k < round((1+nmesh)/2)
                            text(xAxis(k)-0.2,yAxis(k)+0.05,str,'Color',font.fontcolor,'FontWeight',font.fontweight,'FontSize',font.fontsize,'FontName',font.fontname);
                        else
                            text(xAxis(k)-0.2,yAxis(k)-0.08,str,'Color',font.fontcolor,'FontWeight',font.fontweight,'FontSize',font.fontsize,'FontName',font.fontname);
                        end
                    end
                case 4
                    if k == 1
                        text(xAxis(k)-0.06,yAxis(k)+0.1,str);
                    elseif k == nmesh
                        text(xAxis(k)-0.1,yAxis(k)-0.1,str,'Color',font.fontcolor,'FontWeight',font.fontweight,'FontSize',font.fontsize,'FontName',font.fontname);
                    else
                        if k < round((1+nmesh)/2)
                            text(xAxis(k)-0.2,yAxis(k)+0.05,str,'Color',font.fontcolor,'FontWeight',font.fontweight,'FontSize',font.fontsize,'FontName',font.fontname);
                        else
                            text(xAxis(k)-0.2,yAxis(k)-0.08,str,'Color',font.fontcolor,'FontWeight',font.fontweight,'FontSize',font.fontsize,'FontName',font.fontname);
                        end
                    end
                case 5
                    if k < round((1+nmesh)/2)
                        text(xAxis(k)-0.25,yAxis(k)+0.05,str,'Color',font.fontcolor,'FontWeight',font.fontweight,'FontSize',font.fontsize,'FontName',font.fontname);
                    else
                        text(xAxis(k)-0.25,yAxis(k)-0.08,str,'Color',font.fontcolor,'FontWeight',font.fontweight,'FontSize',font.fontsize,'FontName',font.fontname);
                    end
               case 6
                    if k < round((1+nmesh)/2)
                        text(xAxis(k)-0.30,yAxis(k)+0.05,str,'Color',font.fontcolor,'FontWeight',font.fontweight,'FontSize',font.fontsize,'FontName',font.fontname);
                    else
                        text(xAxis(k)-0.30,yAxis(k)-0.08,str,'Color',font.fontcolor,'FontWeight',font.fontweight,'FontSize',font.fontsize,'FontName',font.fontname);
                    end
            end
        end
        % 
        xAxis = X(round((1+MM)/2),locX);
        yAxis = Y(round((1+MM)/2),locX);
        for k = 1:nmesh
            str = num2str(Xlabel(k));
            len = length(str);
            switch(len)
                case 1
                    text(xAxis(k)-0.03,yAxis(k)+0.01,str,'Color',font.fontcolor,'FontWeight',font.fontweight,'FontSize',font.fontsize,'FontName',font.fontname);
                case 2
                    text(xAxis(k)-0.06,yAxis(k)+0.01,str,'Color',font.fontcolor,'FontWeight',font.fontweight,'FontSize',font.fontsize,'FontName',font.fontname);
                case 3
                    text(xAxis(k)-0.1,yAxis(k)+0.01,str,'Color',font.fontcolor,'FontWeight',font.fontweight,'FontSize',font.fontsize,'FontName',font.fontname);
                case 4
                    text(xAxis(k)-0.115,yAxis(k)+0.01,str,'Color',font.fontcolor,'FontWeight',font.fontweight,'FontSize',font.fontsize,'FontName',font.fontname);
                case 5
                    text(xAxis(k)-0.14,yAxis(k)+0.01,str,'Color',font.fontcolor,'FontWeight',font.fontweight,'FontSize',font.fontsize,'FontName',font.fontname);
            end
        end
end

axis equal;
axis off;
