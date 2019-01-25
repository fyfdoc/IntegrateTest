# encoding utf-8

# @company: Datang Mobile
# @license: (c) Copyright 2018, Datang Mobile
# @author: sunshixu
# @file:    portCfg.robot
# @desc: TSP 测试

*** Settings ***
Resource    ../../../resources/LogInHelper.robot
Suite Setup    Open Snmp Connection And Load Private MIB    ${host_address}    ${Community}    ${MibName}

*** Test Cases ***
# 连接设备
Connect
    Remote Login HSCTD Process    ${2}

记录PHY口默认速率
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    npPortGetCfgTest    ${0}    <60>
    Log    ${execute_result}
    ${result}    Evaluate    struct.unpack('IIIIIIIIIIIIIII', ${reslut_list}[0])    struct
    ${rate}    Evaluate    ${result}[2]
    Set Suite Variable    ${default_rate}    ${rate}
    Should Be Equal    ${execute_result}    ${0}
# npPortConfigChgTest 0,3001
配置PHY口速率
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    npPortConfigChgTest    ${0}    ${3001}
    Log    ${execute_result}
    Should Be Equal    ${execute_result}    ${0}
# npPortGetCfgTest 0,0x7fff6c0012b0
检查配置是否成功
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    npPortGetCfgTest    ${0}    <60>
    Log    ${execute_result}
    ${result}    Evaluate    struct.unpack('IIIIIIIIIIIIIII', ${reslut_list}[0])    struct
    ${rate}    Evaluate    ${result}[2]
    Should Be Equal    ${rate}    ${3001}
    Should Be Equal    ${execute_result}    ${0}
恢复PHY口默认速率
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    npPortConfigChgTest    ${0}    ${default_rate}
    Log    ${execute_result}
    Should Be Equal    ${execute_result}    ${0}

# npGetPortTest
PHY口状态查询功能测试
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    npGetPortTest
    Log    ${execute_result}
    Should Be Equal    ${execute_result}    ${0}

Disconnect
    Disconnect UAgent Use Pid


