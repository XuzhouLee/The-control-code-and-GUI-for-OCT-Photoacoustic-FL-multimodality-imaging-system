/** @file               px1500.h
    @version            2.8
    @author				Mike DeKoker
	@author				Felix Grenier
	@author				Support: techsupport@signatec.com
    @brief              Main interface to PX1500 library
	@date               2013/01/10

	Copyright (C) 2008-2013 DynamicSignals LLC.

	THE PROGRAM/LIBRARY IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND,
	EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED
	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
	ENTIRE RISK TO THE QUALITY AND PERFORMANCE OF THE PROGRAMS LIES WITH
	YOU. SHOULD THE PROGRAM PROVE DEFECTIVE, YOU (AND NOT DYNAMICSIGNALS
	LLC) ASSUME THE ENTIRE COST OF ALL NECESSARY SERVICING, REPAIR OR 
	CORRECTION.

    This library supports the following Signatec hardware: 
     - PX1500-4 : 4 channel 1.5GHz 8-bit digitizer PCIe card
	 - PX1500-2 : 2 channel 1.5GHz 8-bit digitizer PCIe card

    This is the main PX1500 library header file and defines PX1500
    library constants, type definitions, macros, and function prototypes for
    use with client applications. Unless explicitly stated otherwise, 
	"PX1500" refers to any specific PX1500 device such as PX1500-4 or
	PX1500-2 devices.

    ALL user-space device access goes through this library. This is the only
	interface to the PX1500 device driver, which in turn, is the only 
	interface to the underlying device hardware. Other platforms (e.g. .NET,
	LabVIEW, Matlab, etc) all interface through this library.

	32-bit/64-bit user-mode code: Both 32- and 64-bit user mode code access
	the PX1500 library through the same library header.
	WINDOWS: The 32-bit PX1500 library is named PX4.dll with import 
	library PX4.lib. The 64-bit PX1500 library is named PX4_64.dll with
	import library PX4_64.lib. If your compiler supports the 'comment' 
	pragma (Microsoft compilers do) then the appropriate import library will
	be included automatically by the build process.
	LINUX: The library is built for whatever the currently running platform
	is, 32- or 64-bit, and the library name is always the same, 
	libsig_px1500

	Windows: See LibDeps.txt if you need to rebuild this library
*/
/*  
    The comments in this project are formatted for use with the Doxygen
    documentation generation tool. Doxygen is available under the GNU
    General Public License and may be downloaded from the Doxygen
    website, http://www.doxygen.org.
*/
#ifndef __px4_library_header_defined
#define __px4_library_header_defined

// -- PX1500 library function return values. (SIG_*)
/// Operation successful
#define SIG_SUCCESS                         0
/// Generic error (GetLastError() will usually provide more info.)
#define SIG_ERROR                           -1
/// An invalid parameter was specified
#define SIG_INVALIDARG                      -2
/// Argument is out of valid bounds
#define SIG_OUTOFBOUNDS                     -3
/// Invalid board device
#define SIG_NODEV                           -4
/// Error allocating memory
#define SIG_OUTOFMEMORY                     -5
/// Error allocating a utility DMA buffer
#define SIG_DMABUFALLOCFAIL                 -6
/// Board with given serial # not found
#define SIG_NOSUCHBOARD                     -7
/// This feature is only available on NT
#define SIG_NT_ONLY                         -8
/// Invalid operation for current operating mode
#define SIG_INVALID_MODE                    -9
/// Operation was cancelled by user
#define SIG_CANCELLED                       -10
/// Asynchronous operation is pending
#define SIG_PENDING                         1
//
// PX1500 specific library return values
//
#define SIG_PX4__FIRST                      -512
/// This operation is not currently implemented
#define SIG_PX4_NOT_IMPLEMENTED             -512
/// An invalid PX1500 device handle (HPX4) was specified
#define SIG_PX4_INVALID_HANDLE              -513
/// A specified buffer is too small
#define SIG_PX4_BUFFER_TOO_SMALL            -514
/// Argument 1 is invalid
#define SIG_PX4_INVALID_ARG_1               -515
/// Argument 2 is invalid
#define SIG_PX4_INVALID_ARG_2               -516
/// Argument 3 is invalid
#define SIG_PX4_INVALID_ARG_3               -517
/// Argument 4 is invalid
#define SIG_PX4_INVALID_ARG_4               -518
/// Argument 5 is invalid
#define SIG_PX4_INVALID_ARG_5               -519
/// Argument 6 is invalid
#define SIG_PX4_INVALID_ARG_6               -520
/// Argument 7 is invalid
#define SIG_PX4_INVALID_ARG_7               -521
/// Argument 8 is invalid
#define SIG_PX4_INVALID_ARG_8               -522
/// Requested transfer size is too small
#define SIG_PX4_XFER_SIZE_TOO_SMALL         -523
/// Requested transfer size is too large
#define SIG_PX4_XFER_SIZE_TOO_LARGE         -524
/// Given address is not part of a DMA buffer
#define SIG_PX4_INVALID_DMA_ADDR            -525
/// Operation would overrun given buffer
#define SIG_PX4_WOULD_OVERRUN_BUFFER        -526
/// Device is busy; try again later
#define SIG_PX4_BUSY                        -527
/// Incorrect function for channel's implementation
#define SIG_PX4_INVALID_CHAN_IMP            -528
/// Invalid XML data was encountered
#define SIG_PX4_XML_MALFORMED               -529
/// XML data was well formed, but not valid
#define SIG_PX4_XML_INVALID                 -530
/// Generic XML related error
#define SIG_PX4_XML_GENERIC                 -531
/// The specified rate is too fast
#define SIG_PX4_RATE_TOO_FAST               -532
/// The specified rate is too slow
#define SIG_PX4_RATE_TOO_SLOW               -533
/// The specified frequency is not available; see operator's manual
#define SIG_PX4_RATE_NOT_AVAILABLE          -534
/// An unexpected error occurred; debug builds will have failed assertion
#define SIG_PX4_UNEXPECTED                  -535
/// A socket error occurred
#define SIG_PX4_SOCKET_ERROR                -536
/// Network subsystem is not ready for network communication
#define SIG_PX4_NETWORK_NOT_READY           -537
/// Limit on number of tasks/processes using sockets has been reached
#define SIG_PX4_SOCKETS_TOO_MANY_TASKS      -538
/// Generic sockets implementation start up failure
#define SIG_PX4_SOCKETS_INIT_ERROR          -539
/// Not connected to a remote PX1500 device
#define SIG_PX4_NOT_REMOTE                  -540
/// Operation timed out
#define SIG_PX4_TIMED_OUT                   -541
/// Connection refused by service; service may not be running
#define SIG_PX4_CONNECTION_REFUSED          -542
/// Received an invalid client request
#define SIG_PX4_INVALID_CLIENT_REQUEST      -543
/// Received an invalid server response
#define SIG_PX4_INVALID_SERVER_RESPONSE     -544
/// Remote service call returned with an error
#define SIG_PX4_REMOTE_CALL_RETURNED_ERROR  -545
/// Undefined method invoked on remote server
#define SIG_PX4_UNKNOWN_REMOTE_METHOD       -546
/// Server closed the connection
#define SIG_PX4_SERVER_DISCONNECTED         -547
/// Remote call for this operation is not implemented or available
#define SIG_PX4_REMOTE_CALL_NOT_AVAILABLE   -548
/// Unknown firmware file type
#define SIG_PX4_UNKNOWN_FW_FILE             -549
/// Firmware upload failed; check that jumper JP1 is not in top position
#define SIG_PX4_FIRMWARE_UPLOAD_FAILED      -550
/// Invalid firmware upload file
#define SIG_PX4_INVALID_FW_FILE             -551
/// Failed to open destination file
#define SIG_PX4_DEST_FILE_OPEN_FAILED       -552
/// Failed to open source file
#define SIG_PX4_SOURCE_FILE_OPEN_FAILED     -553
/// File IO error
#define SIG_PX4_FILE_IO_ERROR               -554
/// Firmware is incompatible with given PX1500
#define SIG_PX4_INCOMPATIBLE_FIRMWARE       -555
/// Unknown structure size specified to library function (X::struct_size)
#define SIG_PX4_UNKNOWN_STRUCT_SIZE         -556
/// An invalid hardware register read/write was attempted
#define SIG_PX4_INVALID_REGISTER            -557
/// An internal FIFO overflowed during acq; couldn't keep up with data rate
#define SIG_PX4_FIFO_OVERFLOW               -558
/// PX1500 firmware could not synchronize to acquisition clock
#define SIG_PX4_DCM_SYNC_FAILED             -559
/// Could not write all data; disk is full
#define SIG_PX4_DISK_FULL                   -560
/// An invalid object handle was used
#define SIG_PX4_INVALID_OBJECT_HANDLE       -561
/// Failed to create a thread
#define SIG_PX4_THREAD_CREATE_FAILURE       -562
/// Phase lock loop (PLL) failed to lock; clock may be bad
#define SIG_PX4_PLL_LOCK_FAILED             -563
/// Recording thread is not responding
#define SIG_PX4_THREAD_NOT_RESPONDING       -564
/// A recording session error occurred
#define SIG_PX4_REC_SESSION_ERROR           -565
/// Cannot arm recording session; already armed or stopped
#define SIG_PX4_REC_SESSION_CANNOT_ARM      -566
/// Snapshots not enabled for given recording session
#define SIG_PX4_SNAPSHOTS_NOT_ENABLED       -567
/// No data snapshot is available
#define SIG_PX4_SNAPSHOT_NOT_AVAILABLE      -568
/// An error occurred while processing .srdc file
#define SIG_PX4_SRDC_FILE_ERROR             -569
/// Named item could not be found
#define SIG_PX4_NAMED_ITEM_NOT_FOUND        -570
/// Could not find Signatec Recorded Data Context info
#define SIG_PX4_CANNOT_FIND_SRDC_DATA       -571
/// Feature is not implemented in current firmware version; upgrade firmware
#define SIG_PX4_NOT_IMPLEMENTED_IN_FIRMWARE -572
/// Timestamp FIFO overflowed during recording
#define SIG_PX4_TIMESTAMP_FIFO_OVERFLOW     -573
/// Cannot determine which firmware needs to be uploaded; update software
#define SIG_PX4_CANNOT_DETERMINE_FW_REQ     -574
/// Required firmware not found in firmware update file
#define SIG_PX4_REQUIRED_FW_NOT_FOUND       -575
/// Loaded firmware is up to date with firmware update file
#define SIG_PX4_FIRMWARE_IS_UP_TO_DATE      -576
/// Operation not implemented for virtual devices
#define SIG_PX4_NO_VIRTUAL_IMPLEMENTATION   -577
/// PX1500 device has been removed from system
#define SIG_PX4_DEVICE_REMOVED              -578
/// JTAG IO error; likely firmware upload IO error
#define SIG_PX4_JTAG_IO_ERROR               -579
/// Access denied
#define SIG_PX4_ACCESS_DENIED               -580
/// Phase lock loop (PLL) failed to lock; lock not stable
#define SIG_PX4_PLL_LOCK_FAILED_UNSTABLE    -581
/// Item could not be set with the given constraints
#define SIG_PX4_UNREACHABLE                 -582
/// Invalid operating mode change; all changes must go or come from Standby
#define SIG_PX4_INVALID_MODE_CHANGE         -583
/// Underlying device is not yet ready; try again shortly
#define SIG_PX4_DEVICE_NOT_READY            -584
/// A parameter is not aligned properly
#define SIG_PX4_ALIGNMENT_ERROR             -585
/// Invalid operation for current board configuration
#define SIG_PX4_INVALID_OP_FOR_BRD_CONFIG   -586
/// Unknown JTAG chain configuration; out-of-date software or hardware error
#define SIG_PX4_UNKNOWN_JTAG_CHAIN          -587
/// An invalid pointer was specified
#define SIG_PX4_INVALIDARG_NULL_POINTER     -588
/// Feature or parameter not available on current revision
#define SIG_PX4_REVISION_MISMATCH           -589
/// Invalid SRDC file handle specified
#define SIG_PX4_INVALID_SRDC_HANDLE         -590
/// Access to protected area of configuration EEPROM denied
#define SIG_PX4_CFG_EEPROM_ACCESS_DENIED	-591
/// Operation not available in current logic package
#define SIG_PX4_INCORRECT_LOGIC_PACKAGE     -592
/// Configuration EEPROM validation failed
#define SIG_PX4_CFG_EEPROM_VALIDATE_ERROR   -593
/// An error occurred while converting text from one encoding to another
#define SIG_PX4_TEXT_CONV_ERROR             -594
/// Calibration failed
#define SIG_PX4_CALIBRATION_ERROR           -595
/// DCM is out of lock; acquisition clock may be bad
#define SIG_PX4_DCM_OUT_OF_LOCK             -596
/// Invalid hardware device configuration data in configuration EEPROM
#define SIG_PX4_INVALID_DEV_CFG_DATA        -597
/// Operation failed; additional context information available via GetErrorText
#define SIG_PX4_OPERATION_FAILED            -598

/// Operation was quasi-successful; one or more items failed
#define SIG_PX4_QUASI_SUCCESSFUL            512

/// Data type of a PX1500 data sample
typedef unsigned char                       px4_sample_t;
/// Data type of a PX1500 timestamp
typedef unsigned long long                  px4_timestamp_t;
/// Size of a PX1500 data sample in bytes
#define PX4_SAMPLE_SIZE_IN_BYTES            1
/// Size of a PX1500 data sample in bits
#define PX4_SAMPLE_SIZE_IN_BITS             8
/// Maximum PX1500 sample value
#define PX4_SAMPLE_MAX_VALUE                0xFF
/// Midscale PX1500 sample value
#define PX4_SAMPLE_MID_VALUE                0x80
/// Minimum PX1500 sample value
#define PX4_SAMPLE_MIN_VALUE                0x00
/// Maximum PX1500 channel count (PX1500-4)
#define PX4_MAX_CHANNELS                    4

/// An invalid PX1500 device handle value
#define PX4_INVALID_HANDLE                  NULL
/// An invalid PX1500 board number
#define PX4_BOARD_NUM_INVALID               0xFFFFFFFF
/// Signatec software board ID
#define PX4_BOARD_TYPE						0x35

/// Maximum PX1500 clock division for clock divider #1
#define PX4CLKDIV1_MAX                      32
/// Maximum PX1500 clock division for clock divider #2
#define PX4CLKDIV2_MAX                      6
/// Maximum SAB board number
#define PX4_MAX_SAB_BOARD_NUMBER            8
/// Maximum DC offset setting value
#define PX4_MAX_DC_OFFSET                   4095
/// ~Midscale DC-offset value
#define PX4_DC_OFFSET_MIDSCALE              2048
/// ~Midscale trigger level
#define PX4_TRIGGER_LEVEL_MIDSCALE          0x80

/// Sentry for free-run (infinite) acquisitions
#define PX4_FREE_RUN                        0
/// Minimum PX1500 ADC frequency in MHz
#define PX4_ADC_FREQ_MIN_MHZ                200
/// Maximum PX1500 ADC frequency in MHz
#define PX4_ADC_FREQ_MAX_MHZ                1500
/// Minimum PX1500 ADC frequency when using dual edge sampling (DES)
#define PX4_ADC_DES_FREQ_MIN_MHZ            500
/// Maximum PX1500 ADC frequency when using dual edge sampling (DES)
#define PX4_ADC_DES_FREQ_MAX_MHZ            1500
/// Minimum (divided) frequency we can get from the internal VCO
#define PX4_VCO_FREQ_MIN_MHZ                160
/// Maximum (divided valid) frequency we can get from the internal VCO
#define PX4_VCO_FREQ_MAX_MHZ                1500
/// Preferred port for remote PX1500 servers
#define PX4_SERVER_PREFERRED_PORT           3494
/// Default timeout for a remote PX1500 service request in milliseconds
#define PX4_SERVER_REQ_TIMEOUT_DEF          3000
/// Boolean true
#define PX4_TRUE                            1
/// Boolean false
#define PX4_FALSE                           0
/// Extension used for Signatec Recorded Data Context (.srdc) files
#define PX4_SRDC_DOT_EXTENSIONA             ".srdc"
/// Extension used for Signatec Recorded Data Context (.srdc) files
#define PX4_SRDC_DOT_EXTENSIONW             L".srdc"
/// Extension used for Signatec Recorded Data Context (.srdc) files
#define PX4_SRDC_EXTENSIONA                 "srdc"
/// Extension used for Signatec Recorded Data Context (.srdc) files
#define PX4_SRDC_EXTENSIONW                 L"srdc"
/// Extension used for PX1500 timestamp files (.px4ts)
#define PX4_TIMESTAMP_FILE_DOT_EXTENSIONA   ".px4ts"
/// Extension used for PX1500 timestamp files (.px4ts)
#define PX4_TIMESTAMP_FILE_DOT_EXTENSIONW   L".px4ts"
/// Extension used for PX1500 timestamp files (.px4ts)
#define PX4_TIMESTAMP_FILE_EXTENSIONA       "px4ts"
/// Extension used for PX1500 timestamp files (.px4ts)
#define PX4_TIMESTAMP_FILE_EXTENSIONW       L"px4ts"

// -- PX1500 source clock values (PX4CLKSRC_*)
/// Internal VCO (Power-up default)
#define PX4CLKSRC_INTERNAL                  0
/// External clock
#define PX4CLKSRC_EXTERNAL                  1
/// Slave 1 clock
#define PX4CLKSRC_SLAVE_1                   2
/// Slave 2 clock
#define PX4CLKSRC_SLAVE_2                   3
#define PX4CLKSRC__COUNT                    4   // Invalid setting

// -- PX1500 ADC clock reference values (PX4CLKREF_*)
/// Internal 10MHz clock reference (Power-up default)
#define PX4CLKREF_INT_10MHZ                 0
/// External clock reference
#define PX4CLKREF_EXT                       1
#define PX4CLKREF__COUNT                    2   // Invalid setting

// -- PX1500 post-ADC clock divider values (PX4POSTADCCLKDIV_*)
/// No post-ADC clock division (Power-up default)
#define PX4POSTADCCLKDIV_01                 0
/// Post-ADC clock division of 2
#define PX4POSTADCCLKDIV_02                 1
/// Post-ADC clock division of 4
#define PX4POSTADCCLKDIV_04                 2
/// Post-ADC clock division of 8
#define PX4POSTADCCLKDIV_08                 3
/// Post-ADC clock division of 16
#define PX4POSTADCCLKDIV_16                 4
/// Post-ADC clock division of 32
#define PX4POSTADCCLKDIV_32                 5
#define PX4POSTADCCLKDIV__COUNT             6   // Invalid setting

// -- PX1500 active channel selection constants (PX4CHANSEL_*)
/// Quad channel: channels 1, 2, 3 and 4 (Power-up default for PX1500-4 devices)
#define PX4CHANSEL_QUAD                     0
/// Dual channel: channels 1 and 2 (Power-up default for PX1500-2 devices)
#define PX4CHANSEL_DUAL_1_2                 1
/// Dual channel: channels 1 and 2
#define PX4CHANSEL_DUAL_3_4                 2
/// Dual channel: channels 1 and 3
#define PX4CHANSEL_DUAL_1_3                 3
// Triple channel: channels 1, 2, and 3 (UNSUPPORTED IN FIRMWARE; DO NOT USE)
#define PX4CHANSEL_TRIPLE_1_2_3             4
/// Single channel: channel 1
#define PX4CHANSEL_SINGLE_CH1               5
/// Single channel: channel 2
#define PX4CHANSEL_SINGLE_CH2               6
/// Single channel: channel 3
#define PX4CHANSEL_SINGLE_CH3               7
/// Single channel: channel 4
#define PX4CHANSEL_SINGLE_CH4               8
/// Dual channel: channels 1 and 3 (ADC interleaved)
#define PX4CHANSEL_DUAL_1_3_ADCINT			9
/// Single channel: channel 1 (ADC interleaved)
#define PX4CHANSEL_SINGLE_CH1_ADCINT		10
/// Single channel: channel 3 (ADC interleaved)
#define PX4CHANSEL_SINGLE_CH3_ADCINT		11
#define PX4CHANSEL__COUNT                   12   // Invalid setting

// -- PX1500 trigger mode values (PX4TRIGMODE_*)
/// Trigger event starts a single data acquisition (Power-up default)
#define PX4TRIGMODE_POST_TRIGGER            0
/// Each trigger event begins a new statically sized data acquisition
#define PX4TRIGMODE_SEGMENTED               1
#define PX4TRIGMODE__COUNT                  2   // Invalid setting

// -- PX1500 trigger source values (PX4TRIGSRC_*)
/// Internal trigger, channel 1 (Power-up default)
#define PX4TRIGSRC_INT_CH1                  0
/// Internal trigger, channel 2
#define PX4TRIGSRC_INT_CH2                  1
/// Internal trigger, channel 3
#define PX4TRIGSRC_INT_CH3                  2
/// Internal trigger, channel 4
#define PX4TRIGSRC_INT_CH4                  3
/// External trigger
#define PX4TRIGSRC_EXT                      4
#define PX4TRIGSRC__COUNT                   5   // Invalid setting

// -- PX1500 trigger direction values (PX4TRIGDIR_*)
/// Trigger occurs on positive going signal (Power-up default)
#define PX4TRIGDIR_POS                      0
/// Trigger occurs on negative going signal
#define PX4TRIGDIR_NEG                      1
#define PX4TRIGDIR__COUNT                   2   // Invalid setting

// -- PX1500 Operating Mode values (PX4MODE_*)
/// Power down mode
#define PX4MODE_OFF                         0
/// Standby (ready) mode
#define PX4MODE_STANDBY                     1
/// RAM acquisition mode
#define PX4MODE_ACQ_RAM                     2
/// Reserved for future use
#define _PX4MODE_RESERVED_3                 3
/// RAM-buffered PCI acquisition mode; data buffered through PX1500 RAM
#define PX4MODE_ACQ_PCI_BUF                 4
/// Signatec Auxiliary Bus (SAB) acquisition; acquire directly to SAB bus
#define PX4MODE_ACQ_SAB                     5
// / Buffered SAB acquisition; acquire to SAB, buffering through PX1500 RAM
// NOT IMPLEMENTED IN FIRMWARE, DO NOT USE
#define PX4MODE_ACQ_SAB_BUF                 6		
/// PX1500 RAM read to PCI; transfer data from PX1500 RAM to host PC
#define PX4MODE_RAM_READ_PCI                7
/// PX1500 RAM read to SAB; transfer data from PX1500 RAM to SAB bus
#define PX4MODE_RAM_READ_SAB                8
// / PX1500 RAM write from PCI; transfer data from host PC to PX1500 RAM
// NOT IMPLEMENTED IN FIRMWARE, DO NOT USE
#define PX4MODE_RAM_WRITE_PCI               9
#define PX4MODE__COUNT                      10  // Invalid setting

// -- PX1500 input voltage range values (PX4VOLTRNG_*)
/// 500 mVp-p (default for amplifier path)
#define PX4VOLTRNG_0_500_VPP                0
/// 700 mVp-p (default for transformer path)
#define PX4VOLTRNG_0_700_VPP                1
#define PX4VOLTRNG__COUNT                   2   // Invalid setting

// -- GetErrorTextPX4 flags (PX4ETF_*)
/// Do not consider system error information
#define PX4ETF_IGNORE_SYSERROR              0x00000001
/// Do not generate user-friendly text for system error information
#define PX4ETF_NO_SYSERROR_TEXT             0x00000002
/// Force inclusion of system error information even if it may not be relevant
#define PX4ETF_FORCE_SYSERROR               0x00000004

// --  PX1500 version ID values (PX4VERID_*)
/// Request (package) version information for the current PX1500 firmware
#define PX4VERID_FIRMWARE                   0
/// Request version/revision information for the current PX1500 hardware
#define PX4VERID_HARDWARE                   1
/// Request version information for the PX1500 device driver
#define PX4VERID_DRIVER                     2
/// Request version information for the PX1500 library
#define PX4VERID_LIBRARY                    3
/// Request version information for the PX1500 software release
#define PX4VERID_PX4_SOFTWARE               4
/// Request version information for the current PX1500 SAB firmware
#define PX4VERID_PCI_FIRMWARE               5
/// Request version information for previous PX1500 PCI firmware
#define PX4VERID_PREV_PCI_FIRMWARE          6
/// Request version information for the current PX1500 SAB firmware
#define PX4VERID_SAB_FIRMWARE               7
/// Request version information for previous PX1500 SAB firmware
#define PX4VERID_PREV_SAB_FIRMWARE          8
#define PX4VERID__COUNT                     9   // Invalid setting

// -- PX1500 PCIe FPGA types (PX4SYSFPGA_*)
/// Virtex 5 LX50T
#define PX4SYSFPGA_V5_LX50T					0
#define PX4SYSFPGA__COUNT					1

// -- PX1500 SAB FPGA types (PX4SABFPGA_*)
/// Virtex 5 LX50T
#define PX4SABFPGA_V5_LX50T			0
/// Virtex 5 SX95T
#define PX4SABFPGA_V5_SX95T					1
#define PX4SABFPGA__COUNT					2

// -- PX1500 input channel filter types (PX4CHANFILTER_*)
/// Unspecified or unknown filter type
#define PX4CHANFILTER_UNSPECIFIED			0
/// 1GHz lowpass filter
#define PX4CHANFILTER_LOWPASS_1GHZ			1
/// 2GHz lowpass filter
#define PX4CHANFILTER_LOWPASS_2GHZ			2
#define PX4CHANFILTER__COUNT				3

// -- PX1500 version string flags (PX4VERF_*)
/// No pre-release indication.
#define PX4VERF_NO_PREREL                   0x00000001
/// No sub-minor info; imples PX4VERF_NO_PACKAGE
#define PX4VERF_NO_SUBMIN                   0x00000006
/// No package info
#define PX4VERF_NO_PACKAGE                  0x00000004
/// No custom enumeration info
#define PX4VERF_NO_CUSTOM                   0x00000008
/// Compact version string if possible (XX.YY.00.00 -> XX.YY)
#define PX4VERF_COMPACT_VER                 0x00000010
/// Use 0 padding for one digit version numbers
#define PX4VERF_ZERO_PAD_SINGLE_DIGIT_VER   0x00000020
/// Allow function to return aliases for known versions
#define PX4VERF_ALLOW_ALIASES               0x00000040

// -- PX1500 SAB mode value (PX4SABMODE_*)
/// Inactive slave; neither send nor receive data (Power-up default)
#define PX4SABMODE_INACTIVE_SLAVE           0
/// Master; send data to SAB
#define PX4SABMODE_MASTER                   1
#define PX4SABMODE__COUNT                   2

// -- PX1500 SAB configuration values (PX4SABCFG_*)
/// 64-bit SAB transfers (Power-up default)
#define PX4SABCFG_64                        0
/// Lower 32 bits of SAB bus 
#define PX4SABCFG_32                        1
/// Lower 32 bits of SAB bus 
#define PX4SABCFG_32L                       1
/// Upper 32 bits of SAB bus
#define PX4SABCFG_32H                       2
#define PX4SABCFG__COUNT                    3

// -- PX1500 SAB clock values (PX4SABCLK_*)
/// Use acquisition clock
#define PX4SABCLK_ACQ_CLOCK                 0
/// 62.5 MHz clock
#define PX4SABCLK_62_5MHZ                   1
/// 125 MHz clock (Power-up default)
#define PX4SABCLK_125MHZ                    2
#define PX4SABCLK__COUNT                    3   // Invalid setting

// -- PX1500 SAB direct command values (PX4SABCMD_*)
/// Enter standby mode
#define PX4SABCMD_MODE_STANDBY              0xF
/// Acquire to SAB (unbuffered)
#define PX4SABCMD_MODE_ACQ_SAB              0xB
/// Acquire to RAM
#define PX4SABCMD_MODE_ACQ_RAM              0xA
/// Transfer PX1500 RAM data over SAB
#define PX4SABCMD_MODE_READ_SAB             0xD

// -- Device register read methods (PX4REGREAD_*)
/// Read from cache unless it's dirty (or status), then go to hardware
#define PX4REGREAD_DEFAULT                  0       // Should be default
/// Read from driver cache only; do *not* read from hardware
#define PX4REGREAD_CACHE_ONLY               1
/// Read from hardware regardless of cache state; updates cache
#define PX4REGREAD_HARDWARE                 2
/// Read from user-mode, handle-specific cache; no kernel mode
#define PX4REGREAD_USER_CACHE               3
#define PX4REGREAD__COUNT                   4

// -- PX1500 features present (PX4FEATURE_*)
/// SAB functionality is present
#define PX4FEATURE_SAB                      0x00000001
/// This is a prototype PX1500 device
#define PX4FEATURE_PROTOTYPE                0x00000004
/// FPGA processing may be present on this device
#define PX4FEATURE_FPGA_PROC                0x00000008

// -- PX1500 board revision identifiers
// (Note: This is not the same as a board's hardware revision value)
/// Original PX1500-4
#define PX4BRDREV_PX1500_4					0
#define PX4BRDREV_1                         0		// Older name		
/// PX1500-2
#define PX4BRDREV_PX1500_2					1
#define PX4BRDREV__COUNT					2

// -- PX1500 board sub-revision values; each set relative to PX4BRDREV_*
/// PX1500-4 SP - Signal Processing
#define PX4BRDREVSUB_PX1500_4_SP            0
/// PX1500-4 DR - Data Recorder
#define PX4BRDREVSUB_PX1500_4_DR			1
#define PX4BRDREVSUB_PX1500_4__COUNT        2
/// PX1500-2 DR - Data Recorder
#define PX4BRDREVSUB_PX1500_2_DR            0
#define PX4BRDREVSUB_PX1500_2__COUNT        1

// -- PX1500 settings save/load XML flags (PX4XMLSET_*)
/// Serialize to a node only; do not include XML header info
#define PX4XMLSET_NODE_ONLY                 0x00000001
/// Pretty-print XML output; add newlines and indentation for human eyes
#define PX4XMLSET_FORMAT_OUTPUT             0x00000002
/// Do not set default hardware settings prior to loading settings
#define PX4XMLSET_NO_PRELOAD_DEFAULTS       0x00000004

// -- PX1500 master/slave configuration values (PX4MSCFG_*)
/// Normal, standalone PX1500
#define PX4MSCFG_STANDALONE                 0
/// Master PX1500; will provide clock and trigger for slave PX1500 devices
#define PX4MSCFG_MASTER                     1
/// Slave #1; clock and trigger will be synchronized with master
#define PX4MSCFG_SLAVE_1                    2
/// Slave #2; clock and trigger will be synchronized with master
#define PX4MSCFG_SLAVE_2                    3
#define PX4MSCFG__COUNT                     4   // Invalid setting

/// Returns nonzero if given master/slave config setting is for a master
#define PX4_IS_MASTER(mscfg)				((mscfg) == PX4MSCFG_MASTER)
/// Returns nonzero if given master/slave config setting if for a slave
#define PX4_IS_SLAVE(mscfg)					\
	(((mscfg)>=PX4MSCFG_SLAVE_1) && ((mscfg)<=PX4MSCFG_SLAVE_2))

// -- PX1500 sync configuration (PX4SYNCCFG_*)
/// Internal synchronization
#define PX4SYNCCFG_INTERNAL                 0
/// External synchronization (e.g. SYNC1500-6); requires external hardware
#define PX4SYNCCFG_EXTERNAL                 1
/// Slave #1 sync; requires master device
#define PX4SYNCCFG_SLAVE1                   2
/// Slave #2 sync; requires master device
#define PX4SYNCCFG_SLAVE2                   3
#define PX4SYNCCFG__COUNT                   4

// -- PX1500 external trigger configuration (PX4EXTTRIGCFG_*)
/// LVTTL/CMOS (0 to 3.3V)
#define PX4EXTTRIGCFG_LVTTL					0
/// LVPECL (3.3V)
#define PX4EXTTRIGCFG_LVPECL				1
#define PX4EXTTRIGCFG__COUNT				2

// -- PX1500 analog path hardware configuration (PX4ANALOGPATH_*)
/// Amplifier path is selected
#define PX4ANALOGPATH_AMPLIFIED				0
/// Transformer path is selected
#define PX4ANALOGPATH_TRANSFORMER			1
#define PX4ANALOGPATH__COUNT				2

// -- PX1500 input channel implementation flags (PX4CHANIMPF_*)
/// Channel coupling: 0 = AC-coupled, 1 = DC-coupled
#define PX4CHANIMPF_COUPLING				0x01
/// Front-end path:   0 = Amplifier,  1 = Transformer
#define PX4CHANIMPF_FRONT_END_PATH			0x02
/// Set when channel implementation flags are valid
#define PX4CHANIMPF__VALID					0x80

// -- A few helper macros to interpret PX4CHANIMPF_*
#define PX4_IS_CHANIMP_AC_COUPLED(f)		(0 == ((f) & PX4CHANIMPF_COUPLING))
#define PX4_IS_CHANIMP_DC_COUPLED(f)		(0 != ((f) & PX4CHANIMPF_COUPLING))
#define PX4_IS_CHANIMP_AMP_PATH(f)			(0 == ((f) & PX4CHANIMPF_FRONT_END_PATH))
#define PX4_IS_CHANIMP_XFRM_PATH(f)			(0 != ((f) & PX4CHANIMPF_FRONT_END_PATH))

// -- PX1500 digital output mode values (PX4DIGIO_*)
/// OUTPUT: 0V (Power-up default)
#define PX4DIGIO_OUT_0V                     0
/// OUTPUT: Digital out is synchronized trigger
#define PX4DIGIO_OUT_SYNC_TRIG              1
/// OUTPUT: Digital out is ADC converter clock divided by 8
#define PX4DIGIO_OUT_ADC_CLOCK_DIV_8        2
#define PX4DIGIO_OUT_ADC_CLOCK              2		// older symbol name
/// OUTPUT: 3.3V
#define PX4DIGIO_OUT_3_3V                   3
/// INPUT: Timestamp request or sibling sync input
#define PX4DIGIO_IN_TS_GEN_OR_SYNC_IN       4
/// Reserved for future (5)
#define PX4DIGIO_RESERVED_5                 5
/// Reserved for future (6)
#define PX4DIGIO_RESERVED_6                 6
/// Reserved for future (7)
#define PX4DIGIO_RESERVED_7                 7
#define PX4DIGIO__COUNT                     8   // Invalid setting

// -- PX1500 firmware release notes severity (PX4FWNOTESEV_*)
/// No firmware release notes provided
#define PX4FWNOTESEV_NONE                   0
/// Firmware release notes are available
#define PX4FWNOTESEV_NORMAL                 1
/// Important firmware release notes available; always prompted
#define PX4FWNOTESEV_IMPORTANT              2
#define PX4FWNOTESEV__COUNT                 3

// -- PX1500 Firmware Context flags (PX4FWCTXF_*)
/// Not really a firmware file; used for things like verify files
#define PX4FWCTXF_VERIFY_FILE               0x00000001
#define PX4FWCTXF__DEFAULT                  0

// -- PX1500 upload firmware flags (PX4UFWF_*)
/// Only upload firmware if given firmware is different from what is loaded
#define PX4UFWF_REFRESH_ONLY                0x00000001
/// Check that firmware file is compatible with hardware; no firmware loaded
#define PX4UFWF_COMPAT_CHECK_ONLY           0x00000002
/// Force erasing of unused EEPROMs even if they're already blank
#define PX4UFWF_FORCE_EEPROM_ERASE          0x00000004

// -- PX1500 upload firmware output flags (PX4UFWOUTF_*)
/// System must be shutdown in order for firmware updata to have effect
#define PX4UFWOUTF_SHUTDOWN_REQUIRED        0x00000001
/// System must be reboot in order for firmware updata to have effect
#define PX4UFWOUTF_REBOOT_REQUIRED          0x00000002
/// All firmware is up-to-date; no firmware uploaded
#define PX4UFWOUTF_FW_UP_TO_DATE            0x00000004
/// Firmware was verified; no new firmware was uploaded
#define PX4UFWOUTF_VERIFIED                 0x00000008

// -- PX1500 file writing flags (PX4FILWF_*)
/// Append if file already exists; default is to overwrite
#define PX4FILWF_APPEND                     0x00000001
/// Save data as text; sample values will be whitespace-delimited
#define PX4FILWF_SAVE_AS_TEXT               0x00000004
/// Don't try to use fast, unbuffered IO
#define PX4FILWF_NO_UNBUFFERED_IO           0x00000008
/// Assume data channel selection (PX4CHANSEL_*) from assumed_chan_sel
#define PX4FILWF_ASSUME_CHANNEL_SEL         0x00000010
/// Use hexadecimal output for; applies to text saves
#define PX4FILWF_HEX_OUTPUT                 0x00000020
/// Deinterleave channel data into separate files
#define PX4FILWF_DEINTERLEAVE               0x00000040
/// Convert data to signed before saving
#define PX4FILWF_CONVERT_TO_SIGNED          0x00000080
/// Generate a Signatec Recorded Data Context (.srdc) file for each output
#define PX4FILWF_GENERATE_SRDC_FILE         0x00000100
/// Embed SRDC information in data file as NTFS alternate file stream
#define PX4FILWF_EMBED_SRDC_AS_AFS          0x00000200
/// Save PX1500 timstamp data in external file
#define PX4FILWF_SAVE_TIMESTAMPS            0x00000400
/// Save timestamps as newline-delimited text; use with above flag
#define PX4FILWF_TIMESTAMPS_AS_TEXT         0x00000800
/// Use timestamp FIFO overflow marker: F1F0F1F0F1F0F1F0 F1F0F1F0F1F0F1F0
#define PX4FILWF_USE_TS_FIFO_OVFL_MARKER    0x00001000
/// Abort and fail operation if timestamp FIFO overflows; for recordings
#define PX4FILWF_ABORT_OP_ON_TS_OVFL        0x00002000

// -- PX1500 file writing output flags (PX4FILWOUTF_*)
/// Timestamp FIFO overflowed during write/record process
#define PX4FILWOUTF_TIMESTAMP_FIFO_OVERFLOW 0x00000001
/// No timestamp data was available
#define PX4FILWOUTF_NO_TIMESTAMP_DATA       0x00000002

/// -- PX1500 Recording Session flags (PX4RECSESF_*)
/// Do a PX1500 RAM-buffered PCI acquisition recording
#define PX4RECSESF_REC_PCI_ACQ              0x00000001
/// Do a PX1500 RAM acquisition/transfer recording
#define PX4RECSESF_REC_RAM_ACQ              0x00000002
/// Mask for session recording type
#define PX4RECSESF_REC__MASK                0x0000000F
/// Do not auto arm recording; will be done with ArmRecordingSessionPX4
#define PX4RECSESF_DO_NOT_ARM               0x00000010
/// Periodically obtain snapshots of recording data
#define PX4RECSESF_DO_SNAPSHOTS             0x00000020
/// Use utility DMA buffers for data transfers
#define PX4RECSESF_USE_UTILITY_BUFFERS      0x00000040

// -- PX1500 Recording Session status (PX4RECSTAT_*)
/// Idle; recording not yet started
#define PX4RECSTAT_IDLE                     0
/// Operation in progress or waiting for trigger event
#define PX4RECSTAT_IN_PROGRESS              1
/// Operation complete or stopped by user
#define PX4RECSTAT_COMPLETE                 2
/// Operation ended due to error
#define PX4RECSTAT_ERROR                    3
#define PX4RECSTAT__COUNT                   4

// -- PX1500 Recording Session progress query flags (PX4RECPROGF_*)
/// Do not obtain error text on error
#define PX4RECPROGF_NO_ERROR_TEXT           0x00000001
#define PX4RECPROGF__DEFAULT                0

// -- PX1500 SRDC file open flags (PX4SRDCOF_*)
/// Opens/create file, refresh and write settings, then close file
#define PX4SRDCOF_QUICK_SET                 0x00000001
/// Open existing SRDC file; fail if file does not exist
#define PX4SRDCOF_OPEN_EXISTING             0x00000002
/// Create a new SDRC file; will ignore and overwrite existing data
#define PX4SDRCOF_CREATE_NEW                0x00000004
/// Given pathname is recorded data; have library search for SRDC
#define PX4SRDCOF_PATHNAME_IS_REC_DATA      0x00000008

// -- SRDC enumeration flags (PX4SRDCENUM_*)
/// Skip standard SRDC items; use to obtain only user-defined items
#define PX4SRDCENUM_SKIP_STD                0x00000001
/// Skip user-defined SRDC items; use to obtain only standard items
#define PX4SRDCENUM_SKIP_USER_DEFINED       0x00000002
/// Only include modified items
#define PX4SRDCENUM_MODIFIED_ONLY           0x00000004

// -- PX1500 Timestamp Mode values (PX4TSMODE_*)
/// No timestamps are generated
#define PX4TSMODE_NO_TIMESTAMPS             0
/// A timestamp is generated for each segment in a segmented acquisition
#define PX4TSMODE_SEGMENTS                  1
/// A timestamp is generated for each trigger received on external trigger
#define PX4TSMODE_TS_ON_EXT_TRIGGER         2
/// A timestamp is generated for each rising edge of digital input
#define PX4TSMODE_TS_ON_DIGITAL_INPUT       3
#define PX4TSMODE__COUNT                    4       // Invalid setting

// -- PX1500 timestamp counter mode values (PX4TSCNTMODE_*)
/// Counter unconditionally increments during acquisition mode
#define PX4TSCNTMODE_DEFAULT                0
/// Counter only increments when digitizing; pauses when waiting for trigger
#define PX4TSCNTMODE_PAUSE_WHEN_ARMED       1
#define PX4TSCNTMODE__COUNT                 2

// -- PX1500 Timestamp read flags (PX4TSREAD_*)
/// Call to read from a known-full timestamp FIFO
#define PX4TSREAD_READ_FROM_FULL_FIFO       0x00000001
/// Mask for input flags
#define PX4TSREAD__INPUT_FLAG_MASK          0x000FFFFF
/// Mask for output flags
#define PX4TSREAD__OUTPUT_FLAG_MASK         0xFFF00000
/// Output flag; More timestamps are available
#define PX4TSREAD_MORE_AVAILABLE            0x01000000
/// Output flag; Timestamp FIFO overflowed
#define PX4TSREAD_FIFO_OVERFLOW             0x02000000

// -- PX1500 firmware types (PX4FWTYPE_*)
/// PCI firmware
#define PX4FWTYPE_PCI                       0
/// SAB firmware
#define PX4FWTYPE_SAB                       1
/// Generic firmware package; firmware version that end users see
#define PX4FWTYPE_PACKAGE                   2
#define PX4FWTYPE__COUNT                    3

// -- PX1500 version constraint types (PX4VCT_*)
/// >=
#define PX4VCT_GTOE                         0
/// <=
#define PX4VCT_LTOE                         1
/// >
#define PX4VCT_GT                           2
/// <
#define PX4VCT_LT                           3
/// ==
#define PX4VCT_E                            4
/// !=
#define PX4VCT_NE                           5
#define PX4VCT__COUNT                       6

// -- GetBoardNamePX4 flags (PX4GBNF_*)
/// Do not include board's serial (or ordinal) number
#define PX4GBNF_NO_SN                       0x00000001
/// Use ordinal number instead of serial number
#define PX4GBNF_USE_ORD_NUM                 0x00000002
/// Include master/slave status
#define PX4GBNF_INC_MSCFG                   0x00000004
/// Include virtual status
#define PX4GBNF_INC_VIRT_STATUS             0x00000008
/// Include remote status
#define PX4GBNF_INC_REMOTE_STATUS           0x00000010
/// Alphanumeric only
#define PX4GBNF_ALPHANUMERIC_ONLY           0x00000020
/// Use underscores '_' in place of spaces
#define PX4GBNF_USE_UNDERSCORES             0x00000040
/// Include sub-revision info (DR/SP##)
#define PX4GBNF_INC_SUB_REVISION            0x00000080
/// Include channel analog path info
#define PX4GBNF_INC_ANALOG_PATH             0x00000100
/// Include channel coupling
#define PX4GBNF_INC_COUPLING                0x00000200
/// Include synchronization
#define PX4GBNF_INC_SYNC_CFG                0x00000400
/// Use dashes '-' in place of spaces
#define PX4GBNF_USE_DASHES                  0x00000800
/// Include master/slave status at end of text (like device part number)
#define PX4GBNF_MSCFG_AT_END                0x00001000
/// Compact channel coupling or path if all channels the same (AAAA->A)
#define PX4GBNF_COMPACT_CHAN_IMP            0x00002000
#define PX4GBNF__DETAILED                                  \
    (PX4GBNF_INC_MSCFG |                                   \
     PX4GBNF_INC_VIRT_STATUS | PX4GBNF_INC_REMOTE_STATUS | \
     PX4GBNF_INC_SUB_REVISION)
#define PX4GBNF__PRODUCT_CLASS                              \
    (PX4GBNF_INC_MSCFG        | PX4GBNF_MSCFG_AT_END      | \
     PX4GBNF_INC_SUB_REVISION | PX4GBNF_INC_ANALOG_PATH   | \
     PX4GBNF_INC_COUPLING     | PX4GBNF_INC_SYNC_CFG      | \
	 PX4GBNF_USE_DASHES       | PX4GBNF_NO_SN)

// -- PX1500 send request flags (PX4SRF_*)
/// Auto-handle response; useful if you're only receive pass/fail info
#define PX4SRF_AUTO_HANDLE_RESPONSE         0x00000001
/// Do not validate response at all; default is a quick, cursory check
#define PX4SRF_NO_VALIDATION                0x00000002
/// SendServiceRequestPX4 will free incoming request data
#define PX4SRF_AUTO_FREE_REQUEST            0x00000004
/// Reserved for internal use
#define PX4SRF_CONNECTING                   0x80000000

// --- Windows ---

#ifdef _WIN32

#if !defined(_WINSOCKAPI_) && !defined(_WINSOCK2API_)
# include <Winsock2.h>      // Windows sockets implementation
#endif

#include <windows.h>        // Main Windows definitions
#include <tchar.h>          // Generic text mappings

/// Alias for Windows socket data type
typedef SOCKET      px4_socket_t;

// Determine if we are importing or exporting symbols from DLL.
#if defined _PX4_IMPLEMENTING_DLL
# define DllSpecPX4 __declspec(dllexport)
#else
# define DllSpecPX4 __declspec(dllimport)
#endif

// Default calling convention used for all library exports
#define PX4CALLCONV         __cdecl

// Define library export calling convension and linkage
#ifdef __cplusplus
# define PX4API_(t) extern "C" DllSpecPX4 t PX4CALLCONV
#else
# define PX4API_(t) DllSpecPX4 t PX4CALLCONV
#endif

// MSVC Users: If PX4PP_NO_LINK_LIBRARY is #defined before including this
// file then the build process will not attempt to link with the PX1500
// import library (PX4.lib). Note that automatic linking will only work if
// px4.lib is within the search path of the build process.
#if defined(_MSC_VER) && !defined(PX4PP_NO_LINK_LIBRARY)
# ifdef _WIN64
#  pragma comment(lib, "px4_64.lib")
# else 
#  pragma comment(lib, "px4.lib")
# endif
#endif

#endif      // _WIN32

// --- Linux ---

#ifdef __linux__

// Define library export calling convension and linkage
#ifdef __cplusplus
# define PX4API_(t)			extern "C" t
#else
# define PX4API_(t)			t
#endif

/// Alias for Linux socket data type
typedef int					px4_socket_t;

// Default calling convention used for all library exports
#define PX4CALLCONV

#endif      // __linux__

/// Most all library exports return an int (SIG_* or SIG_PX4_*)
#define PX4API      PX4API_(int)

/// Specify default function arguments for C++ clients...
#ifndef _PX4_DEF
# ifdef __cplusplus
#  define _PX4_DEF(v)       = v
# else
#  define _PX4_DEF(v)
# endif
#endif

// PX1500 types ------------------------------------------------------- //

/// A handle to a PX1500 device; consider an opaque object
typedef struct _px4hs_ { int hello_there; }* HPX4;

/// Signature of most all SetXXXPX4 routines
typedef int (PX4CALLCONV * px4lib_set_func_t)(HPX4, unsigned int);
/// Signature of most all GetXXXPX4 routines
typedef int (PX4CALLCONV * px4lib_get_func_t)(HPX4, int);

/// Signature of a couple SetXXXPX4 routines that take double arguments
typedef int (PX4CALLCONV * px4lib_setd_func_t)(HPX4, double);
/// Signature of a couple GetXXXPX4 routines that obtain double values
typedef int (PX4CALLCONV * px4lib_getd_func_t)(HPX4, double*, int);

typedef struct _PX4S_FW_VER_INFO_tag
{
    unsigned int        struct_size;        ///< struct size in bytes

    unsigned int        fw_pkg_ver;         // Firmware package version
    unsigned int        fw_pkg_cust_enum;   // Custom fw enum (package)

    int                 readme_sev;         // PX4FWNOTESEV_*
    int                 extra_flags;        // PX4FWCTXF_*

} PX4S_FW_VER_INFO;

#define _PX4SO_PX4S_DRIVER_STATS_V1 40
#ifndef PX4S_DRIVER_STATS_STRUCT_DEFINED
#define PX4S_DRIVER_STATS_STRUCT_DEFINED
/// Used by the IOCTL_PMP1K_DRIVER_STATS device IO control
typedef struct _PX4_DRIVER_STATS_tag
{
    unsigned int    struct_size;        ///< IN: Structure size
    int             nConnections;       ///< Active connection count
    unsigned int    isr_cnt;            ///< Total ISR executions
    unsigned int    dma_finished_cnt;   ///< DMA xfers completed
    unsigned int    dma_started_cnt;    ///< DMA xfers started
    unsigned int    acq_started_cnt;    ///< Acqs started
    unsigned int    acq_finished_cnt;   ///< Acqs completed
    unsigned int    dcm_reset_cnt;      ///< DCM reset counter
    unsigned long long  dma_bytes;      ///< Total bytes DMA'd to system

} PX4S_DRIVER_STATS;
#endif

/// Signature of optional file IO callback function; load/save board data
typedef int (*PX4_FILEIO_CALLBACK)(HPX4 hBrd,
                                   void* callbackCtx,
                                   px4_sample_t* sample_datap,
                                   int sample_count,
                                   const char* pathname, 
                                   unsigned long long samps_in_file,
                                   unsigned long long samps_moved,
                                   unsigned long long samps_to_move);

/// Parameters for saving PX1500 data to file
typedef struct _PX4S_FILE_WRITE_PARAMS_tag
{
    unsigned int    struct_size;        ///< Init to struct size in bytes

    const char*     pathname;           ///< Destination file pathname
    const char*     pathname2;          ///< For Ch 2 when deinterleaving
    const char*     pathname3;          ///< For Ch 3 when deinterleaving
    const char*     pathname4;          ///< For Ch 4 when deinterleaving
    unsigned int    flags;              ///< PX4FILWF_*
    unsigned int    init_bytes_skip;    ///< Initial bytes to skip in file
    unsigned long long max_file_seg;    ///< Max file samples; binary only
    int             assumed_chan_sel;   ///< Assumed chan sel (PX4CHANSEL_*) of data

    PX4_FILEIO_CALLBACK pfnCallback;    ///< Optional progress callback
    void*           callbackCtx;        ///< User-defined callback context

    unsigned int    flags_out;          ///< Output flags; PX4FILWOUTF_*
    const char*     operator_notes;     ///< User-defined notes; SRDC data
    const char*     ts_filenamep;       ///< Timestamp filename override

} PX4S_FILE_WRITE_PARAMS;

/// Signature of optional recording session callback
typedef int (*PX4_REC_CALLBACK)(HPX4 hBrd, 
                                void* data,
                                px4_sample_t* bufp, 
                                unsigned sample_count);

/// Recording session parameters
typedef struct _PX4S_REC_SESSION_PARAMS_tag
{
    unsigned int        struct_size;    ///< Init to struct size in bytes

    int                 rec_flags;      ///< PX4RECSESF_*
    unsigned long long  rec_samples;    ///< # samples or 0 for inf
    unsigned int        acq_samples;    ///< For RAM acq recordings
    unsigned int        xfer_samples;   ///< Transfer size of 0 for autoset

    PX4S_FILE_WRITE_PARAMS* filwp;      ///< Defines output file(s)

    px4_sample_t*       dma_bufp;       ///< Optional DMA buffer address
    unsigned            dma_buf_samples;///< Size of DMA buffer in samps

    // Data snapshot parameters; valid when PX4RECSESF_DO_SNAPSHOTS set

    unsigned int        ss_len_samples; ///< Data snapshot length in samples
    unsigned int        ss_period_xfer; ///< Snapshot period in DMA xfers
    unsigned int        ss_period_ms;   ///<  or in milliseconds

    PX4_REC_CALLBACK    pfnCallback;    ///< Optional callback
    void*               callbackData;   ///< Context data for callback

} PX4S_REC_SESSION_PARAMS;

/// Recording session progress/status
typedef struct _PX4S_REC_SESSION_PROG_tag
{
    unsigned int        struct_size;    ///< Init to struct size in bytes

    int                 status;         ///< PX4RECSTAT_*
    unsigned long       elapsed_time_ms;///< Rec time in ms
    unsigned long long  samps_recorded;
    unsigned long long  samps_to_record;
    unsigned int        xfer_samples;   ///< Transfer size in samps
    unsigned int        xfer_count;     ///< Transfer counter
    unsigned int        snapshot_counter;///< Current snapshot counter

    // Valid when status == PX4RECSTAT_ERROR
    int                 err_res;        ///< SIG_*
    char*               err_textp;      ///< Caller free via FreMemoryPX4
    
} PX4S_REC_SESSION_PROG;

/// Recorded data information; used with GetRecordedDataInfoPX4
typedef struct _PX4S_RECORDED_DATA_INFO_tag
{
    unsigned int        struct_size;    ///< Init to struct size in bytes

    char                boardName[16];  ///< Name of board
    unsigned int        boardSerialNum; ///< Serial number

    unsigned int        channelCount;   ///< Channel count
    unsigned int        channelNum;     ///< Channel ID; single chan data
    unsigned int        sampSizeBytes;  ///< Sample size in bytes 
    unsigned int        sampSizeBits;   ///< Sample size in bits
    int                 bSignedSamples; ///< Signed or unsigned

    double              sampleRateMHz;  ///< Sampling rate in MHz
    double              inputVoltRngPP; ///< Peak-to-peak input volt range

    unsigned int        segment_size;   ///< Segment size or zero

    unsigned int        header_bytes;   ///< Size of app-specific header
    int                 bTextData;      ///< Data is text (versus binary)?
    int                 textRadix;      ///< Radix of text data (10/16)

    unsigned int        trig_offset;    ///< Relates first sample to trig
    int                 bPreTrigger;    ///< ? Pre-trigger : trigger delay

} PX4S_RECORDED_DATA_INFO;

// PX4IMP: Update marshalling in ConnectToRemoteDeviceWPX4 when updated
typedef struct _PX4S_REMOTE_CONNECT_CTXA_tag
{
    unsigned int        struct_size;        ///< Init to struct size in bytes
    unsigned short      flags;              // Currently undefined, use 0
	unsigned short      timeout_secs;       // Connection timeout or 0
    unsigned short      port;
    const char*         pServerAddress;
    const char*         pApplicationName;   // Optional
    const char*         pSubServices;       // Optional

} PX4S_REMOTE_CONNECT_CTXA;

typedef struct _PX4S_REMOTE_CONNECT_CTXW_tag
{
    unsigned int        struct_size;        ///< Init to struct size in bytes
    unsigned short      flags;              // Currently undefined, use 0
	unsigned short      timeout_secs;       // Connection timeout or 0
    unsigned short      port;
    const wchar_t*      pServerAddress;
    const wchar_t*      pApplicationName;   // Optional
    const wchar_t*      pSubServices;       // Optional

} PX4S_REMOTE_CONNECT_CTXW;

// PX1500 macros ------------------------------------------------------ //

// PX1500 generic-text mapping macros --------------------------------- //

//  For PX1500 library functions that take string parameters, both ASCII
//   and UNICODE versions may be implemented. ASCII implementations are
//   suffixed with 'APX4' and UNICODE implementations are suffixed with
//   'WPX4'. The following macros can be used for character-type agnostic
//   code. That is, for ASCII builds the ASCII versions will be used and for
//   UNICODE builds the UNICODE versions will be used.

#ifdef _UNICODE
# define GetBoardNamePX4                    GetBoardNameWPX4
# define GetErrorTextPX4                    GetErrorTextWPX4
# define GetVersionTextPX4                  GetVersionTextWPX4
# define UploadFirmwarePX4                  UploadFirmwareWPX4
# define QueryFirmwareVersionInfoPX4        QueryFirmwareVersionInfoWPX4
# define ExtractFirmwareNotesPX4            ExtractFirmwareNotesWPX4
# define OpenSrdcFilePX4                    OpenSrdcFileWPX4
# define SaveSrdcFilePX4                    SaveSrdcFileWPX4
# define GetSrdcItemPX4                     GetSrdcItemWPX4
# define PX4_SRDC_DOT_EXTENSION             PX4_SRDC_DOT_EXTENSIONW
# define PX4_SRDC_EXTENSION                 PX4_SRDC_EXTENSIONW
# define GetRecordedDataInfoPX4             GetRecordedDataInfoWPX4
# define EnumSrdcItemsPX4                   EnumSrdcItemsWPX4
# define SetSrdcItemPX4                     SetSrdcItemWPX4
# define PX4_TIMESTAMP_FILE_DOT_EXTENSION   PX4_TIMESTAMP_FILE_DOT_EXTENSIONW
# define PX4_TIMESTAMP_FILE_EXTENSION       PX4_TIMESTAMP_FILE_EXTENSIONW
# define SaveSettingsToStringXmlPX4         SaveSettingsToStringXmlWPX4
# define LoadSettingsFromStringXmlPX4       LoadSettingsFromStringXmlWPX4
# define SaveSettingsToFileXmlPX4           SaveSettingsToFileXmlWPX4
# define LoadSettingsFromFileXmlPX4         LoadSettingsFromFileXmlWPX4
# define PX4S_REMOTE_CONNECT_CTX            PX4S_REMOTE_CONNECT_CTXW
# define ConnectToRemoteDevicePX4           ConnectToRemoteDeviceWPX4
# define ConnectToRemoteVirtualDevicePX4    ConnectToRemoteVirtualDeviceWPX4
# define GetRemoteDeviceCountPX4            GetRemoteDeviceCountWPX4
# define GetHostServerInfoPX4               GetHostServerInfoWPX4
# define DumpLibErrorPX4					DumpLibErrorWPX4
#else
# define GetBoardNamePX4                    GetBoardNameAPX4
# define GetErrorTextPX4                    GetErrorTextAPX4
# define GetVersionTextPX4                  GetVersionTextAPX4
# define UploadFirmwarePX4                  UploadFirmwareAPX4
# define QueryFirmwareVersionInfoPX4        QueryFirmwareVersionInfoAPX4
# define ExtractFirmwareNotesPX4            ExtractFirmwareNotesAPX4
# define OpenSrdcFilePX4                    OpenSrdcFileAPX4
# define SaveSrdcFilePX4                    SaveSrdcFileAPX4
# define GetSrdcItemPX4                     GetSrdcItemAPX4
# define PX4_SRDC_DOT_EXTENSION             PX4_SRDC_DOT_EXTENSIONA
# define PX4_SRDC_EXTENSION                 PX4_SRDC_EXTENSIONA
# define GetRecordedDataInfoPX4             GetRecordedDataInfoAPX4
# define EnumSrdcItemsPX4                   EnumSrdcItemsAPX4
# define SetSrdcItemPX4                     SetSrdcItemAPX4
# define PX4_TIMESTAMP_FILE_DOT_EXTENSION   PX4_TIMESTAMP_FILE_DOT_EXTENSIONA
# define PX4_TIMESTAMP_FILE_EXTENSION       PX4_TIMESTAMP_FILE_EXTENSIONA
# define SaveSettingsToStringXmlPX4         SaveSettingsToStringXmlAPX4
# define LoadSettingsFromStringXmlPX4       LoadSettingsFromStringXmlAPX4
# define SaveSettingsToFileXmlPX4           SaveSettingsToFileXmlAPX4
# define LoadSettingsFromFileXmlPX4         LoadSettingsFromFileXmlAPX4
# define PX4S_REMOTE_CONNECT_CTX            PX4S_REMOTE_CONNECT_CTXA
# define ConnectToRemoteDevicePX4           ConnectToRemoteDeviceAPX4
# define ConnectToRemoteVirtualDevicePX4    ConnectToRemoteVirtualDeviceAPX4
# define GetRemoteDeviceCountPX4            GetRemoteDeviceCountAPX4
# define GetHostServerInfoPX4               GetHostServerInfoAPX4
# define DumpLibErrorPX4					DumpLibErrorAPX4
#endif

// PX1500 library exports --------------------------------------------- //

// --- Device connection/management --- //

// Obtains number of PX1500 devices in local system
PX4API GetDeviceCountPX4();

// Obtain a handle to a local PX1500 device
PX4API ConnectToDevicePX4 (HPX4* phDev, unsigned int brdNum);
// Closes a PX1500 device handle
PX4API DisconnectFromDevicePX4 (HPX4 hBrd);

// Obtain a handle to a virtual (fake) PX1500 device
PX4API ConnectToVirtualDevicePX4 (HPX4* phDev, 
                                  unsigned int serialNum, 
                                  unsigned int brdNum);

// Determines if a given PX1500 device handle is for a virtual device
PX4API IsDeviceVirtualPX4 (HPX4 hBrd);
// Determines if the given PX1500 device handle is connected to a device
PX4API IsHandleValidPX4 (HPX4 hBrd);
// Determines if a given PX1500 device handle is for a remote device
PX4API IsDeviceRemotePX4 (HPX4 hBrd);

// Duplicate a PX1500 device handle
PX4API DuplicateHandlePX4 (HPX4 hBrd, HPX4* phNew);

// Obtain the serial number of the PX1500 connected to the given handle
PX4API GetSerialNumberPX4 (HPX4 hBrd, unsigned int* snp);
// Obtain the ordinal number of the PX1500 connected to the given handle
PX4API GetOrdinalNumberPX4 (HPX4 hBrd, unsigned int* onp);
// Obtain board revision and/or sub-revision
PX4API GetBoardRevisionPX4 (HPX4 hBrd, unsigned int* revp, unsigned int* sub_revp);

// Obtains the features (PX4FEATURE_*) implemented on given PX1500
PX4API GetBoardFeaturesPX4 (HPX4 hBrd);

// Copy hardware settings from another PX1500 device
PX4API CopyHardwareSettingsPX4 (HPX4 hBrdDst, HPX4 hBrdSrc);

// Obtain user-friendly name for given board (ASCII)
PX4API GetBoardNameAPX4 (HPX4 hBrd, char** bufpp,
                         int flags _PX4_DEF(0));
// Obtain user-friendly name for given board (UNICODE)
PX4API GetBoardNameWPX4 (HPX4 hBrd, wchar_t** bufpp,
                         int flags _PX4_DEF(0));

// --- Remote PX1500 device routines --- //

// Call once per application instance to initialize sockets implementation
PX4API SocketsInitPX4();

// Sockets implementation cleanup; call if your app calls SocketsInitD4K
PX4API SocketsCleanupPX4();

// Obtain count (and serial numbers) of remote PX1500 devices (ASCII)
PX4API GetRemoteDeviceCountAPX4 (const char* server_addrp,
                unsigned short port _PX4_DEF(PX4_SERVER_PREFERRED_PORT),
                                unsigned int** sn_bufpp _PX4_DEF(NULL));

// Obtain count (and serial numbers) of remote PX1500 devices (UNICODE)
PX4API GetRemoteDeviceCountWPX4 (const wchar_t* server_addrp,
                unsigned short port _PX4_DEF(PX4_SERVER_PREFERRED_PORT),
                                unsigned int** sn_bufpp _PX4_DEF(NULL));

// Obtain a handle to a PX1500 device on a remote system
PX4API ConnectToRemoteDeviceAPX4 (HPX4* phDev, unsigned int brdNum,
                                  PX4S_REMOTE_CONNECT_CTXA* ctxp);
// Obtain a handle to a PX1500 device on a remote system
PX4API ConnectToRemoteDeviceWPX4 (HPX4* phDev, unsigned int brdNum,
                                  PX4S_REMOTE_CONNECT_CTXW* ctxp);


// Obtain a handle to a virtual PX1500 on a remote system
PX4API ConnectToRemoteVirtualDeviceAPX4 (HPX4* phDev,
                                        unsigned int serialNum, 
                                        unsigned int brdNum,
                                        PX4S_REMOTE_CONNECT_CTXA* ctxp);
// Obtain a handle to a virtual PX1500 on a remote system
PX4API ConnectToRemoteVirtualDeviceWPX4 (HPX4* phDev,
                                        unsigned int serialNum, 
                                        unsigned int brdNum,
                                        PX4S_REMOTE_CONNECT_CTXW* ctxp);

// Obtain socket of the underlying connection for remote PX1500
PX4API GetServiceSocketPX4 (HPX4 hBrd, px4_socket_t* sockp);

// Send a request to a remote PX1500 service
PX4API SendServiceRequestPX4 (HPX4 hBrd, 
                              const void* svc_reqp, int req_bytes,
                              void** responsepp,
                              unsigned int timeoutMs _PX4_DEF (3000),
                              unsigned int flags _PX4_DEF(0));

// Free a response from a previous remote service request
PX4API FreeServiceResponsePX4 (void* bufp);

// Obtain remote server information (ASCII)
PX4API GetHostServerInfoAPX4 (HPX4 hBrd, char** server_addrpp,
                              unsigned short* portp);
// Obtain remote server information (UNICODE)
PX4API GetHostServerInfoWPX4 (HPX4 hBrd, wchar_t** server_addrpp,
                              unsigned short* portp);


// --- Acquisition routines --- //

// Acquire data to PX1500 RAM
PX4API AcquireToBoardRamPX4 (HPX4 hBrd, 
                             unsigned int samp_start,
                             unsigned int samp_count,
                             unsigned int timeout_ms _PX4_DEF(0),
                             int bAsynchronous _PX4_DEF(0));

// Acquire data to Signatec Auxiliary Bus (SAB)
PX4API AcquireToSabPX4 (HPX4 hBrd, unsigned int samp_count,
                        int bRamBuffered _PX4_DEF(0),
                        unsigned int timeout_ms _PX4_DEF(0),
                        int bAsynchronous _PX4_DEF(0));

// Begin a buffered PCI acquisition
PX4API BeginBufferedPciAcquisitionPX4 (HPX4 hBrd,
                                       unsigned int samp_count _PX4_DEF(PX4_FREE_RUN));

// Obtain fresh PCI acquisition data
PX4API GetPciAcquisitionDataFastPX4 (HPX4 hBrd, unsigned int samples,
                                     px4_sample_t* dma_bufp,
                                     int bAsynchronous _PX4_DEF(0));
// Obtain fresh PCI acquisition data given normal, non-DMA buffer
PX4API GetPciAcquisitionDataBufPX4 (HPX4 hBrd,
                                    unsigned int samples,
                                    px4_sample_t* heap_bufp,
                                    int bAsynchronous _PX4_DEF(0));

// End a buffered PCI acquisition
PX4API EndBufferedPciAcquisitionPX4 (HPX4 hBrd);

// Determine if RAM/SAB acquisition is currently in progress
PX4API IsAcquisitionInProgressPX4 (HPX4 hBrd);
// Wait for a RAM/SAB data acquisition to complete with optional timeout
PX4API WaitForAcquisitionCompletePX4 (HPX4 hBrd, unsigned int timeout_ms _PX4_DEF(0));

// --- DMA buffer routines --- //

// Allocate a DMA buffer
PX4API AllocateDmaBufferPX4 (HPX4 hBrd, unsigned int samples, 
                             px4_sample_t** bufpp);

// Free a DMA buffer
PX4API FreeDmaBufferPX4 (HPX4 hBrd, px4_sample_t* bufp);

// Ensures that the library managed utility DMA buffer is of the given size
PX4API EnsureUtilityDmaBufferPX4 (HPX4 hBrd, unsigned int sample_count);
// Frees the utility buffer associated with the given PX1500 handle
PX4API FreeUtilityDmaBufferPX4 (HPX4 hBrd);
// Get the library managed utility DMA buffer
PX4API GetUtilityDmaBufferPX4 (HPX4 hBrd, px4_sample_t** bufpp,
                               unsigned int* buf_samplesp);

// Ensures that the library managed utility DMA buffer #2 is of the given size
PX4API EnsureUtilityDmaBuffer2PX4 (HPX4 hBrd, unsigned int sample_count);
// Frees the #2 utility buffer associated with the given PX1500 handle
PX4API FreeUtilityDmaBuffer2PX4 (HPX4 hBrd);
// Get the library managed utility DMA buffer #2
PX4API GetUtilityDmaBuffer2PX4 (HPX4 hBrd, px4_sample_t** bufpp,
                                unsigned int* buf_samplesp);


// --- Data transfer routines --- //

// Transfer data in PX1500 RAM to a DMA buffer on the host PC
PX4API ReadSampleRamFastPX4 (HPX4 hBrd, 
                             unsigned int sample_start,
                             unsigned int sample_count, 
                             px4_sample_t* dma_bufp,
                             int bAsynchronous _PX4_DEF(0));

// Determine if transfer is currently in progress; for asynch transfers
PX4API IsTransferInProgressPX4 (HPX4 hBrd);
// Wait (sleep) for an asynchronous data xfer to complete with optional timeout
PX4API WaitForTransferCompletePX4 (HPX4 hBrd, 
                                   unsigned int timeout_ms _PX4_DEF(0));

// Xfer data in PX1500 RAM to a buffer on the PC; any boundary/alignment
PX4API ReadSampleRamBufPX4 (HPX4 hBrd,
                            unsigned int sample_start,
                            unsigned int sample_count,
                            px4_sample_t* bufp,
                            int bAsynchronous _PX4_DEF(0));

// Xfer and deinterleave data in brd RAM to host PC; any boundary/alignment
PX4API ReadSampleRamMultiChannelBufPX4 (HPX4 hBrd,
                                        unsigned int sample_start,
                                        unsigned int samples_per_chan,
                                        px4_sample_t* buf_ch1p,
                                        px4_sample_t* buf_ch2p,
                                        px4_sample_t* buf_ch3p,
                                        px4_sample_t* buf_ch4p,
                                        int chan_sel _PX4_DEF(-1));

// Transfer data in PX1500 RAM to local file on host PC
PX4API ReadSampleRamFileFastPX4 (HPX4 hBrd,
                                 unsigned int sample_start,
                                 unsigned int sample_count,
                                 px4_sample_t* dma_bufp,
                                 unsigned int dma_buf_samples,
                                 PX4S_FILE_WRITE_PARAMS* paramsp);

// Transfer data in PX1500 RAM to local file on host PC
PX4API ReadSampleRamFileBufPX4 (HPX4 hBrd,
                                unsigned int sample_start,
                                unsigned int sample_count,
                                PX4S_FILE_WRITE_PARAMS* paramsp);


// Transfer data in PX1500 RAM to the SAB bus
PX4API TransferSampleRamToSabPX4 (HPX4 hBrd,
                                  unsigned int sample_start,
                                  unsigned int sample_count,
                                  unsigned int timeout_ms _PX4_DEF(0),
                                  int bAsynchronous _PX4_DEF(0));


// Transfer data from a buffer to a file using library's file write params
PX4API _DumpRawDataPX4 (HPX4 hBrd,
                        px4_sample_t* bufp,
                        unsigned samples, 
                        PX4S_FILE_WRITE_PARAMS* paramsp);

// --- Data interleaving/deinterleaving functions --- //

// De-interleave dual channel data into separate buffers
PX4API DeInterleaveData2ChanPX4 (const px4_sample_t* srcp, 
                                 unsigned int samples_in,
                                 px4_sample_t* dst_ch1p,
                                 px4_sample_t* dst_ch2p);

// (Re)interleave dual channel data into a single buffer
PX4API InterleaveData2ChanPX4 (const px4_sample_t* src_ch1p, 
                               const px4_sample_t* src_ch2p, 
                               unsigned int samps_per_chan, 
                               px4_sample_t* dstp);

// De-interleave triple channel data into separate buffers
PX4API DeInterleaveData3ChanPX4 (const px4_sample_t* srcp, 
                                 unsigned int samples_in,
                                 px4_sample_t* dst_ch1p,
                                 px4_sample_t* dst_ch2p,
                                 px4_sample_t* dst_ch3p);

// (Re)interleave triple channel data into a single buffer
PX4API InterleaveData3ChanPX4 (const px4_sample_t* src_ch1p, 
                               const px4_sample_t* src_ch2p, 
                               const px4_sample_t* src_ch3p,
                               unsigned int samps_per_chan, 
                               px4_sample_t* dstp);

// De-interleave four channel data into separate buffers
PX4API DeInterleaveData4ChanPX4 (const px4_sample_t* srcp, 
                                 unsigned int samples_in,
                                 px4_sample_t* dst_ch1p,
                                 px4_sample_t* dst_ch2p,
                                 px4_sample_t* dst_ch3p,
                                 px4_sample_t* dst_ch4p);

// (Re)interleave four channel data into a single buffer
PX4API InterleaveData4ChanPX4 (const px4_sample_t* src_ch1p, 
                               const px4_sample_t* src_ch2p, 
                               const px4_sample_t* src_ch3p,
                               const px4_sample_t* src_ch4p,
                               unsigned int samps_per_chan, 
                               px4_sample_t* dstp);

// --- Acquisition Recording Session functions --- //

/// A handle to a PX1500 recording session
typedef struct _px4rsh_ { int reserved; }* HPX4RECORDING;

/// An invalid HPX4RECORDING value
#define INVALID_HPX4RECORDING_HANDLE        NULL

// Create a PX1500 acquisition recording session
PX4API CreateRecordingSessionPX4 (HPX4 hBrd, 
                                  PX4S_REC_SESSION_PARAMS* rec_paramsp,
                                  HPX4RECORDING* handlep);

// Arm device for recording
PX4API ArmRecordingSessionPX4 (HPX4RECORDING hRec);

// Obtain progress/status for current recording session
PX4API GetRecordingSessionProgressPX4 (HPX4RECORDING hRec,
                                       PX4S_REC_SESSION_PROG* progp,
                                       unsigned flags _PX4_DEF(PX4RECPROGF__DEFAULT));

// Obtain data snapshot from current recording
PX4API GetRecordingSnapshotPX4 (HPX4RECORDING hRec,
                                px4_sample_t* bufp,
                                unsigned int samples,
                                unsigned int* samples_gotp,
                                unsigned int* ss_countp);

// Abort the current recording session
PX4API AbortRecordingSessionPX4 (HPX4RECORDING hRec);

// Delete a PX1500 recording session
PX4API DeleteRecordingSessionPX4 (HPX4RECORDING hRec);

// Obtain recording session output flags; only valid after recording stopped
PX4API GetRecordingSessionOutFlagsPX4 (HPX4RECORDING hRec,
                                       unsigned int* flagsp);

// --- Timestamp routines --- // 

// Read Timestamp Overflow Flag from PX1500 hardware
PX4API GetTimestampOverflowFlagPX4 (HPX4 hBrd);

// Determine if any timestamps are available in timestamp FIFO
PX4API GetTimestampAvailabilityPX4 (HPX4 hBrd);

// Set the timestamp mode; determines how timestamps are recorded
PX4API SetTimestampModePX4 (HPX4 hBrd, unsigned int val);
// Get the timestamp mode; determines how timestamps are recorded
PX4API GetTimestampModePX4 (HPX4 hBrd, int bFromCache _PX4_DEF(1));

// Set timestamp counter mode; determines how timestamp counter increments
PX4API SetTimestampCounterModePX4 (HPX4 hBrd, unsigned int val);
// Get timestamp counter mode; determines how timestamp counter increments
PX4API GetTimestampCounterModePX4 (HPX4 hBrd, int bFromCache _PX4_DEF(1));

// Read timestamp data from PX1500 timestamp FIFO
PX4API ReadTimestampDataPX4 (HPX4 hBrd, px4_timestamp_t* bufp,
                             unsigned int ts_count,
                             unsigned int* ts_readp,
                             unsigned int flags _PX4_DEF(0),
                             unsigned int timeout_ms _PX4_DEF(0),
                             unsigned int* flags_outp _PX4_DEF(NULL));

// Obtain size of PX1500 timestamp FIFO, in timestamp elements
PX4API GetTimestampFifoDepthPX4 (HPX4 hBrd, unsigned int* ts_elementsp);

// --- Hardware configuration functions --- //

// Get size of PX1500 sample RAM in samples
PX4API GetSampleRamSizePX4 (HPX4 hBrd, unsigned int* samplesp);

// Get type of SAB FPGA present on the PX1500; (PX4SABFPGA_*)
PX4API GetSabFpgaTypePX4 (HPX4 hBrd);

// --- Hardware settings functions --- //

// Determine if the PX1500 is idle; in Standby or Off mode
PX4API InIdleModePX4 (HPX4 hBrd);

// Determine if the PX1500 is acquiring (or waiting to acquire)
PX4API InAcquisitionModePX4 (HPX4 hBrd);

// Set the PX1500's operating mode
PX4API SetOperatingModePX4 (HPX4 hBrd, unsigned int val);
// Get the PX1500's operating mode
PX4API GetOperatingModePX4 (HPX4 hBrd, int bFromCache _PX4_DEF(1));

// Set the PX1500's segment size for use with Segmented triggering mode
PX4API SetSegmentSizePX4 (HPX4 hBrd, unsigned int val);
// Get the PX1500's segment size for use with Segmented triggering mode
PX4API GetSegmentSizePX4 (HPX4 hBrd, int bFromCache _PX4_DEF(1));

// Reserved; use SetActiveMemoryRegionPX4
PX4API SetSampleCountPX4 (HPX4 hBrd, unsigned int val);
PX4API GetSampleCountPX4 (HPX4 hBrd, int bFromCache _PX4_DEF(1));
PX4API _GetSampleCountExPX4 (HPX4 hBrd, unsigned int* valp, int bFromCache _PX4_DEF(1));

// Reserved; use SetActiveMemoryRegionPX4
PX4API SetStartSamplePX4 (HPX4 hBrd, unsigned int val);
PX4API GetStartSamplePX4 (HPX4 hBrd, int bFromCache _PX4_DEF(1));
PX4API _GetStartSampleExPX4 (HPX4 hBrd, unsigned int* valp, int bFromCache _PX4_DEF(1));

// Defines PX1500 memory region for subsequent acquisitions and transfers
PX4API SetActiveMemoryRegionPX4 (HPX4 hBrd,
								 unsigned int sample_count,
								 unsigned int sample_start _PX4_DEF(0));

// Get the current active memory region
PX4API GetActiveMemoryRegionPX4 (HPX4 hBrd,
								 unsigned int* sample_countp,
								 unsigned int* sample_startp,
								 int bFromCache _PX4_DEF(1));

// Synchronize ADCs on given device (and all connected slaves)
PX4API SynchronizeAdcsPX4 (HPX4 hBrd);
// SynchronizeAdcsPX4 is only required for master/slave synchronization
//  1) Set master's int or ext clock rate
//  2) Set slave's external clock rate (SetExternalClockRatePX4) with master's rate
//  3) Call SynchronizeAdcsPX4 on the master

// Obtain maximum sample count for given active channel selection (PX4CHANSEL_*)
PX4API GetMaxSampleCountForActiveChanSelPX4 (HPX4 hBrd, int active_chan_sel, 
											 unsigned int* max_sample_countp);
PX4API GetBankCountForActiveChanSelPX4 (int active_chan_sel);

// Set trigger delay samples; count of samples to skip after trigger
PX4API SetTriggerDelaySamplesPX4 (HPX4 hBrd, unsigned int val);
// Get trigger delay samples; count of samples to skip after trigger
PX4API GetTriggerDelaySamplesPX4 (HPX4 hBrd, int bFromCache _PX4_DEF(1));

// Set pre-trigger sample count; count of samples to keep prior to trigger
PX4API SetPreTriggerSamplesPX4 (HPX4 hBrd, unsigned int val);
// Get pre-trigger sample count; count of samples to keep prior to trigger
PX4API GetPreTriggerSamplesPX4 (HPX4 hBrd, int bFromCache _PX4_DEF(1));

// Set trigger A level; defines threshold for an internal trigger event
PX4API SetTriggerLevelAPX4 (HPX4 hBrd, unsigned int val);
// Get trigger A level; defines threshold for an internal trigger event
PX4API GetTriggerLevelAPX4 (HPX4 hBrd, int bFromCache _PX4_DEF(1));

// Set trigger B level; defines threshold for an internal trigger event
PX4API SetTriggerLevelBPX4 (HPX4 hBrd, unsigned int val);
// Get trigger B level; defines threshold for an internal trigger event
PX4API GetTriggerLevelBPX4 (HPX4 hBrd, int bFromCache _PX4_DEF(1));

// Set triggering mode; relates trigger events to how data is saved
PX4API SetTriggerModePX4 (HPX4 hBrd, unsigned int val);
// Get triggering mode; relates trigger events to how data is saved
PX4API GetTriggerModePX4 (HPX4 hBrd, int bFromCache _PX4_DEF(1));

// Set trigger source; defines where trigger events originate
PX4API SetTriggerSourcePX4 (HPX4 hBrd, unsigned int val);
// Get trigger source; defines where trigger events originate
PX4API GetTriggerSourcePX4 (HPX4 hBrd, int bFromCache _PX4_DEF(1));

// Set trigger A direction; defines the direction that defines a trigger
PX4API SetTriggerDirectionAPX4 (HPX4 hBrd, unsigned int val);
// Get trigger A direction; defines the direction that defines a trigger
PX4API GetTriggerDirectionAPX4 (HPX4 hBrd, int bFromCache _PX4_DEF(1));

// Set trigger B direction; defines the direction that defines a trigger
PX4API SetTriggerDirectionBPX4 (HPX4 hBrd, unsigned int val);
// Get trigger B direction; defines the direction that defines a trigger
PX4API GetTriggerDirectionBPX4 (HPX4 hBrd, int bFromCache _PX4_DEF(1));

// Set external trigger direction
PX4API SetTriggerDirectionExtPX4 (HPX4 hBrd, unsigned int val);
// Get external trigger direction
PX4API GetTriggerDirectionExtPX4 (HPX4 hBrd, int bFromCache _PX4_DEF(1));

// Issue a software-generated trigger event to a PX1500
PX4API IssueSoftwareTriggerPX4 (HPX4 hBrd);

// Note: Most all boards will have the same input voltage range for all
//       input channels. The software supports different input voltage
//       ranges for different channels.

// Get channel 1 input voltage range; (PX4VOLTRNG_*)
PX4API GetInputVoltRangeCh1PX4 (HPX4 hBrd, int bFromCache _PX4_DEF(1));
// Get channel 2 input voltage range; (PX4VOLTRNG_*)
PX4API GetInputVoltRangeCh2PX4 (HPX4 hBrd, int bFromCache _PX4_DEF(1));
// Get channel 3 input voltage range; (PX4VOLTRNG_*)
PX4API GetInputVoltRangeCh3PX4 (HPX4 hBrd, int bFromCache _PX4_DEF(1));
// Get channel 4 input voltage range; (PX4VOLTRNG_*)
PX4API GetInputVoltRangeCh4PX4 (HPX4 hBrd, int bFromCache _PX4_DEF(1));

// Obtain actual peak-to-peak voltage for given PX4VOLTRNG_*
PX4API GetInputVoltRangeFromSettingPX4 (int vr_sel, double* vpp);

// Obtain actual peak-to-peak voltage for channel 1 input
PX4API GetInputVoltageRangeVoltsCh1PX4 (HPX4 hBrd, double* voltsp, int bFromCache _PX4_DEF(1));
// Obtain actual peak-to-peak voltage for channel 2 input
PX4API GetInputVoltageRangeVoltsCh2PX4 (HPX4 hBrd, double* voltsp, int bFromCache _PX4_DEF(1));
// Obtain actual peak-to-peak voltage for channel 3 input
PX4API GetInputVoltageRangeVoltsCh3PX4 (HPX4 hBrd, double* voltsp, int bFromCache _PX4_DEF(1));
// Obtain actual peak-to-peak voltage for channel 4 input
PX4API GetInputVoltageRangeVoltsCh4PX4 (HPX4 hBrd, double* voltsp, int bFromCache _PX4_DEF(1));

// Set the ADC internal clock reference source (PX4CLKREF_*)
PX4API SetInternalAdcClockReferencePX4 (HPX4 hBrd, unsigned int val);
// Get the ADC internal clock reference source (PX4CLKREF_*)
PX4API GetInternalAdcClockReferencePX4 (HPX4 hBrd, int bFromCache _PX4_DEF(1));

//Trigger Selection
PX4API SetTriggerSelectionPX4 (HPX4 hBrd, int val);

//Trigger Hysteresis
PX4API SetTriggerHysteresisPX4 (HPX4 hBrd, int val);

//FPGA Temperature
PX4API GetFPGATemperaturePX4(HPX4 hBrd, int bFromCache);

// Set the external clock rate 
PX4API SetExternalClockRatePX4 (HPX4 hBrd, double dRateMHz);
// Get the external clock rate
PX4API GetExternalClockRatePX4 (HPX4 hBrd, double* ratep, int bFromCache _PX4_DEF(1));

// Set the ADC clock rate; only applies to internal 1.5 GHz VCO
PX4API SetInternalAdcClockRatePX4 (HPX4 hBrd, double dRateMHz);
// Get the ADC clock rate
PX4API GetInternalAdcClockRatePX4 (HPX4 hBrd, double* ratep, int bFromCache _PX4_DEF(1));

// Set the PX1500's source ADC clock
PX4API SetAdcClockSourcePX4 (HPX4 hBrd, unsigned int val);
// Get the PX1500's source ADC clock
PX4API GetAdcClockSourcePX4 (HPX4 hBrd, int bFromCache _PX4_DEF(1));

// Set the PX1500's clock divider values
PX4API SetExtClockDividersPX4 (HPX4 hBrd, unsigned int div1,  unsigned int div2);
PX4API SetExtClockDivider1PX4 (HPX4 hBrd, unsigned int div1);
PX4API SetExtClockDivider2PX4 (HPX4 hBrd, unsigned int div2);

// Get the PX1500's #1 clock divider value; applies to internal VCXO and ext
PX4API GetExtClockDivider1PX4 (HPX4 hBrd,  int bFromCache _PX4_DEF(1));
// Get the PX1500's #2 clock divider value; applies to internal VCXO and ext
PX4API GetExtClockDivider2PX4 (HPX4 hBrd,  int bFromCache _PX4_DEF(1));

// Set the PX1500's post-ADC clock divider; division by dropping samples
PX4API SetPostAdcClockDividerPX4 (HPX4 hBrd, unsigned int val);
// Get the PX1500's post-ADC clock divider; division by dropping samples
PX4API GetPostAdcClockDividerPX4 (HPX4 hBrd, int bFromCache _PX4_DEF(1));

// Troubleshooting: disable internal clock PLL usage
PX4API _SetPllDisablePX4 (HPX4 hBrd, int bDisable);
PX4API _GetPllDisablePX4 (HPX4 hBrd, int bFromCache _PX4_DEF(1));

// Obtain effective acquisition rate considering post-ADC division
PX4API GetEffectiveAcqRatePX4 (HPX4 hBrd, double* pRateMHz);
// Obtain the actual ADC acquisition rate
PX4API GetActualAdcAcqRatePX4 (HPX4 hBrd, double* pRateMHz);

// Set the digital output mode; determines what is output on digital output (PX4DIGIO_*)
PX4API SetDigitalIoModePX4 (HPX4 hBrd, unsigned int val);
// Get the digital output mode; determines what is output on digital output (PX4DIGIO_*)
PX4API GetDigitalIoModePX4 (HPX4 hBrd, int bFromCache _PX4_DEF(1));

// Enable/disable the PX1500's digital output
PX4API SetDigitalIoEnablePX4 (HPX4 hBrd, unsigned int bEnable);
// Get state of PX1500's digital output enable
PX4API GetDigitalIoEnablePX4 (HPX4 hBrd, int bFromCache _PX4_DEF(1));

// Set active channels; defines which channels are digitized
PX4API SetActiveChannelsPX4 (HPX4 hBrd, unsigned int val);
// Get active channels; defines which channels are digitized
PX4API GetActiveChannelsPX4 (HPX4 hBrd, int bFromCache _PX4_DEF(1));

// Obtain actual channel count for given channel selection (PX4CHANSEL_*)
PX4API GetChannelCountFromChanSelPX4 (int chanSel);
// Get physical channel number for nth chan of given active channel selection
PX4API GetPhysChanNumFromChanSelIdxPX4 (int chanSel, int idx);

// - Alternate API for active channel selection; uses a generic bitmask
//   instead of a device specific encoding (PX4CHANSEL_*). Bitmask
//   interpretation: 0x1 = Channel 1, 0x2 = Channel 2, 0x4 = Channel 3,
//   0x8 = Channel 4, 0x3 = Dual channel (Ch1 and Ch2), and so on

// Set active channel mask; defines which channels are digitized
PX4API SetActiveChannelsMaskPX4 (HPX4 hBrd, unsigned int chan_mask, int bAdcInt _PX4_DEF(0));
// Get active channel mask; defines which channels are digitized
PX4API GetActiveChannelMaskPX4 (HPX4 hBrd, int bFromCache _PX4_DEF(1));

// Returns non-zero if given active channel mask is supported by the device
PX4API IsActiveChannelMaskSupportedPX4 (HPX4 hBrd, unsigned int chan_mask);
// Returns the absolute 0-based channel index from the relative channel index of a particular channel mask
PX4API GetAbsChanIdxFromChanMaskPX4 (int chan_mask, int rel_idx);
// Returns the relative 0-based channel index from the absolulte channel index of a particular channel mask
PX4API GetRelChanIdxFromChanMaskPX4 (int chan_mask, int abs_idx);
// Returns the number of channels active in the given channel mask
PX4API GetChanCountFromChanMaskPX4 (int chan_mask);
// Returns channel mask for given active channel selection
PX4API GetChanMaskFromChanSelPX4 (int active_channels);
// Returns active channel selection for given channel mask
PX4API GetChanSelFromChanMaskPX4 (int chan_mask);
// -

// Set channel 1 DC offset
PX4API SetDcOffsetCh1PX4 (HPX4 hBrd, unsigned int val _PX4_DEF(2048));
// Get channel 1 DC offset
PX4API GetDcOffsetCh1PX4 (HPX4 hBrd, int bFromCache _PX4_DEF(1));

// Set channel 2 DC offset
PX4API SetDcOffsetCh2PX4 (HPX4 hBrd, unsigned int val _PX4_DEF(2048));
// Get channel 2 DC offset
PX4API GetDcOffsetCh2PX4 (HPX4 hBrd, int bFromCache _PX4_DEF(1));

// Set channel 3 DC offset
PX4API SetDcOffsetCh3PX4 (HPX4 hBrd, unsigned int val _PX4_DEF(2048));
// Get channel 3 DC offset
PX4API GetDcOffsetCh3PX4 (HPX4 hBrd, int bFromCache _PX4_DEF(1));

// Set channel 4 DC offset
PX4API SetDcOffsetCh4PX4 (HPX4 hBrd, unsigned int val _PX4_DEF(2048));
// Get channel 4 DC offset
PX4API GetDcOffsetCh4PX4 (HPX4 hBrd, int bFromCache _PX4_DEF(1));

// Adjust DC offset for given channel such that average sample value sits a specified value
PX4API CenterSignalPX4 (HPX4 hBrd, int chan_idx,
						px4_sample_t center_to _PX4_DEF(PX4_SAMPLE_MID_VALUE));

// Set SAB board number; uniquely identifies a board on SAB bus
PX4API SetSabBoardNumberPX4 (HPX4 hBrd, unsigned int val);
// Get SAB board number; uniquely identifies a board on SAB bus
PX4API GetSabBoardNumberPX4 (HPX4 hBrd, int bFromCache _PX4_DEF(1));

// Set SAB configuration; defines which bus lines are used
PX4API SetSabConfigurationPX4 (HPX4 hBrd, unsigned int val);
// Get SAB configuration; defines which bus lines are used
PX4API GetSabConfigurationPX4 (HPX4 hBrd, int bFromCache _PX4_DEF(1));

// Set SAB clock; governs rate when writing to SAB bus
PX4API SetSabClockPX4 (HPX4 hBrd, unsigned int val);
// Get SAB clock; governs rate when writing to SAB bus
PX4API GetSabClockPX4 (HPX4 hBrd, int bFromCache _PX4_DEF(1));

// Set FPGA slave enable; used to synchronize internal firmware between multiple PX1500 devices
PX4API SetFpgaSlaveEnablePX4 (HPX4 hBrd, unsigned int bEnable);
// Get FPGA slave enable; used to synchronize internal firmware between multiple PX1500 devices
PX4API GetFpgaSlaveEnablePX4 (HPX4 hBrd, int bFromCache _PX4_DEF(1));

// Set a PX1500 FPGA processing parameter value
PX4API SetBoardProcessingParamPX4 (HPX4 hBrd, unsigned short idx, unsigned short value);

// Set custom board processing enable
PX4API SetBoardProcessingEnablePX4 (HPX4 hBrd, unsigned int bEnable);
// Get custom board processing enable
PX4API GetBoardProcessingEnablePX4 (HPX4 hBrd, int bFromCache _PX4_DEF(1));

// When enabled, all acquisition data is routed to SDRAM2
PX4API SetRouteToSdram2EnablePX4 (HPX4 hBrd, unsigned int bEnable);
PX4API GetRouteToSdram2EnablePX4 (HPX4 hBrd, int bFromCache _PX4_DEF(1));

// -- Hardware configuration info --- //

// Get master/slave configuration; slaves are clock/trig synched with master (PX4MSCFG_*)
PX4API GetMasterSlaveConfigurationPX4 (HPX4 hBrd, int bFromCache _PX4_DEF(1));
// Get device sync configuration; defines how board can be synchronized (PX4SYNCCFG_*)
PX4API GetSyncConfigurationPX4 (HPX4 hBrd, int bFromCache _PX4_DEF(1));
// Get external trigger configuration; defines expected pulse format (PX4EXTTRIGCFG_*)
PX4API GetExtTriggerConfigurationPX4 (HPX4 hBrd, int bFromCache _PX4_DEF(1));
// Obsoloete; use GetInputChannelFlagsPX4
PX4API GetAnalogPathConfigurationPX4 (HPX4 hBrd, int bFromCache _PX4_DEF(1));
// Get channel filter type (PX4CHANFILTER_*)
PX4API GetInputChannelConfigurationPX4 (HPX4 hBrd, int chan_idx _PX4_DEF(0));
// Get input channel configuration flags (PX4CHANIMPF_*)
PX4API GetInputChannelFlagsPX4 (HPX4 hBrd, int chan_idx _PX4_DEF(0));
// Get system FPGA type (PX4SYSFPGA_*)
PX4API GetSysFpgaTypePX4 (HPX4 hBrd);
// Get SAB/user FPGA type (PX4SABFPGA_*)
PX4API GetUsrFpgaTypePX4 (HPX4 hBrd);

// --- Status register flags --- //

// Get status of the samples complete flag; set when a RAM/SAB acq. finishes
PX4API GetSamplesCompleteFlagPX4 (HPX4 hBrd);
// Get status of the FIFO full flag; use with PCIBUF acquisitions
PX4API GetFifoFullFlagPX4 (HPX4 hBrd);
// Get PLL lock status; only valid for internal clock
PX4API GetPllLockStatusPX4 (HPX4 hBrd);

// --- Device register access routines --- //

// Refresh local device register cache from driver's cache; no hardware read
PX4API RefreshLocalRegisterCachePX4 (HPX4 hBrd,
                                     unsigned int bFromHardware _PX4_DEF(0));

// Bring hardware settings up to date with current cache settings
PX4API RewriteHardwareSettingsPX4 (HPX4 hBrd);

// Restores all PX1500 settings to power up default values
PX4API SetPowerupDefaultsPX4 (HPX4 hBrd);

// --- Fixed logic parameters --- //

// The PX1500-4 can be loaded with one of serveral fixed-logic packages. 
//  Each fixed-logic package implements a particular operation in the device
//  firmware.
//
// NOTE: As of this library version, none of the fixed-logic parameters
//  are affected by a SetPowerupDefaultsPX4 operation.
//
// Fixed-logic functionality is only enabled when board processing is 
//  enabled. (SetBoardProcessingEnablePX4)

// -- PX1500 Fixed Logic Package custom enumerations (PX4FLP_*)
/// Programmable decimation (C2)
#define PX4FLP_C2_DECIMATION					0x0002
/// FFT (C4)
#define PX4FLP_C4_FFT							0x0004
/// FIR filtering - single channel (C5)
#define PX4FLP_C5_FIRFILT_SINGLE_CHAN			0x0005
/// FIR filtering - dual channel (C6)
#define PX4FLP_C6_FIRFILT_DUAL_CHAN				0x0006

// Determine if given fixed logic package is available
PX4API IsFixedLogicPackagePresentPX4 (HPX4 hBrd, unsigned short flp);

// -- Fixed logic package C2: Programmable Decimation

// -- C2 Decimation factors
#define PX4C2DECF_NONE							0	// No decimation
#define PX4C2DECF_2X							1
#define PX4C2DECF_4X							2
#define PX4C2DECF_8X							3
#define PX4C2DECF_16X							4
#define PX4C2DECF_32X							5
#define PX4C2DECF_64X							6
#define PX4C2DECF_128X							7
#define PX4C2DECF_256X							8
#define PX4C2DECF_512X							9
#define PX4C2DECF_1024X							10
#define PX4C2DECF_2048X							11
#define PX4C2DECF_4096X							12
#define PX4C2DECF_8192X							13
#define PX4C2DECF__COUNT						14

// Set decimation factor (PX4C2DECF_*)
PX4API FLPC2_SetDecimationFactorPX4 (HPX4 hBrd, unsigned val);

// Set the NCO frequency in MHz; call after acqusition clock rate has been set
PX4API FLPC2_SetNcoFrequencyPX4 (HPX4 hBrd, double nco_freqMHz);

// -- Fixed logic package C4: FFT

// Obtain minimum/maximum supported FFT sizes
PX4API FLPC4_GetFftSizeLimitsPX4 (HPX4 hBrd, unsigned int* min_fft_sizep, unsigned int* max_fft_sizep);
// Set the FFT size (1024 or 2048)
PX4API FLPC4_SetFftSizePX4 (HPX4 hBrd, unsigned fft_size);
// Set the number of data points to zero-pad (appended)
PX4API FLPC4_SetZeroPadPointsPX4 (HPX4 hBrd, unsigned zero_points);
// Set the magnitude-squared enable
PX4API FLPC4_SetMagnitudeSquaredEnablePX4 (HPX4 hBrd, int bEnable);
// Load FFT window data
PX4API FLPC4_LoadWindow (HPX4 hBrd, const short* coefficients, unsigned coefficient_count);

// -- Fixed logic package C5: FIR Filtering (Single channel)

// Load the 129 filter coefficients
PX4API FLPC5_LoadCoefficientsPX4 (HPX4 hBrd, const short* coefficients, int ordering _PX4_DEF(0));

// -- Fixed logic package C6: FIR Filtering (Dual channel)

// Load the 65 channel 1 filter coefficients
PX4API FLPC6_LoadCoefficientsCh1PX4 (HPX4 hBrd, const short* coefficients, int ordering _PX4_DEF(0));
// Load the 65 channel 2 filter coefficients
PX4API FLPC6_LoadCoefficientsCh2PX4 (HPX4 hBrd, const short* coefficients, int ordering _PX4_DEF(0));

// -- XML routines -- //

// Save board settings to a library allocated buffer (ASCII)
PX4API SaveSettingsToStringXmlAPX4 (HPX4 hBrd, unsigned int flags, char** bufpp);
// Save board settings to a library allocated buffer (UNICODE)
PX4API SaveSettingsToStringXmlWPX4 (HPX4 hBrd, unsigned int flags, wchar_t** bufpp);


// Load board settings from an XML string (ASCII)
PX4API LoadSettingsFromStringXmlAPX4 (HPX4 hBrd, unsigned int flags, const char* bufp);
// Load board settings from an XML string (UNICODE)
PX4API LoadSettingsFromStringXmlWPX4 (HPX4 hBrd, unsigned int flags, const wchar_t* bufp);

// Save board settings to an XML file (ASCII)
PX4API SaveSettingsToFileXmlAPX4 (HPX4 hBrd, unsigned int flags,
                                  const char* pathnamep,
                                  const char* encodingp _PX4_DEF("UTF-8"));
// Save board settings to an XML file (UNICODE)
PX4API SaveSettingsToFileXmlWPX4 (HPX4 hBrd, unsigned int flags,
                                  const wchar_t* pathnamep,
                                  const wchar_t* encodingp _PX4_DEF(L"UTF-8"));


// Load board settings from an XML file (ASCII)
PX4API LoadSettingsFromFileXmlAPX4 (HPX4 hBrd, unsigned int flags,
                                    const char* pathnamep);
// Load board settings from an XML file (UNICODE)
PX4API LoadSettingsFromFileXmlWPX4 (HPX4 hBrd, unsigned int flags,
                                    const wchar_t* pathnamep);

// --- Firmware uploading routines --- //

/** @brief 
        Prototype for optional callback function for PX1500 firmware updating

    Special case: We sometimes need to wait for a specified amount of time
    in order for certain operations to complete. This can appear as dead
    time during the firmware update process. Firmware update shells may want
    to provide some kind of notification to the operator for these long 
    waits. (They can be a couple of minutes.)

    When this callback is called with the file_cur parameter of zero, then 
    the callback is a wait notification:
     If file_cur == 0 then:
      If file_total > 0 then we are about to wait for file_total ms.
      If file_total == 0 then we have just finished a wait
     If file cur != 0 then parameters are interpreted as normal (below).

    @param prog_cur
        Current progress value for the current firmware file
    @param prog_total
        Total progress counts for the current firmware file
    @param file_cur
        1-based index of current firmware file being uploaded
    @param file_total
        Total number of firmware files to be uploaded for the current
        firmware upload operation
*/
typedef void (*PX4_FW_UPLOAD_CALLBACK)(HPX4 hBrd, void* callback_ctx,
                                       int prog_cur, int prog_total,
                                       int file_cur, int file_total);

// Upload PX1500 firmware (ASCII)
PX4API UploadFirmwareAPX4 (HPX4 hBrd, const char* fw_pathnamep, 
                           unsigned int flags _PX4_DEF(0),
                           unsigned int* out_flagsp _PX4_DEF(NULL),
                           PX4_FW_UPLOAD_CALLBACK callbackp _PX4_DEF(NULL),
                           void* callback_ctx _PX4_DEF(NULL));
// Upload PX1500 firmware (UNICODE)
PX4API UploadFirmwareWPX4 (HPX4 hBrd, const wchar_t* fw_pathnamep, 
                           unsigned int flags _PX4_DEF(0),
                           unsigned int* out_flagsp _PX4_DEF(NULL),
                           PX4_FW_UPLOAD_CALLBACK callbackp _PX4_DEF(NULL),
                           void* callback_ctx _PX4_DEF(NULL));

// Obtain firmware version information (ASCII)
PX4API QueryFirmwareVersionInfoAPX4 (const char* fw_pathnamep,
                                     PX4S_FW_VER_INFO* infop);
// Obtain firmware version information (UNICODE)
PX4API QueryFirmwareVersionInfoWPX4 (const wchar_t* fw_pathnamep,
                                     PX4S_FW_VER_INFO* infop);

// Obtain PX1500 firmware release notes from firmware file (ASCII)
PX4API ExtractFirmwareNotesAPX4 (const char* fw_pathnamep,
                                 char** notes_pathpp,
                                 int* severityp);
// Obtain PX1500 firmware release notes from firmware file (UNICODE)
PX4API ExtractFirmwareNotesWPX4 (const wchar_t* fw_pathnamep,
                                 wchar_t** notes_pathpp,
                                 int* severityp);

// --- Signatec Recorded Data (*.srdc) file support --- //

/// Invalid SRDC file handle
#define PX4_INVALID_HPX4SRDC                NULL

/// A handle to a SRDC file
typedef struct _px4srdchs_ { int reserved; }* HPX4SRDC;

// Open a new or existing .srdc file
PX4API OpenSrdcFileAPX4 (HPX4 hBrd, HPX4SRDC* handlep,
                         const char* pathnamep,
                         unsigned flags _PX4_DEF(0));
// Open a new or existing .srdc file (UNICODE)
PX4API OpenSrdcFileWPX4 (HPX4 hBrd, HPX4SRDC* handlep,
                         const wchar_t* pathnamep,
                         unsigned flags _PX4_DEF(0));

// Refresh SRDC data with current board settings; not written to file
PX4API RefreshSrdcParametersPX4 (HPX4SRDC hFile,
                                 unsigned flags _PX4_DEF(0));

// Look up SRDC item with given name; name is case-sensitive
PX4API GetSrdcItemAPX4 (HPX4SRDC hFile, const char* namep,
                        char** valuepp);
// Look up SRDC item with given name; name is case-sensitive (UNICODE)
PX4API GetSrdcItemWPX4 (HPX4SRDC hFile, const wchar_t* namep,
                        wchar_t** valuepp);

// Add/modify SRDC item with given name; not written to file
PX4API SetSrdcItemAPX4 (HPX4SRDC hFile, const char* namep,
                        const char* valuep);
// Add/modify SRDC item with given name; not written to file (UNICODE)
PX4API SetSrdcItemWPX4 (HPX4SRDC hFile, const wchar_t* namep,
                        const wchar_t* valuep);

// Write SRDC data to file
PX4API SaveSrdcFileAPX4 (HPX4SRDC hFile, const char* pathnamep);
// Write SRDC data to file (UNICODE)
PX4API SaveSrdcFileWPX4 (HPX4SRDC hFile, const wchar_t* pathnamep);

// Close given SRDC file without updating contents
PX4API CloseSrdcFilePX4 (HPX4SRDC hFile);

// Obtain information on data recorded to given file
PX4API GetRecordedDataInfoAPX4 (const char* pathnamep,
                                PX4S_RECORDED_DATA_INFO* infop,
                                char** operator_notespp _PX4_DEF(NULL));
// Obtain information on data recorded to given file (UNICODE)
PX4API GetRecordedDataInfoWPX4 (const wchar_t* pathnamep,
                                PX4S_RECORDED_DATA_INFO* infop,
                             wchar_t** operator_notespp _PX4_DEF(NULL));

// Fill in PX4S_RECORDED_DATA_INFO structure for given device
PX4API InitRecordedDataInfoPX4 (HPX4 hBrd, PX4S_RECORDED_DATA_INFO* infop);

// Obtain enumeration of all SRDC items with given constraints
PX4API EnumSrdcItemsAPX4 (HPX4SRDC hFile, char** itemspp, 
                          unsigned int flags _PX4_DEF(0));

// Obtain enumeration of all SRDC items with given constraints (UNICODE)
PX4API EnumSrdcItemsWPX4 (HPX4SRDC hFile, wchar_t** itemspp, 
                          unsigned int flags _PX4_DEF(0));

// Returns > 0 if SRDC data is modified
PX4API IsSrdcFileModifiedPX4 (HPX4SRDC hFile);

// --- Miscellaneous functions --- //

// Synchronize the PX1500 firmware to the ADC clock
PX4API SyncFirmwareToAdcClockPX4 (HPX4 hBrd, int ignored _PX4_DEF(0));

// Initiate an ADC calibration operation
PX4API CalibrateAdcPX4 (HPX4 hBrd, int adc_idx);

// Obtains the version of the PX1500 library
PX4API GetLibVersionPX4 (unsigned long long* verp);
// Obtains the version of the PX1500 driver
PX4API GetDriverVersionPX4 (HPX4 hBrd, unsigned long long* verp);
// Obtains the version of the PX1500 firmware
//PX4API GetFirmwareVersionPX4 (HPX4 hBrd, unsigned long long* verp);
// Obtains the version of the PX1500 SAB firmware
PX4API GetSabFirmwareVersionPX4 (HPX4 hBrd, unsigned long long* verp);
// Obtains the version of the PX1500 PCI firmware
PX4API GetPciFirmwareVersionPX4 (HPX4 hBrd, unsigned long long* verp);
// Obtains the revision of the PX1500 hardware
PX4API GetHardwareRevisionPX4 (HPX4 hBrd, unsigned long long* verp);
// Obtains the version of the PX1500 software release
PX4API GetSoftwareReleaseVersionPX4 (unsigned long long* verp);
// Obtains an ASCII string describing the version of an item
PX4API GetVersionTextAPX4 (HPX4 hBrd, unsigned int ver_type, 
                           char** bufpp, unsigned int flags);
// Obtains a UNICODE string describing the version of an item
PX4API GetVersionTextWPX4 (HPX4 hBrd, unsigned int ver_type, 
                           wchar_t** bufpp, unsigned int flags);

PX4API SetUserDataPX4 (HPX4 hBrd, void* data);
PX4API GetUserDataPX4 (HPX4 hBrd, void** datap);

// Obtain PX1500 driver/device statistics
PX4API GetDriverStatsPX4 (HPX4 hBrd, PX4S_DRIVER_STATS* statsp, 
                          int bReset _PX4_DEF(0));

// Read an element from the PX1500 configuration EEPROM
PX4API ReadConfigEepromPX4 (HPX4 hBrd, unsigned int eeprom_addr,
                            unsigned short* eeprom_datap);
// Write an element from the PX1500 configuration EEPROM
PX4API WriteConfigEepromPX4 (HPX4 hBrd, unsigned int eeprom_addr,
                             unsigned short eeprom_data);

// Obtains a user-friendly ASCII string describing the given SIG_* error
PX4API GetErrorTextAPX4 (int res, char** bufpp, unsigned int flags,
                         HPX4 hBrd _PX4_DEF(NULL));
// Obtains a user-friendly UNICODE string describing the given SIG_* error
PX4API GetErrorTextWPX4 (int res, wchar_t** bufpp, unsigned int flags,
                         HPX4 hBrd _PX4_DEF(NULL));

// Ensures that desired firmware matches desired constraint
PX4API CheckFirmwareVerPX4 (HPX4 hBrd, unsigned int fw_ver, 
                            int fw_type _PX4_DEF(PX4FWTYPE_PCI),
                            int constraint _PX4_DEF(PX4VCT_GTOE));

// Free memory allocated by this library
PX4API FreeMemoryPX4 (void* p);

// Run an integrity check on configuration EEPROM data
PX4API ValidateConfigEepromPX4 (HPX4 hBrd);

/// - PX1500 Min/Max/Align item indices (PX4MMA_*)
#define PX4MMA_DMA_XFER_SAMPLES			0
#define PX4MMA_SAMPLE_START				1
#define PX4MMA_SAMPLE_COUNT				2
#define PX4MMA_TRIG_DELAY_SAMPLES		3
#define PX4MMA_PRE_TRIG_SAMPLES			4
#define PX4MMA_SEGMENT_SAMPLES			5
#define PX4MMA_TRIGGER_LEVEL			6
#define PX4MMA_ADC_FREQ_HZ				7
#define PX4MMA_ADC_FREQ_HZ_ADCINT		8
#define PX4MMA__COUNT					9

// Determine minimum/maximum/alignment requirements for counted items
PX4API GetMinMaxAlignPX4 (HPX4 hBrd,
						  int itemIdx, 
						  unsigned int* pMinVal,
						  unsigned int* pMaxVal,
						  unsigned int* pAlnVal);

// --- Console application helper functions --- //

#include <stdio.h>

#if defined(__linux__) && !defined(PX4PP_NO_LINUX_CONSOLE_HELP_FUNCS)

// Equivalent of old DOS getch function
PX4API getch_PX4();
// Equivalent of old DOS kbhit function
PX4API kbhit_PX4();

#endif

// Dump library error description to given file or stream (ASCII)
PX4API DumpLibErrorAPX4 (int res, const char* pPreamble, 
                         HPX4 hBrd _PX4_DEF(PX4_INVALID_HANDLE),
                         FILE* filp _PX4_DEF(NULL)); // NULL == stderr

// Dump library error description to standard file or stream (UNICODE)
PX4API DumpLibErrorWPX4 (int res, const wchar_t* pPreamble, 
                         HPX4 hBrd _PX4_DEF(PX4_INVALID_HANDLE),
                         FILE* filp _PX4_DEF(NULL)); // NULL == stderr

#endif // __px4_library_header_defined


