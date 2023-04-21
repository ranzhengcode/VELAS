function drawPolar(Axes, R, varargin)

%{
    Adds a polar grid to the specified axis.
    Input parameters:
        Axes  -- the handle of the specified axis;
        R     -- a series of scale values on the specified axis;
        Rc    -- Inner radius of polar grid, default: 0;
        color -- The color of the grid, default: [0.82 0.82 0.82];
        linewidth -- Width of grid lines, default: 1.2;
        font  -- Font settings in Grid, font is a structure data, 
                including:
                         font.fontname, default: 'Times New Roman';
                         font.fontweight, default: 'normal';
                         font.fontangle, default: 'normal';
                         font.fontsize, default: 14;
   
%}
% nAng, Rc, color, linwidth, font
narginchk(2,7);

switch(nargin)
    case 2
        nAng     = 13;
        Rc       = 0;
        color    = [0.82 0.82 0.82];
        linwidth =  1.2;
        font.fontname      = 'Times New Roman';
        font.fontweight    = 'normal';
        font.fontangle     = 'normal';
        font.fontsize = 14;
    case 3
        nAng     = varargin{1};
        Rc       = 0;
        color    = [0.82 0.82 0.82];
        linwidth =  1.2;
        font.fontname      = 'Times New Roman';
        font.fontweight    = 'normal';
        font.fontangle     = 'normal';
        font.fontsize      = 14;
    case 4
        nAng     = varargin{1};
        Rc       = varargin{2};
        color    = [0.82 0.82 0.82];
        linwidth =  1.2;
        font.fontname      = 'Times New Roman';
        font.fontweight    = 'normal';
        font.fontangle     = 'normal';
        font.fontsize      = 14;
    case 5
        nAng     = varargin{1};
        Rc       = varargin{2};
        color    = varargin{3};
        linwidth =  1.2;
        font.fontname      = 'Times New Roman';
        font.fontweight    = 'normal';
        font.fontangle     = 'normal';
        font.fontsize      = 14;
    case 6
        nAng     = varargin{1};
        Rc       = varargin{2};
        color    = varargin{3};
        linwidth = varargin{4};
        font.fontname      = 'Times New Roman';
        font.fontweight    = 'normal';
        font.fontangle     = 'normal';
        font.fontsize      = 14;
    case 7
        nAng     = varargin{1};
        Rc       = varargin{2};
        color    = varargin{3};
        linwidth = varargin{4};
        font     = varargin{5};
end

if find(R == Rc)
    drc = false;
else
    try
        NR = [R Rc];
    catch
        NR = [R; Rc];
    end
    loc = find(sort(NR)== Rc);
    R   = NR(loc:end);
end

% Circle of polar
theC  = linspace(0,2*pi,200);
cX    = cos(theC);
cY    = sin(theC);
tAng  = 0.42*pi;
labx  = R*cos(tAng);
laby  = R*sin(tAng);
nCir  = length(R);

% Line of polar
theL  = linspace(0,2*pi,nAng);
tLin  = linspace(0,360,nAng);
lXO     = max(R)*cos(theL);
lYO     = max(R)*sin(theL);
lXI     = Rc*cos(theL);
lYI     = Rc*sin(theL);
labAngX = 1.07*max(R)*sin(theL);
lanAngY = 1.07*max(R)*cos(theL);
N       = max(nCir,nAng-1);

hold on

if nCir <= nAng-1
    for m = 1:N
        plot(Axes, [lXI(m) lXO(m)], [lYI(m) lYO(m)], 'color', color,'LineWidth', linwidth);
        % adding the label of Angle
        text(lanAngY(m),labAngX(m),num2str(tLin(m)),...
            'horizontalalignment','center',...
            'FontSize',font.fontsize,...
            'FontName',font.fontname,...
            'FontWeight',font.fontweight,...
            'FontAngle',font.fontangle,...
            'handlevisibility','off');
        
        if m <= nCir
            plot(Axes, R(m).*cX, R(m).*cY, 'color', color, 'LineWidth', linwidth);
            % adding the value of Radius
            if R(m) ~= 0
                text(labx(m), laby(m), num2str(R(m)),...
                    'FontSize',font.fontsize,...
                    'FontName',font.fontname,...
                    'FontWeight',font.fontweight,...
                    'FontAngle',font.fontangle);
            end
        end
    end
else
    for m = 1:N
        if m <= nAng-1
            plot(Axes, [lXI(m) lXO(m)], [lYI(m) lYO(m)], 'color', color,'LineWidth', linwidth);
            text(lanAngY(m),labAngX(m),num2str(tLin(m)),...
                'horizontalalignment','center',...
                'FontSize',font.fontsize,...
                'FontName',font.fontname,...
                'FontWeight',font.fontweight,...
                'FontAngle',font.fontangle,...
                'handlevisibility','off');
        end
        
        plot(Axes, R(m).*cX, R(m).*cY, 'color', color, 'LineWidth', linwidth);
        if R(m) ~= 0
            text(labx(m), laby(m), num2str(R(m)),...
                'FontSize',font.fontsize,...
                'FontName',font.fontname,...
                'FontWeight',font.fontweight,...
                'FontAngle',font.fontangle);
        end

    end
end
hold off
end
