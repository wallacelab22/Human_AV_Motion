function [CAM_r] = makeramp(dur,Fs,CAM)

t = dur;
rampt = 0.01;
rampsamples = round(rampt*Fs);
ramp_t = 1:rampsamples;

x = ones((round(Fs*t))-2*rampsamples,1);
rampd = cos(ramp_t./(rampsamples/pi))';
rampu = -rampd;

ramp = zeros(length(CAM), 2);
ramp = .5.*[rampu rampu;x x;rampd rampd]+.5;
while length(CAM) ~= length(ramp)
    ramp(end+1,:) = 0;
end
CAM_r = CAM.*ramp;