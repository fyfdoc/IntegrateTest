# encoding utf-8
'''
日志文件测试用例
'''
from pysnmp.smi.rfc1902 import ObjectIdentity

*** Settings ***
Library    SnmpLibrary
Library    BuiltIn
Library    ../utils/CiUtils.py
Resource    ../resources/SnmpMibHelper.robot
Resource    ../resources/LogHelper.robot
Suite Setup    Open Snmp Connection And Load Private MIB    ${DeviceIp}    ${Community}    ${MibName}

*** Variables ***
${DeviceIp}    172.27.245.92
${FtpServerIp}    172.27.245.198
#${Community}    public
${Community}    dtm.1234
${MibName}    DTM-TD-LTE-ENODEB-ENBMIB

*** Keywords ***

*** test case ***
#~ #----------------------------------------------------------------------
# 初始化ftp服务器信息
Init FtpServer Info
    FtpServer Info Set    ${FtpServerIp}

#~ #----------------------------------------------------------------------
# 操作日志上传
Log Upload operationLog
    ${rs}    Log File Upload    operationLog    C:\\enb_log
    Should be equal    ${rs}    ${True}

#~ #----------------------------------------------------------------------
# 配置数据一致性文件
Log Upload cfgDataConsistency
    ${rs}    Log File Upload    cfgDataConsistency    C:\\enb_log
    Should be equal    ${rs}    ${True}

#~ #----------------------------------------------------------------------
# 状态数据一致性文件
Log Upload stateDataConsistency
    ${rs}    Log File Upload    stateDataConsistency    C:\\enb_log
    Should be equal    ${rs}    ${True}

#~ #----------------------------------------------------------------------
# 数据一致性文件
Log Upload dataConsistency
    ${rs}    Log File Upload    dataConsistency    C:\\enb_log
    Should be equal    ${rs}    ${True}

#~ #----------------------------------------------------------------------
# 当前运行配置文件
Log Upload curConfig
    ${rs}    Log File Upload    curConfig    C:\\enb_log
    Should be equal    ${rs}    ${True}

#~ #----------------------------------------------------------------------
# 数据库文件
Log Upload lmtMDBFile
    ${rs}    Log File Upload    lmtMDBFile    C:\\enb_log
    Should be equal    ${rs}    ${True}
#~ #----------------------------------------------------------------------

# 活跃告警文件
Log Upload activeAlarmFile
    ${rs}    Log File Upload    activeAlarmFile    C:\\enb_log
    Should be equal    ${rs}    ${True}
#~ #----------------------------------------------------------------------

# dump快照日志文件
Log Upload dumpLogFile
    ${rs}    Log File Upload    dumpLogFile    C:\\enb_log
    Should be equal    ${rs}    ${True}

#~ #----------------------------------------------------------------------
# 告警日志文件
Log Upload alarmLog
    ${rs}    Log File Upload    alarmLog    C:\\enb_log
    Should be equal    ${rs}    ${True}

#~ #----------------------------------------------------------------------
# 跟踪用户日志
Log Upload traceUserLog
    ${rs}    Log File Upload    traceUserLog    C:\\enb_log
    Should be equal    ${rs}    ${True}

#~ #----------------------------------------------------------------------
# 重要过程日志上传
Log Upload omKeyLog
    ${rs}    Log File Upload    omKeyLog    C:\\enb_log
    Should be equal    ${rs}    ${True}

#~ #----------------------------------------------------------------------
# 黑匣子日志
Log Upload debugLog
    ${rs}    Log File Upload    debugLog    C:\\enb_log
    Should be equal    ${rs}    ${True}

#~ #----------------------------------------------------------------------
# 异常日志
Log Upload statelessAlarmLog
    ${rs}    Log File Upload    statelessAlarmLog    C:\\enb_log
    Should be equal    ${rs}    ${True}

#~ #----------------------------------------------------------------------
# 事件日志
Log Upload eventLog
    ${rs}    Log File Upload    eventLog    C:\\enb_log
    Should be equal    ${rs}    ${True}


