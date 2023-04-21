function runUI()

global VELAS

C = get(VELAS.CS,'String');

if VELAS.importflag
    VELAS.runflag   = true;
    inputData       = getUiInput;
    filename        = inputData.filename;
    [pathn,filen,~] = fileparts(filename);
    matnameInput    = strcat(filen,'Input.mat');
    matnameOutput   = strcat(filen,'Output.mat');
    inmatname       = strcat(pathn,filesep,matnameInput);
    
    save(inmatname,'inputData'); 
    initR          = initOutput();
    outputData     = checkStability(inputData,initR);
%     outmatname     = strcat(pathn,filesep,matnameOutput);
%     save(outmatname,'outputData'); 
else
     if ~isempty(C)
         VELAS.runflag   = true;
         inputData       = getUiInput;
         filename        = inputData.filename;
         [pathn,filen,~] = fileparts(filename);
         matnameInput    = strcat(filen,'Input.mat');
         matnameOutput   = strcat(filen,'Output.mat');
         inmatname       = strcat(pathn,filesep,matnameInput);
         save(inmatname,'inputData');
         
         initR           = initOutput();
         outputData      = checkStability(inputData,initR);
%          outmatname      = strcat(pathn,filesep,matnameOutput);
%          save(outmatname,'outputData');
     else
         VELAS.runflag  = false;
         msgbox({'The elastic constant matrix cannot be empty.','Please supplement and try again.'}, 'VELAS reminder','error');
     end
end
