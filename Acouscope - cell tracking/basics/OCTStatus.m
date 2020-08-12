%% Class definition
classdef OCTStatus < handle
   properties
      Device = libpointer('C_OCTDevicePtr', []); % device object. Check spectralRadar libraries
      Probe = libpointer('C_ProbePtr', []); % probe object
      Pattern = libpointer('C_ScanPatternPtr', []); % pattern class
   end
   methods
       function octStatus = OCTStatus()
           if nargin == 0
               octStatus.Device = [];
               octStatus.Probe = [];
               octStatus.Pattern = [];
               %OCTStatus.Shutter = [];
           end
       end
   end
           
end