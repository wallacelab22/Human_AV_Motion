function [CAM_r] = makeramp(dur,Fs,CAM)

t = dur;
rampt = 0.01;
rampsamples = rampt*Fs;
ramp_t = 1:rampsamples;

x = ones((Fs*t)-2*rampsamples,1);
rampd = cos(ramp_t./(rampsamples/pi))';
rampu = -rampd;

ramp = .5.*[rampu rampu;x x;rampd rampd]+.5;
CAM_r = CAM.*ramp;

