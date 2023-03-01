%% LSL MATLAB TEST %%%%%%%%%%%%%%%%%%%%

addpath("C:\Users\Wallace Lab\Documents\MATLAB\Human_AV_Motion\liblsl-Matlab-master");
addpath("C:\Users\Wallace Lab\Documents\MATLAB\Human_AV_Motion\liblsl-Matlab-master\bin");

% instantiate the LSL library
lib = lsl_loadlib();
 
% make a new stream outlet
info = lsl_streaminfo(lib,'MyMarkerStream','Markers',1,0,'cf_string','wallacelab');

currvisdir = 2;
currviscoh = 4;
dir_id = num2str(currvisdir);
coh_id = num2str(currviscoh)
outlet = lsl_outlet(info);

markers = strcat([dir_id coh_id]);


outlet.push_sample({markers})


