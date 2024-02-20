function gain = getGain(RT_A, RT_V, RT_AV)
%GETGAIN   Computation of redundancy gain.
% GAIN = GETGAIN(DATA) returns the redundancy gain in a redundant signals
% experiment. Input argument DATA is an N-by-3 matrix that contains
% reaction times in the two single signal conditions (columns 1 and 2) and
% the redundant signals condition (column 3). If DATA has more than three
% columns, columns 1 to 3 are used. Output argument GAIN is the speed-up of
% reaction times in the redundant signals condition using Grice's bound as
% baseline (Otto, Dassy, & Mamassian, 2013).
%
% Reference: 
% Otto, Dassy, & Mamassian (2013). Principles of multisensory behavior.
% Journal of Neuroscience, 33(17), 7463-7474.
%
% See also demo01_quantiles, getCP, getGrice, sampleDown

% Copyright (C) 2017-18 Thomas Otto, University of St Andrews
% See rseBox_license for details

% Sort sample points in DATA
RT_A = sort(RT_A);
RT_V = sort(RT_V);
RT_AV = sort(RT_AV);

% Get Grice's bound as baseline
UnisensoryRTs = [RT_A RT_V];
grice = getGrice(UnisensoryRTs);

% Compute the redundancy gain
gain = mean(grice - RT_AV);

end