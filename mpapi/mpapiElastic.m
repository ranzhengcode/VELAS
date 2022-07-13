function outputs = mpapiElastic(mpid,xapikey,verflag)

%

if ispc
    comd = 'ping -n 2 www.google.com';
else
    comd = 'ping -c 2 www.google.com';
end

[netstate,~] = system(comd);

if netstate == 0
    if isOctave
        if ~verflag
            % api.materialsproject.org [new api]
            try
                urlnew  = ['https://api.materialsproject.org/elasticity/',mpid,'/?_fields=pretty_formula%2Celasticity&_all_fields=false'];
                options = weboptionsNew('RequestMethod','get',...
                           'KeyName', 'X-API-KEY', ...
                           'KeyValue', xapikey,...
                           'Timeout',5);
                outputs = webreadNew(urlnew,options);
                outputs = json2struct(outputs);
                outputs = outputs.data{1,1};
                pause(0.2);
                
                urlbase = ['https://api.materialsproject.org/summary/',mpid,'/?_fields=volume%2Cdensity%2Csymmetry&_all_fields=false'];
                options = weboptionsNew('RequestMethod','get',...
                           'KeyName', 'X-API-KEY', ...
                           'KeyValue', xapikey,...
                           'Timeout',5);
                crysys  = webreadNew(urlbase,options);
                crysys  = json2struct(crysys);
                crysys  = crysys.data{1,1};
                
                toutputs.data.pretty_formula = outputs.pretty_formula;
                toutputs.data.volume         = crysys.volume;
                toutputs.data.density        = crysys.density;
                toutputs.data.symmetry       = crysys.symmetry;
                toutputs.data.elasticity     = outputs.elasticity;
                
                outputs = toutputs;
  
            catch
                outputs = [];
                hmsg = msgbox(['Item with task_id = ', mpid,' not found, please try Legacy API.'], 'VELAS reminder','error');
                pause(0.8);
                if ishandle(hmsg)
                    close(hmsg);
                end
            end

        else
            % www.materialsproject.org [Legacy API]
            try
                criteria = ['{"material_id": "',mpid,'"}'];
                props    = '["pretty_formula","spacegroup","volume","density","elasticity"]';
                urlold   = 'https://materialsproject.org/rest/v2/query';
                options  = weboptionsNew('RequestMethod','post',...
                                         'KeyName', 'X-API-KEY', ...
                                         'KeyValue', xapikey,...
                                          'Timeout',5);
                outputs = webwriteNew(urlold,{'criteria',criteria,'properties',props}',options);
                outputs = json2struct(outputs);
                outputs.response = outputs.response{1,1};
            catch
                outputs = [];
                hmsg = msgbox(['Item with task_id = ', mpid,' not found, please visit the official website of Materials Project.'], 'VELAS reminder','error');
                pause(0.8);
                if ishandle(hmsg)
                    close(hmsg);
                end
            end
        end

    else
        if ~verflag
            % api.materialsproject.org [New API]
            urlnew  = ['https://api.materialsproject.org/elasticity/',mpid,'/?_fields=pretty_formula%2Celasticity&_all_fields=false'];
            urlsys  = ['https://api.materialsproject.org/summary/',mpid,'/?_fields=symmetry%2Cvolume%2Cdensity&_all_fields=false'];
            options = weboptions('RequestMethod','get',...
                'ContentType','json',...
                'HeaderFields',{'accept','application/json';'X-API-KEY',xapikey});
            try
                outputs   = webread(urlnew,options);

                crysys    = webread(urlsys,options);
                outputs.data.volume   = crysys.data.volume;
                outputs.data.density  = crysys.data.density;
                outputs.data.symmetry = crysys.data.symmetry;
  
            catch
                outputs = [];
                hmsg = msgbox(['Item with task_id = ', mpid,' not found, please try Legacy API.'], 'VELAS reminder','error');
                pause(0.8);
                if ishandle(hmsg)
                    close(hmsg);
                end
            end

        else
            % www.materialsproject.org [Legacy API]
            urlold   = 'https://www.materialsproject.org/rest/v2/query';
            criteria = ['{"task_id":"',mpid,'"}'];
            props    = '["pretty_formula","spacegroup","volume","density","elasticity"]';

            options    = weboptions('RequestMethod','post',...
                'KeyName', 'X-API-KEY', ...
                'KeyValue', xapikey);
            try
                outputs    = webwrite(urlold,'criteria',criteria,'properties',props,options);
            catch
                outputs = [];
                hmsg = msgbox(['Item with task_id = ', mpid,' not found, please visit the official website of Materials Project.'], 'VELAS reminder','error');
                pause(0.8);
                if ishandle(hmsg)
                    close(hmsg);
                end
            end
        end
    end
else
    error('Your network does not have access to the Materials Project API!');
end