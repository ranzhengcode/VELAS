% uninstall VELAS automatically using the [rvpath] function.
try
    rmpath(fullfile(pwd));
    rmpath(fullfile(pwd,'basic'));
    rmpath(fullfile(pwd,'doc'));
    rmpath(fullfile(pwd,'drawing'));
    rmpath(fullfile(pwd,'GUI'));
    rmpath(fullfile(pwd,'mpapi'));
    rmpath(fullfile(pwd,'properties'));
    disp('VELAS uninstall finished!');
    disp('Thank you for your use and support! If you have any suggestions or comments on VELAS, please email us.');
    disp('Email: ranzheng@outlook.com');
catch
    disp('There is a problem with the [rmpath] function. Please add the path manually according to the VELAS Manual.');
end

