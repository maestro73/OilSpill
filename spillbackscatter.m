
function [ out ] = spillbackscatter( spill, back )

% Inside Slick Mean
% Inside Slick Standard Deviation
[out.SpillMean, out.SpillStandardDeviation] = spillutils( spill );

% Outside Slick Radar Backscatter (?sce)
% Outside Slick Standard Deviation (?sce)
[out.BackMean, out.BackStandardDeviation] = spillutils( back );

% Intensity Ratio
out.IntensityRatio = out.SpillMean - out.BackMean; % / - 

% Intensity Standard Deviation Ratio
out.ISDR = out.SpillStandardDeviation - out.BackStandardDeviation; % / - 

% Intensity Standard Deviation Ratio Inside (ISRI)
out.ISRI = out.SpillMean - out.SpillStandardDeviation; % / - 

% Intensity Standard Deviation Ratio Outside (ISRO)
out.ISRO = out.BackMean - out.BackStandardDeviation; % / - 

% ISRI ISRO Ratio
out.IRatio = out.ISRI - out.ISRO; % / - 




% Mean Contrast (ConMe) 
% difference (in dB) between the background mean
% value and the object mean value

out.ConMe = out.BackMean - out.SpillMean;

%Max Gradient (GMax): maximum value (in dB) 
% of border gradient magnitude, 
% calculated using Sobel operator.

% Mean Gradient (GMe): mean border gradient 
% magnitude (in dB).

% Gradient Standard Deviation (GSd): 
% standard deviation (in dB) of the
% border gradient magnitudes.

[out.GMax, out.GMe, out.GSd] = spillgradient( spill );


