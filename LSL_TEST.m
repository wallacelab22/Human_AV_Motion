%% LSL MATLAB TEST %%%%%%%%%%%%%%%%%%%%

addpath("C:\Users\Wallace Lab\Documents\MATLAB\Human_AV_Motion\liblsl-Matlab-master\bin\")

% instantiate the LSL library
lib = lsl_loadlib();
 
% make a new stream outlet (name: BioSemi, type: EEG. 8 channels, 100Hz)
info = lsl_streaminfo(lib,'MyMarkerStream','Markers',1,0,'cf_string','wallacelab');
currvisdir = 2;
currviscoh = 4;
dir_id = num2str(currvisdir);
coh_id = num2str(currviscoh);
marker_out = {dir_id, coh_id};
outlet = lsl_outlet(info);

outlet.push_sample({marker_out}, 0);

