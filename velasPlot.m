
clear; clc; close all;

[filename, pathn] = uigetfile({'*.dat'},'Select One or More input Files','MultiSelect', 'on');
if isequal(filename,0)
    errordlg('Nothing selected!','VELAS reminder');
else
    if iscell(filename)
        lenF          = size(filename,2);
        for k = 1:lenF
            inname             = filename{1,k};
            inputData(k).fname = inname;
            [inputData(k).mode,inputData(k).name,inputData(k).units,inputData(k).abbr,inputData(k).plane,inputData(k).mma] = getPropName(inname);
            tfname             = strcat(pathn,filename{1,k});
            inputData(k).data  = importdata(tfname);
        end
    else
        inputData.fname = filename;
        [inputData.mode,inputData.name,inputData.units,inputData.abbr,inputData.plane,inputData.mma] = getPropName(filename);
        tfname          = strcat(pathn,filename);
        inputData.data  = importdata(tfname);
    end
    
    %% print setting
    % pic path
    doprint = false;  % true or false
    dpi     = 600;   % Resolution, this value is not the real DPI, just control the size of pic.
    
    if doprint
        picpath = strcat(pathn,'picture');
        if ~isfolder(picpath)
            mkdir(picpath);
        end
    end
    
    % Spherical Unit 3D plot
    supctrl   = false; % true or false
    
    % map projection
    mpctrl    = true; % true or false
    flag      = 'Mollweide'; % flag = {'Gall-Peters','Robinson','Hammer-Aitoff','Mollweide'};
    nmesh     = 7;
    cmapname  = 'jet';
    cmap      = colormapdata(cmapname);
    lineStyle = '--';
    
    %% Basic setting
    % Gridline setting
    gridSwitch2D = 'off';
    gridSwitch3D = 'off';
    
    % Font setting
    fontname     = 'Times New Roman';
    fontweight   = 'bold';
    fontangle    = 'normal';
	fontcolor    = 'k';
	fontsize     = 20;
	
	font.fontname     = fontname;
    font.fontweight   = fontweight;
    font.fontangle    = fontangle;
    font.fontcolor    = fontcolor;
    font.fontsize     = fontsize;
    
    hmsg = msgbox('Plotting start!', 'VELAS reminder','help');
    pause(0.8);
    if ishandle(hmsg)
        close(hmsg);
    end
    
    %% 2D plot
    loc  = strcmp({inputData.mode},'2D');
    ind  = find(loc==1);
    lenI = length(ind);
    for dk = 1:lenI
        mpmode = size(inputData(ind(dk)).data,2);
        switch(mpmode)
            case 2
                theta   = inputData(ind(dk)).data(:,1);
                R       = inputData(ind(dk)).data(:,2);
                tR      = getRadiusTicks(theta,R);
                [tx,ty] = head2Tail(R.*cos(theta),R.*sin(theta));
                figure('Position',[396.20 103.40 1220.75 863.18],...
                    'Color','w','Name',[inputData(ind(dk)).name,' in plane (',inputData(ind(dk)).plane,')'],...
                    'NumberTitle','off');
                
                color = 0.82*[1 1 1];
                linwidth = 1.2;
                fontsize = 15;
                Rc       = tR(2);
                drawPolar(gca, tR, 13, Rc,color, linwidth, font);
                
                hold on;
                plt = plot(tx,ty,'b','LineWidth',2.0);
                hold off;
                set(gca,'xminortick','on')
                set(gca,'yminortick','on')
                set(gca, 'XLim', 1.15*max(tR)*[-1, 1]);
                set(gca, 'YLim', 1.15*max(tR)*[-1, 1]);
                legend(plt,inputData(ind(dk)).abbr,'FontName',fontname,'FontWeight',fontweight,'FontAngle',fontangle,'FontSize',fontsize);
                
            case 3
                theta   = inputData(ind(dk)).data(:,1);
                Rpos    = inputData(ind(dk)).data(:,2);
                Rneg    = inputData(ind(dk)).data(:,3);
                tR      = getRadiusTicks(theta,Rpos,Rneg);
                [xpos,ypos] = head2Tail(Rpos.*cos(theta),Rpos.*sin(theta));
                [xneg,yneg] = head2Tail(Rneg.*cos(theta),Rneg.*sin(theta));
                figure('Position',[396.20 103.40 1220.75 863.18],...
                    'Color','w','Name',[inputData(ind(dk)).name,' in plane (',inputData(ind(dk)).plane,')'],...
                    'NumberTitle','off');
                
                color = 0.82*[1 1 1];
                linwidth = 1.2;
                fontsize = 15;
                Rc       = tR(2);
                drawPolar(gca, tR, 13, Rc, color, linwidth, font);
                
                hold on;
                switch(inputData(ind(dk)).name)
                    case 'Young''s Modulus'
                        posneg  = true;
                    case 'Linear Compressibility'
                        posneg  = true;
                    case 'Bulk Modulus'
                        posneg  = true;
                    otherwise
                        posneg  = false;
                end
                if posneg
                    plt1 = plot(xpos,ypos,'b','LineWidth',2.0);
                    plt2 = plot(xneg,yneg,'r','LineWidth',2.0);
                    legend([plt1,plt2],{strcat(inputData(ind(dk)).abbr,'_{+}'),...
                        strcat(inputData(ind(dk)).abbr,'_{-}')},...
                        'FontName',fontname);
                else
                    plt1 = plot(xpos,ypos,'b','LineWidth',2.0);
                    plt2 = plot(xneg,yneg,'g','LineWidth',2.0);
                    legend([plt1,plt2], {strcat(inputData(ind(dk)).abbr,'_{max}'),...
                        strcat(inputData(ind(dk)).abbr,'_{min}')},...
                        'FontName',fontname);
                end
                
                set(gca,'xminortick','on')
                set(gca,'yminortick','on')
                set(gca, 'XLim', 1.15*max(tR)*[-1, 1]);
                set(gca, 'YLim', 1.15*max(tR)*[-1, 1]);
                hold off;
                
            case 4
                theta   = inputData(ind(dk)).data(:,1);
                Rmax    = inputData(ind(dk)).data(:,2);
                Rmin    = inputData(ind(dk)).data(:,3);
                Ravg    = inputData(ind(dk)).data(:,4);
                tR      = getRadiusTicks(theta,Rmax,Rmin,Ravg);
                [xmax,ymax] = head2Tail(Rmax.*cos(theta),Rmax.*sin(theta));
                [xmin,ymin] = head2Tail(Rmin.*cos(theta),Rmin.*sin(theta));
                [xavg,yavg] = head2Tail(Ravg.*cos(theta),Ravg.*sin(theta));
                figure('Position',[396.20 103.40 1220.75 863.18],...
                    'Color','w','Name',[inputData(ind(dk)).name,' in plane (',inputData(ind(dk)).plane,')'],...
                    'NumberTitle','off');
                
                color = 0.82*[1 1 1];
                linwidth = 1.2;
                fontsize = 15;
                Rc       = tR(2);
                drawPolar(gca, tR, 13, Rc, color, linwidth, font);
                
                hold on;
                plt1 = plot(xmax,ymax,'b','LineWidth',2.0);
                plt2 = plot(xmin,ymin,'g','LineWidth',2.0);
                
                switch(inputData(ind(dk)).name)
                    case 'Shear Modulus'
                        posneg  = false || min(Rmin) < 0;
                    case 'Poisson''s Ratio'
                        posneg  = true;
                    case 'Vickers Hardness'
                        posneg  = false || min(Rmin) < 0;
                    case 'Pugh Ratio'
                        posneg  = false || min(Rmin) < 0;
                    case 'Fracture Toughness'
                        posneg  = false || min(Rmin) < 0;
                    otherwise
                        posneg  = false;
                end
                
                if posneg
                    plt3 = plot(xavg,yavg,'Color','r','LineWidth',2.0);
                    legend([plt1,plt2,plt3],{strcat(inputData(ind(dk)).abbr,'_{max}'),...
                        strcat(inputData(ind(dk)).abbr,'_{min +}'),...
                        strcat(inputData(ind(dk)).abbr,'_{min -}')},...
                        'FontName',fontname);
                else
                    plt3 = plot(xavg,yavg,'Color',[0 0.4470 0.7410],'LineWidth',2.0);
                    legend([plt1,plt2,plt3],{strcat(inputData(ind(dk)).abbr,'_{max}'),...
                        strcat(inputData(ind(dk)).abbr,'_{min}'),...
                        strcat(inputData(ind(dk)).abbr,'_{avg}')},...
                        'FontName',fontname);
                end
                set(gca,'xminortick','on')
                set(gca,'yminortick','on')
                set(gca, 'XLim', 1.15*max(tR)*[-1, 1]);
                set(gca, 'YLim', 1.15*max(tR)*[-1, 1]);
                hold off;
                
            case 5
                theta   = inputData(ind(dk)).data(:,1);
                Rmax    = inputData(ind(dk)).data(:,2);
                Rminp   = inputData(ind(dk)).data(:,3);
                Rminn   = inputData(ind(dk)).data(:,4);
                Ravg    = inputData(ind(dk)).data(:,5);
                tR      = getRadiusTicks(theta,Rmax,Rminp,Rminn,Ravg);
                [xmax,ymax]   = head2Tail(Rmax.*cos(theta),Rmax.*sin(theta));
                [xminp,yminp] = head2Tail(Rminp.*cos(theta),Rminp.*sin(theta));
                [xminn,yminn] = head2Tail(Rminn.*cos(theta),Rminn.*sin(theta));
                [xavg,yavg] = head2Tail(Ravg.*cos(theta),Ravg.*sin(theta));
                figure('Position',[396.20 103.40 1220.75 863.18],...
                    'Color','w','Name',[inputData(ind(dk)).name,' in plane (',inputData(ind(dk)).plane,')'],...
                    'NumberTitle','off');
                
                color = 0.82*[1 1 1];
                linwidth = 1.2;
                fontsize = 15;
                Rc       = tR(2);
                drawPolar(gca, tR, 13, Rc,color, linwidth, font);
                
                hold on;
                plt1 = plot(xmax,ymax,'b','LineWidth',2.0);
                plt2 = plot(xminp,yminp,'g','LineWidth',2.0);
                plt3 = plot(xminn,yminn,'r','LineWidth',2.0);
                plt4 = plot(xavg,yavg,'Color',[0 0.4470 0.7410],'LineWidth',2.0);
                hold off;
                
                if isempty(inputData(ind(dk)).units)
                    xlab  = strcat(inputData(ind(dk)).abbr,'_{X}');
                    ylab  = strcat(inputData(ind(dk)).abbr,'_{Y}');
                else
                    xlab  = [strcat(inputData(ind(dk)).abbr,'_{X}'),char(32),'(',inputData(ind(dk)).units,')'];
                    ylab  = [strcat(inputData(ind(dk)).abbr,'_{Y}'),char(32),'(',inputData(ind(dk)).units,')'];
                end
                xlabel(xlab,'FontName',fontname,'FontWeight',fontweight,'FontAngle',fontangle,'FontSize',fontsize);
                ylabel(ylab,'FontName',fontname,'FontWeight',fontweight,'FontAngle',fontangle,'FontSize',fontsize);
                legend([plt1,plt2,plt3,plt4],{strcat(inputData(ind(dk)).abbr,'_{max}'),...
                    strcat(inputData(ind(dk)).abbr,'_{min +}'),...
                    strcat(inputData(ind(dk)).abbr,'_{min -}'),...
                    strcat(inputData(ind(dk)).abbr,'_{avg}')},...
                    'FontName',fontname);
                
                set(gca,'xminortick','on')
                set(gca,'yminortick','on')
                set(gca, 'XLim', 1.15*max(tR)*[-1, 1]);
                set(gca, 'YLim', 1.15*max(tR)*[-1, 1]);
        end
        
        xlm = get(gca,'xlim');
        ylm = get(gca,'ylim');
        axis equal;
        axis([xlm ylm]);
        set(gca,'box','on',...
            'LineWidth',1.5,...
            'FontName',fontname,...
            'FontWeight',fontweight,...
            'FontAngle',fontangle,...
            ...
            'FontSize',fontsize,...
            'XMinorTick','on',....
            'YMinorTick','on',...
            'XMinorGrid',gridSwitch2D,....
            'YMinorGrid',gridSwitch2D,....
            'gridcolor',[0.5 0.5 0.5],...
            'GridLineStyle','--',...
            'GridAlpha',0.25,...
            'MinorGridAlpha',0.05,...
            'minorgridlinestyle',':');
        legend('boxoff');
        
        if isempty(inputData(ind(dk)).units)
            xlab  = strcat(inputData(ind(dk)).abbr,'_{X}');
            ylab  = strcat(inputData(ind(dk)).abbr,'_{Y}');
        else
            xlab  = [strcat(inputData(ind(dk)).abbr,'_{X}'),char(32),'(',inputData(ind(dk)).units,')'];
            ylab  = [strcat(inputData(ind(dk)).abbr,'_{Y}'),char(32),'(',inputData(ind(dk)).units,')'];
        end
        xlabel(xlab,'FontName',fontname,'FontWeight',fontweight,'FontAngle',fontangle,'FontSize',fontsize);
        ylabel(ylab,'FontName',fontname,'FontWeight',fontweight,'FontAngle',fontangle,'FontSize',fontsize);
        
        % print pic
        if doprint
            picname = strcat(picpath,filesep,strrep(inputData(dk).fname,'dat','tif'));
            ddpi    = strcat('-r',dpi);
            print(gcf,picname,ddpi, "-dtiffn");
            pause(1e-6);
        end
    end
    
    %% 3D plot and map projection
    loc  = strcmp({inputData.mode},'3D');
    ind  = find(loc==1);
    lenI = length(ind);
    if any(lenI)
        loc  = strcmp({inputData.mode},'3D');
        [m,n] = size(inputData(ind(1)).data);
        [theta,phi] = meshgrid(linspace(0,pi,n),linspace(0,2*pi,m));
        % 'FaceColor','EdgeColor','LineStyle','FaceAlpha','FaceLighting'
        for dk = 1:lenI
            if isempty(inputData(ind(dk)).mma)
                figure('Position',[396.20 103.40 1220.75 863.18],...
                    'Color','w','Name',[inputData(ind(dk)).mode,char(32),inputData(ind(dk)).name],...
                    'NumberTitle','off');
            else
                figure('Position',[396.20 103.40 1220.75 863.18],...
                    'Color','w','Name',[inputData(ind(dk)).mma,char(32),'of',char(32),inputData(ind(dk)).mode,char(32),inputData(ind(dk)).name],...
                    'NumberTitle','off');
            end
            hold on;
            SphericalPlot3D(inputData(ind(dk)).data,theta,phi,'interp','none','none',1);
            hold off;
            if isempty(inputData(ind(dk)).units)
                xlab  = strcat(inputData(ind(dk)).abbr,'_{X}');
                ylab  = strcat(inputData(ind(dk)).abbr,'_{Y}');
                zlab  = strcat(inputData(ind(dk)).abbr,'_{Z}');
            else
                xlab  = [inputData(ind(dk)).abbr,'_{X}',char(32),'(',inputData(ind(dk)).units,')'];
                ylab  = [inputData(ind(dk)).abbr,'_{Y}',char(32),'(',inputData(ind(dk)).units,')'];
                zlab  = [inputData(ind(dk)).abbr,'_{Z}',char(32),'(',inputData(ind(dk)).units,')'];
            end
            xlabel(xlab,'FontName',fontname,'FontWeight',fontweight,'FontSize',fontsize);
            ylabel(ylab,'FontName',fontname,'FontWeight',fontweight,'FontSize',fontsize);
            zlabel(zlab,'FontName',fontname,'FontWeight',fontweight,'FontSize',fontsize);
            set(gca,'box','on',...
                'LineWidth',1.5,...
                'FontName',fontname,...
                'FontWeight',fontweight,...
                'FontSize',fontsize,...
                'gridcolor',[0.5 0.5 0.5],...
                'GridLineStyle','--',...
                'GridAlpha',0.15,...
                'XMinorTick','on',....
                'YMinorTick','on',...
                'ZMinorTick','on',...
                'XMinorGrid',gridSwitch3D,....
                'YMinorGrid',gridSwitch3D,....
                'ZMinorGrid',gridSwitch3D,....
                'MinorGridAlpha',0.05,...
                'minorgridlinestyle',':');
            
            % set colorbar
            cbar    = colorbar;
            title(cbar, inputData(ind(dk)).units,'FontName',fontname,'FontSize',fontsize,'FontWeight',fontweight);
            set(cbar,'FontName',fontname,'FontSize',fontsize,'FontWeight',fontweight);
            axpos   = get(gca,'Position');
            cpos    = get(cbar,'Position');
            if isOctave
                  cpos(1) = axpos(1)+axpos(3)+0.05;
                  cpos(2) = axpos(2)+0.1;
                  cpos(3) = 0.618*cpos(3);
             else
                  cpos(1) = axpos(1)+axpos(3)+0.065;
            end
            set(cbar,'Position',cpos);
            proname = [inputData(ind(dk)).mma,char(32),inputData(ind(dk)).name];
            
            % print pic
            if doprint
                picname = strcat(picpath,filesep,strrep(inputData(ind(dk)).fname,'dat','tif'));
                ddpi    = strcat('-r',num2str(dpi));
                print(gcf,picname,ddpi, "-dtiffn");
                pause(1e-6);
            end
            
            % Spherical Unit 3D
            if supctrl
                if isempty(inputData(ind(dk)).mma)
                    figure('Position',[396.20 103.40 1220.75 863.18],...
                        'Color','w','Name',[inputData(ind(dk)).mode,char(32),inputData(ind(dk)).name,'_SUnit'],...
                        'NumberTitle','off');
                else
                    figure('Position',[396.20 103.40 1220.75 863.18],...
                        'Color','w','Name',[inputData(ind(dk)).mma,char(32),'of',char(32),inputData(ind(dk)).mode,char(32),inputData(ind(dk)).name,'_SUnit'],...
                        'NumberTitle','off');
                end
                hold on;
                SphericalUnitPlot3D(inputData(ind(dk)).data,theta,phi,'interp','none','none',1);
                hold off;
                if isempty(inputData(ind(dk)).units)
                    xlab  = strcat(inputData(ind(dk)).abbr,'_{X}');
                    ylab  = strcat(inputData(ind(dk)).abbr,'_{Y}');
                    zlab  = strcat(inputData(ind(dk)).abbr,'_{Z}');
                else
                    xlab  = [inputData(ind(dk)).abbr,'_{X}',char(32),'(',inputData(ind(dk)).units,')'];
                    ylab  = [inputData(ind(dk)).abbr,'_{Y}',char(32),'(',inputData(ind(dk)).units,')'];
                    zlab  = [inputData(ind(dk)).abbr,'_{Z}',char(32),'(',inputData(ind(dk)).units,')'];
                end
                xlabel(xlab,'FontName',fontname,'FontWeight',fontweight,'FontSize',fontsize);
                ylabel(ylab,'FontName',fontname,'FontWeight',fontweight,'FontSize',fontsize);
                zlabel(zlab,'FontName',fontname,'FontWeight',fontweight,'FontSize',fontsize);
                set(gca,'box','on',...
                    'LineWidth',1.5,...
                    'FontName',fontname,...
                    'FontWeight',fontweight,...
                    'FontSize',fontsize,...
                    'gridcolor',[0.5 0.5 0.5],...
                    'GridLineStyle','--',...
                    'GridAlpha',0.15,...
                    'XMinorTick','on',....
                    'YMinorTick','on',...
                    'ZMinorTick','on',...
                    'XMinorGrid',gridSwitch3D,....
                    'YMinorGrid',gridSwitch3D,....
                    'ZMinorGrid',gridSwitch3D,....
                    'MinorGridAlpha',0.05,...
                    'minorgridlinestyle',':');
                
                % set colorbar
                cbar    = colorbar;
                title(cbar, inputData(ind(dk)).units,'FontName',fontname,'FontSize',fontsize,'FontWeight',fontweight);
                set(cbar,'FontName',fontname,'FontSize',fontsize,'FontWeight',fontweight);
                axpos   = get(gca,'Position');
                cpos    = get(cbar,'Position');
                if isOctave
                  cpos(1) = axpos(1)+axpos(3)+0.05;
                  cpos(2) = axpos(2)+0.1;
                  cpos(3) = 0.618*cpos(3);
                else
                  cpos(1) = axpos(1)+axpos(3)+0.065;
                end
                set(cbar,'Position',cpos);
                proname = [inputData(ind(dk)).mma,char(32),inputData(ind(dk)).name];
                
                % print pic
                if doprint
                    picname = strcat(picpath,filesep,strrep(inputData(ind(dk)).fname,'.dat','_SUnit.tif'));
                    ddpi    = strcat('-r',num2str(dpi));
                    print(gcf,picname,ddpi, "-dtiffn");
                    pause(1e-6);
                end
            end
            
            % Map Projection
            if mpctrl
                mapProjection(inputData(ind(dk)).data,theta,phi,proname,flag,nmesh,cmap,lineStyle);
                % set colorbar
                cbar = colorbar;
                title(cbar, inputData(ind(dk)).units,'FontName',fontname,'FontSize',fontsize,'FontWeight',fontweight);
                set(cbar,'FontName',fontname,'FontSize',fontsize,'FontWeight',fontweight);
                axpos = get(gca,'Position');
                cpos = get(cbar,'Position');
                if isOctave
                  cpos(1) = axpos(1)+axpos(3)+0.05;
                  cpos(2) = axpos(2)+0.1;
                  cpos(3) = 0.618*cpos(3);
                else
                  cpos(1) = axpos(1)+axpos(3)+0.065;
                end
                set(cbar,'Position',cpos);
                
                % print pic
                if doprint
                    picname = strcat(picpath,filesep,strrep(inputData(ind(dk)).fname,'.dat','_map.tif'));
                    ddpi    = strcat('-r',num2str(dpi));
                    print(gcf,picname,ddpi, "-dtiffn");
                    pause(1e-6);
                end
            end
        end
    end
    
    %% Combine maximum, minimum and average graphs for 3D Young's Modulus, Bulk Modulus, Linear Compressibility, Shear Modulus, Poisson's Ratio,
    % Pugh Ratio, Vickers Hardness, and Fracture Toughness.
    
    combn = regexp(pathn,strcat('\',filesep),'split');
    combn(cellfun(@isempty,combn)) = [];
    combname = combn{end};
    
    % Young's Modulus
    locE  = strcmp({inputData(ind).name},'Young''s Modulus');
    indE  = ind(locE==1);
    lenE = length(indE);
    lenC  = 256;              % length for colormap
    if lenE >= 2
        str  = 'The';
        for tk = 1:lenE
            if tk < lenE
                str = [str,char(32),inputData(indE(tk)).mma,',',char(32)];
            else
                str = [str,char(32),inputData(indE(tk)).mma,char(32)];
            end
        end
        
        figure('Position',[396.20 103.40 1220.75 863.18],...
            'Color','w','Name',[str,char(32),'of',char(32),inputData(indE(1)).mode,char(32),inputData(indE(1)).name],...
            'NumberTitle','off');
        hold on;
        
        locEmma   = strcmp({inputData(indE).mma},'Negative');
        locEminn  = indE(locEmma==1);
        if ~isempty(locEminn)
            hE(1) = SphericalPlot3D(inputData(locEminn).data,theta,phi,'interp','none','none',1,'none','r');
        end
        
        locEmma  = strcmp({inputData(indE).mma},'Positive');
        locEminp  = indE(locEmma==1);
        if ~isempty(locEminp)
            hE(2) = SphericalPlot3D(inputData(locEminp).data,theta,phi,'interp','none','none',1,'none','b');
        end
        
        Emap1 = setColor('r',lenC);
        Emap2 = setColor('b',lenC);
        colormap([Emap1;Emap2]);
        
        Ecmin1 = min(inputData(locEminn).data(:));
        Ecmax1 = max(inputData(locEminn).data(:));
        Ecmin2 = min(inputData(locEminp).data(:));
        Ecmax2 = max(inputData(locEminp).data(:));
        
        % CData for surface
        EC1 = min(lenC,round((lenC-1)*(inputData(locEminn).data-Ecmin1)/(Ecmax1-Ecmin1))+1);
        EC2 = lenC+min(lenC,round((lenC-1)*(inputData(locEminp).data-Ecmin1)/(Ecmax2-Ecmin2))+1);
        
        % Update the CDatas for each object.
        set(hE(1),'CData',EC1);
        set(hE(2),'CData',EC2);
        
        % Change the CLim property of axes so that it spans the
        % CDatas of both objects.
        caxis([min(EC1(:)) max(EC2(:))]);
        
        hold off;
        xlabel('E_{X} (GPa)','FontName',fontname,'FontWeight',fontweight,'FontSize',fontsize);
        ylabel('E_{Y} (GPa)','FontName',fontname,'FontWeight',fontweight,'FontSize',fontsize);
        zlabel('E_{Z} (GPa)','FontName',fontname,'FontWeight',fontweight,'FontSize',fontsize);
        set(gca,'box','on',...
            'LineWidth',1.5,...
            'FontName',fontname,...
            'FontWeight',fontweight,...
            'FontSize',fontsize,...
            'gridcolor',[0.5 0.5 0.5],...
            'gridLineStyle','--',...
            'gridAlpha',0.25,...
            'XMinorTick','on',....
            'YMinorTick','on',...
            'ZMinorTick','on',...
            'XMinorgrid',gridSwitch3D,....
            'YMinorgrid',gridSwitch3D,....
            'ZMinorgrid',gridSwitch3D,....
            'MinorgridAlpha',0.05,...
            'minorgridlinestyle',':');
        
        % print pic
        if doprint
            picname = strcat(picpath,filesep,strcat(combname,'_3D_E_comb.tif'));
            ddpi    = strcat('-r',num2str(dpi));
            print(gcf,picname,ddpi, "-dtiffn");
            pause(1e-6);
        end
    end
    
    % Linear Compressibility
    locLC  = strcmp({inputData(ind).name},'Linear Compressibility');
    indLC  = ind(locLC==1);
    lenLC = length(indLC);
    lenC  = 256;              % length for colormap
    if lenLC >= 2
        str  = 'The';
        for tk = 1:lenLC
            if tk < lenLC
                str = [str,char(32),inputData(indLC(tk)).mma,',',char(32)];
            else
                str = [str,char(32),inputData(indLC(tk)).mma,char(32)];
            end
        end
        
        figure('Position',[396.20 103.40 1220.75 863.18],...
            'Color','w','Name',[str,char(32),'of',char(32),inputData(indLC(1)).mode,char(32),inputData(indLC(1)).name],...
            'NumberTitle','off');
        hold on;
        
        locLCmma   = strcmp({inputData(indLC).mma},'Negative');
        locLCminn  = indLC(locLCmma==1);
        if ~isempty(locLCminn)
            hLC(1) = SphericalPlot3D(inputData(locLCminn).data,theta,phi,'interp','none','none',1,'none','r');
        end
        
        locLCmma  = strcmp({inputData(indLC).mma},'Positive');
        locLCminp  = indLC(locLCmma==1);
        if ~isempty(locLCminp)
            hLC(2) = SphericalPlot3D(inputData(locLCminp).data,theta,phi,'interp','none','none',1,'none','b');
        end
        
        LCmap1 = setColor('r',lenC);
        LCmap2 = setColor('b',lenC);
        colormap([LCmap1;LCmap2]);
        
        LCcmin1 = min(inputData(locLCminn).data(:));
        LCcmax1 = max(inputData(locLCminn).data(:));
        LCcmin2 = min(inputData(locLCminp).data(:));
        LCcmax2 = max(inputData(locLCminp).data(:));
        
        % CData for surface
        LCC1 = min(lenC,round((lenC-1)*(inputData(locLCminn).data-LCcmin1)/(LCcmax1-LCcmin1))+1);
        LCC2 = lenC+min(lenC,round((lenC-1)*(inputData(locLCminp).data-LCcmin1)/(LCcmax2-LCcmin2))+1);
        
        % Update the CDatas for each object.
        set(hLC(1),'CData',LCC1);
        set(hLC(2),'CData',LCC2);
        
        % Change the CLim property of axes so that it spans the
        % CDatas of both objects.
        caxis([min(LCC1(:)) max(LCC2(:))]);
        
        hold off;
        xlabel('LC_{X} (TPa^{-1})','FontName',fontname,'FontWeight',fontweight,'FontSize',fontsize);
        ylabel('LC_{Y} (TPa^{-1})','FontName',fontname,'FontWeight',fontweight,'FontSize',fontsize);
        zlabel('LC_{Z} (TPa^{-1})','FontName',fontname,'FontWeight',fontweight,'FontSize',fontsize);
        set(gca,'box','on',...
            'LineWidth',1.5,...
            'FontName',fontname,...
            'FontWeight',fontweight,...
            'FontSize',fontsize,...
            'gridcolor',[0.5 0.5 0.5],...
            'gridLineStyle','--',...
            'gridAlpha',0.25,...
            'XMinorTick','on',....
            'YMinorTick','on',...
            'ZMinorTick','on',...
            'XMinorgrid',gridSwitch3D,....
            'YMinorgrid',gridSwitch3D,....
            'ZMinorgrid',gridSwitch3D,....
            'MinorgridAlpha',0.05,...
            'minorgridlinestyle',':');
        
        % print pic
        if doprint
            picname = strcat(picpath,filesep,strcat(combname,'_3D_beta_comb.tif'));
            ddpi    = strcat('-r',num2str(dpi));
            print(gcf,picname,ddpi, "-dtiffn");
            pause(1e-6);
        end
    end
    
    % Bulk Modulus
    locB  = strcmp({inputData(ind).name},'Bulk Modulus');
    indB  = ind(locB==1);
    lenB  = length(indB);
    lenC  = 256;              % length for colormap
    if lenB >= 2
        str  = 'The';
        for tk = 1:lenB
            if tk < lenB
                str = [str,char(32),inputData(indB(tk)).mma,',',char(32)];
            else
                str = [str,char(32),inputData(indB(tk)).mma,char(32)];
            end
        end
        
        figure('Position',[396.20 103.40 1220.75 863.18],...
            'Color','w','Name',[str,char(32),'of',char(32),inputData(indB(1)).mode,char(32),inputData(indB(1)).name],...
            'NumberTitle','off');
        hold on;
        
        locBmma   = strcmp({inputData(indB).mma},'Negative');
        locBminn  = indB(locBmma==1);
        if ~isempty(locBminn)
            hB(1) = SphericalPlot3D(inputData(locBminn).data,theta,phi,'interp','none','none',1,'none','r');
        end
        
        locBmma   = strcmp({inputData(indB).mma},'Positive');
        locBminp  = indB(locBmma==1);
        if ~isempty(locBminp)
            hB(2) = SphericalPlot3D(inputData(locBminp).data,theta,phi,'interp','none','none',1,'none','b');
        end
        
        Bmap1 = setColor('r',lenC);
        Bmap2 = setColor('b',lenC);
        colormap([Bmap1;Bmap2]);
        
        Bcmin1 = min(inputData(locBminn).data(:));
        Bcmax1 = max(inputData(locBminn).data(:));
        Bcmin2 = min(inputData(locBminp).data(:));
        Bcmax2 = max(inputData(locBminp).data(:));
        
        % CData for surface
        BC1 = min(lenC,round((lenC-1)*(inputData(locBminn).data-Bcmin1)/(Bcmax1-Bcmin1))+1);
        BC2 = lenC+min(lenC,round((lenC-1)*(inputData(locBminp).data-Bcmin1)/(Bcmax2-Bcmin2))+1);
        
        % Update the CDatas for each object.
        set(hB(1),'CData',BC1);
        set(hB(2),'CData',BC2);
        
        % Change the CLim property of axes so that it spans the
        % CDatas of both objects.
        caxis([min(BC1(:)) max(BC2(:))]);
        
        hold off;
        xlabel('B_{X} (GPa)','FontName',fontname,'FontWeight',fontweight,'FontSize',fontsize);
        ylabel('B_{Y} (GPa)','FontName',fontname,'FontWeight',fontweight,'FontSize',fontsize);
        zlabel('B_{Z} (GPa)','FontName',fontname,'FontWeight',fontweight,'FontSize',fontsize);
        set(gca,'box','on',...
            'LineWidth',1.5,...
            'FontName',fontname,...
            'FontWeight',fontweight,...
            'FontSize',fontsize,...
            'gridcolor',[0.5 0.5 0.5],...
            'gridLineStyle','--',...
            'gridAlpha',0.25,...
            'XMinorTick','on',....
            'YMinorTick','on',...
            'ZMinorTick','on',...
            'XMinorgrid',gridSwitch3D,....
            'YMinorgrid',gridSwitch3D,....
            'ZMinorgrid',gridSwitch3D,....
            'MinorgridAlpha',0.05,...
            'minorgridlinestyle',':');
        
        % print pic
        if doprint
            picname = strcat(picpath,filesep,strcat(combname,'_3D_B_comb.tif'));
            ddpi    = strcat('-r',num2str(dpi));
            print(gcf,picname,ddpi, "-dtiffn");
            pause(1e-6);
        end
    end
    
    % Shear Modulus
    locG  = strcmp({inputData(ind).name},'Shear Modulus');
    indG  = ind(locG==1);
    lenG = length(indG);
    if lenG >= 2
        str  = 'The';
        for tk = 1:lenG
            if tk < lenG
                str = [str,char(32),inputData(indG(tk)).mma,',',char(32)];
            else
                str = [str,char(32),inputData(indG(tk)).mma,char(32)];
            end
        end
        
        figure('Position',[396.20 103.40 1220.75 863.18],...
            'Color','w','Name',[str,char(32),'of',char(32),inputData(indG(1)).mode,char(32),inputData(indG(1)).name],...
            'NumberTitle','off');
        hold on;
        locGmma   = strcmp({inputData(indG).mma},'Minimum negative');
        locGminn  = indG(locGmma==1);
        if ~isempty(locGminn)
            Gmap1 = setColor('r',lenC);
            Gh(1) = SphericalPlot3D(inputData(locGminn).data,theta,phi,'interp','none','none',1,'none','r');
            GZ{1} = inputData(locGminn).data;
            Gmxmi = [min(inputData(locGminn).data(:)) max(inputData(locGminn).data(:))];
        end
        locGmma  = strcmp({inputData(indG).mma},'Minimum positive');
        locGminp  = indG(locGmma==1);
        if ~isempty(locGminp)
            if exist('Gmap1','var')
                Gmap2 = setColor('g',lenC);
                Gh(2) = SphericalPlot3D(inputData(locGminp).data,theta,phi,'interp','none','none',1,'none','g');
                GZ{2} = inputData(locGminp).data;
                Gmxmi = [Gmxmi; min(inputData(locGminp).data(:)) max(inputData(locGminp).data(:))];
                Gmap  = [Gmap1;Gmap2];
            else
                Gmap1 = setColor('g',lenC);
                Gh(1) = SphericalPlot3D(inputData(locGminp).data,theta,phi,'interp','none','none',1,'none','g');
                GZ{1} = inputData(locGminp).data;
                Gmxmi = [min(inputData(locGminp).data(:)) max(inputData(locGminp).data(:))];
            end
        end
        locGmma  = strcmp({inputData(indG).mma},'Maximum');
        locGmax  = indG(locGmma==1);
        if ~isempty(locGmax)
            if exist('Gmap2','var')
                Gmap3 = setColor('b',lenC);
                Gh(3) = SphericalPlot3D(inputData(locGmax).data,theta,phi,'interp','none','none',0.35,'none','b');
                GZ{3} = inputData(locGmax).data;
                Gmap  = [Gmap1;Gmap2;Gmap3];
                Gmxmi = [Gmxmi; min(inputData(locGmax).data(:)) max(inputData(locGmax).data(:))];
            else
                Gmap2 = setColor('b',lenC);
                Gh(2) = SphericalPlot3D(inputData(locGmax).data,theta,phi,'interp','none','none',0.5,'none','b');
                GZ{2} = inputData(locGmax).data;
                Gmxmi = [Gmxmi; min(inputData(locGmax).data(:)) max(inputData(locGmax).data(:))];
                Gmap  = [Gmap1;Gmap2];
            end
        end
        colormap(Gmap);
        
        if length(Gh) == 2
            % CData for surface
            GC1 = min(lenC,round((lenC-1)*(GZ{1}-Gmxmi(1,1))/(Gmxmi(1,2)-Gmxmi(1,1)))+1);
            GC2 = lenC+min(lenC,round((lenC-1)*(GZ{2}-Gmxmi(2,1))/(Gmxmi(2,2)-Gmxmi(2,1)))+1);
            
            % Update the CDatas for each object.
            set(Gh(1),'CData',GC1);
            set(Gh(2),'CData',GC2);
            
            % Change the CLim property of axes so that it spans the CDatas of both objects.
            caxis([min(GC1(:)) max(GC2(:))]);
        else
            % CData for surface
            GC1 = min(lenC,round((lenC-1)*(GZ{1}-Gmxmi(1,1))/(Gmxmi(1,2)-Gmxmi(1,1)))+1);
            GC2 = lenC+min(lenC,round((lenC-1)*(GZ{2}-Gmxmi(2,1))/(Gmxmi(2,2)-Gmxmi(2,1)))+1);
            GC3 = 2*lenC+min(lenC,round((lenC-1)*(GZ{3}-Gmxmi(3,1))/(Gmxmi(3,2)-Gmxmi(3,1)))+1);
            
            % Update the CDatas for each object.
            set(Gh(1),'CData',GC1);
            set(Gh(2),'CData',GC2);
            set(Gh(3),'CData',GC3);
            
            % Change the CLim property of axes so that it spans the CDatas of both objects.
            caxis([min(GC1(:)) max(GC3(:))]);
        end
        
        hold off;
        xlabel('G_{X} (GPa)','FontName',fontname,'FontWeight',fontweight,'FontSize',fontsize);
        ylabel('G_{Y} (GPa)','FontName',fontname,'FontWeight',fontweight,'FontSize',fontsize);
        zlabel('G_{Z} (GPa)','FontName',fontname,'FontWeight',fontweight,'FontSize',fontsize);
        set(gca,'box','on',...
            'LineWidth',1.5,...
            'FontName',fontname,...
            'FontWeight',fontweight,...
            'FontSize',fontsize,...
            'gridcolor',[0.5 0.5 0.5],...
            'GridLineStyle','--',...
            'GridAlpha',0.25,...
            'XMinorTick','on',....
            'YMinorTick','on',...
            'ZMinorTick','on',...
            'XMinorGrid',gridSwitch3D,....
            'YMinorGrid',gridSwitch3D,....
            'ZMinorGrid',gridSwitch3D,....
            'MinorGridAlpha',0.05,...
            'minorgridlinestyle',':');
        
        % print pic
        if doprint
            picname = strcat(picpath,filesep,strcat(combname,'_3D_G_comb.tif'));
            ddpi    = strcat('-r',num2str(dpi));
            print(gcf,picname,ddpi, "-dtiffn");
            pause(1e-6);
        end
    end
    
    % Poisson's Ratio
    locP   = strcmp({inputData(ind).name},'Poisson''s Ratio');
    indP   = ind(locP==1);
    lenP   = length(indP);
    if lenP >= 2
        str  = 'The';
        for tk = 1:lenP
            if tk < lenP
                str = [str,char(32),inputData(indP(tk)).mma,',',char(32)];
            else
                str = [str,char(32),inputData(indP(tk)).mma,char(32)];
            end
        end
        
        figure('Position',[396.20 103.40 1220.75 863.18],...
            'Color','w','Name',[str,char(32),'of',char(32),inputData(indP(1)).mode,char(32),inputData(indP(1)).name],...
            'NumberTitle','off');
        hold on;
        
        locPmma  = strcmp({inputData(indP).mma},'Minimum negative');
        locPminn  = indP(locPmma==1);
        
        locPmma   = strcmp({inputData(indP).mma},'Minimum positive');
        locPminp  = indP(locPmma==1);
        
        locPmma  = strcmp({inputData(indP).mma},'Maximum');
        locPmax  = indP(locPmma==1);
        negMax   = false;
        
        if ~isempty(locPminn)
            Pminn = inputData(locPminn).data;
            PminnMax = max(Pminn(:));
            if ~isempty(locPmax)
                Pmax  = inputData(locPmax).data;
                PmaxMax = max(Pmax(:));
                if PminnMax > PmaxMax
                    negMax   = true;
                end
            end
        end
        
        if ~negMax
            if ~isempty(locPminn)
                Pmap1 = setColor('r',lenC);
                Ph(1) = SphericalPlot3D(inputData(locPminn).data,theta,phi,'interp','none','none',1,'none','r');
                PZ{1} = inputData(locPminn).data;
                Pmxmi = [min(inputData(locPminn).data(:)) max(inputData(locPminn).data(:))];
            end
            
            if ~isempty(locPminp)
                if exist('Pmap1','var')
                    Pmap2 = setColor('g',lenC);
                    Ph(2) = SphericalPlot3D(inputData(locPminp).data,theta,phi,'interp','none','none',0.7,'none','g');
                    PZ{2} = inputData(locPminp).data;
                    Pmxmi = [Pmxmi; min(inputData(locPminp).data(:)) max(inputData(locPminp).data(:))];
                    Pmap  = [Pmap1;Pmap2];
                else
                    Pmap1 = setColor('g',lenC);
                    Ph(1) = SphericalPlot3D(inputData(locPminp).data,theta,phi,'interp','none','none',1,'none','g');
                    PZ{1} = inputData(locPminp).data;
                    Pmxmi = [min(inputData(locPminp).data(:)) max(inputData(locPminp).data(:))];
                end
            end
            
            if ~isempty(locPmax)
                if exist('Pmap2','var')
                    Pmap3 = setColor('b',lenC);
                    Ph(3) = SphericalPlot3D(inputData(locPmax).data,theta,phi,'interp','none','none',0.35,'none','b');
                    PZ{3} = inputData(locPmax).data;
                    Pmap  = [Pmap1;Pmap2;Pmap3];
                    Pmxmi = [Pmxmi; min(inputData(locPmax).data(:)) max(abs(inputData(locPmax).data(:)))];
                else
                    Pmap2 = setColor('b',lenC);
                    Ph(2) = SphericalPlot3D(inputData(locPmax).data,theta,phi,'interp','none','none',0.5,'none','b');
                    PZ{2} = inputData(locPmax).data;
                    Pmxmi = [Pmxmi; min(inputData(locPmax).data(:)) max(inputData(locPmax).data(:))];
                    Pmap  = [Pmap1;Pmap2];
                end
            end
        else
            if ~isempty(locPmax)
                Pmap1 = setColor('b',lenC);
                Ph(1) = SphericalPlot3D(inputData(locPmax).data,theta,phi,'interp','none','none',1,'none','b');
                PZ{1} = inputData(locPmax).data;
                Pmxmi = [min(inputData(locPmax).data(:)) max(inputData(locPmax).data(:))];
            end
            
            if ~isempty(locPminp)
                if exist('Pmap1','var')
                    Pmap2 = setColor('g',lenC);
                    Ph(2) = SphericalPlot3D(inputData(locPminp).data,theta,phi,'interp','none','none',0.5,'none','g');
                    PZ{2} = inputData(locPminp).data;
                    Pmxmi = [Pmxmi; min(inputData(locPminp).data(:)) max(inputData(locPminp).data(:))];
                    Pmap  = [Pmap1;Pmap2];
                else
                    Pmap1 = setColor('g',lenC);
                    Ph(1) = SphericalPlot3D(inputData(locPminp).data,theta,phi,'interp','none','none',1,'none','g');
                    PZ{1} = inputData(locPminp).data;
                    Pmxmi = [min(inputData(locPminp).data(:)) max(inputData(locPminp).data(:))];
                end
            end
            
            if ~isempty(locPminn)
                if exist('Pmap2','var')
                    Pmap3 = setColor('r',lenC);
                    Ph(3) = SphericalPlot3D(inputData(locPminn).data,theta,phi,'interp','none','none',0.35,'none','r');
                    PZ{3} = inputData(locPminn).data;
                    Pmap  = [Pmap1;Pmap2;Pmap3];
                    Pmxmi = [Pmxmi; min(inputData(locPminn).data(:)) max(inputData(locPminn).data(:))];
                else
                    Pmap2 = setColor('r',lenC);
                    Ph(2) = SphericalPlot3D(inputData(locPminn).data,theta,phi,'interp','none','none',0.5,'none','r');
                    PZ{2} = inputData(locPminn).data;
                    Pmxmi = [Pmxmi; min(inputData(locPminn).data(:)) max(inputData(locPminn).data(:))];
                    Pmap  = [Pmap1;Pmap2];
                end
            end
        end
        
        
        colormap(Pmap);
        
        if length(Ph) == 2
            % CData for surface
            PC1 = min(lenC,round((lenC-1)*(PZ{1}-Pmxmi(1,1))/(Pmxmi(1,2)-Pmxmi(1,1)))+1);
            PC2 = lenC+min(lenC,round((lenC-1)*(PZ{2}-Pmxmi(2,1))/(Pmxmi(2,2)-Pmxmi(2,1)))+1);
            
            % Update the CDatas for each object.
            set(Ph(1),'CData',PC1);
            set(Ph(2),'CData',PC2);
            
            % Change the CLim property of axes so that it spans the CDatas of both objects.
            caxis([min(PC1(:)) max(PC2(:))]);
        else
            % CData for surface
            PC1 = min(lenC,round((lenC-1)*(PZ{1}-Pmxmi(1,1))/(Pmxmi(1,2)-Pmxmi(1,1)))+1);
            PC2 = lenC+min(lenC,round((lenC-1)*(PZ{2}-Pmxmi(2,1))/(Pmxmi(2,2)-Pmxmi(2,1)))+1);
            PC3 = 2*lenC+min(lenC,round((lenC-1)*(PZ{3}-Pmxmi(3,1))/(Pmxmi(3,2)-Pmxmi(3,1)))+1);
            
            % Update the CDatas for each object.
            set(Ph(1),'CData',PC1);
            set(Ph(2),'CData',PC2);
            set(Ph(3),'CData',PC3);
            
            % Change the CLim property of axes so that it spans the CDatas of both objects.
            caxis([min(PC1(:)) max(PC3(:))]);
        end
        
        hold off;
        xlabel('\lambda_{X}','FontName',fontname,'FontWeight',fontweight,'FontAngle',fontangle,'FontSize',fontsize);
        ylabel('\lambda_{Y}','FontName',fontname,'FontWeight',fontweight,'FontAngle',fontangle,'FontSize',fontsize);
        zlabel('\lambda_{Z}','FontName',fontname,'FontWeight',fontweight,'FontAngle',fontangle,'FontSize',fontsize);
        set(gca,'box','on',...
            'LineWidth',1.5,...
            'FontName',fontname,...
            'FontWeight',fontweight,...
            'FontAngle',fontangle,...
            ...
            'FontSize',fontsize,...
            'gridcolor',[0.5 0.5 0.5],...
            'GridLineStyle','--',...
            'GridAlpha',0.25,...
            'XMinorTick','on',....
            'YMinorTick','on',...
            'ZMinorTick','on',...
            'XMinorGrid',gridSwitch3D,....
            'YMinorGrid',gridSwitch3D,....
            'ZMinorGrid',gridSwitch3D,....
            'MinorGridAlpha',0.05,...
            'minorgridlinestyle',':');
        
        % print pic
        if doprint
            picname = strcat(picpath,filesep,strcat(combname,'_3D_P_comb.tif'));
            ddpi    = strcat('-r',dpi);
            print(gcf,picname,ddpi, "-dtiffn");
            pause(1e-6);
        end
    end
    
    % Pugh Ratio
    locPr  = strcmp({inputData(ind).name},'Pugh Ratio');
    indPr  = ind(locPr==1);
    lenPr  = length(indPr);
    lenC   = 256;              % length for colormap
    if lenPr >= 2
        str  = 'The';
        for tk = 1:lenPr
            if tk < lenPr
                str = [str,char(32),inputData(indPr(tk)).mma,',',char(32)];
            else
                str = [str,char(32),inputData(indPr(tk)).mma,char(32)];
            end
        end
        
        figure('Position',[396.20 103.40 1220.75 863.18],...
            'Color','w','Name',[str,char(32),'of',char(32),inputData(indPr(1)).mode,char(32),inputData(indPr(1)).name],...
            'NumberTitle','off');
        hold on;
        
        locPrmma  = strcmp({inputData(indPr).mma},'Minimum');
        locPrminp  = indPr(locPrmma==1);
        if ~isempty(locPrminp)
            hPr(1) = SphericalPlot3D(inputData(locPrminp).data,theta,phi,'interp','none','none',1,'none','g');
        end
        
        locPrmma   = strcmp({inputData(indPr).mma},'Maximum');
        locPrminn  = indPr(locPrmma==1);
        if ~isempty(locPrminn)
            hPr(2) = SphericalPlot3D(inputData(locPrminn).data,theta,phi,'interp','none','none',0.5,'none','b');
        end
        
        Prmap1 = setColor('g',lenC);
        Prmap2 = setColor('b',lenC);
        colormap([Prmap1;Prmap2]);
        
        Prcmin1 = min(inputData(locPrminn).data(:));
        Prcmax1 = max(inputData(locPrminn).data(:));
        Prcmin2 = min(inputData(locPrminp).data(:));
        Prcmax2 = max(inputData(locPrminp).data(:));
        
        % CData for surface
        PrC1 = min(lenC,round((lenC-1)*(inputData(locPrminn).data-Prcmin1)/(Prcmax1-Prcmin1))+1);
        PrC2 = lenC+min(lenC,round((lenC-1)*(inputData(locPrminp).data-Prcmin1)/(Prcmax2-Prcmin2))+1);
        
        % Update the CDatas for each object.
        set(hPr(1),'CData',PrC1);
        set(hPr(2),'CData',PrC2);
        
        % Change the CLim property of axes so that it spans the
        % CDatas of both objects.
        caxis([min(PrC1(:)) max(PrC2(:))]);
        
        hold off;
        xlabel('Pr_{X}','FontName',fontname,'FontWeight',fontweight,'FontSize',fontsize);
        ylabel('Pr_{Y}','FontName',fontname,'FontWeight',fontweight,'FontSize',fontsize);
        zlabel('Pr_{Z}','FontName',fontname,'FontWeight',fontweight,'FontSize',fontsize);
        set(gca,'box','on',...
            'LineWidth',1.5,...
            'FontName',fontname,...
            'FontWeight',fontweight,...
            'FontSize',fontsize,...
            'gridcolor',[0.5 0.5 0.5],...
            'gridLineStyle','--',...
            'gridAlpha',0.25,...
            'XMinorTick','on',....
            'YMinorTick','on',...
            'ZMinorTick','on',...
            'XMinorgrid',gridSwitch3D,....
            'YMinorgrid',gridSwitch3D,....
            'ZMinorgrid',gridSwitch3D,....
            'MinorgridAlpha',0.05,...
            'minorgridlinestyle',':');
        
        % print pic
        if doprint
            picname = strcat(picpath,filesep,strcat(combname,'_3D_Pr_comb.tif'));
            ddpi    = strcat('-r',num2str(dpi));
            print(gcf,picname,ddpi, "-dtiffn");
            pause(1e-6);
        end
    end
    
    % Vickers Hardness
    locHv  = strcmp({inputData(ind).name},'Vickers Hardness');
    indHv  = ind(locHv==1);
    lenHv = length(indHv);
    if lenHv >= 2
        str  = 'The';
        for tk = 1:lenHv
            str = [str,char(32),inputData(indHv(tk)).mma,',',char(32)];
        end
        figure('Position',[396.20 103.40 1220.75 863.18],...
            'Color','w','Name',[str,char(32),'of',char(32),inputData(indHv(1)).mode,char(32),inputData(indHv(1)).name],...
            'NumberTitle','off');
        hold on;
        locHvmma  = strcmp({inputData(indHv).mma},'Minimum');
        locHvmin  = indHv(locHvmma==1);
        if ~isempty(locHvmin)
            hHv(1) = SphericalPlot3D(inputData(locHvmin).data,theta,phi,'interp','none','none',1,'flat','g');
        end
        
        locHvmma  = strcmp({inputData(indHv).mma},'Maximum');
        locHvmax  = indHv(locHvmma==1);
        if ~isempty(locHvmax)
            hHv(2) = SphericalPlot3D(inputData(locHvmax).data,theta,phi,'interp','none','none',0.5,'flat','b');
        end
        
        Hvmap1 = setColor('g',lenC);
        Hvmap2 = setColor('b',lenC);
        colormap([Hvmap1;Hvmap2]);
        
        Hvcmin1 = min(inputData(locHvmin).data(:));
        Hvcmax1 = max(inputData(locHvmin).data(:));
        Hvcmin2 = min(inputData(locHvmax).data(:));
        Hvcmax2 = max(inputData(locHvmax).data(:));
        
        % CData for surface
        HvC1 = min(lenC,round((lenC-1)*(inputData(locHvmin).data-Hvcmin1)/(Hvcmax1-Hvcmin1))+1);
        HvC2 = lenC+min(lenC,round((lenC-1)*(inputData(locHvmax).data-Hvcmin1)/(Hvcmax2-Hvcmin2))+1);
        
        % Update the CDatas for each object.
        set(hHv(1),'CData',HvC1);
        set(hHv(2),'CData',HvC2);
        
        % Change the CLim property of axes so that it spans the CDatas of both objects.
        caxis([min(HvC1(:)) max(HvC2(:))]);
        
        hold off;
        xlabel('Hv_{X} (GPa)','FontName',fontname,'FontWeight',fontweight,'FontSize',fontsize);
        ylabel('Hv_{Y} (GPa)','FontName',fontname,'FontWeight',fontweight,'FontSize',fontsize);
        zlabel('Hv_{Z} (GPa)','FontName',fontname,'FontWeight',fontweight,'FontSize',fontsize);
        set(gca,'box','on',...
            'LineWidth',1.5,...
            'FontName',fontname,...
            'FontWeight',fontweight,...
            'FontSize',fontsize,...
            'gridcolor',[0.5 0.5 0.5],...
            'GridLineStyle','--',...
            'GridAlpha',0.25,...
            'XMinorTick','on',....
            'YMinorTick','on',...
            'ZMinorTick','on',...
            'XMinorGrid',gridSwitch3D,....
            'YMinorGrid',gridSwitch3D,....
            'ZMinorGrid',gridSwitch3D,....
            'MinorGridAlpha',0.05,...
            'minorgridlinestyle',':');
        
        % print pic
        if doprint
            picname = strcat(picpath,filesep,strcat(combname,'_3D_Hv_comb.tif'));
            ddpi    = strcat('-r',num2str(dpi));
            print(gcf,picname,ddpi, "-dtiffn");
            pause(1e-6);
        end
    end
    
    % Fracture Toughness
    locKic  = strcmp({inputData(ind).name},'Fracture Toughness');
    indKic  = ind(locKic==1);
    lenKic = length(indKic);
    if lenKic >= 2
        str  = 'The';
        for tk = 1:lenKic
            str = [str,char(32),inputData(indKic(tk)).mma,',',char(32)];
        end
        figure('Position',[396.20 103.40 1220.75 863.18],...
            'Color','w','Name',[str,char(32),'of',char(32),inputData(indKic(1)).mode,char(32),inputData(indKic(1)).name],...
            'NumberTitle','off');
        hold on;
        locKicmma  = strcmp({inputData(indKic).mma},'Minimum');
        locKicmin  = indKic(locKicmma==1);
        if ~isempty(locKicmin)
            hKic(1) = SphericalPlot3D(inputData(locKicmin).data,theta,phi,'interp','none','none',1,'flat','g');
        end
        
        locKicmma  = strcmp({inputData(indKic).mma},'Maximum');
        locKicmax  = indKic(locKicmma==1);
        if ~isempty(locKicmax)
            hKic(2) = SphericalPlot3D(inputData(locKicmax).data,theta,phi,'interp','none','none',0.5,'flat','b');
        end
        
        Kicmap1 = setColor('g',lenC);
        Kicmap2 = setColor('b',lenC);
        colormap([Kicmap1;Kicmap2]);
        
        Kiccmin1 = min(inputData(locKicmin).data(:));
        Kiccmax1 = max(inputData(locKicmin).data(:));
        Kiccmin2 = min(inputData(locKicmax).data(:));
        Kiccmax2 = max(inputData(locKicmax).data(:));
        
        % CData for surface
        KicC1 = min(lenC,round((lenC-1)*(inputData(locKicmin).data-Kiccmin1)/(Kiccmax1-Kiccmin1))+1);
        KicC2 = lenC+min(lenC,round((lenC-1)*(inputData(locKicmax).data-Kiccmin1)/(Kiccmax2-Kiccmin2))+1);
        
        % Update the CDatas for each object.
        set(hKic(1),'CData',KicC1);
        set(hKic(2),'CData',KicC2);
        
        % Change the CLim property of axes so that it spans the CDatas of both objects.
        caxis([min(KicC1(:)) max(KicC2(:))]);
        
        hold off;
        xlabel('K_{ICX} (MPa·m^{1/2})','FontName',fontname,'FontWeight',fontweight,'FontSize',fontsize);
        ylabel('K_{ICY} (MPa·m^{1/2})','FontName',fontname,'FontWeight',fontweight,'FontSize',fontsize);
        zlabel('K_{ICZ} (MPa·m^{1/2})','FontName',fontname,'FontWeight',fontweight,'FontSize',fontsize);
        set(gca,'box','on',...
            'LineWidth',1.5,...
            'FontName',fontname,...
            'FontWeight',fontweight,...
            'FontSize',fontsize,...
            'gridcolor',[0.5 0.5 0.5],...
            'GridLineStyle','--',...
            'GridAlpha',0.25,...
            'XMinorTick','on',....
            'YMinorTick','on',...
            'ZMinorTick','on',...
            'XMinorGrid',gridSwitch3D,....
            'YMinorGrid',gridSwitch3D,....
            'ZMinorGrid',gridSwitch3D,....
            'MinorGridAlpha',0.05,...
            'minorgridlinestyle',':');
        
        % print pic
        if doprint
            picname = strcat(picpath,filesep,strcat(combname,'_3D_KIC_comb.tif'));
            ddpi    = strcat('-r',num2str(dpi));
            print(gcf,picname,ddpi, "-dtiffn");
            pause(1e-6);
        end
    end
    
    hmsg = msgbox('Plotting finished!', 'VELAS reminder','help');
    pause(0.8);
    if ishandle(hmsg)
        close(hmsg);
    end
end
