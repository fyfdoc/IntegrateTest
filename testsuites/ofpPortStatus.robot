 #encoding utf-8

'''
create by zhuqingshuang
光口状态测试用例集
'''

from pysnmp.smi.rfc1902 import ObjectIdentity

*** Settings ***
Library    SnmpLibrary
Library    BuiltIn
Library    Collections
Library    ../utils/CiUtils.py
Resource    ../resources/SnmpMibHelper.robot

Suite Setup    Open Snmp Connection and Load Private MIB    ${dstIP}    ${community}    ${MIB}
Suite TearDown    Log    do somethings for post-processing

*** Variables ***
${dstIp}    172.27.245.91
#${dstIp}             192.168.1.5
${community}    public
${MIB}    DTM-TD-LTE-ENODEB-ENBMIB
${OM_SNMP_GET_NOT_EXIST}    ${342}

@{objNames}
...    ofpPortRowStatus    #光口行状态
...    ofpPortType    #光口类型
...    ofpPortFpgaStatus    #FPGA状态
...    ofpPortModuleStandStatus    #在位状态
...    ofpPortModuleTemperature    #温度
...    ofpPortModuleVcc    #电压
...    ofpPortModuleBias    #激光偏置电流
...    ofpPortModuleTxPower    #发送功率
...    ofpPortModuleRxPower    #接收功率
...    ofpPortModuleLossStatus    #信号丢失状态
...    #ofpPortModuleVendorName    #光模块厂商
...    ofpPortModuleS9umKmLen    #以m为单位计算的9um单模光纤支持的最大长度
...    ofpPortModuleS9um100MLen    #以100m为单位计算的9um单模光纤支持的最大长度
...    ofpPortModuleM50um10MLen    #以10m为单位计算的50um多模光纤支持的最大长度
...    ofpPortModuleM625um10MLen    #以10m为单位计算的62.5um多模光纤支持的最大长度
...    ofpPortModuleBitRate    #光模块传输速率
...    ofpPortLoopBackTrigger    #环回指示
...    ofpPortLoopCheckPeriod    #环回检测周期
...    ofpPortMatchStatus    #端口光模块是否匹配
...    ofpPortLinkStatus    #端口状态
...    ofpPortModuleActualBitRate    #光口实际传输速率
...    ofpPortFPGARate    #光口寄存器配置
...    ofpPortResetOfpTrigger    #光口复位开关
...    ofpPortOperationStatus    #光口可用状态
...    ofpPortBitErrorRate    #光口误码率
...    #ofpPortFpgaOpenState    #光口打开状态
...    ofpPortGsmSetFlag    #光口GSM开关配置
...    #ofpPortModuleTxPowerEx1    #发送功率扩展1
...    #ofpPortModuleRxPowerEx1    #接收功率扩展1
...    #ofpPortModuleTxPowerEx2    #发送功率扩展2
...    #ofpPortModuleRxPowerEx2    #接收功率扩展2
...    #ofpPortModuleTxPowerEx3    #发送功率扩展3
...    #ofpPortModuleRxPowerEx3    #接收功率扩展3

*** KeyWords ***
#
Get All Leaf Of MIB
    [Arguments]    ${objName}
    ${oid}    Get Oid By Name    ${MIB}    ${objName}
    @{list}    Walk    ${oid}
    [Return]    @{list}

#index of ofpPortTable :
#ofpProtRackNO(0..0), ofpPortShelfNo(0..0), ofpPortSlotNo(0..16), ofpPortIndexOnBoard(0..7)
Get Ofp Port Status
    [Arguments]    ${ofpPortSlotNo}    ${ofpPortIndexOnBoard}
    &{ofpPortStatus}    Create Dictionary
    :FOR    ${objName}    IN    @{objNames}
    \    Log    ${objName}
    \    ${value}    ${error}    Get With Error By Name
    ...    ${objName}    idx=@{0,0,${ofpPortSlotNo},${ofpPortIndexOnBoard}}
    \    Continue For Loop If    ${error} != 0
    \    Set To Dictionary    ${ofpPortStatus}    ${objName}    ${value}
    \    Return From Keyword If    '${value}' == 'notExisted'    &{ofpPortStatus}
    Log    at ${ofpPortSlotNo} slot ${ofpPortIndexOnBoard} port: &{ofpPortStatus}
    [Return]    &{ofpPortStatus}

#hsctd,hbpod
Get Exist Board
    [Arguments]    ${boardType}
    @{existBoard}    Create List
    :FOR    ${slot}    IN RANGE    0    16
    \    ${RowSts}    ${error}    Get With Error By Name
    ...    boardRowStatus    idx=@{0,0,${slot}}
    \    Log    ${error}
    \    Continue For Loop If    ${error} == ${OM_SNMP_GET_NOT_EXIST}
    \    ${bType}    Run Keyword If    '${RowSts}' == 'createAndGo'
    ...    Get By Name    boardHardwareType    idx=@{0,0,${slot}}
    \    Run Keyword If    '${boardType}' == '${bType}'
    ...    Append to List    ${existBoard}    ${slot}
    Log    ${boardType} exist @{existBoard}
    [Return]    @{existBoard}

Hsctd Ofp Port Status Check
    [Arguments]    ${slot}
    &{result}    Create Dictionary
    :FOR    ${ofpPortIndexOnBoard}    IN    0    1
    \    ${noMatchCount} =    Set Variable    ${0}
    \    &{ofpPortStatus}    Get Ofp Port Status    ${slot}    ${ofpPortIndexOnBoard}
    \    Continue For Loop If    '${ofpPortStatus.ofpPortModuleStandStatus}' == 'notExisted'
    #\    ${noMatchCount}    Set Variable If    '${ofpPortStatus.ofpPortRowStatus}' != 'createAndGo'    ${noMatchCount+1}    ${noMatchCount}
    \    ${noMatchCount}    Set Variable If    '${ofpPortStatus.ofpPortType}' != 'eth'    ${noMatchCount+1}    ${noMatchCount}
    #\    ${noMatchCount}    Set Variable If    '${ofpPortStatus.ofpPortFpgaStatus}' != 'unknown'    ${noMatchCount+1}    ${noMatchCount}
    #\    ${noMatchCount}    Set Variable If    '${ofpPortStatus.ofpPortModuleTemperature}' != ''    ${noMatchCount+1}    ${noMatchCount}    
    #\    ${noMatchCount}    Set Variable If    '${ofpPortStatus.ofpPortModuleVcc}' != ''    ${noMatchCount+1}    ${noMatchCount}
    #\    ${noMatchCount}    Set Variable If    '${ofpPortStatus.ofpPortModuleBias}' != ''    ${noMatchCount+1}    ${noMatchCount}   
    #\    ${noMatchCount}    Set Variable If    '${ofpPortStatus.ofpPortModuleTxPower}' != ''    ${noMatchCount+1}    ${noMatchCount}
    #\    ${noMatchCount}    Set Variable If    '${ofpPortStatus.ofpPortModuleRxPower}' != ''    ${noMatchCount+1}    ${noMatchCount}
    \    ${noMatchCount}    Set Variable If    '${ofpPortStatus.ofpPortModuleLossStatus}' != 'noLosss'    ${noMatchCount+1}    ${noMatchCount}
    #\    ${noMatchCount}    Set Variable If    '${ofpPortStatus.ofpPortModuleVendorName}' != ''    ${noMatchCount+1}    ${noMatchCount}
    #\    ${noMatchCount}    Set Variable If    '${ofpPortStatus.ofpPortModuleS9umKmLen}' != ''    ${noMatchCount+1}    ${noMatchCount}
    #\    ${noMatchCount}    Set Variable If    '${ofpPortStatus.ofpPortModuleS9um100MLen}' != ''    ${noMatchCount+1}    ${noMatchCount}
    #\    ${noMatchCount}    Set Variable If    '${ofpPortStatus.ofpPortModuleM50um10MLen}' != ''    ${noMatchCount+1}    ${noMatchCount}   
    #\    ${noMatchCount}    Set Variable If    '${ofpPortStatus.ofpPortModuleM625um10MLen}' != ''    ${noMatchCount+1}    ${noMatchCount}
    #\    ${noMatchCount}    Set Variable If    '${ofpPortStatus.ofpPortModuleBitRate}' != ''    ${noMatchCount+1}    ${noMatchCount}
    #\    ${noMatchCount}    Set Variable If    '${ofpPortStatus.ofpPortLoopBackTrigger}' != ''    ${noMatchCount+1}    ${noMatchCount}
    #\    ${noMatchCount}    Set Variable If    '${ofpPortStatus.ofpPortLoopCheckPeriod}' != ''    ${noMatchCount+1}    ${noMatchCount}
    #\    ${noMatchCount}    Set Variable If    '${ofpPortStatus.ofpPortMatchStatus}' != 'match'    ${noMatchCount+1}    ${noMatchCount}
    #\    ${noMatchCount}    Set Variable If    '${ofpPortStatus.ofpPortLinkStatus}' != ''    ${noMatchCount+1}    ${noMatchCount}
    #\    ${noMatchCount}    Set Variable If    '${ofpPortStatus.ofpPortModuleActualBitRate}' != ''    ${noMatchCount+1}    ${noMatchCount}   
    #\    ${noMatchCount}    Set Variable If    '${ofpPortStatus.ofpPortFPGARate}' != ''    ${noMatchCount+1}    ${noMatchCount}
    #\    ${noMatchCount}    Set Variable If    '${ofpPortStatus.ofpPortResetOfpTrigger}' != ''    ${noMatchCount+1}    ${noMatchCount}
    #\    ${noMatchCount}    Set Variable If    '${ofpPortStatus.ofpPortOperationStatus}' != ''    ${noMatchCount+1}    ${noMatchCount}
    #\    ${noMatchCount}    Set Variable If    '${ofpPortStatus.ofpPortBitErrorRate}' != ''    ${noMatchCount+1}    ${noMatchCount}
    #\    ${noMatchCount}    Set Variable If    '${ofpPortStatus.ofpPortFpgaOpenState}' != ''    ${noMatchCount+1}    ${noMatchCount}
    #\    ${noMatchCount}    Set Variable If    '${ofpPortStatus.ofpPortGsmSetFlag}' != ''    ${noMatchCount+1}    ${noMatchCount}
    #\    ${noMatchCount}    Set Variable If    '${ofpPortStatus.ofpPortModuleTxPowerEx1}' != ''    ${noMatchCount+1}    ${noMatchCount}   
    #\    ${noMatchCount}    Set Variable If    '${ofpPortStatus.ofpPortModuleRxPowerEx1}' != ''    ${noMatchCount+1}    ${noMatchCount}
    #\    ${noMatchCount}    Set Variable If    '${ofpPortStatus.ofpPortModuleTxPowerEx2}' != ''    ${noMatchCount+1}    ${noMatchCount}
    #\    ${noMatchCount}    Set Variable If    '${ofpPortStatus.ofpPortModuleRxPowerEx2}' != ''    ${noMatchCount+1}    ${noMatchCount}
    #\    ${noMatchCount}    Set Variable If    '${ofpPortStatus.ofpPortModuleTxPowerEx3}' != ''    ${noMatchCount+1}    ${noMatchCount}
    #\    ${noMatchCount}    Set Variable If    '${ofpPortStatus.ofpPortModuleRxPowerEx3}' != ''    ${noMatchCount+1}    ${noMatchCount}
    \    ${locate}    Catenate    ${slot}    .    ${ofpPortIndexOnBoard}
    \    Set To Dictionary    ${result}    ${locate}    ${noMatchCount}
    [Return]    &{result}

Hbpod Ofp Port Status Check
    [Arguments]    ${slot}
    &{result}    Create Dictionary
    :FOR    ${ofpPortIndexOnBoard}    IN RANGE    0    8
    \    ${noMatchCount} =    Set Variable    ${0}
    \    &{ofpPortStatus}    Get Ofp Port Status    ${slot}    ${ofpPortIndexOnBoard}
    \    Continue For Loop If    '${ofpPortStatus.ofpPortModuleStandStatus}' == 'notExisted'
    #\    ${noMatchCount}    Set Variable If    '${ofpPortStatus.ofpPortRowStatus}' != 'createAndGo'    ${noMatchCount+1}    ${noMatchCount}
    \    ${noMatchCount}    Set Variable If    '${ofpPortStatus.ofpPortType}' != 'hir'    ${noMatchCount+1}    ${noMatchCount}
    \    ${noMatchCount}    Set Variable If    '${ofpPortStatus.ofpPortFpgaStatus}' != 'syn'    ${noMatchCount+1}    ${noMatchCount}
    #\    ${noMatchCount}    Set Variable If    '${ofpPortStatus.ofpPortModuleTemperature}' != ''    ${noMatchCount+1}    ${noMatchCount}    
    #\    ${noMatchCount}    Set Variable If    '${ofpPortStatus.ofpPortModuleVcc}' != ''    ${noMatchCount+1}    ${noMatchCount}
    #\    ${noMatchCount}    Set Variable If    '${ofpPortStatus.ofpPortModuleBias}' != ''    ${noMatchCount+1}    ${noMatchCount}   
    #\    ${noMatchCount}    Set Variable If    '${ofpPortStatus.ofpPortModuleTxPower}' != ''    ${noMatchCount+1}    ${noMatchCount}
    #\    ${noMatchCount}    Set Variable If    '${ofpPortStatus.ofpPortModuleRxPower}' != ''    ${noMatchCount+1}    ${noMatchCount}
    \    ${noMatchCount}    Set Variable If    '${ofpPortStatus.ofpPortModuleLossStatus}' != 'noLosss'    ${noMatchCount+1}    ${noMatchCount}
    #\    ${noMatchCount}    Set Variable If    '${ofpPortStatus.ofpPortModuleVendorName}' != ''    ${noMatchCount+1}    ${noMatchCount}
    #\    ${noMatchCount}    Set Variable If    '${ofpPortStatus.ofpPortModuleS9umKmLen}' != ''    ${noMatchCount+1}    ${noMatchCount}
    #\    ${noMatchCount}    Set Variable If    '${ofpPortStatus.ofpPortModuleS9um100MLen}' != ''    ${noMatchCount+1}    ${noMatchCount}
    #\    ${noMatchCount}    Set Variable If    '${ofpPortStatus.ofpPortModuleM50um10MLen}' != ''    ${noMatchCount+1}    ${noMatchCount}   
    #\    ${noMatchCount}    Set Variable If    '${ofpPortStatus.ofpPortModuleM625um10MLen}' != ''    ${noMatchCount+1}    ${noMatchCount}
    \    ${noMatchCount}    Set Variable If    '${ofpPortStatus.ofpPortModuleBitRate}' != '100'    ${noMatchCount+1}    ${noMatchCount}
    #\    ${noMatchCount}    Set Variable If    '${ofpPortStatus.ofpPortLoopBackTrigger}' != ''    ${noMatchCount+1}    ${noMatchCount}
    #\    ${noMatchCount}    Set Variable If    '${ofpPortStatus.ofpPortLoopCheckPeriod}' != ''    ${noMatchCount+1}    ${noMatchCount}
    \    ${noMatchCount}    Set Variable If    '${ofpPortStatus.ofpPortMatchStatus}' != 'match'    ${noMatchCount+1}    ${noMatchCount}
    #\    ${noMatchCount}    Set Variable If    '${ofpPortStatus.ofpPortLinkStatus}' != ''    ${noMatchCount+1}    ${noMatchCount}
    #\    ${noMatchCount}    Set Variable If    '${ofpPortStatus.ofpPortModuleActualBitRate}' != ''    ${noMatchCount+1}    ${noMatchCount}   
    #\    ${noMatchCount}    Set Variable If    '${ofpPortStatus.ofpPortFPGARate}' != ''    ${noMatchCount+1}    ${noMatchCount}
    #\    ${noMatchCount}    Set Variable If    '${ofpPortStatus.ofpPortResetOfpTrigger}' != ''    ${noMatchCount+1}    ${noMatchCount}
    #\    ${noMatchCount}    Set Variable If    '${ofpPortStatus.ofpPortOperationStatus}' != ''    ${noMatchCount+1}    ${noMatchCount}
    #\    ${noMatchCount}    Set Variable If    '${ofpPortStatus.ofpPortBitErrorRate}' != ''    ${noMatchCount+1}    ${noMatchCount}
    #\    ${noMatchCount}    Set Variable If    '${ofpPortStatus.ofpPortFpgaOpenState}' != ''    ${noMatchCount+1}    ${noMatchCount}
    #\    ${noMatchCount}    Set Variable If    '${ofpPortStatus.ofpPortGsmSetFlag}' != ''    ${noMatchCount+1}    ${noMatchCount}
    #\    ${noMatchCount}    Set Variable If    '${ofpPortStatus.ofpPortModuleTxPowerEx1}' != ''    ${noMatchCount+1}    ${noMatchCount}   
    #\    ${noMatchCount}    Set Variable If    '${ofpPortStatus.ofpPortModuleRxPowerEx1}' != ''    ${noMatchCount+1}    ${noMatchCount}
    #\    ${noMatchCount}    Set Variable If    '${ofpPortStatus.ofpPortModuleTxPowerEx2}' != ''    ${noMatchCount+1}    ${noMatchCount}
    #\    ${noMatchCount}    Set Variable If    '${ofpPortStatus.ofpPortModuleRxPowerEx2}' != ''    ${noMatchCount+1}    ${noMatchCount}
    #\    ${noMatchCount}    Set Variable If    '${ofpPortStatus.ofpPortModuleTxPowerEx3}' != ''    ${noMatchCount+1}    ${noMatchCount}
    #\    ${noMatchCount}    Set Variable If    '${ofpPortStatus.ofpPortModuleRxPowerEx3}' != ''    ${noMatchCount+1}    ${noMatchCount}
    \    ${locate}    Catenate    ${slot}    .    ${ofpPortIndexOnBoard}
    \    Set To Dictionary    ${result}    ${locate}    ${noMatchCount}
    [Return]    &{result}

*** Test Cases ***
Ofp Port Status
    # all hsctd ofp port status
    @{hsctd}    Get Exist Board    hsctd
    &{sctRet}    Create Dictionary
    :FOR    ${slot}    IN    @{hsctd}
    \    &{ret}    Hsctd Ofp Port Status Check    ${slot}
    \    Set To Dictionary    ${sctRet}    &{ret}
    Log    All hsctd ofp port status: &{sctRet}
    :FOR    ${item}    IN    &{sctRet}
    \    ${key}    Get Dictionary Keys    ${item}
    \    ${value}    Get Dictionary Values    ${item}
    \    Run Keyword And Continue On Failure    Should Be Equal
    ...     @{value}[${0}]    ${0}    Ofp Port of "@{key}[${0}]"    vlaues = False

    #all hbpod ofp port status
    @{hbpod}    Get Exist Board    hbpod
    &{bpRet}    Create Dictionary
    :FOR    ${slot}    IN    @{hbpod}
    \    &{ret}    Hbpod Ofp Port Status Check    ${slot}
    \    Set To Dictionary    ${bpRet}    &{ret}
    Log Many    All hbpod ofp port status: &{bpRet}
    :FOR    ${item}    IN    &{bpRet}
    \    ${key}    Get Dictionary Keys    ${item}
    \    ${value}    Get Dictionary Values    ${item}
    \    Log Many    @{key}[${0}]    @{value}[${0}]
    \    Run Keyword And Continue On Failure    Should Be Equal
    ...    @{value}[${0}]    ${0}    Ofp Port of "@{key}[${0}]"    vlaues = False