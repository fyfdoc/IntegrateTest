# encoding utf-8
'''
*************************************************************
*** COPYRIGHT DaTang Mobile Communications Equipment CO.,LTD
*************************************************************
*文件名称：file2_nrCellLogTest.robot
*功能描述：测试nr小区日志上传用例
*使用方法：

-----------------------------------------------------------------------------------
*修改记录：                                                                       |
*##修改日期    |    修改人    |    修改描述    |                                  |
*2018-10-20        morunzhang       创建文件                                      |
----------------------------------------------------------------------------------|
*************************************************************
______________________________________________________________________________________
*用例记录：（记录用例测试出的问题，引用关键字遇到的异常问题等等）                    |
**                                                                                   |
**                                                                                   |
_____________________________________________________________________________________|

************************************************用例文件头结束**************************************************
'''
from pysnmp.smi.rfc1902 import ObjectIdentity

*** Settings ***
Library    Collections
Resource    ../../COMM/commResources/SnmpMibHelper.robot
Resource    ../fileResources/CommonLogResource.robot
Resource    ../fileResources/BoardLogResource.robot
Resource    ../fileResources/RruLogResource.robot
Suite Setup           Open Snmp Connection And Load Private MIB

*** Variables ***
${MibName}       DTM-TD-LTE-ENODEB-ENBMIB
${aom}           aom
${UPLOADPATH}    C:\\enb_log\\nrcelllogdir
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

${AOM_INDEX}
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
    Sleep    60




*** test case ***
#~ #----------------------------------------------------------------------
Init SaveDir Test
    [Documentation]    初始化保存目录
    [Tags]
    Create folder    ${UPLOADPATH}

#~ #----------------------------------------------------------------------
Init Aom Index Test
    [Documentation]    初始化主控索引
    [Tags]
    ${boardEntry}    Get Oid By Name    ${MibName}    boardRowStatus
    Log    ${boardEntry}
    @{aom_slotNo_list}    Get board of aom or som    ${aom}    ${boardEntry}    ${16}

    ${AOM_INDEX}    Catenate   SEPARATOR=    0.0.    @{aom_slotNo_list}[0]
    ${AOM_INDEX}    Catenate   SEPARATOR=    ${AOM_INDEX}    .0
    Set Global Variable    ${AOM_INDEX}
    Log    ${AOM_INDEX}
    
#~ #----------------------------------------------------------------------
Init CellId Test
    [Documentation]    初始化小区ID
    [Tags]
    :FOR    ${loop_num}    IN RANGE    36
    \    ${nrLocalCellRowStatus}    ${error}    Get With Error By Name    nrCellCfgRowStatus    ${loop_num}
    \    Continue For Loop If    ${error} != 0
    \    Append to List    ${NRCELLID_LIST}    ${loop_num}
    Log    ${NRCELLID_LIST}
 
    :FOR    ${list_num}    IN    @{NRCELLID_LIST}
    \    UploadCellLog_function    ${list_num}
    Log    ${CELLLOG_DICT}

#~ #----------------------------------------------------------------------
RRU Test
    [Documentation]    RRU场景
    [Tags]
    :FOR    ${list_num}    IN    &{CELLLOG_DICT}
    \    UploadCommonLog_function    

	\    ${rs}    Board SetLog File Upload    ${AOM_INDEX}    1    ${UPLOADPATH}
    \    Should be equal    ${rs}    ${True}            
    \    Sleep    60
	\    ${rs}    RRU Log File Upload    rrualarm    ${UPLOADPATH}
	\    Should be equal    ${rs}    ${True}
    \    Sleep    120
    \    ${rs}    RRU Log File Upload    rruuser    ${UPLOADPATH}
	\    Should be equal    ${rs}    ${True}
    \    Sleep    180
    \    ${rs}    RRU Log File Upload    rrusys    ${UPLOADPATH}
	\    Should be equal    ${rs}    ${True}
    \    Sleep    120

    Sleep    30

#~ #----------------------------------------------------------------------
Trans Test
    [Documentation]    传输问题场景
    [Tags]
    :FOR    ${list_num}    IN    &{CELLLOG_DICT}
    \    UploadCommonLog_function    
    \    Sleep    60
    \    ${rs}    Board SetLog File Upload    ${AOM_INDEX}    1;71    ${UPLOADPATH}
    \    Should be equal    ${rs}    ${True}	
    \    Sleep    60
    \    ${value}    Get Dictionary Values    ${list_num}
    \    ${value}    Catenate   SEPARATOR=    @{value}[0]    .0
    \    Log    ${value}
    
	\    ${rs}    Board SetLog File Upload    ${value}    1    ${UPLOADPATH}
    \    Should be equal    ${rs}    ${True}

    Sleep    30

#~ #----------------------------------------------------------------------
Dispatch Test
    [Documentation]    调度问题
    [Tags]
    :FOR    ${list_num}    IN    &{CELLLOG_DICT}
    \    UploadCommonLog_function    
    \    Sleep    60
    \    ${value}    Get Dictionary Values    ${list_num}
    \    ${value}    Catenate   SEPARATOR=    @{value}[0]    .0
    \    Log    ${value}

    \    ${rs}    Board SetLog File Upload    ${value}    1    ${UPLOADPATH}
    \    Should be equal    ${rs}    ${True}

    Sleep    30

#~ #----------------------------------------------------------------------
Task Test
    [Documentation]    任务故障
    [Tags]
    :FOR    ${list_num}    IN    &{CELLLOG_DICT}
    \    UploadCommonLog_function    
    \    Sleep    60
    \    ${rs}    Board SetLog File Upload    ${AOM_INDEX}    1;71    ${UPLOADPATH}
    \    Should be equal    ${rs}    ${True}	
    \    Sleep    60
    \    ${value}    Get Dictionary Values    ${list_num}
    \    ${value}    Catenate   SEPARATOR=    @{value}[0]    .0
    \    Log    ${value}

	\    ${rs}    Board SetLog File Upload    ${value}    1    ${UPLOADPATH}
    \    Should be equal    ${rs}    ${True}

    Sleep    30

#~ #----------------------------------------------------------------------
Insert Test
    [Documentation]    随机接入问题
    [Tags]
    :FOR    ${list_num}    IN    &{CELLLOG_DICT}
    \    UploadCommonLog_function    
    \    Sleep    60
    \    ${value}    Get Dictionary Values    ${list_num}
    \    ${value}    Catenate   SEPARATOR=    @{value}[0]    .0
    \    Log    ${value}

    \    ${rs}    Board SetLog File Upload    ${value}    1    ${UPLOADPATH}
    \    Should be equal    ${rs}    ${True}
    
    Sleep    30

#~ #----------------------------------------------------------------------
RateLow Test
    [Documentation]    速率低
    [Tags]
    :FOR    ${list_num}    IN    &{CELLLOG_DICT}
    \    UploadCommonLog_function    
    \    Sleep    60
    \    ${value}    Get Dictionary Values    ${list_num}
    \    ${value}    Catenate   SEPARATOR=    @{value}[0]    .0
    \    Log    ${value}

    \    ${rs}    Board SetLog File Upload    ${value}    1    ${UPLOADPATH}
    \    Should be equal    ${rs}    ${True}
    \    Sleep    60
	\    ${rs}    RRU Log File Upload    rrualarm    ${UPLOADPATH}
	\    Should be equal    ${rs}    ${True}
    \    Sleep    120
    \    ${rs}    RRU Log File Upload    rruuser    ${UPLOADPATH}
	\    Should be equal    ${rs}    ${True}
    \    Sleep    180
    \    ${rs}    RRU Log File Upload    rrusys    ${UPLOADPATH}
	\    Should be equal    ${rs}    ${True}
    \    Sleep    120
    
    Sleep    30

#~ #----------------------------------------------------------------------
Switch Test
    [Documentation]    切换类问题
    [Tags]
    :FOR    ${list_num}    IN    &{CELLLOG_DICT}
    \    UploadCommonLog_function    
    \    Sleep    60
    \    ${rs}    Board SetLog File Upload    ${AOM_INDEX}    71    ${UPLOADPATH}
    \    Should be equal    ${rs}    ${True}

    Sleep    30