% uninstall VELAS automatically using the [rvpath] function.
try
    if isempty(which('velasGUI'))
        rmpath(fullfile(pwd));
        rmpath(fullfile(pwd,'basic'));
        rmpath(fullfile(pwd,'drawing'));
        rmpath(fullfile(pwd,'GUI'));
        rmpath(fullfile(pwd,'mpapi'));
        rmpath(fullfile(pwd,'properties'));
    else
        velaspath = fileparts(which('velasGUI'));
        rmpath(fullfile(velaspath));
        rmpath(fullfile(velaspath,'basic'));
        rmpath(fullfile(velaspath,'drawing'));
        rmpath(fullfile(velaspath,'GUI'));
        rmpath(fullfile(velaspath,'mpapi'));
        rmpath(fullfile(velaspath,'properties'));
    end
    disp('VELAS uninstall finished!');
    disp('Thank you for your use and support! If you have any suggestions or comments on VELAS, please email us.');
    disp('Email: ranzheng@outlook.com');
catch
    disp('There is a problem with the [rmpath] function. Please add the path manually according to the VELAS Manual.');
end

