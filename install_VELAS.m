
% install VELAS automatically using the [addpath] function.
try
    addpath(fullfile(pwd));
    addpath(fullfile(pwd,'basic'));
    addpath(fullfile(pwd,'doc'));
    addpath(fullfile(pwd,'drawing'));
    addpath(fullfile(pwd,'GUI'));
    addpath(fullfile(pwd,'mpapi'));
    addpath(fullfile(pwd,'properties'));
    savepath;
    disp('VELAS installation completed. Enjoy!');
    disp('Please don''t hesitate to contact us if you have any questions about using VELAS or suggestions for improving VELAS.');
    disp('Email: ranzheng@outlook.com');
catch
    disp('There is a problem with the [addpath] function. Please add the path manually according to the VELAS Manual.');
end

