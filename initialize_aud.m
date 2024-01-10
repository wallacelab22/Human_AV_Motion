function [pahandle] = initialize_aud(curWindow, Fs)

PsychPortAudio('Close')
Screen('BlendFunction', curWindow, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
InitializePsychSound;

% Get a list of available audio devices
devices = PsychPortAudio('GetDevices');

% Search for audio devices containing 'UMC' in their name
% 'UMC' is the name of our audio interface. 
selectedDeviceIndex = [];
audioName = 'UMC';
for i = 1:length(devices)
    deviceName = devices(i).DeviceName;
    if contains(deviceName, audioName)
        selectedDeviceIndex = devices(i).DeviceIndex;
        break;
    end
end

pahandle = PsychPortAudio('Open', selectedDeviceIndex, [], 0, Fs, 2);

end