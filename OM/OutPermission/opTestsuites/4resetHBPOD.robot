# encoding utf-8
'''
*************************************************************
*** COPYRIGHT DaTang Mobile Communications Equipment CO.,LTD
*************************************************************
*文件名称：3resetGnb.robot
*功能描述：复位基带板压力测试，板卡、处理器状态检测与统计时长
*使用方法：
*用例步骤：
1. 获得机框上基带在位的板卡槽位号
2. 根据槽位号获取处理器表索引
2. 根据槽位号获取板卡表索引
4. 压力测试80次，反复复位基站，获取该索引对应的处理器状态，直到可用，统计时长
5. 获取该索引对应的板卡状态，直到可用，统计时长

-----------------------------------------------------------------------------------
*修改记录：                                                                       |
*##修改日期    |    修改人    |    修改描述    |                                  |
*2018-11-06        yangnan1       创建文件                                       |
----------------------------------------------------------------------------------|
*************************************************************
______________________________________________________________________________________
*用例记录：                                                                          |
-------------------------------------------------------------------------            |
**                                                                                   |
_____________________________________________________________________________________|

************************************************资源文件头结束**************************************************
'''
from pysnmp.smi.rfc1902 import ObjectIdentity

*** Settings ***
Library    DateTime
Library    Collections
Resource    ../../COMM/commResources/SnmpMibHelper.robot
Resource    ../opResources/opResource.robot
#Resource    ../resources/UploadLogsAndRecoverGnb.robot
Suite Setup           Open Snmp Connection And Load Private MIB
#Suite Teardown    Run Keyword If Any Tests Failed    Upload Logs And Recover Gnb


*** Variables ***
${ENB_ResetValue}    1        #不影响下一级复位
${ENB_SartUpStage}    configured

${LOG_Phase}    '接入标志:'
${LOG_Oper}    '操作状态:'
${enabled}    'enabled'
${boardResetTrigger}    1

*** test case ***
Reset HBPOD
     @{processorIndex_list}    Get HBPOD Actual Processors Index List
     Log List    @{processorIndex_list}
     @{boardIndex_list}    Get HBPOD Actual Boards Index List
     Log List    @{boardIndex_list}

    :FOR    ${loop}    IN RANGE    80
    \    Set Many By Name    boardResetTrigger    ${boardResetTrigger}
    \    Sleep    60
    \    Get HBPOD Processors Until Enabled    @{processorIndex_list}
    \    Get HBPOD Boards Until Enabled    @{boardIndex_list}