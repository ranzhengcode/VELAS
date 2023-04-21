function re = isExistColormap(incmapname)

if ischar(incmapname)
    vpath = which('velasColormap');
    [vpath,~,~] = fileparts(vpath);
    vcmapname   = [vpath,filesep,'velasColormap.mat'];
    load(vcmapname);
    if exist(incmapname,'var')
        re = true;
    else
        re = false;
    end
else
    re = false;
end