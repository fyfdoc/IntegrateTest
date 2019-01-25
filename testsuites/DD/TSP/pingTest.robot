# encoding utf-8

# @company: Datang Mobile
# @license: (c) Copyright 2018, Datang Mobile
# @author: sunshixu
# @file:    pingTest.robot
# @desc: TSP 测试

*** Settings ***
Resource    ../../../resources/LogInHelper.robot
Suite Setup    Open Snmp Connection And Load Private MIB    ${host_address}    ${Community}    ${MibName}

*** Test Cases ***
# 连接设备
Connect
    Remote Login HSCTD Process    ${2}

# nh_set_ping_test "192.168.1.5", "192.168.1.100", 1000,1000,128,20,0
NpHost Set Ping DF
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    nh_set_ping_test
    ...    '192.168.1.5\n'    '192.168.1.100\n'   ${1000}    ${1000}    ${128}    ${20}    ${0}
    Log    ${execute_result}
    Should Be Equal    ${execute_result}    ${0}
# nhIsPingRelpyTest
Is Ping Relpy DF
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    nhIsPingRelpyTest
    Log    ${execute_result}
    Should Be Equal    ${execute_result}    ${0}
# nh_del_ping_test "192.168.1.5", "192.168.1.100"
NpHost Del Ping DF
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    nh_del_ping_test
    ...    '192.168.1.5\n'    '192.168.1.100\n'
    Log    ${execute_result}
    Should Be Equal    ${execute_result}    ${0}

# nh_set_ping_test "192.168.1.5", "192.168.1.100", 1000,1000,2000,20,0
NpHost Set Ping F
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    nh_set_ping_test
    ...    '192.168.1.5\n'    '192.168.1.100\n'   ${1000}    ${1000}    ${2000}    ${20}    ${0}
    Log    ${execute_result}
    Should Be Equal    ${execute_result}    ${0}
# nhIsPingRelpyTest
Is Ping Relpy F
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    nhIsPingRelpyTest
    Log    ${execute_result}
    Should Be Equal    ${execute_result}    ${0}
# nh_del_ping_test "192.168.1.5", "192.168.1.100"
NpHost Del Ping F
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    nh_del_ping_test
    ...    '192.168.1.5\n'    '192.168.1.100\n'
    Log    ${execute_result}
    Should Be Equal    ${execute_result}    ${0}


Disconnect
    Disconnect UAgent Use Pid

