# encoding utf-8
# @company: Datang Mobile
# @license: (c) Copyright 2018, Datang Mobile
# @author: sunshixu
# @file:    Loginhelper.robot
# @desc: login相关关键字

*** Settings ***
Library     DateTime
Resource    ../resources/UAgentWrapper.robot
Library    SnmpLibrary
Library    BuiltIn
Library    ../utils/CiUtils.py
Resource    ../resources/SnmpMibHelper.robot
Resource    ../resources/LogHelper.robot



*** Variables ***
${DeviceIp}    172.27.245.92
${host_address}    192.168.1.5
${Community}    public
${MibName}    DTM-TD-LTE-ENODEB-ENBMIB

${hbpod_address_base}    172.27.246

*** Keywords ***

Local Login HSCTD Process
    [documentation]    链接主控板个处理器进程 pid : x86-> 2-5
    [arguments]    ${pid}
    # 配置connect 参数
    ${ip_address}    Set Variable    ${DeviceIp}
    ${pid}    Set Variable    ${pid}
    # connect
    ${ret}=    Connect Device By UAgent Use Pid    hsctd scp ${pid}    ${ip_address}    ${pid}
    Should be equal    ${ret}    ${0}

Local Login HBPOD Process
    [documentation]    链接基带板个处理器进程 pid : x86-> 2-8  plp1-> 11  plp2-> 21
    ...    board_num: 基带板序号  多基带板时使用
    [arguments]    ${pid}    ${board_num}=${0}
    # 获取基带槽位号
    ${boardEntry}    Get Oid By Name    ${MibName}    boardRowStatus
    Log    ${boardEntry}
    @{hbpod_slots}    Get board of aom or som    som    ${boardEntry}    ${16}
    ${hbpod_slot}    Set Variable    @{hbpod_slots}[${board_num}]
    # 配置connect 参数
    ${host}    Run Keyword If    ${pid}==${11}    Evaluate    ${hbpod_slot} + ${pid}
    ...    ELSE IF    ${pid}==${21}    Evaluate    ${hbpod_slot} + ${pid}
    ...    ELSE    Evaluate    ${hbpod_slot} + ${1}
    ${ip_address}    Catenate    SEPARATOR=.    ${hbpod_address_base}    ${host}
    ${pid}    Set Variable    ${pid}
    # connect
    ${ret}    Run Keyword If    ${pid}==${11}    Connect Device By UAgent Use Pid    hbpod ${pid}    ${ip_address}    ${0}
    ...    ELSE IF    ${pid}==${21}    Connect Device By UAgent Use Pid    hbpod ${pid}    ${ip_address}    ${0}
    ...    ELSE    Connect Device By UAgent Use Pid    hbpod bcp ${pid}    ${ip_address}    ${pid}
    Should be equal    ${ret}    ${0}


Remote Login HSCTD Process
    [documentation]    链接主控板个处理器进程 pid : x86-> 2-5
    [arguments]    ${pid}
    # 获取主控槽位号
    ${boardEntry}    Get Oid By Name    ${MibName}    boardRowStatus
    Log    ${boardEntry}
    @{aom_slotNo_list}    Get board of aom or som    aom    ${boardEntry}    ${16}
    ${hsctd_slot}   Set Variable    @{aom_slotNo_list}[0]
    ${hsctd_slot}    Evaluate    int(${hsctd_slot})
    # connect
    ${ret}=    Connect Device By UAgent Use Pid    scp ${pid}
    ...    ${host_address}    ${pid}    ${hsctd_slot}    ${0}
    Should be equal    ${ret}    ${0}

Remote Login HBPOD Process
    [documentation]    链接基带板个处理器进程 pid : x86-> 2-8  plp1-> 11  plp2-> 21
    ...    board_num: 基带板序号  多基带板时使用
    [arguments]    ${pid}    ${board_num}=${0}
    # 获取基带槽位号
    ${boardEntry}    Get Oid By Name    ${MibName}    boardRowStatus
    Log    ${boardEntry}
    @{hbpod_slots}    Get board of aom or som    som    ${boardEntry}    ${16}
    ${hbpod_slot}    Set Variable    @{hbpod_slots}[${board_num}]
    ${hbpod_slot}    Evaluate    int(${hbpod_slot})

    log    ${hbpod_slot}
    # connect
    ${ret}    Run Keyword If    ${pid}==${11}        Connect Device By UAgent Use Pid    hbpod ${pid}
    ...    ${host_address}    ${0}    ${hbpod_slot}    ${8}
    ...    ELSE IF    ${pid}==${21}        Connect Device By UAgent Use Pid    hbpod ${pid}
    ...    ${host_address}    ${0}    ${hbpod_slot}    ${10}
    ...    ELSE        Connect Device By UAgent Use Pid    hbpod ${pid}
    ...    ${host_address}    ${pid}    ${hbpod_slot}    ${0}
    Should be equal    ${ret}    ${0}