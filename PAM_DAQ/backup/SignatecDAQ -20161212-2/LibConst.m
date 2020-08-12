% -- PX1500 active channel selection constants (PX4CHANSEL_*)
%/ Quad channel: channels 1, 2, 3 and 4 (Power-up default for PX1500-4 devices)
 PX4CHANSEL_QUAD=0;
%/ Dual channel: channels 1 and 2 (Power-up default for PX1500-2 devices)
 PX4CHANSEL_DUAL_1_2=1;
%/ Dual channel: channels 1 and 2
 PX4CHANSEL_DUAL_3_4=2;
%/ Dual channel: channels 1 and 3
 PX4CHANSEL_DUAL_1_3= 3;
% Triple channel: channels 1, 2, and 3 (UNSUPPORTED IN FIRMWARE; DO NOT USE)
 PX4CHANSEL_TRIPLE_1_2_3=4;
%/ Single channel: channel 1
 PX4CHANSEL_SINGLE_CH1=5;
%/ Single channel: channel 2
 PX4CHANSEL_SINGLE_CH2=6;
%/ Single channel: channel 3
 PX4CHANSEL_SINGLE_CH3=7;
%/ Single channel: channel 4
 PX4CHANSEL_SINGLE_CH4=8;
%/ Dual channel: channels 1 and 3 (ADC interleaved)
 PX4CHANSEL_DUAL_1_3_ADCINT=9;
%/ Single channel: channel 1 (ADC interleaved)
 PX4CHANSEL_SINGLE_CH1_ADCINT=10;
%/ Single channel: channel 3 (ADC interleaved)
 PX4CHANSEL_SINGLE_CH3_ADCINT=11;


% -- PX1500 trigger mode values (PX4TRIGMODE_*)
%/ Trigger event starts a single data acquisition (Power-up default)
 PX4TRIGMODE_POST_TRIGGER=0;
%/ Each trigger event begins a new statically sized data acquisition
 PX4TRIGMODE_SEGMENTED = 1;
 PX4TRIGMODE__COUNT=2;   % Invalid setting

% -- PX1500 trigger source values (PX4TRIGSRC_*)
%/ Internal trigger, channel 1 (Power-up default)
 PX4TRIGSRC_INT_CH1 =  0;
%/ Internal trigger, channel 2
 PX4TRIGSRC_INT_CH2 = 1;
%/ Internal trigger, channel 3
 PX4TRIGSRC_INT_CH3 = 2;
%/ Internal trigger, channel 4
 PX4TRIGSRC_INT_CH4 = 3;
%/ External trigger
 PX4TRIGSRC_EXT = 4;
 PX4TRIGSRC__COUNT = 5;   % Invalid setting

% -- PX1500 trigger direction values (PX4TRIGDIR_*)
%/ Trigger occurs on positive going signal (Power-up default)
 PX4TRIGDIR_POS  =0;
%/ Trigger occurs on negative going signal
 PX4TRIGDIR_NEG = 1;
 PX4TRIGDIR__COUNT = 2;   % Invalid setting

% -- PX1500 Operating Mode values (PX4MODE_*)
%/ Power down mode
 PX4MODE_OFF = 0;
%/ Standby (ready) mode
 PX4MODE_STANDBY = 1;
%/ RAM acquisition mode
 PX4MODE_ACQ_RAM = 2;
%/ Reserved for future use
 PX4MODE_RESERVED_3 =3;
%/ RAM-buffered PCI acquisition mode; data buffered through PX1500 RAM
 PX4MODE_ACQ_PCI_BUF = 4;
%/ Signatec Auxiliary Bus (SAB) acquisition; acquire directly to SAB bus
 PX4MODE_ACQ_SAB = 5;
% / Buffered SAB acquisition; acquire to SAB, buffering through PX1500 RAM
% NOT IMPLEMENTED IN FIRMWARE, DO NOT USE
 PX4MODE_ACQ_SAB_BUF = 6;		
%/ PX1500 RAM read to PCI; transfer data from PX1500 RAM to host PC
 PX4MODE_RAM_READ_PCI = 7;
%/ PX1500 RAM read to SAB; transfer data from PX1500 RAM to SAB bus
 PX4MODE_RAM_READ_SAB = 8;
% / PX1500 RAM write from PCI; transfer data from host PC to PX1500 RAM
% NOT IMPLEMENTED IN FIRMWARE, DO NOT USE
 PX4MODE_RAM_WRITE_PCI = 9;
 PX4MODE__COUNT = 10 ; % Invalid setting

% -- PX1500 input voltage range values (PX4VOLTRNG_*)
%/ 500 mVp-p (default for amplifier path)
 PX4VOLTRNG_0_500_VPP = 0;
%/ 700 mVp-p (default for transformer path)
 PX4VOLTRNG_0_700_VPP = 1;
 PX4VOLTRNG__COUNT = 2 ;  % Invalid setting
