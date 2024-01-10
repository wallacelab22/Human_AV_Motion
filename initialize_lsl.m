function [lib, info, outlet] = initialize_lsl
% Instantiate the LSL library (LSL stands for lab streaming layer and
% it is what we use to send stimulus triggers from MATLAB to our EEG
% recording software to note stimulus onset, stimulus offset, key
% press, etc.)
lib = lsl_loadlib();
 
% Make a new stream outlet- e.g.: (name: BioSemi, type: EEG. 8 channels, 100Hz)
info = lsl_streaminfo(lib, 'MyMarkerStream', 'Markers', 1, 0, 'cf_string', 'wallacelab');
outlet = lsl_outlet(info);
end