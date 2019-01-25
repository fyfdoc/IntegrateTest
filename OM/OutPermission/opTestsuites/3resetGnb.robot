# encoding utf-8
'''
*************************************************************
*** COPYRIGHT DaTang Mobile Communications Equipment CO.,LTD
*************************************************************
*文件名称：3resetGnb.robot
*功能描述：整站复位压力测试，板卡、处理器状态检测与统计时长
*使用方法：
*用例步骤：
1. 分别获得机框上主控和基带在位的板卡槽位号
2. 根据槽位号获取处理器表索引
2. 根据槽位号获取板卡表索引
4. 压力测试80次，反复复位基站，获取该索引对应的处理器状态，直到可用，统计时长
5. 获取该索引对应的板卡状态，直到可用，统计时长

-----------------------------------------------------------------------------------
*修改记录：                                                                       |
*##修改日期    |    修改人    |    修改描述    |                                  |
*2018-11-06        yangnan1       创建文件                                        |
*2018-11-22        morunzhang     添加时间统计信息                                |
*2018-11-26        yangnan1       增加后处理                                        |
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
Resource    ../../COMM/commResources/GnbCommands.robot
Resource    ../../FILE/fileResources/CommonLogResource.robot
Resource    ../opResources/UploadLogsAndResetGnb.robot
Suite Setup           Open Snmp Connection And Load Private MIB
Suite Teardown    Run Keyword If Any Tests Failed    Upload Logs And Recover Gnb


*** Variables ***
${ENB_ResetValue}    1        #不影响下一级复位
${ENB_SartUpStage}    configured

${LOG_Phase}    '接入标志:'
${LOG_Oper}    '操作状态:'
${enabled}    'enabled'
${GnbTrigger_Value}    1
${cellIndex}    0

*** test case ***
Reset Gnb
     @{processorIndex_list}    Get All Actual Processors Index List
     Log List    @{processorIndex_list}
     @{boardIndex_list}    Get All Actual Boards Index List
     Log List    @{boardIndex_list}


    ${time01}    get current date

    :FOR    ${loop}    IN RANGE    100
    \    Set Many By Name    equipResetTrigger    ${GnbTrigger_Value}
    \    Sleep    60

    \    ${time02}    get current date
    \    Get All Processors Until Enabled When No Clock    @{processorIndex_list}
    \    &{time02info}    Get Date Info     读取处理器状态时间信息    ${time02}    1
    \    Log    ${time02info}

    \    Set No Clk Mode
    \    Connect Hsctd Pid2
    \    ${Ret_NoAAU}    Set No AAU Mode
    \    Log    ${Ret_NoAAU}
    \    Disconnect UAgent Use Pid
    \    Get All Processors Until Enabled    @{processorIndex_list}
    \    Get All Boards Until Enabled    @{boardIndex_list}
    \    ${rs}    Log File Upload    dataConsistency    C:\\enb_log
    \    Should be equal    ${rs}    ${True}
    \    ${nrCellCfgRowStatus_oid}    Get Oid By Name    ${Mib}    nrCellCfgRowStatus
    \    Log    ${nrCellCfgRowStatus_oid}
    \    @{CellIdList}    get_CellIDList    ${nrCellCfgRowStatus_oid}    ${35}
    \    Get Cell Until Enabled    @{CellIdList}

    &{time01info}    Get Date Info     整站复位压力测试100次    ${time01}    100
    Log    ${time01info}

