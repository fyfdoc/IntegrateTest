# encoding utf-8
'''
日志文件测试用例
'''
from pysnmp.smi.rfc1902 import ObjectIdentity

*** Settings ***
Library    SnmpLibrary
Library    BuiltIn
Library    Collections
Library    ../utils/CiUtils.py
Resource    ../resources/SnmpMibHelper.robot
Resource    ../resources/LogHelper.robot
Suite Setup    Open Snmp Connection And Load Private MIB    ${DeviceIp}    ${Community}    ${MibName}




*** Variables ***
${DeviceIp}    172.27.245.92
${Community}    public
#${Community}    dtm.1234
${MibName}    DTM-TD-LTE-ENODEB-ENBMIB
${aom}    aom
${som}    som

${UPLOADPATH}    C:\\enb_log
@{COMMONLOG_LIST}    
...    operationLog
...    omKeyLog
...    debugLog
...    statelessAlarmLog
...    dataConsistency
...    curConfig
...    lmtMDBFile
...    activeAlarmFile
...    alarmLog

@{NRCELLID_LIST}    
@{BANDWIDTH_LIST}     
@{SLOT_LIST}
&{CELLLOG_DICT}    

*** Keywords ***

Loop_function
    [Arguments]    ${cellid}    ${objName}    ${num_one}    ${num_two}
	:FOR    ${loop_num}    IN RANGE    ${num_two}
    \    ${returnval}    ${error}    Get With Error By Name    ${objName}    idx=@{0,0,${num_one},${loop_num}}
    \    Continue For Loop If    ${error} != 0
    \    Continue For Loop If    ${returnval} != ${cellid}
    \    Set To Dictionary    ${CELLLOG_DICT}    ${cellid}    0.0.${num_one}
 

UploadCellLog_function
    [Arguments]    ${cellid}
    :FOR    ${loop_num}    IN RANGE    1    12
    \    Loop_function    ${cellid}    baseBandwidthLcId    ${loop_num}    24

UploadCommonLog_function
    :FOR    ${loop_num}    IN    @{COMMONLOG_LIST}
    \    ${rs}    Log File Upload    ${loop_num}    ${UPLOADPATH}
    \    Should be equal    ${rs}    ${True}


*** test case ***
#~ #----------------------------------------------------------------------
初始化
    Open And Close Capture Package Switch

    :FOR    ${loop_num}    IN RANGE    36
    \    ${nrLocalCellRowStatus}    ${error}    Get With Error By Name    nrCellCfgRowStatus    ${loop_num}
    \    Continue For Loop If    ${error} != 0
    \    Append to List    ${NRCELLID_LIST}    ${loop_num}
    Log    ${NRCELLID_LIST}
 
#~ #---------------------------------------------------------------------- 
获取小区列表和板卡对应关系  
    :FOR    ${list_num}    IN    @{NRCELLID_LIST}
    \    UploadCellLog_function    ${list_num}

    Log    ${CELLLOG_DICT}

#~ #----------------------------------------------------------------------
RRU场景
    :FOR    ${list_num}    IN    &{CELLLOG_DICT}
    \    UploadCommonLog_function    

	\    ${rs}    NRLog File Upload    0.0.1.0    1    ${UPLOADPATH}
    \    Should be equal    ${rs}    ${True}            

	\    ${rs}    RRU Log File Upload    rrualarm    ${UPLOADPATH}
	\    Should be equal    ${rs}    ${True}
    \    Sleep    30
    \    ${rs}    RRU Log File Upload    rruuser    ${UPLOADPATH}
	\    Should be equal    ${rs}    ${True}
    \    Sleep    30
    \    ${rs}    RRU Log File Upload    rrusys    ${UPLOADPATH}
	\    Should be equal    ${rs}    ${True}
    \    Sleep    30

    Sleep    10
#~ #----------------------------------------------------------------------
传输问题场景
    :FOR    ${list_num}    IN    &{CELLLOG_DICT}
    \    UploadCommonLog_function    

    \    ${rs}    NRLog File Upload    0.0.1.0    1;71    ${UPLOADPATH}
    \    Should be equal    ${rs}    ${True}	

    \    ${value}    Get Dictionary Values    ${list_num}
    \    ${value}    Catenate   SEPARATOR=    @{value}[0]    .0
    \    Log    ${value}

	\    ${rs}    NRLog File Upload    ${value}    1    ${UPLOADPATH}
    \    Should be equal    ${rs}    ${True}

    Sleep    10
#~ #----------------------------------------------------------------------
调度问题
    :FOR    ${list_num}    IN    &{CELLLOG_DICT}
    \    UploadCommonLog_function    

    \    ${value}    Get Dictionary Values    ${list_num}
    \    ${value}    Catenate   SEPARATOR=    @{value}[0]    .0
    \    Log    ${value}

    \    ${rs}    NRLog File Upload    ${value}    1    ${UPLOADPATH}
    \    Should be equal    ${rs}    ${True}

    Sleep    10
#~ #----------------------------------------------------------------------
任务故障
    :FOR    ${list_num}    IN    &{CELLLOG_DICT}
    \    UploadCommonLog_function    

    #4G场景下有53和69号日志
    \    ${rs}    NRLog File Upload    0.0.1.0    1;71    ${UPLOADPATH}
    \    Should be equal    ${rs}    ${True}	

    \    ${value}    Get Dictionary Values    ${list_num}
    \    ${value}    Catenate   SEPARATOR=    @{value}[0]    .0
    \    Log    ${value}

	\    ${rs}    NRLog File Upload    ${value}    1    ${UPLOADPATH}
    \    Should be equal    ${rs}    ${True}

    Sleep    20
#~ #----------------------------------------------------------------------
随机接入问题
    :FOR    ${list_num}    IN    &{CELLLOG_DICT}
    \    UploadCommonLog_function    

    \    ${value}    Get Dictionary Values    ${list_num}
    \    ${value}    Catenate   SEPARATOR=    @{value}[0]    .0
    \    Log    ${value}

    \    ${rs}    NRLog File Upload    ${value}    1    ${UPLOADPATH}
    \    Should be equal    ${rs}    ${True}
    Sleep    10
#~ #----------------------------------------------------------------------
速率低
    :FOR    ${list_num}    IN    &{CELLLOG_DICT}
    \    UploadCommonLog_function    

    \    ${value}    Get Dictionary Values    ${list_num}
    \    ${value}    Catenate   SEPARATOR=    @{value}[0]    .0
    \    Log    ${value}

    \    ${rs}    NRLog File Upload    ${value}    1    ${UPLOADPATH}
    \    Should be equal    ${rs}    ${True}

	\    ${rs}    RRU Log File Upload    rrualarm    ${UPLOADPATH}
	\    Should be equal    ${rs}    ${True}
    \    Sleep    30
    \    ${rs}    RRU Log File Upload    rruuser    ${UPLOADPATH}
	\    Should be equal    ${rs}    ${True}
    \    Sleep    30
    \    ${rs}    RRU Log File Upload    rrusys    ${UPLOADPATH}
	\    Should be equal    ${rs}    ${True}
    \    Sleep    30
    
    Sleep    10
#~ #----------------------------------------------------------------------
切换类问题
    :FOR    ${list_num}    IN    &{CELLLOG_DICT}
    \    UploadCommonLog_function    

    \    ${rs}    NRLog File Upload    0.0.1.0    71    ${UPLOADPATH}
    \    Should be equal    ${rs}    ${True}


	




