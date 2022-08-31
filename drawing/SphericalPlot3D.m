function [handle,X,Y,Z] = SphericalPlot3D(r,theta,phi,varargin)
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
L1=sin(theta).*cos(phi);
L2=sin(theta).*sin(phi);
L3=cos(theta);
if isnumeric(r)
    lenr = length(r);
    if lenr == 1
        r = r*ones(size(L1));
    end
    X = r.*L1; Y = r.*L2; Z = r.*L3;
    if isempty(pureColor)
        handle = surf(X,Y,Z,r,'FaceColor',faceColor, 'EdgeColor',edgeColor,'LineStyle',lineStyle,'FaceAlpha',faceAlpha,'FaceLighting',faceLighting,'EdgeAlpha',0);
        lenD   = length(unique(r(:)));
        if lenD >  8192
            lenD = 8192;
        end
        cmap   = interpColormap(cmap,lenD);
        colormap(cmap);
        shading interp;
        box on;
        %    set(gca,'BoxStyle','full');
        view(30,30); % 查看角度, 根据需要更改. (30,30)可能更合适
        % 设置坐标轴
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
        %     axpos = get(gca,'Position');
        %     cpos = get(cbar,'Position');
        %     cpos(1) = axpos(1)+axpos(3)+0.05;
        %     cpos(2) = axpos(2)+0.1;
        %     cpos(3) = 0.618*cpos(3);
        %     set(cbar,'Position',cpos);
        %             camlight('headlight');
        %             lighting gouraud;
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
%         camlight('right');
%         lighting gouraud;
        
    end
elseif ischar(r)
    fun = str2func(r);
    R   = fun(theta,phi);
    X   = R.*L1; Y = R.*L2; Z = R.*L3;
    if isempty(pureColor)
        handle = surf(X,Y,Z,r,'FaceColor',faceColor, 'EdgeColor',edgeColor,'LineStyle',lineStyle,'FaceAlpha',faceAlpha,'FaceLighting',faceLighting);
        lenD   = length(unique(r(:)));
        if lenD >  8192
            lenD = 8192;
        end
        cmap   = interpColormap(cmap,lenD);
        colormap(cmap);
        shading interp;
        cbar=colorbar; title(cbar, 'GPa','FontName','Times New Roman','FontSize',20,'FontWeight','bold');
    else
        cdata=cat(3,pureColor(1)*ones(size(X)),pureColor(2)*ones(size(X)),pureColor(3)*ones(size(X)));
        handle = surf(X,Y,Z,cdata,'FaceColor',faceColor, 'EdgeColor',edgeColor,'LineStyle',lineStyle,'FaceAlpha',faceAlpha,'FaceLighting',faceLighting);
        lenD   = length(unique(cdata(:)));
        if lenD >  8192
            lenD = 8192;
        end
        cmap   = interpColormap(cmap,lenD);
        colormap(cmap);
        shading interp;
    end
    camlight;
    lighting gouraud;
else
    msgbox('The input radius format does not meet the requirements.', 'Warning','error');
    return;
end
