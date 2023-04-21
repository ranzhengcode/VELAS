function exitUI()

global VELAS

C  = get(VELAS.CS,'String');
if ~isempty(C)
    if VELAS.saveflag
        close(VELAS.hfig);
    else
        answer = questdlg({'The input configuration has not been saved.',' Are you sure you want to exit this program?'}, ...
            'VELAS reminder', ...
            'Yes','No','No');
        % Handle response
        switch answer
            case 'Yes'     % Exit
                close(VELAS.hfig);
            case 'No'      % Save and exit.
                mLegel = isMatrixLegel();
                if mLegel
                    saveConfigUI;
                    close(VELAS.hfig);
                else
                    
                end
        end
    end
else
    close(VELAS.hfig);
end
