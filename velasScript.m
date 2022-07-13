
clc;clear;close all;
format long;
% maximum(blue), minimum positive (green) and minimum negative(red)
global VELAS

VELAS.uiname = 'VELAS';

[filen, pathn] = uigetfile({'*.txt'},'Select input file.','MultiSelect','on');
if isequal(filen,0)
    errordlg('No file selected.','VELAS reminder');
else
    len             = length(filen);
    for k = 1:len
    fname           = filen{k};    
    matnameInput    = strrep(fname,'.txt','Input.mat');
    matnameOutput   = strrep(fname,'.txt','Output.mat');
    filename        = strcat(pathn,fname);
    inmatname       = strcat(pathn,matnameInput);
    outmatname      = strcat(pathn,matnameOutput);
    R               = initOutput();
    inputData       = getInput(filename);
    % save input
    save(inmatname,'inputData'); 
    outputData = checkStability(inputData,R);
    % save output
    save(outmatname,'outputData'); 
    end 
end

