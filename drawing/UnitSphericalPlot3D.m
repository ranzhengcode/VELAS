function [handle,X,Y,Z] = UnitSphericalPlot3D(r,theta,phi,varargin)

faceColor    = 'flat';
edgeColor    = [0 0 0];
lineStyle    = '-';
faceAlpha    = 1;
faceLighting = 'flat';
pureColor    = [];
cmap         = 'viridis';
switch(nargin)
    case 4
        faceColor = varargin{1};
    case 5
        faceColor = varargin{1};
        edgeColor = varargin{2};
    case 6
        faceColor = varargin{1};
        edgeColor = varargin{2};
        lineStyle = varargin{3};
    case 7
        faceColor = varargin{1};
        edgeColor = varargin{2};
        lineStyle = varargin{3};
        faceAlpha = varargin{4};
    case 8
        faceColor = varargin{1};
        edgeColor = varargin{2};
        lineStyle = varargin{3};
        faceAlpha = varargin{4};
        faceLighting = varargin{5};
    case 9
        faceColor    = varargin{1};
        edgeColor    = varargin{2};
        lineStyle    = varargin{3};
        faceAlpha    = varargin{4};
        faceLighting = varargin{5};
        pureColor    = varargin{6};
    case 10
        faceColor    = varargin{1};
        edgeColor    = varargin{2};
        lineStyle    = varargin{3};
        faceAlpha    = varargin{4};
        faceLighting = varargin{5};
        pureColor    = varargin{6};
        cmap         = varargin{7};
end
X = sin(theta).*cos(phi);
Y = sin(theta).*sin(phi);
Z = cos(theta);
if isnumeric(r)
    lenr = length(r);
    if lenr == 1
        r = r*ones(size(X));
    end

    if isempty(pureColor)
        handle = surf(X,Y,Z,r,'FaceColor',faceColor, 'EdgeColor',edgeColor,'LineStyle',lineStyle,'FaceAlpha',faceAlpha,'FaceLighting',faceLighting,'EdgeAlpha',0);
        colormap(cmap);
        box on;
        view(30,30);
      
        set(gca,'box','on',...
            'LineWidth',1.5,...
            'FontName','Times New Roman',...
            'FontWeight','bold',...
            'FontSize',15,...
            'gridcolor',[0.5 0.5 0.5],...
            'GridLineStyle','--',...
            'GridAlpha',0.25,...
            'XMinorTick','on',....
            'YMinorTick','on',...
            'XMinorGrid','on',....
            'YMinorGrid','on',....
            'MinorGridAlpha',0.05,...
            'minorgridlinestyle',':');
        axis equal;

    else
        
        handle = surf(X,Y,Z,r,'FaceColor',faceColor, 'EdgeColor',edgeColor,'LineStyle',lineStyle,'FaceAlpha',faceAlpha,'FaceLighting',faceLighting,'EdgeAlpha',0);
        box on;
        view(30,30); 
        set(gca,'box','on',...
            'LineWidth',1.5,...
            'FontName','Times New Roman',...
            'FontWeight','bold',...
            'FontSize',15,...
            'gridcolor',[0.5 0.5 0.5],...
            'GridLineStyle','--',...
            'GridAlpha',0.25,...
            'XMinorTick','on',....
            'YMinorTick','on',...
            'XMinorGrid','on',....
            'YMinorGrid','on',....
            'MinorGridAlpha',0.05,...
            'minorgridlinestyle',':');
        axis equal;
        
    end
elseif ischar(r)
    fun = str2func(r);
    R   = fun(theta,phi);
    if isempty(pureColor)
        handle = surf(X,Y,Z,R,'FaceColor',faceColor, 'EdgeColor',edgeColor,'LineStyle',lineStyle,'FaceAlpha',faceAlpha,'FaceLighting',faceLighting);
        colormap(cmap);
        cbar=colorbar; title(cbar, 'GPa','FontName','Times New Roman','FontSize',20,'FontWeight','bold');
    else
        cdata=cat(3,pureColor(1)*ones(size(X)),pureColor(2)*ones(size(X)),pureColor(3)*ones(size(X)));
        handle = surf(X,Y,Z,cdata,'FaceColor',faceColor, 'EdgeColor',edgeColor,'LineStyle',lineStyle,'FaceAlpha',faceAlpha,'FaceLighting',faceLighting);
    end
    camlight;
    lighting gouraud;
else
    msgbox('The input radius format does not meet the requirements.', 'VELAS reminder','error');
    return;
end
