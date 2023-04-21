
warning off;

clear; clc; close all;

vsplot.doplot  = true;   % doplot should always be true.

%% print setting
% pic path
vsplot.doprint   = false;  % true or false
vsplot.dpi       = 300;    % Resolution, this value is not the real DPI, just control the size of pic.

% Spherical Unit 3D plot
vsplot.dounitsph = false;  % true or false

% map projection
vsplot.domap     = true; % true or false
vsplot.mpmodel   = 'Mollweide'; % flag = {'Gall-Peters','Robinson','Hammer-Aitoff','Mollweide'};
vsplot.nmesh     = 7;
vsplot.cmap      = 'viridis';
vsplot.flipflag  = false;       % determine whether to flip the colormap, flipflag = false (Default).
vsplot.lineStyle = '--';

%% Basic setting
% Gridline setting
vsplot.gridSwitch2D = 'off';
vsplot.gridSwitch3D = 'off';

% Font setting
vsplot.fontname     = 'Times New Roman';
vsplot.fontweight   = 'bold';
vsplot.fontangle    = 'normal';
vsplot.fontcolor    = 'k';
vsplot.fontsize     = 13;
vsplot.mpfontcolor  = [0 0 0];   % Set the xticklabel color of the map projection, black [0 0 0].

plotUI(vsplot);
