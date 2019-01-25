# encoding utf-8
'''
BBU状态检查资源文件
'''
from pysnmp.smi.rfc1902 import ObjectIdentity

*** Settings ***
Library    SnmpLibrary
Library    BuiltIn
Library    ../../utils/CiUtils.py

*** Variables ***
${OM_SNMP_GET_NOT_EXIST}    ${342}
${OM_SNMP_SET_NOT_EXIST}    ${345}

*** Keywords ***
Is Exist Clock Src
    :FOR    ${index}    IN RANGE    1    10
    \    ${ret}    ${error}   Get With Error By Name    clkSrcStatus    ${index}
    \    Run Keyword If    ${error} == ${0}    Run Keyword If    '${ret}' == 'active'    Exit For Loop
    \    Return From Keyword If    ${index} == ${9}    ${0}
    [Return]    ${1}

# 获取板卡运行状态:boardOperationalState
Get Board Status
    :FOR    ${index}    IN RANGE    0    16
    \    ${RowSts}    ${error}    Get With Error By Name    boardRowStatus    idx=@{0,0,${index}}
    \    Log    ${error}
    \    Continue For Loop If    ${error} == ${OM_SNMP_GET_NOT_EXIST}
    \    ${BoardSts}    Get By Name    boardOperationalState    idx=@{0,0,${index}}
    \    Return From Keyword If    '${BoardSts}' == 'disabled'    ${False}
    [Return]    ${True}

# 获取处理器操作状态:procOperationalState
#idx:机架：0 机框：0 插槽：0..16  处理器号:0..9
Get SingleBoard Processor Status
    [Arguments]    ${SlotNo}
    :FOR    ${IndexOnBoard}    IN RANGE    0    9
    \    ${OperationalState}    ${error2}    Get With Error By Name    procOperationalState    idx=@{0,0,${SlotNo},${IndexOnBoard}}
    \    Log    ${error2}
    \    Continue For Loop If    ${error2} > ${0}
    \    Return From Keyword If    '${OperationalState}' == 'disabled'    ${False}
    [Return]    ${True}

Get AllProcessor Status
    :FOR    ${SlotNo}    IN RANGE    0    16
    \    ${status}    Get SingleBoard Processor Status    ${SlotNo}
    \    Log    ${status}
    \    Return From Keyword If    ${status} == ${False}    ${False}
    [Return]    ${True}

#BBU重启后的状态检查
BBU Status Check After Restart
    # 判断时钟模式
    ${ClkSrcMode}    Get By Name    sysStartIsNoClkSrcMode
    Log    ${ClkSrcMode}
    # 判断时钟源是否存在
    ${isExistClkSrc}    Is Exist Clock Src
    Log    ${isExistClkSrc}
    Run Keyword If    ${isExistClkSrc} == ${0}
    ...    Run Keyword If    '${ClkSrcMode}' == 'normal'
    ...    Set By Name    sysStartIsNoClkSrcMode    noClkSrc

    Sleep    5s

    #判断板卡状态
    ${runStatus}    Get Board Status
    Run Keyword If    ${runStatus} == ${False}     Log    'Board exist disable status'
    Should be equal    ${runStatus}    ${True}

    #判断处理器状态
    ${retProSts}    Get AllProcessor Status
    Run Keyword If    ${retProSts} == ${False}     Log    'Processor exist disable status'
    Should be equal    ${retProSts}    ${True}

    #RRU接入状态
    #${retAAU}    AAU Status Check After Restart
    #Run Keyword If    ${retAAU} == ${False}     Log    'RRU Access Phase or NR cell not active'
    #Should be equal    ${retAAU}    ${True}
