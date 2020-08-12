%% Class definition for LsrStatus
classdef LsrStatus < handle
   properties
      Connection = [];  %Connection to controller: 0 for no connection; 1 for connected
      AmpON = [];       % Amp status: 0 for OFF and 1 for ON
      Wavelength = [];  % OPO Wavelength (double between 405 and 2000)
      Shutter = [];     % Shutter status: 0 for closed and 1 for open
   end
   methods
       function OPOStatus = LsrStatus()
           if nargin == 0
               OPOStatus.Connection = 0;
               OPOStatus.AmpON = 0;
               OPOStatus.Wavelength = 0;
               OPOStatus.Shutter = 0;
           end
       end
   end
           
end