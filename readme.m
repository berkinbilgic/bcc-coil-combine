%
%
% script_bcc.m : uses Block Coil Compression (BCC) virtual body coil and
% ESPIRiT for reference-free coil combination
% this is especially useful at ultra high field, where the simpler SVD
% virtual body coil may still contain phase singularities
% BCC mitigates this problem by more local coil compression
%
% ESPIRiT is a part of BART, developed by the Berkeley team:
% http://mrirecon.github.io/bart/
% 
% this Matlab script is tested with BART version 0.2.06, which is added to 
% this toolbox for consistency
%