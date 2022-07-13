function outputs = mpapiElasticOffline(mpid)
dbdir = which('mpDataBaseOffline.mat');
if exist(dbdir,'file')
    load(dbdir,'data');
    if ~isempty(strfind(mpid,'mp-')) || ~isempty(strfind(mpid,'mvc-'))
        loc = find(strcmp(mpid,{data.material_id})==1);
        if ~isempty(loc)
            outputs = data(loc);
        else
            outputs = [];
            errordlg(['Item with task_id = ', mpid,' not found, please try onlnine API with your personal x-api-key.'],'VELAS reminder');
            return;
        end
    else
        loc = find(strcmp(mpid,{data.formula})==1);
        if ~isempty(loc)
            len     = length(loc);
            outputs = data(loc);
            nd      = squeeze(struct2cell(outputs))';
            allRow  = cell(1,len+1);
            mpmx = max([cellfun(@length,nd(:,1));11]);
            frmx = max([cellfun(@length,nd(:,2));7]);
            demx = max([cellfun(@length,cellfun(@num2str,nd(:,4),'UniformOutput',false));7]);
            csmx = max([cellfun(@length,nd(:,5));13]);

            tmpid = repmat(' ',[1 mpmx]);
            tfrid = repmat(' ',[1 frmx]);
            tdeid = repmat(' ',[1 demx]);
            tcsid = repmat(' ',[1 csmx]);
            tmpid(1:11) = 'Material_ID';
            tfrid(1:7)  = 'Formula';
            tdeid(1:7)  = 'Density';
            tcsid(1:13) = 'CrystalSystem';
            allRow{1} = [tmpid,'   ',tfrid,'   ',tdeid,'   ',tcsid];

            for tk = 2:len+1
                tmpid = repmat(' ',[1 mpmx]);
                tfrid = repmat(' ',[1 frmx]);
                tdeid = repmat(' ',[1 demx]);
                tcsid = repmat(' ',[1 csmx]);
                tlen  = length(nd{tk-1,1});
                tmpid(1:tlen) = nd{tk-1,1};
                tlen  = length(nd{tk-1,2});
                tfrid(1:tlen)  = nd{tk-1,2};
                tlen  = length(num2str(nd{tk-1,4}));
                tdeid(1:tlen)  = num2str(nd{tk-1,4});
                tlen  = length(nd{tk-1,5});
                tcsid(1:tlen) = nd{tk-1,5};
                allRow{tk} = [tmpid,'   ',tfrid,'   ',tdeid,'   ',tcsid];
            end

            [sel, ok] = listdlg('Name','VELAS reminder','ListString', allRow,...
                'PromptString','Please select one and press OK!',...
                'SelectionMode', 'Single',...
                'ListSize',[250 400]);
            if (ok == 1)
                if sel ~= 1
                    outputs = outputs(sel-1);
                else
                    outputs = [];
                    errordlg('Cannot select header.','VELAS reminder');
                    return;
                end
            else
                outputs = [];
                errordlg('You cancelled.','VELAS reminder');
                return;
            end
        else
            outputs = [];
            errordlg(['Pretty Formula: ', mpid,' not found, please try onlnine API with MP-ID and your personal x-api-key.'],'VELAS reminder');
            return;
        end
    end
    else
            outputs = [];
            errordlg('The database.mat file dose not exist, please prepare database.mat file','VELAS reminder');
    return;
end