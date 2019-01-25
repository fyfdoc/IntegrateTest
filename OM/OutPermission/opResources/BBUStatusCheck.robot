# encoding utf-8
'''
*************************************************************
*** COPYRIGHT DaTang Mobile Communications Equipment CO.,LTD
*************************************************************
*文件名称：BBUStatusCheck.robot
*功能描述：基站状态检查资源文件
*使用方法：

-----------------------------------------------------------------------------------
*修改记录：                                                                       |
*##修改日期    |    修改人    |    修改描述    |                                  |
*2018-11-09       wangruixuan      创建文件                                       |
----------------------------------------------------------------------------------|
*************************************************************
______________________________________________________________________________________
*关键字目录：                                                                        |
-------------------------------------------------------------------------            |
*##检查类关键字##                                                                    |
*A1.检查是否存在时钟源                   -> Is Exist Clock Src                       |
*A2.检查板卡状态                         -> Get Board Status                         |
*A3.检查单一处理器状态                   -> Get SingleBoard Processor Status         |
*A4.检查所有处理器状态                   -> Get AllProcessor Status                  |
*A5.BBU重启后 状态检查                   -> BBU Status Check After Restart           |
_____________________________________________________________________________________|

************************************************资源文件头结束**************************************************
'''
from pysnmp.smi.rfc1902 import ObjectIdentity

*** Settings ***
Library    SnmpLibrary
Library    ../../utils/CiUtils.py
Resource    ../../COMM/commResources/SnmpMibHelper.robot

*** Variables ***
${Mib}    DTM-TD-LTE-ENODEB-ENBMIB

${OM_SNMP_GET_NOT_EXIST}    ${342}
${OM_SNMP_SET_NOT_EXIST}    ${345}

${ActivateIndicator}    instantActivate

*** Keywords ***
#***********************************************************************************
#功能     ：检查是否存在时钟源                                                     *
#标签     ：                                                                       *
#索引     ：XXXXXXXX                                                               *
#入参     ：无                                                                     *
#返回值   ：0 / 1                                                                  *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：SFT                                                                    *
#适用用例 ：                                                                       *
#负责人   ：wangruixuan                                                            *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Is Exist Clock Src
    :FOR    ${index}    IN RANGE    1    10
    \    ${ret}    ${error}   Get With Error By Name    clkSrcStatus    ${index}
    \    Run Keyword If    ${error} == ${0}    Run Keyword If    '${ret}' == 'active'    Exit For Loop
    \    Return From Keyword If    ${index} == ${9}    ${0}
    [Return]    ${1}

#***********************************************************************************
#功能     ：检查板卡状态                                                           *
#标签     ：                                                                       *
#索引     ：XXXXXXXX                                                               *
#入参     ：无                                                                     *
#返回值   ：True / False                                                           *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：SFT                                                                    *
#适用用例 ：                                                                       *
#负责人   ：wangruixuan                                                            *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：获取板卡运行状态:boardOperationalState                                 *
#                                                                                  *
#***********************************************************************************
Get Board Status
    :FOR    ${index}    IN RANGE    0    16
    \    ${RowSts}    ${error}    Get With Error By Name    boardRowStatus    idx=@{0,0,${index}}
    \    Log    ${error}
    \    Continue For Loop If    ${error} == ${OM_SNMP_GET_NOT_EXIST}
    \    ${BoardSts}    Get By Name    boardOperationalState    idx=@{0,0,${index}}
    \    Return From Keyword If    '${BoardSts}' == 'disabled'    ${False}
    [Return]    ${True}

#***********************************************************************************
#功能     ：检查单一处理器状态                                                     *
#标签     ：                                                                       *
#索引     ：XXXXXXXX                                                               *
#入参     ：无                                                                     *
#返回值   ：True / False                                                           *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：SFT                                                                    *
#适用用例 ：                                                                       *
#负责人   ：wangruixuan                                                            *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：获取处理器操作状态:procOperationalState                                *
#                                                                                  *
#***********************************************************************************
Get SingleBoard Processor Status
    [Arguments]    ${SlotNo}
    :FOR    ${IndexOnBoard}    IN RANGE    0    9
    \    ${OperationalState}    ${error2}    Get With Error By Name    procOperationalState    idx=@{0,0,${SlotNo},${IndexOnBoard}}
    \    Log    ${error2}
    \    Continue For Loop If    ${error2} > ${0}
    \    Return From Keyword If    '${OperationalState}' == 'disabled'    ${False}
    [Return]    ${True}

#***********************************************************************************
#功能     ：检查所有处理器状态                                                     *
#标签     ：                                                                       *
#索引     ：XXXXXXXX                                                               *
#入参     ：无                                                                     *
#返回值   ：True / False                                                           *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：SFT                                                                    *
#适用用例 ：                                                                       *
#负责人   ：wangruixuan                                                            *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Get AllProcessor Status
    :FOR    ${SlotNo}    IN RANGE    0    16
    \    ${status}    Get SingleBoard Processor Status    ${SlotNo}
    \    Log    ${status}
    \    Return From Keyword If    ${status} == ${False}    ${False}
    [Return]    ${True}

#***********************************************************************************
#功能     ：BBU重启后 状态检查                                                     *
#标签     ：                                                                       *
#索引     ：XXXXXXXX                                                               *
#入参     ：无                                                                     *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：SFT                                                                    *
#适用用例 ：                                                                       *
#负责人   ：wangruixuan                                                            *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
BBU Status Check After Restart
    # 判断时钟模式
    ${ClkSrcMode_oid}    Get Oid By Name    ${Mib}    sysStartIsNoClkSrcMode
    ${ClkSrcMode}    Get    ${ClkSrcMode_oid}
    Log    ${ClkSrcMode}
    # 判断时钟源是否存在
    ${isExistClkSrc}    Is Exist Clock Src
    Log    ${isExistClkSrc}
    Run Keyword If    ${isExistClkSrc} == ${0}
    ...    Run Keyword If    '${ClkSrcMode}' == 'normal'
    ...    Set By Name    sysStartIsNoClkSrcMode    noClkSrc

    Sleep    5s

    :FOR    ${loop}    IN RANGE    120
    \    Log to console    进入间断性检查
    \    Sleep    10
    #判断板卡状态
    \    ${runStatus}    Get Board Status
    \    Run Keyword If    ${runStatus} == ${True}    Exit For Loop
    Should be equal    ${runStatus}    ${True}
    
    #判断处理器状态
    ${retProSts}    Get AllProcessor Status
    Run Keyword If    ${retProSts} == ${False}    Log    'Processor exist disable status'
    Should be equal    ${retProSts}    ${True}