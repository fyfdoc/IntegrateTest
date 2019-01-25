# encoding utf-8
'''
*************************************************************
*** COPYRIGHT DaTang Mobile Communications Equipment CO.,LTD
*************************************************************
*文件名称：cell0_xxx.robot
*功能描述：
*使用方法：

-----------------------------------------------------------------------------------
*修改记录：                                                                       |
*##修改日期    |    修改人    |    修改描述    |                                  |
*2018-10-20        majingwei       创建文件                                       |
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
Resource    ../cellResources/cellResource.robot
Suite Setup           Open Snmp Connection And Load Private MIB

*** Variables ***
${host_name}    'HSCTD'
${host_address}    172.27.245.92
${pId}    ${2}

*** test case ***
CELL_ANT_CAL
    [Documentation]    天线校准
    [Tags]
#    [Setup]    Connect Device By UAgent Use Pid    ${host_name}    ${host_address}    ${pId}
    [Setup]    Connect Hsctd Pid2
    [Teardown]    Disconnect UAgent Use Pid
    [Timeout]

    @{Cell_List}    Get Useful Cell List
    :FOR    ${idx}    IN    @{Cell_List}
    \    Set calAc Switch    disable
    \    Reset Cell Active Trigger    ${idx}
    \    Set calAc Switch    enable
    \    ${RruNO}    Get RruNo By LcID    ${idx}
    \    Set AntCal Command    ${idx}    ${RruNO}
    \    PeriodCalRowStatus Should be CreateAndGo    ${idx}    ${RruNO}

CELL_PERIOD_ANT_CAL
    [Documentation]    天线周期校准
    [Tags]
 #   [Setup]    Connect Device By UAgent Use Pid    ${host_name}    ${host_address}    ${pId}
    [Setup]    Connect Hsctd Pid2
    [Teardown]    Disconnect UAgent Use Pid
    [Timeout]

    @{Cell_List}    Get Useful Cell List
    :FOR    ${idx}    IN    @{Cell_List}
    \    Set calAc Switch    disable
    \    Reset Cell Active Trigger    ${idx}
    \    Set PeriodCal
    \    Sleep    70
    \    ${RruNO}    Get RruNo By LcID    ${idx}
    \    PeriodCalRowStatus Should be CreateAndGo    ${idx}    ${RruNO}
