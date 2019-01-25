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
${Community}    public
#${Community}    dtm.1234
${MibName}    DTM-TD-LTE-ENODEB-ENBMIB
${aom}    aom
${som}    som

*** Keywords ***

*** test case ***
#~ #----------------------------------------------------------------------
#Clear Folder
#    Clear folder    C:\\enb_log

Board Log Upload
    Open And Close Capture Package Switch

    ${boardEntry}    Get Oid By Name    ${MibName}    boardRowStatus
    Log    ${boardEntry}
    @{aom_slotNo_list}    Get board of aom or som    ${aom}    ${boardEntry}    ${16}

    :For    ${loop_slotNo}    in    @{aom_slotNo_list}
    \    Specified Board Log Upload    ${loop_slotNo}
    \    Log    ${loop_slotNo}'s board log upload is complete!

    ${boardEntry}    Get Oid By Name    ${MibName}    boardRowStatus
    Log    ${boardEntry}
    @{som_slotNo_list}    Get board of aom or som    ${som}    ${boardEntry}    ${16}

    :For    ${loop_slotNo}    in    @{som_slotNo_list}
    \    Specified Board Log Upload    ${loop_slotNo}
    \    Log    ${loop_slotNo}'s board log upload is complete!

#    @{index_list}    Get Index By SlotNo    6
#    :For    ${loop_index}    in    @{index_list}
#    \    ${rs}    Board Log File Upload    ${loop_index}    C:\\enb_log\\boardLogs
#    \    Should be equal    ${rs}    ${True}


