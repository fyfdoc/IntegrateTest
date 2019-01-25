# encoding utf-8
'''
*************************************************************
*** COPYRIGHT DaTang Mobile Communications Equipment CO.,LTD
*************************************************************
*文件名称：file0_CommonLogTest.robot
*功能描述：测试公共日志文件上传用例
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
Resource    ../../COMM/commResources/SnmpMibHelper.robot
Resource    ../fileResources/CommonLogResource.robot
Suite Setup           Open Snmp Connection And Load Private MIB

*** Variables ***
${FtpServerIp}    172.27.245.198
${CommonlogPath}    C:\\enb_log\\commonlogdir

*** test case ***

#~ #----------------------------------------------------------------------
Init FtpServer Test
    [Documentation]    初始化FTP服务器信息测试
    [Tags]
    FtpServer Info Set    ${FtpServerIp}

#~ #----------------------------------------------------------------------
Init SaveDir Test
    [Documentation]    初始化保存目录
    [Tags]
    Create folder    ${CommonlogPath}
    
#~ #----------------------------------------------------------------------
OperationLog Upload Test
    [Documentation]    操作日志上传测试
    [Tags]
    ${rs}    Log File Upload    operationLog    ${CommonlogPath}
    Should be equal    ${rs}    ${True}

#~ #----------------------------------------------------------------------
CfgDataConsistency Upload Test
    [Documentation]    配置数据一致性文件上传测试
    [Tags]
    ${rs}    Log File Upload    cfgDataConsistency    ${CommonlogPath}
    Should be equal    ${rs}    ${True}

#~ #----------------------------------------------------------------------
StateDataConsistency Upload Test
    [Documentation]    状态数据一致性文件上传测试
    [Tags]
    ${rs}    Log File Upload    stateDataConsistency    ${CommonlogPath}
    Should be equal    ${rs}    ${True}

#~ #----------------------------------------------------------------------
DataConsistency Upload Test
    [Documentation]    数据一致性文件上传测试
    [Tags]
    ${rs}    Log File Upload    dataConsistency    ${CommonlogPath}
    Should be equal    ${rs}    ${True}

#~ #----------------------------------------------------------------------
CurConfig Upload Test
    [Documentation]   当前运行配置文件上传测试
    [Tags]
    ${rs}    Log File Upload    curConfig    ${CommonlogPath}
    Should be equal    ${rs}    ${True}

#~ #----------------------------------------------------------------------
LmtMDBFile Upload Test
    [Documentation]    数据库文件上传测试
    [Tags]
    ${rs}    Log File Upload    lmtMDBFile    ${CommonlogPath}
    Should be equal    ${rs}    ${True}

#~ #----------------------------------------------------------------------
ActiveAlarmFile Upload Test
    [Documentation]    活跃告警文件上传测试
    [Tags]
    ${rs}    Log File Upload    activeAlarmFile    ${CommonlogPath}
    Should be equal    ${rs}    ${True}

#~ #----------------------------------------------------------------------
AlarmLog Upload Test
    [Documentation]    告警日志文件上传测试
    [Tags]
    ${rs}    Log File Upload    alarmLog    ${CommonlogPath}
    Should be equal    ${rs}    ${True}

#~ #----------------------------------------------------------------------
OmKeyLog Upload Test
    [Documentation]    重要过程日志上传上传测试
    [Tags]
    ${rs}    Log File Upload    omKeyLog    ${CommonlogPath}
    Should be equal    ${rs}    ${True}

#~ #----------------------------------------------------------------------
DebugLog Upload Test
    [Documentation]    黑匣子日志上传测试
    [Tags]
    ${rs}    Log File Upload    debugLog    ${CommonlogPath}
    Should be equal    ${rs}    ${True}

#~ #----------------------------------------------------------------------
StatelessAlarmLog Upload Test
    [Documentation]    异常日志上传测试
    [Tags]
    ${rs}    Log File Upload    statelessAlarmLog    ${CommonlogPath}
    Should be equal    ${rs}    ${True}

#~ #----------------------------------------------------------------------
EventLog Upload Test
    [Documentation]    事件日志上传测试
    [Tags]
    ${rs}    Log File Upload    eventLog    ${CommonlogPath}
    Should be equal    ${rs}    ${True}