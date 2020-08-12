function params = UpdateParams(handles,params)

   setappdata(0, 'OffsetCH1', params(8)); % DC offset for CH1
   setappdata(0, 'OffsetCH2', params(9)); % DC offset for CH2
   setappdata(0, 'OffsetCH3', params(10)); % DC offset for CH3
   setappdata(0, 'OffsetCH4', params(11)); % DC offset for CH4
   setappdata(0, 'PreTrigSampl',(params(12)-1000)./10); %trigger delay in usec
   setappdata(0, 'AtrigLevel', params(13));
   setappdata(0, 'SamplingRateMHz', params(14)); %sampling rate in MHz (here 1GHz)
   setappdata(0, 'AcqLengthPoint', params(15)); % length of acquisition. Here 2 microsecond per trigger
   setappdata(0, 'ActivChNum', params(16)); % 2 active channels
   setappdata(0, 'Channeloption', params(17)); % Channel Options: select "3" for channels 1-3; select "0" for QUAD
   setappdata(0, 'ScanType', params(18)); % ScanType Option: '0' for regular scan; '1' for free position scan


end