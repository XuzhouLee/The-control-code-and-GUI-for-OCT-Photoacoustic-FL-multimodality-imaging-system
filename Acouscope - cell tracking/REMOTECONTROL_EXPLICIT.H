/*
 *    EKSPLA REMOTECONTROL.H
 *   explicit linkage version
 *
 *    Explicit linkage REMOTECONTROL.H should be included twice in one of *.cpp (*.c) project files.
 *    First time to declare DLL exported function pointers. And 2nd time, after '#define DEFINERCFPTRS', 
 *    to define pointer variables. Like below
 *
 *    // File 1.cpp
 *    #include REMOTECONTROL.H   // declare DLL functions
 *	  #define DEFINERCFPTRS
 *    #include REMOTECONTROL.H   // allocate static storage for DLL function pointers
 *	  ....
 *
 *    // File's 2.cpp, 3.cpp, ...
 *    #include REMOTECONTROL.H   // declare DLL functions
 *	  ....
 *
 *    DLL and DLL function addresses should be loaded and initialized with rcLoadLibrary() call.

/*
 * REMOTECONTROL.H revision history
 *
 *   - DLL version v1.6.0.0 and above:
 *          Added Register type functions
 *          Added rcSetRegFromDoubleA and rcSetRegFromStringA
 *
 *   - DLL version v2.0.0.0 and above:
 *          Support for more than 1 USB/COM connection,
 *          new functions with '2' at the of function name

 *   - DLL version v2.2.0.0 and above:
 *          TCP/IP connections. Use rcConnect2 to connect
 *
 *	 - DLL version v2.3.0.1 and above:
 *			Added rcGetRegMinVal* and rcGetRegMaxVal functions.
 *			Added rcGetRegFmtString* functions
 */

#if !defined(__REMOTECONTROL_H) || defined(DEFINERCFPTRS)
#define __REMOTECONTROL_H

#include "windows.h"

#ifdef DEFINERCFPTRS
 #define __RCEXTERN
#else
 #define __RCEXTERN extern
#endif


/*
 *   Function return codes
 */

#define RMTCTRLERR_OK                0  // Success, no error
#define RMTCTRLERR_NOMOREDATA        1  // End of registers list or enumerated values list
#define RMTCTRLERR_NOCFGFILE         2  // No config file found
#define RMTCTRLERR_WRONGCFGFILE      3  // wrong CFG file
#define RMTCTRLERR_BUFFERTOOSHORT    4  // application provided return buffer is too short
#define RMTCTRLERR_NOSUCHDEVICE      5  // no such device name
#define RMTCTRLERR_NOSUCHREGISTER    6  // no such register name
#define RMTCTRLERR_CANTCONNECT       7
#define RMTCTRLERR_TIMEOUT           8  // timeout waiting for device answer
#define RMTCTRLERR_READONLY          9  // register is read only
#define RMTCTRLERR_NOT_NV           10  // register is not NV
#define RMTCTRLERR_HILIMIT          11  // attempt to set value above upper limit
#define RMTCTRLERR_LOLIMIT          12  // attempt to set value below bottom limit
#define RMTCTRLERR_NOSUCHVALUE      13  // attempt to set not allowed value
#define RMTCTRLERR_NOTLOGGED        14  // register is not being logged
#define RMTCTRLERR_MEMORYFULL       15  // not enough memory
#define RMTCTRLERR_LOGISEMPTY       16  // no data in the queue yet
#define RMTCTRLERR_ALREADYCONNECTED 17  // already connected, please disconnect first
#define RMTCTRLERR_NOTYETCONNECTED  18  // not connected, please connect first


/*
  Function rcGetRegFromLogAsDouble and rcGetRegFromLogAsString
  may or return value with RMTCTRLERR_LOGOVERFLOW.
  This happens when data retrieval succeeds, but Log FIFO
  overflow is detected.
*/
#define RMTCTRLERR_LOGOVERFLOW  0x80000000 // Log FIFO overrun occured


/*
 *   Functions list

 Connection functions:
   rcConnect
   rcDisconnect

 Devices and registers enumeration functions:
   rcGetFirstDeviceName
   rcGetNextDeviceName
   rcGetFirstRegisterName
   rcGetNextRegisterName

 Register classification functions
   rcIsRegisterWriteable
   rcIsRegisterNV

 Get available register values.
   rcGetRegFirstEnumValue
   rcGetRegNextEnumValue

 Get register min and max. (Available since DLL v 2.3.0.1)
   rcGetRegMinVal
   rcGetRegMaxVal

 Get register format string
   rcGetRegFmtString
   
   Register access functions:
   rcGetRegAsDouble
   rcSetRegFromDouble
   rcSetRegFromDoubleA
   rcSetRegNVFromDouble
   rcGetRegAsString
   rcSetRegFromString
   rcSetRegFromStringA
   rcSetRegNVFromString

 Register log and access functions:
   rcLogRegStart
   rcLogRegStop
   rcGetRegFromLogAsDouble
   rcGetRegFromLogAsString

   Support for >1 USB/COm connections:
   ---------------------------------
   Functionality is nearly identical.
   1) rcConnect2 returns
      connection handle via pointer. You use this handle to call
      specific USB/COM port.
   2) rcConnect2 takes USB chip serial number and/or COM port name like
      COM1, COM2
   3) Since you may have >1 REMOTECONTROL.CSV, it is possible to specify
      now full file and path to different *.CSV files 

 Connection functions:
   rcConnect2
   rcDisconnect2

 Devices and registers enumeration functions:
   rcGetFirstDeviceName2
   rcGetNextDeviceName2
   rcGetFirstRegisterName2
   rcGetNextRegisterName2

 Register classification functions
   rcIsRegisterWriteable2
   rcIsRegisterNV2

 Get available register values.
   rcGetRegFirstEnumValue2
   rcGetRegNextEnumValue2

 Get register min and max. (Available since DLL v 2.3.0.1)
   rcGetRegMinVal2
   rcGetRegMaxVal2

 Get register format string
   rcGetRegFmtString2

 Register access functions:
   rcGetRegAsDouble2
   rcSetRegFromDouble2
   rcSetRegFromDoubleA2
   rcSetRegNVFromDouble2
   rcGetRegAsString2
   rcSetRegFromString2
   rcSetRegFromStringA2
   rcSetRegNVFromString2

 Register log and access functions:
   rcLogRegStart2
   rcLogRegStop2
   rcGetRegFromLogAsDouble2
   rcGetRegFromLogAsString2

 */



/***************************************************************
    Function:     rcConnect

    Description:  Makes a connection attempt

    Arguments:    connectiontype: 0 - direct USB or "gray box"
                                  1 - RS232

                  comportnumber: in case connectiontype is RS232, specifies COM port number
                                  1 - COM1
                                  2 - COM2
                                  ...

    Return value: error code, one of RMTCTRLERR_xxx list
 */
__RCEXTERN int (__stdcall *rcConnect)(int connectiontype, int comportnumber);

/***************************************************************
    Function:     rcConnect2

    Description:  Makes a connection attempt

    Arguments:    connectionhandle:
                                  pointer to connection handle, rcConnect2 will write your handle to

                  connectiontype: 0 - direct USB or "gray box"
                                  1 - RS232
                                  2 - TCP/IP

                  hwdevice:
                              in case connectiontype==0 (USB), serial number of USB chip like FT123456
                              in case connectiontype==1, com port name like "COM1", "COM2", etc
                              in case connectiontype==2, IP address or (DHCP) host name


                  inipath:
                              CSV file name, including or not including full path.
                              In case inipath==NULL, or inipath=="", default REMOTECONTROL.CSV is used.
                              inipath is ignored connecting over TCP/IP. Server uses its own REMOTECONTROL.CSV

    Return value: error code, one of RMTCTRLERR_xxx list
 */
__RCEXTERN int (__stdcall *rcConnect2)(int * connectionhandle, int connectiontype, const char *hwdevice, const char *inipath);




/***************************************************************
    Function:     rcDisconnect

    Description:  Disconnect

    Arguments:    none

    Return value: error code, one of RMTCTRLERR_xxx list
 */
__RCEXTERN int (__stdcall *rcDisconnect)(void);

/***************************************************************
    Function:     rcDisconnect2

    Description:  Disconnect

    Arguments:    handle:    handle

    Return value: error code, one of RMTCTRLERR_xxx list
 */
__RCEXTERN int (__stdcall *rcDisconnect2)(int handle);




/***************************************************************
    Function:     GetFirstDeviceName

    Description:  Get the name of first device in the list. Use
                  GetNextDeviceName() in a loop to retrieve all
                  device names.

    Arguments:    devname:       pointer to C string. GetFirstDeviceName will
                                 write to *devname
                  maxdevnamelen: Maximum length of devname string including
                                 terminatiion character.

    Return value: error code, one of RMTCTRLERR_xxx list
 */
__RCEXTERN int (__stdcall *rcGetFirstDeviceName)(char *devname, int maxdevnamelen);


/***************************************************************
    Function:     GetFirstDeviceName2

    Description:  Get the name of first device in the list. Use
                  GetNextDeviceName() in a loop to retrieve all
                  device names.

    Arguments:    handle:        connection handle

                  devname:       pointer to C string. GetFirstDeviceName will
                                 write to *devname
                  maxdevnamelen: Maximum length of devname string including
                                 terminatiion character.

    Return value: error code, one of RMTCTRLERR_xxx list
 */
__RCEXTERN int (__stdcall *rcGetFirstDeviceName2)(int handle, char *devname, int maxdevnamelen);



/***************************************************************
    Function:     GetNextDeviceName

    Description:  Get the name of next device in the list. Use
                  GetFirstDeviceName() to restart retrieval from
                  the beginning of device names list

    Arguments:    devname:       pointer to C string. GetFirstDeviceName will
                                 write to *devname
                  maxdevnamelen: Maximum length of devname string including
                                 terminatiion character.

    Return value: error code, one of RMTCTRLERR_xxx list
                  On the end of devices list, GetNextDeviceName will
                  return RMTCTRLERR_NOMOREDATA
 */
__RCEXTERN int (__stdcall *rcGetNextDeviceName)(char *devname, int maxdevnamelen);

/***************************************************************
    Function:     GetNextDeviceName2

    Description:  Get the name of next device in the list. Use
                  GetFirstDeviceName() to restart retrieval from
                  the beginning of device names list

    Arguments:    handle:        connection handle

                  devname:       pointer to C string. GetFirstDeviceName will
                                 write to *devname
                  maxdevnamelen: Maximum length of devname string including
                                 terminatiion character.

    Return value: error code, one of RMTCTRLERR_xxx list
                  On the end of devices list, GetNextDeviceName will
                  return RMTCTRLERR_NOMOREDATA
 */
__RCEXTERN int (__stdcall *rcGetNextDeviceName2)(int handle, char *devname, int maxdevnamelen);



/***************************************************************
    Function:     GetFirstRegisterName

    Description:  Get first register name of specific device. Use
                  GetNextRegName() in a loop to retrieve all device
                  register names.

    Arguments:    devname:       pointer to device name string.

                  regname:       pointer to register name string. GetFirstRegisterName will
                                 write to *regname
                  maxregnamelen: Maximum length of string including terminatiion
                                 character.

    Return value: error code, one of RMTCTRLERR_xxx list
 */
__RCEXTERN int (__stdcall *rcGetFirstRegisterName)(const char * devname, char *regname, int maxregnamelen);

/***************************************************************
    Function:     GetFirstRegisterName2

    Description:  Get first register name of specific device. Use
                  GetNextRegName() in a loop to retrieve all device
                  register names.

    Arguments:    handle:        connection handle

                  devname:       pointer to device name string.

                  regname:       pointer to register name string. GetFirstRegisterName will
                                 write to *regname
                  maxregnamelen: Maximum length of string including terminatiion
                                 character.

    Return value: error code, one of RMTCTRLERR_xxx list
 */
__RCEXTERN int (__stdcall *rcGetFirstRegisterName2)(int handle, const char * devname, char *regname, int maxregnamelen);



/***************************************************************
    Function:     GetNextRegisterName

    Description:  Get next register name of specific device. Use GetFirstRegisterName()
                  to reset retrival of register names from the beginning.

    Arguments:    regname:       pointer to C string. GetNextParName will
                                 write to *parname

                  maxregnamelen: Maximum length of string including terminatiion
                                 character.

    Return value: error code, one of RMTCTRLERR_xxx list.
                  On the end of registers list, GetNextRegName will
                  return RMTCTRLERR_NOMOREDATA
 */
__RCEXTERN int (__stdcall *rcGetNextRegisterName)(char *regname, int maxparlen);

/***************************************************************
    Function:     GetNextRegisterName2

    Description:  Get next register name of specific device. Use GetFirstRegisterName()
                  to reset retrival of register names from the beginning.

    Arguments:    handle:        connection handle

                  regname:       pointer to C string. GetNextParName will
                                 write to *parname

                  maxregnamelen: Maximum length of string including terminatiion
                                 character.

    Return value: error code, one of RMTCTRLERR_xxx list.
                  On the end of registers list, GetNextRegName will
                  return RMTCTRLERR_NOMOREDATA
 */
__RCEXTERN int (__stdcall *rcGetNextRegisterName2)(int handle, char *regname, int maxparlen);



/***************************************************************
    Function:     rcIsRegisterWriteable

    Description:  Determine if register is writeable

    Arguments:    devname:     pointer to device name string

                  regname:     pointer to register name string.

                  isWriteable: pointer to integer. On success
                               rcIsRegisterWriteable will write:
                                1 - in case register is writeable
                                0 - in case register is not writeable

    Return value: error code, one of RMTCTRLERR_xxx list.
 */
__RCEXTERN int (__stdcall *rcIsRegisterWriteable)(const char *devname, const char *regname,
                              int *isWriteable);

/***************************************************************
    Function:     rcIsRegisterWriteable2

    Description:  Determine if register is writeable

    Arguments:    handle:      connection handle

                  devname:     pointer to device name string

                  regname:     pointer to register name string.

                  isWriteable: pointer to integer. On success
                               rcIsRegisterWriteable will write:
                                1 - in case register is writeable
                                0 - in case register is not writeable

    Return value: error code, one of RMTCTRLERR_xxx list.
 */
__RCEXTERN int (__stdcall *rcIsRegisterWriteable2)(int handle, const char *devname, const char *regname,
                              int *isWriteable);



/***************************************************************
    Function:     rcIsRegisterNV

    Description:  Determine if register is NV (nonvolatile)

    Arguments:    devname:     pointer to device name string

                  regname:     pointer to register name string.

                  isNV:        pointer to integer. On success
                               rcIsRegisterNV will write:
                                1 - in case register is NV
                                0 - in case register is not NV

    Return value: error code, one of RMTCTRLERR_xxx list.
 */
__RCEXTERN int (__stdcall *rcIsRegisterNV)(const char *devname, const char *regname,
                              int *isNV);

/***************************************************************
    Function:     rcIsRegisterNV2

    Description:  Determine if register is NV (nonvolatile)

    Arguments:    handle:      connection handle

                  devname:     pointer to device name string

                  regname:     pointer to register name string.

                  isNV:        pointer to integer. On success
                               rcIsRegisterNV will write:
                                1 - in case register is NV
                                0 - in case register is not NV

    Return value: error code, one of RMTCTRLERR_xxx list.
 */
__RCEXTERN int (__stdcall *rcIsRegisterNV2)(int handle, const char *devname, const char *regname,
                              int *isNV);



/***************************************************************
    Function:     rcGetRegFirstEnumValue

    Description:  For registers having list of values, like ON, OFF, DISABLE etc,
                  this function returns first available value.
                  Attempt to get enumerated value of numeric register
                  returns RMTCTRLERR_NOMOREDATA.
                  Use rcGetRegNextEnumValue() in a loop to
                  retrieve all available enumerated register values.

    Arguments:    devname:        pointer to device name string.

                  regname:        pointer to register name string.

                  enumname:       pointer to value. rcGetRegFirstEnumValue will
                                  write value string to *enumname

                  maxenumnamelen: Maximum length of enumname string including terminatiion
                                  character.

    Return value: error code, one of RMTCTRLERR_xxx list
 */
__RCEXTERN int (__stdcall *rcGetRegFirstEnumValue)(const char * devname, const char *regname,
                                           char * enumname, int maxenumnamelen);

/***************************************************************
    Function:     rcGetRegFirstEnumValue2

    Description:  For registers having list of values, like ON, OFF, DISABLE etc,
                  this function returns first available value.
                  Attempt to get enumerated value of numeric register
                  returns RMTCTRLERR_NOMOREDATA.
                  Use rcGetRegNextEnumValue() in a loop to
                  retrieve all available enumerated register values.

    Arguments:    handle:         connection handle

                  devname:        pointer to device name string.

                  regname:        pointer to register name string.

                  enumname:       pointer to value. rcGetRegFirstEnumValue will
                                  write value string to *enumname

                  maxenumnamelen: Maximum length of enumname string including terminatiion
                                  character.

    Return value: error code, one of RMTCTRLERR_xxx list
 */
__RCEXTERN int (__stdcall *rcGetRegFirstEnumValue2)(int handle, const char * devname, const char *regname,
                                           char * enumname, int maxenumnamelen);



/***************************************************************
    Function:     rcGetRegNextEnumValue

    Description:  See rcGetRegFirstEnumValue.
                  rcGetRegNextEnumValue() will return next available listed
                  value.

    Arguments:    devname:        pointer to device name string.

                  regname:        pointer to register name string.

                  enumname:       pointer to value. rcGetRegNextEnumValue will
                                  write value string to *enumname

                  maxenumnamelen: Maximum length of enumname string including terminatiion
                                  character.

    Return value: error code, one of RMTCTRLERR_xxx list
 */
__RCEXTERN int (__stdcall *rcGetRegNextEnumValue)(const char * devname, const char *regname,
                                          char * enumname, int maxenumnamelen);

/***************************************************************
    Function:     rcGetRegNextEnumValue2

    Description:  See rcGetRegFirstEnumValue.
                  rcGetRegNextEnumValue() will return next available listed
                  value.

    Arguments:    handle:         connection handle

                  devname:        pointer to device name string.

                  regname:        pointer to register name string.

                  enumname:       pointer to value. rcGetRegNextEnumValue will
                                  write value string to *enumname

                  maxenumnamelen: Maximum length of enumname string including terminatiion
                                  character.

    Return value: error code, one of RMTCTRLERR_xxx list
 */
__RCEXTERN int (__stdcall *rcGetRegNextEnumValue2)(int handle, const char * devname, const char *regname,
                                          char * enumname, int maxenumnamelen);


/***************************************************************
    Function:     GetRegAsDouble

    Description:  Return register value as double.

    Arguments:    devname:   pointer to device name string

                  regname:   pointer to register name string.

                  value:     pointer to double, rcGetRegAsDouble will overwrite
                             on success

                  timeout:   timeout in milliseconds. (-1) - infinite timeout

                  timestamp: pointer to int. In case timestamp is not a NULL,
                             rcGetRegAsDouble will write to *timestamp the time
                             stamp of received message

    Return value: error code, one of RMTCTRLERR_xxx list.
 */
__RCEXTERN int (__stdcall *rcGetRegAsDouble)(const char *devname, const char *regname,
                              double *value,       int timeout,
                              int *timestamp);

/***************************************************************
    Function:     GetRegAsDouble2

    Description:  Return register value as double.

    Arguments:    handle:    connection handle

                  devname:   pointer to device name string

                  regname:   pointer to register name string.

                  value:     pointer to double, rcGetRegAsDouble will overwrite
                             on success

                  timeout:   timeout in milliseconds. (-1) - infinite timeout

                  timestamp: pointer to int. In case timestamp is not a NULL,
                             rcGetRegAsDouble will write to *timestamp the time
                             stamp of received message

    Return value: error code, one of RMTCTRLERR_xxx list.
 */
__RCEXTERN int (__stdcall *rcGetRegAsDouble2)(int handle, const char *devname, const char *regname,
                              double *value,       int timeout,
                              int *timestamp);


/***************************************************************
    Function:     SetRegFromDouble

    Description:  Set register value from double variable.

    Arguments:    devname:   pointer to device name string

                  regname:   pointer to register name string.

                  value:     value

    Return value: error code, one of RMTCTRLERR_xxx list.
 */
__RCEXTERN int (__stdcall *rcSetRegFromDouble)(const char *devname, const char *regname, double value);

/***************************************************************
    Function:     SetRegFromDouble2

    Description:  Set register value from double variable.

    Arguments:    handle:    connection handle

                  devname:   pointer to device name string

                  regname:   pointer to register name string.

                  value:     value

    Return value: error code, one of RMTCTRLERR_xxx list.
 */
__RCEXTERN int (__stdcall *rcSetRegFromDouble2)(int handle, const char *devname, const char *regname, double value);


/***************************************************************
    Function:     SetRegFromDoubleA

    Description:  Set register value from double variable.

    Arguments:    devname:     pointer to device name string

                  regname:     pointer to register name string.

                  value:       value

                  forcelimits: forcelimits==0 - complain when value is out of limits
                               forcelimits!=0 - force value limits

    Return value: error code, one of RMTCTRLERR_xxx list.
 */
__RCEXTERN int (__stdcall *rcSetRegFromDoubleA)(const char *devname, const char *regname, double value,
                                  int forcelimits);

/***************************************************************
    Function:     SetRegFromDoubleA2

    Description:  Set register value from double variable.

    Arguments:    handle;      connection handle

                  devname:     pointer to device name string

                  regname:     pointer to register name string.

                  value:       value

                  forcelimits: forcelimits==0 - complain when value is out of limits
                               forcelimits!=0 - force value limits

    Return value: error code, one of RMTCTRLERR_xxx list.
 */
__RCEXTERN int (__stdcall *rcSetRegFromDoubleA2)(int handle, const char *devname, const char *regname, double value,
                                  int forcelimits);



/***************************************************************
    Function:     SetRegNVFromDouble

    Description:  Set register NV value from double variable.

    Arguments:    devname:   pointer to device name string

                  regname:   pointer to register name string.

                  value:     value

    Return value: error code, one of RMTCTRLERR_xxx list.
 */
__RCEXTERN int (__stdcall *rcSetRegNVFromDouble)(const char *devname, const char *regname, double value);

/***************************************************************
    Function:     SetRegNVFromDouble2

    Description:  Set register NV value from double variable.

    Arguments:    handle:    connection handle

                  devname:   pointer to device name string

                  regname:   pointer to register name string.

                  value:     value

    Return value: error code, one of RMTCTRLERR_xxx list.
 */
__RCEXTERN int (__stdcall *rcSetRegNVFromDouble2)(int handle, const char *devname, const char *regname, double value);


/***************************************************************
    Function:     GetRegAsString

    Description:  Return register value as string.

    Arguments:    devname:   pointer to device name string

                  regname:   pointer to register name string.

                  value:     pointer to string, GetRegAsString will overwrite

                  maxvallen: maximum length of value string, including terminating character

                  timeout:   timeout in milliseconds. (-1) - infinite timeout

                  timestamp: pointer to int. In case timestamp is not a NULL,
                             rcGetRegAsDouble will write to *timestamp the time
                             stamp of received message

    Return value: error code, one of RMTCTRLERR_xxx list.
 */
__RCEXTERN int (__stdcall *rcGetRegAsString)(const char *devname, const char *regname,
                              char *value, int maxvallen, int timeout,
                              int *timestamp);

/***************************************************************
    Function:     GetRegAsString2

    Description:  Return register value as string.

    Arguments:    handle:    connection handle

                  devname:   pointer to device name string

                  regname:   pointer to register name string.

                  value:     pointer to string, GetRegAsString will overwrite

                  maxvallen: maximum length of value string, including terminating character

                  timeout:   timeout in milliseconds. (-1) - infinite timeout

                  timestamp: pointer to int. In case timestamp is not a NULL,
                             rcGetRegAsDouble will write to *timestamp the time
                             stamp of received message

    Return value: error code, one of RMTCTRLERR_xxx list.
 */
__RCEXTERN int (__stdcall *rcGetRegAsString2)(int handle, const char *devname, const char *regname,
                              char *value, int maxvallen, int timeout,
                              int *timestamp);


/***************************************************************
    Function:     SetRegFromString

    Description:  Set register value from string.

    Arguments:    devname:   pointer to device name string

                  regname:   pointer to register name string.

                  value:     pointer to string

    Return value: error code, one of RMTCTRLERR_xxx list.
 */
__RCEXTERN int (__stdcall *rcSetRegFromString)(const char *devname, const char *regname, const char *value);

/***************************************************************
    Function:     SetRegFromString2

    Description:  Set register value from string.

    Arguments:    handle:    connection handle

                  devname:   pointer to device name string

                  regname:   pointer to register name string.

                  value:     pointer to string

    Return value: error code, one of RMTCTRLERR_xxx list.
 */
__RCEXTERN int (__stdcall *rcSetRegFromString2)(int handle, const char *devname, const char *regname, const char *value);


/***************************************************************
    Function:     SetRegFromStringA

    Description:  Set register value from string.

    Arguments:    devname:     pointer to device name string

                  regname:     pointer to register name string.

                  value:       pointer to string

                  forcelimits: forcelimits==0 - complain when value is out of limits
                               forcelimits!=0 - force value limits

    Return value: error code, one of RMTCTRLERR_xxx list.
 */
__RCEXTERN int (__stdcall *rcSetRegFromStringA)(const char *devname, const char *regname, const char *value,
                                  int forcelimits);

/***************************************************************
    Function:     SetRegFromStringA2

    Description:  Set register value from string.

    Arguments:    handle:      connection handle

                  devname:     pointer to device name string

                  regname:     pointer to register name string.

                  value:       pointer to string

                  forcelimits: forcelimits==0 - complain when value is out of limits
                               forcelimits!=0 - force value limits

    Return value: error code, one of RMTCTRLERR_xxx list.
 */
__RCEXTERN int (__stdcall *rcSetRegFromStringA2)(int handle, const char *devname, const char *regname, const char *value,
                                  int forcelimits);

/***************************************************************
    Function:     SetRegNVFromString

    Description:  Set register value from string.

    Arguments:    devname:   pointer to device name string

                  regname:   pointer to register name string.

                  value:     pointer to string

    Return value: error code, one of RMTCTRLERR_xxx list.
 */
__RCEXTERN int (__stdcall *rcSetRegNVFromString)(const char *devname, const char *regname, const char *value);

/***************************************************************
    Function:     SetRegNVFromString2

    Description:  Set register value from string.

    Arguments:    handle:    connection handle

                  devname:   pointer to device name string

                  regname:   pointer to register name string.

                  value:     pointer to string

    Return value: error code, one of RMTCTRLERR_xxx list.
 */
__RCEXTERN int (__stdcall *rcSetRegNVFromString2)(int handle, const char *devname, const char *regname, const char *value);


/***************************************************************
    Function:     rcLogRegStart

    Description:  Start logging register

    Arguments:    devname:   pointer to device name string

                  regname:   pointer to register name string.

                  queuesize: Size of memory to allocate
                             for data queue.

    Return value: error code, one of RMTCTRLERR_xxx list.
 */
__RCEXTERN int (__stdcall *rcLogRegStart)(const char *devname, const char *regname,
                          int queuesize);

/***************************************************************
    Function:     rcLogRegStart2

    Description:  Start logging register

    Arguments:    handle:    connection handle

                  devname:   pointer to device name string

                  regname:   pointer to register name string.

                  queuesize: Size of memory to allocate
                             for data queue.

    Return value: error code, one of RMTCTRLERR_xxx list.
 */
__RCEXTERN int (__stdcall *rcLogRegStart2)(int handle, const char *devname, const char *regname,
                          int queuesize);


/***************************************************************
    Function:     rcLogRegStop

    Description:  Stop logging register

    Arguments:    devname:   pointer to device name string

                  regname:   pointer to register name string.

    Return value: error code, one of RMTCTRLERR_xxx list.
 */
__RCEXTERN int (__stdcall *rcLogRegStop)(const char *devname, const char *regname);

/***************************************************************
    Function:     rcLogRegStop2

    Description:  Stop logging register

    Arguments:    handle:    connection handle

                  devname:   pointer to device name string

                  regname:   pointer to register name string.

    Return value: error code, one of RMTCTRLERR_xxx list.
 */
__RCEXTERN int (__stdcall *rcLogRegStop2)(int handle, const char *devname, const char *regname);


/***************************************************************
    Function:     rcGetRegFromLogAsDouble

    Description:  Get register value from log queue as double value.

    Arguments:    devname:   pointer to device name string

                  regname:   pointer to register name string.

                  value:     pointer to double, rcGetRegAsDouble will overwrite

                  timestamp: pointer to int. In case timestamp is not a NULL,
                             rcGetRegAsDouble will write to *timestamp the time
                             stamp of received message

    Return value: error code, one of RMTCTRLERR_xxx list.
 */
__RCEXTERN int (__stdcall *rcGetRegFromLogAsDouble)(const char *devname, const char *regname,
                              double *value,  int *timestamp);

/***************************************************************
    Function:     rcGetRegFromLogAsDouble2

    Description:  Get register value from log queue as double value.

    Arguments:    handle:    connection handle

                  devname:   pointer to device name string

                  regname:   pointer to register name string.

                  value:     pointer to double, rcGetRegAsDouble will overwrite

                  timestamp: pointer to int. In case timestamp is not a NULL,
                             rcGetRegAsDouble will write to *timestamp the time
                             stamp of received message

    Return value: error code, one of RMTCTRLERR_xxx list.
 */
__RCEXTERN int (__stdcall *rcGetRegFromLogAsDouble2)(int handle, const char *devname, const char *regname,
                              double *value,  int *timestamp);


/***************************************************************
    Function:     rcGetRegFromLogAsString

    Description:  Get register value from log queue as string.

    Arguments:    devname:   pointer to device name string

                  regname:   pointer to register name string.

                  value:     pointer to string, GetRegAsString will overwrite

                  maxvallen: maximum length of value string, including terminating character

                  timestamp: pointer to int. In case timestamp is not a NULL,
                             rcGetRegAsDouble will write to *timestamp the time
                             stamp of received message

    Return value: error code, one of RMTCTRLERR_xxx list.
 */
__RCEXTERN int (__stdcall *rcGetRegFromLogAsString)(const char *devname, const char *regname,
                              char *value, int maxvallen, int *timestamp);

/***************************************************************
    Function:     rcGetRegFromLogAsString2

    Description:  Get register value from log queue as string.

    Arguments:    handle:    connection handle

                  devname:   pointer to device name string

                  regname:   pointer to register name string.

                  value:     pointer to string, GetRegAsString will overwrite

                  maxvallen: maximum length of value string, including terminating character

                  timestamp: pointer to int. In case timestamp is not a NULL,
                             rcGetRegAsDouble will write to *timestamp the time
                             stamp of received message

    Return value: error code, one of RMTCTRLERR_xxx list.
 */
__RCEXTERN int (__stdcall *rcGetRegFromLogAsString2)(int handle, const char *devname, const char *regname,
                              char *value, int maxvallen, int *timestamp);

/***************************************************************
    Function:     rcGetRegMinVal

    Description:  Return register minimum value as double.

    Arguments:    devname:   pointer to device name string

                  regname:   pointer to register name string.

				  min:       pointer to double, rcGetRegMinVal will overwrite
							 on success

	Return value: error code, one of RMTCTRLERR_xxx list.
*/
__RCEXTERN int (__stdcall *rcGetRegMinVal)(const char *devname, const char *regname,
	double *min);

/***************************************************************
	Function:     rcGetRegMinVal2

	Description:  Return register minimum value as double.

	Arguments:    handle:   connection handle

				  devname:  pointer to device name string

				  regname:  pointer to register name string.

				  min:      pointer to double, rcGetRegAsDouble will overwrite
						    on success

	Return value: error code, one of RMTCTRLERR_xxx list.
*/
__RCEXTERN int (__stdcall *rcGetRegMinVal2)(int handle, const char *devname, const char *regname,
	double *min);

/***************************************************************
	Function:     rcGetRegMaxVal

	Description:  Return register maximum value as double.

	Arguments:    devname:   pointer to device name string

				  regname:   pointer to register name string.

				  max:       pointer to double, rcGetRegMinVal will overwrite
							 on success

	Return value: error code, one of RMTCTRLERR_xxx list.
*/
__RCEXTERN int (__stdcall *rcGetRegMinVal)(const char *devname, const char *regname,
	double *max);

/***************************************************************
	Function:     rcGetRegMaxVal2

	Description:  Return register maximum value as double.

	Arguments:    handle:   connection handle

				  devname:  pointer to device name string

				  regname:  pointer to register name string.

				  value:    pointer to double, rcGetRegAsDouble will overwrite
							on success

	Return value: error code, one of RMTCTRLERR_xxx list.
*/
__RCEXTERN int (__stdcall *rcGetRegMaxVal2)(int handle, const char *devname, const char *regname,
	double *ax);


/***************************************************************
*	Function:     rcGetRegFmtString2
*
*	Description:  Get register format string
*
*	Arguments:    handle:    connection handle
*
*				  devname:   pointer to device name string
*
*				  regname:   pointer to register name string.
*
*				  *value:     pointer to string, GetRegAsString will overwrite
*
*				  maxvallen: maximum length of value string, including terminating character
*
*  Return value: error code, one of RMTCTRLERR_xxx list.
*/
__RCEXTERN int (__stdcall *rcGetRegFmtString2)(int handle, const char *devname,
	const char *regname, char *value, int maxvallen);

/***************************************************************
*	Function:     rcGetRegFmtString
*
*	Description:  Get register value from log queue as string.
*
*	Arguments:    devname:   pointer to device name string
*
*				  regname:   pointer to register name string.
*
*				  *value:     pointer to string, GetRegAsString will overwrite
*
*				  maxvallen: maximum length of value string, including terminating character
*
*  Return value: error code, one of RMTCTRLERR_xxx list.
*/
__RCEXTERN int (__stdcall *rcGetRegFmtString)(const char *devname,
	const char *regname, char *value, int maxvallen);

#undef __RCEXTERN


#ifndef DEFINERCFPTRS
void rcLoadLibrary(void); // Declare DLL load function
#else
void rcLoadLibrary(void)
{
HMODULE module;
	
static const struct{
	FARPROC *fptr;
	char *fname;
}rcFunctions[] = {
	    {(FARPROC*)&rcConnect,				"rcConnect"},            
	    {(FARPROC*)&rcConnect2,				"rcConnect2"},
        {(FARPROC*)&rcDisconnect,           "rcDisconnect"},         
        {(FARPROC*)&rcDisconnect2,          "rcDisconnect2"},
        {(FARPROC*)&rcGetFirstDeviceName,   "rcGetFirstDeviceName"}, 
        {(FARPROC*)&rcGetFirstDeviceName2,  "rcGetFirstDeviceName2"}, 
        {(FARPROC*)&rcGetNextDeviceName,    "rcGetNextDeviceName"},  
        {(FARPROC*)&rcGetNextDeviceName2,   "rcGetNextDeviceName2"},
        {(FARPROC*)&rcGetFirstRegisterName, "rcGetFirstRegisterName"}, 
        {(FARPROC*)&rcGetFirstRegisterName2,"rcGetFirstRegisterName2"}, 
        {(FARPROC*)&rcGetNextRegisterName,  "rcGetNextRegisterName"},  
        {(FARPROC*)&rcGetNextRegisterName2, "rcGetNextRegisterName2"},
        {(FARPROC*)&rcIsRegisterWriteable,  "rcIsRegisterWriteable"},  
        {(FARPROC*)&rcIsRegisterWriteable2, "rcIsRegisterWriteable2"},
        {(FARPROC*)&rcIsRegisterNV,         "rcIsRegisterNV"},
        {(FARPROC*)&rcIsRegisterNV2,        "rcIsRegisterNV2"},
        {(FARPROC*)&rcGetRegFirstEnumValue, "rcGetRegFirstEnumValue"},
        {(FARPROC*)&rcGetRegFirstEnumValue2,"rcGetRegFirstEnumValue2"},
        {(FARPROC*)&rcGetRegNextEnumValue,  "rcGetRegNextEnumValue"},  
        {(FARPROC*)&rcGetRegNextEnumValue2, "rcGetRegNextEnumValue2"},
        {(FARPROC*)&rcGetRegAsDouble,       "rcGetRegAsDouble"},
        {(FARPROC*)&rcGetRegAsDouble2,      "rcGetRegAsDouble2"},
        {(FARPROC*)&rcSetRegFromDouble,     "rcSetRegFromDouble"},
        {(FARPROC*)&rcSetRegFromDouble2,    "rcSetRegFromDouble2"},
        {(FARPROC*)&rcSetRegFromDoubleA,    "rcSetRegFromDoubleA"},
        {(FARPROC*)&rcSetRegFromDoubleA2,   "rcSetRegFromDoubleA2"},
        {(FARPROC*)&rcSetRegNVFromDouble,   "rcSetRegNVFromDouble"},
        {(FARPROC*)&rcSetRegNVFromDouble2,  "rcSetRegNVFromDouble2"},
        {(FARPROC*)&rcGetRegAsString,       "rcGetRegAsString"},       
        {(FARPROC*)&rcGetRegAsString2,      "rcGetRegAsString2"},
        {(FARPROC*)&rcSetRegFromString,     "rcSetRegFromString"},     
        {(FARPROC*)&rcSetRegFromString2,    "rcSetRegFromString2"},
        {(FARPROC*)&rcSetRegFromStringA,    "rcSetRegFromStringA"},    
        {(FARPROC*)&rcSetRegFromStringA2,   "rcSetRegFromStringA2"},
        {(FARPROC*)&rcSetRegNVFromString,   "rcSetRegNVFromString"},   
        {(FARPROC*)&rcSetRegNVFromString2,  "rcSetRegNVFromString2"},
        {(FARPROC*)&rcLogRegStart,          "rcLogRegStart"},          
        {(FARPROC*)&rcLogRegStart2,         "rcLogRegStart2"},
        {(FARPROC*)&rcLogRegStop,           "rcLogRegStop"},           
        {(FARPROC*)&rcLogRegStop2,          "rcLogRegStop2"},
        {(FARPROC*)&rcGetRegFromLogAsDouble,"rcGetRegFromLogAsDouble"}, 
        {(FARPROC*)&rcGetRegFromLogAsDouble2,"rcGetRegFromLogAsDouble2"}, 
        {(FARPROC*)&rcGetRegFromLogAsString,"rcGetRegFromLogAsString"},
        {(FARPROC*)&rcGetRegFromLogAsString2,"rcGetRegFromLogAsString2"},

		{(FARPROC*)&rcGetRegMinVal,			 "rcGetRegMinVal"},
		{(FARPROC*)&rcGetRegMinVal2,	     "rcGetRegMinVal2"},
		{(FARPROC*)&rcGetRegMaxVal,			 "rcGetRegMaxVal"},
		{(FARPROC*)&rcGetRegMaxVal2,	     "rcGetRegMaxVal2"},
		{(FARPROC*)&rcGetRegFmtString,	     "rcGetRegFmtString"},
		{(FARPROC*)&rcGetRegFmtString2,	     "rcGetRegFmtString2"},
};

   module = LoadLibraryA("REMOTECONTROL.DLL");

   for(int i = 0; i < sizeof(rcFunctions)/sizeof(rcFunctions[0]); i++)
   {
	   *rcFunctions[i].fptr  = GetProcAddress(module, rcFunctions[i].fname);
   }
}
#endif


#endif //__REMOTECONTROL_H
