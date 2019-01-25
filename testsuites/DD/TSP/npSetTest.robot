
# @company: Datang Mobile
# @license: (c) Copyright 2018, Datang Mobile
# @author: sunshixu
# @file:    addFlow.robot
# @desc: TSP测试 np  channel 、 flow 删建

*** Settings ***
Resource    ../../../resources/LogInHelper.robot
Suite Setup    Open Snmp Connection And Load Private MIB    ${DeviceIp}    ${Community}    ${MibName}


*** Test Cases ***

资源构建 & Channel 测试
    Local Login HSCTD Process    ${2}
    CHANNEL TEST
    配置添加Channel_Construct
    无对端模式增加设置MAC功能_Construct

UDP FLOW TEST
    配置添加一条UDP FLOW
    查询配置的UDP FLOW
    删除配置的UDP FLOW
    查询删除的UDP FLOW

GTPU FLOW TEST
    配置添加一条GTPU FLOW
    查询配置的GTPU FLOW
    删除配置的GTPU FLOW
    查询删除的GTPU FLOW

ROUTE FLOW TEST
    配置添加一条ROUTE FLOW
    查询配置的ROUTE FLOW
    删除配置的ROUTE FLOW
    查询删除的ROUTE FLOW

SCTP FLOW TEST
    配置添加一条SCTP FLOW
    查询配置的SCTP FLOW
    删除配置的SCTP FLOW
    查询删除的SCTP FLOW

IPV6 DOWN TRAFFIC FLOW TEST
    配置添加一条IPV6 DOWN TRAFFIC FLOW
    查询配置的IPV6 DOWN TRAFFIC FLOW
    删除配置的IPV6 DOWN TRAFFIC FLOW
    查询删除的IPV6 DOWN TRAFFIC FLOW

IPV6 UP TRAFFIC FLOW TEST
    配置添加一条IPV6 UP TRAFFIC FLOW
    查询配置的IPV6 UP TRAFFIC FLOW
    删除配置的IPV6 UP TRAFFIC FLOW
    查询删除的IPV6 UP TRAFFIC FLOW

IPV6 UDP FLOW TEST
    配置添加一条IPV6 UDP FLOW
    查询配置的IPV6 UDP FLOW
    删除配置的IPV6 UDP FLOW
    查询删除的IPV6 UDP FLOW

IPV6 GTPU FLOW TEST
    配置添加一条IPV6 GTPU FLOW
    查询配置的IPV6 GTPU FLOW
    删除配置的IPV6 GTPU FLOW
    查询删除的IPV6 GTPU FLOW

IPV6 ROUTE FLOW TEST
    配置添加一条IPV6 ROUTE FLOW
    查询配置的IPV6 ROUTE FLOW
    删除配置的IPV6 ROUTE FLOW
    查询删除的IPV6 ROUTE FLOW

IPV6 SCTP FLOW TEST
    配置添加一条IPV6 SCTP FLOW
    查询配置的IPV6 SCTP FLOW
    删除配置的IPV6 SCTP FLOW
    查询删除的IPV6 SCTP FLOW

REMOTE ACCESS FLOW TEST
    配置添加一条REMOTE ACCESS FLOW
    查询配置的REMOTE ACCESS FLOW
    删除配置的REMOTE ACCESS FLOW
    查询删除的REMOTE ACCESS FLOW

REMOTE FTP CONTROL CATCH FLOW TEST
    配置添加一条REMOTE FTP CONTROL CATCH FLOW
    查询配置的REMOTE FTP CONTROL CATCH FLOW
    删除配置的REMOTE FTP CONTROL CATCH FLOW
    查询删除的REMOTE FTP CONTROL CATCH FLOW

REMOTE FTP CONTROL FLOW TEST
    配置添加一条REMOTE FTP CONTROL FLOW
    查询配置的REMOTE FTP CONTROL FLOW
    删除配置的REMOTE FTP CONTROL FLOW
    查询删除的REMOTE FTP CONTROL FLOW

REMOTE FTP DATA FLOW TEST
    配置添加一条REMOTE FTP DATA FLOW
    查询配置的REMOTE FTP DATA FLOW
    删除配置的REMOTE FTP DATA FLOW
    查询删除的REMOTE FTP DATA FLOW

NB REMOTE NB FLOW TEST
    配置添加一条NB REMOTE NB FLOW
    查询配置的NB REMOTE NB FLOW
    删除配置的NB REMOTE NB FLOW
    查询删除的NB REMOTE NB FLOW

COMP JT FLOW TEST
    配置添加一条COMP JT FLOW
    查询配置的COMP JT FLOW
    删除配置的COMP JT FLOW
    查询删除的COMP JT FLOW

DOWN TRAFFIC FLOW TEST
    配置添加一条DOWN TRAFFIC FLOW
    查询配置的DOWN TRAFFIC FLOW
    删除配置的DOWN TRAFFIC FLOW
    查询删除的DOWN TRAFFIC FLOW

DOWN GTPC FLOW TEST
    配置添加一条DOWN GTPC FLOW
    查询配置的DOWN GTPC FLOW
    删除配置的DOWN GTPC FLOW
    查询删除的DOWN GTPC FLOW

# F1 FLOW TEST
    # F1 FLOW
    # F1 FLOW
    # F1 FLOW4

UP TRAFFIC FLOW TEST
    配置添加一条UP TRAFFIC FLOW
    查询配置的UP TRAFFIC FLOW
    删除配置的UP TRAFFIC FLOW
    查询删除的UP TRAFFIC FLOW

IPV6 REMOTE ACCESS FLOW TEST
    配置添加一条IPV6 REMOTE ACCESS FLOW
    查询配置的IPV6 REMOTE ACCESS FLOW
    删除配置的IPV6 REMOTE ACCESS FLOW
    查询删除的IPV6 REMOTE ACCESS FLOW

IPV6 REMOTE FTP CONTROL CATCH FLOW TEST
    配置添加一条IPV6 REMOTE FTP CONTROL CATCH FLOW
    查询配置的IPV6 REMOTE FTP CONTROL CATCH FLOW
    删除配置的IPV6 REMOTE FTP CONTROL CATCH FLOW
    查询删除的IPV6 REMOTE FTP CONTROL CATCH FLOW

IPV6 REMOTE FTP CONTROL FLOW TEST
    配置添加一条IPV6 REMOTE FTP CONTROL FLOW
    查询配置的IPV6 REMOTE FTP CONTROL FLOW
    删除配置的IPV6 REMOTE FTP CONTROL FLOW
    查询删除的IPV6 REMOTE FTP CONTROL FLOW

IPV6 REMOTE FTP DATA FLOW TEST
    配置添加一条IPV6 REMOTE FTP DATA FLOW
    查询配置的IPV6 REMOTE FTP DATA FLOW
    删除配置的IPV6 REMOTE FTP DATA FLOW
    查询删除的IPV6 REMOTE FTP DATA FLOW

资源销毁
    删除配置的channel_Destruct
    Disconnect UAgent Use Pid









*** Keywords ***

# *************** Construct & Desturct **************

配置添加Channel_Construct
    ${execute_result}=    Execute Command by UAgent    npAddChan    ${0}    ${99}    ${20000}
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}

删除配置的channel_Destruct
    ${execute_result}=    Execute Command by UAgent    npDelChan    ${0}    ${99}
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}

无对端模式增加设置MAC功能_Construct
    ${execute_result}=    Execute Command by UAgent    npSetMac    '00:11:22:33:44:55\n'    '00:01:02:03:04:05\n'
    ...    '00:11:22:33:44:55\n'    '00:01:02:03:04:05\n'
    Log    ${execute_result}


# ************************ Channel *******************************
配置并添加一条channel
    ${execute_result}=    Execute Command by UAgent    npAddChan    ${0}    ${99}    ${20000}
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}

配置后查找channel
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    np_is_chan_exist    ${99}
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}

删除配置的channel
    ${execute_result}=    Execute Command by UAgent    npDelChan    ${0}    ${99}
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}

删除后查找channel
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    np_is_chan_exist    ${99}
    Log    ${execute_result}
    Should Not Be Equal    ${execute_result}    ${0}

CHANNEL TEST
    配置并添加一条channel
    配置后查找channel
    删除配置的channel
    删除后查找channel


# **************** 配置FLOW ****************
配置添加一条UDP FLOW
    ${execute_result}=    Execute Command by UAgent    npAddUdpFlow    ${99}    ${0}
    ...    ${0xc0a80003}    ${0xc0a80001}    ${40000}    ${20003}
    ...    ${0x0a0001c1}    ${0x0a0004c3}    ${2152}    ${2152}    ${1}
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}

配置添加一条GTPU FLOW
    ${execute_result}=    Execute Command by UAgent    npAddGtpuFlow    ${99}    ${0}
    ...    ${0xc0a80002}    ${0xc0a80001}    ${2152}    ${2152}    ${3}    ${3}
    ...    ${0x0a0001c1}    ${0x0a0004c3}    ${40000}    ${20003}    ${1}
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}

配置添加一条ROUTE FLOW
    ${execute_result}=    Execute Command by UAgent    npAddRouteFlow    ${99}    ${55}
    ...    ${0xc0a80003}    ${0xc0a80001}    ${0x0a0001c1}    ${0x0a0004c3}    ${1}
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}

配置添加一条SCTP FLOW
    ${execute_result}=    Execute Command by UAgent    npAddSctpFlow    ${99}    ${20}
    ...    ${0xc0a80003}    ${0xc0a80001}    ${36412}    ${36412}
    ...    ${0x0a0001c1}    ${0x0a0004c3}    ${36412}    ${36412}    ${1}
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}

配置添加一条IPV6 DOWN TRAFFIC FLOW
    ${execute_result}=    Execute Command by UAgent    npAddIpv6DownTrafficFlow    ${5}
    ...    ${0x20010011}    ${0}    ${0}    ${0x9}    ${0x20010011}    ${0}    ${0}    ${0x3}
    ...    ${2152}    ${2152}    ${192}    ${0}    ${0x0a0001c1}    ${0x0a0006c1}
    ...    ${40000}    ${20003}    ${1}
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}
# npAddIpv6UpTrafficFlow 99,10,0x20010011,0,0,0x9,0x20010011,0,0,3,2152,2152,0
配置添加一条IPV6 UP TRAFFIC FLOW
    ${execute_result}=    Execute Command by UAgent    npAddIpv6UpTrafficFlow    ${99}
    ...    ${10}    ${0x20010011}    ${0}    ${0}    ${0x9}    ${0x20010011}    ${0}    ${0}
    ...    ${3}    ${2152}    ${2152}
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}
# npAddIpv6UdpFlow 99,2,0x20010011,0,0,0x9,0x20010011,0,0,0x3,9378,9143,0xc101000a,0xc106000a,9378,9143,1
配置添加一条IPV6 UDP FLOW
    ${execute_result}=    Execute Command by UAgent    npAddIpv6UdpFlow    ${99}
    ...    ${2}    ${0x20010011}    ${0}    ${0}    ${9}    ${0x20010011}    ${0}    ${0}
    ...    ${3}    ${9378}    ${9143}    ${0xc101000a}    ${0xc106000a}
    ...    ${9378}    ${9143}    ${1}
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}
# npAddipv6gtpuFlow 99,0,0x20010011,0,0,9,0x20010011,0,0,3,2152,2152,0,0,0x0a0001c1,0x0a0006c0,40000,20000,1
配置添加一条IPV6 GTPU FLOW
    ${execute_result}=    Execute Command by UAgent    npAddipv6gtpuFlow    ${99}
    ...    ${0}    ${0x20010011}    ${0}    ${0}    ${9}    ${0x20010011}    ${0}    ${0}
    ...    ${3}    ${2152}    ${2152}    ${0}    ${0}    ${0x0a0001c1}    ${0x0a0006c0}
    ...    ${40000}    ${20000}    ${1}
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}
# npAddipv6routeFlow 99,0,0x20010011,0,0,9,0x20010011,0,0,3,1
配置添加一条IPV6 ROUTE FLOW
    ${execute_result}=    Execute Command by UAgent    npAddipv6routeFlow    ${99}
    ...    ${60}    ${0x20010011}    ${0}    ${0}    ${9}    ${0x20010011}    ${0}    ${0}
    ...    ${3}    ${1}
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}
# npAddipv6sctpFlow 99,0,0x20010011,0,0,0x9,0x20010011,0,0,0x3,36422,36422,36422,36422,1
配置添加一条IPV6 SCTP FLOW
    ${execute_result}=    Execute Command by UAgent    npAddipv6sctpFlow    ${99}
    ...    ${0}    ${0x20010011}    ${0}    ${0}    ${9}    ${0x20010011}    ${0}    ${0}
    ...    ${3}    ${36422}    ${36422}    ${36422}    ${36422}    ${1}
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}
# npAddremoteAccessFlow 99,0,0xc0a80005,0xc0a80006,20000,20000,0xc0a80005,0xc0a80006,20000,20000,2
配置添加一条REMOTE ACCESS FLOW
    ${execute_result}=    Execute Command by UAgent    npAddremoteAccessFlow    ${99}
    ...    ${0}    ${0xc0a80005}    ${0xc0a80006}    ${20000}    ${20000}
    ...    ${0xc0a80005}    ${0xc0a80006}    ${20000}    ${20000}    ${2}
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}
# npAddremoteFtpControlCatchFlow 0,0xac1b016f,0xc0a80006,21,0,0
配置添加一条REMOTE FTP CONTROL CATCH FLOW
    ${execute_result}=    Execute Command by UAgent    npAddremoteFtpControlCatchFlow
    ...    ${0}    ${0xac1b016f}    ${0xc0a80006}    ${21}    ${0}    ${0}
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}
# npAddremoteFtpControlFlow 0,0xc0a80005,0xc0a80006,21,0,0xc0a80005,0xc0a80006,21,0,2
配置添加一条REMOTE FTP CONTROL FLOW
    ${execute_result}=    Execute Command by UAgent    npAddremoteFtpControlFlow
    ...    ${0}    ${0xc0a80005}    ${0xc0a80006}    ${21}    ${0}
    ...    ${0xc0a80005}    ${0xc0a80006}    ${21}    ${0}    ${2}
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}
# npAddremoteFtpDataFlow 99,0,0xc0a80005,0xc0a80006,21,0,0xc0a80005,0xc0a80006,21,0,2
配置添加一条REMOTE FTP DATA FLOW
    ${execute_result}=    Execute Command by UAgent    npAddremoteFtpDataFlow    ${99}
    ...    ${0}    ${0xc0a80005}    ${0xc0a80006}    ${21}    ${0}
    ...    ${0xc0a80005}    ${0xc0a80006}    ${21}    ${0}    ${2}
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}
# npAddNbRemoteNbFlow 0,0x0a0001c1, 0x0a0001c0,0xc0a80005,0xc0a80006
配置添加一条NB REMOTE NB FLOW
    ${execute_result}=    Execute Command by UAgent    npAddNbRemoteNbFlow
    ...    ${0}    ${0xc0a80005}    ${0xc0a80006}
    ...    ${0xc0a80005}    ${0xc0a80006}
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}
# npAddCompJtFlow 99, 0, 0xC0A80005, 0xC0A80001, 5, 2, 6, 0x0a0001c1, 0x0a0004c7, 1
配置添加一条COMP JT FLOW
    ${execute_result}=    Execute Command by UAgent    npAddCompJtFlow    ${99}
    ...    ${0}    ${0xC0A80005}    ${0xC0A80001}    ${5}    ${2}    ${6}
    ...    ${0x0a0001c1}    ${0x0a0004c7}    ${1}
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}
# npAddDownTrafficFlow 0, 0x01010100, 0x0a0a0a0a, 2152, 2152, 0x42,0, 0x0a0001c1, 0x0a0004c7, 40000, 20003, 1
配置添加一条DOWN TRAFFIC FLOW
    ${execute_result}=    Execute Command by UAgent    npAddDownTrafficFlow
    ...    ${0}    ${0x01010100}    ${0x0a0a0a0a}    ${2152}    ${2152}    ${0x42}    ${0}
    ...    ${0x0a0001c1}    ${0x0a0004c7}    ${40000}    ${20003}    ${1}
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}
# npAddDownGtpcFlow 0, 0x01010100, 0x0a0a0a0a, 2152, 2152, 0, 0, 0x0a0001c1, 0x0a0004c7, 40000, 20003, 1
配置添加一条DOWN GTPC FLOW
    ${execute_result}=    Execute Command by UAgent    npAddDownGtpcFlow
    ...    ${0}    ${0x01010100}    ${0x0a0a0a0a}    ${2152}    ${2152}    ${0}    ${0}
    ...    ${0x0a0001c1}    ${0x0a0004c7}    ${40000}    ${20003}    ${1}
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}
# npAddUpTrafficFlow 99, 0, 0xC0A80000, 0xC0A80001, 2152, 2152, 0
配置添加一条UP TRAFFIC FLOW
    ${execute_result}=    Execute Command by UAgent    npAddUpTrafficFlow    ${99}
    ...    ${0}    ${0xC0A80000}    ${0xC0A80001}    ${2152}    ${2152}    ${0}
    Should be equal    ${execute_result}    ${0}
# npAddIpv6RemoteAccessFlow 0,0,0x20010011,0,0,0x9,0x20010011,0,0,0x3, 40000, 20003, 0xc0a80001, 0xc0a80002, 40000,20003
配置添加一条IPV6 REMOTE ACCESS FLOW
    ${execute_result}=    Execute Command by UAgent    npAddIpv6RemoteAccessFlow    ${99}
    ...    ${0}    ${0x20010011}    ${0}    ${0}    ${9}    ${0x20010011}    ${0}    ${0}    ${3}
    ...    ${40000}    ${20003}    ${0xc0a80001}    ${0xc0a80002}    ${40000}    ${20003}
    Should be equal    ${execute_result}    ${0}
# npAddIpv6remoteFtpControlCatchFlow 0, 0xC0A80000, 0xC0A80001, 0, 0
配置添加一条IPV6 REMOTE FTP CONTROL CATCH FLOW
    ${execute_result}=    Execute Command by UAgent    npAddIpv6remoteFtpControlCatchFlow
    ...    ${0}    ${0xC0A80000}    ${0xC0A80001}    ${0}    ${0}
    Should be equal    ${execute_result}    ${0}
# npAddIpv6RemoteFtpControlFlow 0,0,0x20010011,0,0,0x9,0x20010011,0,0,0x3, 40000, 20003, 0xc0a80001, 0xc0a80002, 40000,20003
配置添加一条IPV6 REMOTE FTP CONTROL FLOW
    ${execute_result}=    Execute Command by UAgent    npAddIpv6RemoteFtpControlFlow    ${99}
    ...    ${0}    ${0x20010011}    ${0}    ${0}    ${9}    ${0x20010011}    ${0}    ${0}    ${3}
    ...    ${40000}    ${20003}    ${0xc0a80001}    ${0xc0a80002}    ${40000}    ${20003}
    Should be equal    ${execute_result}    ${0}
# npAddIpv6RemoteFtpDataFlow 0,0,0x20010011,0,0,0x9,0x20010011,0,0,0x3, 40000, 20003, 0xc0a80001, 0xc0a80002, 40000,20003
配置添加一条IPV6 REMOTE FTP DATA FLOW
    ${execute_result}=    Execute Command by UAgent    npAddIpv6RemoteFtpDataFlow    ${99}
    ...    ${0}    ${0x20010011}    ${0}    ${0}    ${9}    ${0x20010011}    ${0}    ${0}    ${3}
    ...    ${40000}    ${20003}    ${0xc0a80001}    ${0xc0a80002}    ${40000}    ${20003}
    Should be equal    ${execute_result}    ${0}





# ******************* 查询FLow ***************
查询配置的UDP FLOW
    ${flow_id}    Evaluate    1 << 25 | 99
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    np_is_flow_exist    ${flow_id}
    ...    <16,[N;1;0;192],[N;1;1;168],[N;1;2;0],[N;1;3;3],[N;1;4;192],[N;1;5;168],[N;1;6;0],[N;1;7;1],[N;2;8;40000],[N;2;10;20003]>
    ...    <16>    ${1}
    Log    ${execute_result}
    Should Be Equal    ${execute_result}    ${1}

查询删除的UDP FLOW
    ${flow_id}    Evaluate    1 << 25 | 99
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    np_is_flow_exist    ${flow_id}
    ...    <16,[N;1;0;192],[N;1;1;168],[N;1;2;0],[N;1;3;3],[N;1;4;192],[N;1;5;168],[N;1;6;0],[N;1;7;1],[N;2;8;40000],[N;2;10;20003]>
    ...    <16>    ${1}
    Log    ${execute_result}
    Should Not Be Equal    ${execute_result}    ${1}

查询配置的GTPU FLOW
    ${flow_id}    Evaluate    2 << 25 | 0  # 99 不存在 按端点匹配
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    np_is_flow_exist    ${flow_id}
    ...    <24,[N;1;0;192],[N;1;1;168],[N;1;2;0],[N;1;3;2],[N;1;4;192],[N;1;5;168],[N;1;6;0],[N;1;7;1],[N;2;8;2152],[N;2;10;2152],[N;4;12;3],[N;4;16;3]>
    ...    <24>    ${1}
    Log    ${execute_result}
    Should Be Equal    ${execute_result}    ${1}

查询删除的GTPU FLOW
    ${flow_id}    Evaluate    2 << 25 | 0  # 99 不存在 按端点匹配
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    np_is_flow_exist    ${flow_id}
    ...    <24,[N;1;0;192],[N;1;1;168],[N;1;2;0],[N;1;3;2],[N;1;4;192],[N;1;5;168],[N;1;6;0],[N;1;7;1],[N;2;8;2152],[N;2;10;2152],[N;4;12;3],[N;4;16;3]>
    ...    <24>    ${1}
    Log    ${execute_result}
    Should Not Be Equal    ${execute_result}    ${1}

查询配置的ROUTE FLOW
    ${flow_id}    Evaluate    3 << 25 | 99  # 99 不存在 按端点匹配
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    np_is_flow_exist    ${flow_id}
    ...    <12,[N;1;0;192],[N;1;1;168],[N;1;2;0],[N;1;3;3],[N;1;4;192],[N;1;5;168],[N;1;6;0],[N;1;7;1]>
    ...    <12>    ${1}
    Log    ${execute_result}
    Should Be Equal    ${execute_result}    ${1}

查询删除的ROUTE FLOW
    ${flow_id}    Evaluate    3 << 25 | 99  # 99 不存在 按端点匹配
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    np_is_flow_exist    ${flow_id}
    ...    <16,[N;1;0;192],[N;1;1;168],[N;1;2;0],[N;1;3;3],[N;1;4;192],[N;1;5;168],[N;1;6;0],[N;1;7;1]>
    ...    <16>    ${1}
    Log    ${execute_result}
    Should Not Be Equal    ${execute_result}    ${1}
# npAddSctpFlow    ${99}    ${0}
#     ...    ${0xc0a80003}    ${0xc0a80001}    ${36412}    ${36412}
#     ...    ${0x0a0001c1}    ${0x0a0004c3}    ${36412}    ${36412}    ${1}
查询配置的SCTP FLOW
    ${flow_id}    Evaluate    4 << 25 | 99
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    np_is_flow_exist    ${flow_id}
    ...    <16,[N;1;0;192],[N;1;1;168],[N;1;2;0],[N;1;3;3],[N;1;4;192],[N;1;5;168],[N;1;6;0],[N;1;7;1],[N;2;8;36412],[N;2;10;36412]>
    ...    <16>    ${1}
    Log    ${execute_result}
    Should Be Equal    ${execute_result}    ${1}

查询删除的SCTP FLOW
    ${flow_id}    Evaluate    4 << 25 | 99
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    np_is_flow_exist    ${flow_id}
    ...    <16,[N;1;0;192],[N;1;1;168],[N;1;2;0],[N;1;3;3],[N;1;4;192],[N;1;5;168],[N;1;6;0],[N;1;7;1],[N;2;8;36412],[N;2;10;36412]>
    ...    <16>    ${1}
    Log    ${execute_result}
    Should Not Be Equal    ${execute_result}    ${1}

查询配置的IPV6 DOWN TRAFFIC FLOW
    ${flow_id}    Evaluate    11 << 25 | 99    #pdcp 192 << 2  == 769
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    np_is_flow_exist    ${flow_id}
    ...    <40,[N;4;0;536936465],[N;4;4;0],[N;4;8;0],[N;4;12;9],[N;4;16;536936465],[N;4;20;0],[N;4;24;0],[N;4;28;3],[N;2;32;2152],[N;2;34;2152],[N;2;36;768]>
    ...    <40>    ${1}
    Log    ${execute_result}
    Should Be Equal    ${execute_result}    ${1}

查询删除的IPV6 DOWN TRAFFIC FLOW
    ${flow_id}    Evaluate    11 << 25 | 99
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    np_is_flow_exist    ${flow_id}
    ...    <40,[N;4;0;536936465],[N;4;4;0],[N;4;8;0],[N;4;12;9],[N;4;16;536936465],[N;4;20;0],[N;4;24;0],[N;4;28;3],[N;2;32;2152],[N;2;34;2152],[N;2;36;768]>
    ...    <40>    ${1}
    Log    ${execute_result}
    Should Not Be Equal    ${execute_result}    ${1}
# npAddIpv6UpTrafficFlow 0,10,0x20010011,0,0,0x9,0x20010011,0,0,3,2152,2152,0
查询配置的IPV6 UP TRAFFIC FLOW
    ${flow_id}    Evaluate    12 << 25 | 99
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    np_is_flow_exist    ${flow_id}
    ...    <48,[N;4;0;285212960],[N;4;4;0],[N;4;8;0],[N;4;12;150994944],[N;4;16;285212960],[N;4;20;0],[N;4;24;0],[N;4;28;3],[N;2;32;2152],[N;2;34;2152],[N;4;36;0],[N;4;40;0]>
    ...    <48>    ${0}
    Log    ${execute_result}
    Should Be Equal    ${execute_result}    ${1}

查询删除的IPV6 UP TRAFFIC FLOW
    ${flow_id}    Evaluate    12 << 25 | 99
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    np_is_flow_exist    ${flow_id}
    ...    <48,[N;4;0;285212960],[N;4;4;0],[N;4;8;0],[N;4;12;150994944],[N;4;16;285212960],[N;4;20;0],[N;4;24;0],[N;4;28;3],[N;2;32;2152],[N;2;34;2152],[N;2;36;768]>
    ...    <48>    ${0}
    Log    ${execute_result}
    Should Not Be Equal    ${execute_result}    ${1}
# npAddIpv6UdpFlow 99,2,0x20010011,0,0,0x9,0x20010011,0,0,0x3,9378,9143,0xc101000a,0xc106000a,9378,9143,1
查询配置的IPV6 UDP FLOW
    ${flow_id}    Evaluate    13 << 25 | 99
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    np_is_flow_exist    ${flow_id}
    ...    <40,[N;4;0;285212960],[N;4;4;0],[N;4;8;0],[N;4;12;150994944],[N;4;16;285212960],[N;4;20;0],[N;4;24;0],[N;4;28;50331648],[N;2;32;9378],[N;2;34;9143]>
    ...    <16>    ${1}
    Log    ${execute_result}
    Should Be Equal    ${execute_result}    ${1}

查询删除的IPV6 UDP FLOW
    ${flow_id}    Evaluate    13 << 25 | 99
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    np_is_flow_exist    ${flow_id}
    ...    <40,[N;4;0;285212960],[N;4;4;0],[N;4;8;0],[N;4;12;150994944],[N;4;16;285212960],[N;4;20;0],[N;4;24;0],[N;4;28;50331648],[N;2;32;9378],[N;2;34;9143]>
    ...    <16>    ${1}
    Log    ${execute_result}
    Should Not Be Equal    ${execute_result}    ${1}

查询配置的IPV6 GTPU FLOW
    ${flow_id}    Evaluate    14 << 25 | 0
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    np_is_flow_exist    ${flow_id}
    ...    <48>
    ...    <24>    ${1}
    Log    ${execute_result}
    Should Be Equal    ${execute_result}    ${1}

查询删除的IPV6 GTPU FLOW
    ${flow_id}    Evaluate    14 << 25 | 0
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    np_is_flow_exist    ${flow_id}
    ...    <48>
    ...    <24>    ${1}
    Log    ${execute_result}
    Should Not Be Equal    ${execute_result}    ${1}

查询配置的IPV6 ROUTE FLOW
    ${flow_id}    Evaluate    15 << 25 | 99
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    np_is_flow_exist    ${flow_id}
    ...    <36,[N;4;0;285212960],[N;4;4;0],[N;4;8;0],[N;4;12;150994944],[N;4;16;285212960],[N;4;20;0],[N;4;24;0],[N;4;28;50331648]>
    ...    <36>    ${1}
    Log    ${execute_result}
    Should Be Equal    ${execute_result}    ${1}

查询删除的IPV6 ROUTE FLOW
    ${flow_id}    Evaluate    15 << 25 | 99
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    np_is_flow_exist    ${flow_id}
    ...    <36,[N;4;0;285212960],[N;4;4;0],[N;4;8;0],[N;4;12;150994944],[N;4;16;285212960],[N;4;20;0],[N;4;24;0],[N;4;28;50331648]>
    ...    <36>    ${1}
    Log    ${execute_result}
    Should Not Be Equal    ${execute_result}    ${1}
# npAddipv6sctpFlow 99,0,0x20010011,0,0,0x9,0x20010011,0,0,0x3,36422,36422,36422,36422,1
查询配置的IPV6 SCTP FLOW
    ${flow_id}    Evaluate    16 << 25 | 99
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    np_is_flow_exist    ${flow_id}
    ...    <40,[N;4;0;285212960],[N;4;4;0],[N;4;8;0],[N;4;12;150994944],[N;4;16;285212960],[N;4;20;0],[N;4;24;0],[N;4;28;50331648],[N;2;32;36422],[N;2;34;36422]>
    ...    <16>    ${1}
    Log    ${execute_result}
    Should Be Equal    ${execute_result}    ${1}

查询删除的IPV6 SCTP FLOW
    ${flow_id}    Evaluate    16 << 25 | 99
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    np_is_flow_exist    ${flow_id}
    ...    <40,[N;4;0;285212960],[N;4;4;0],[N;4;8;0],[N;4;12;150994944],[N;4;16;285212960],[N;4;20;0],[N;4;24;0],[N;4;28;50331648],[N;2;32;36422],[N;2;34;36422]>
    ...    <16>    ${1}
    Log    ${execute_result}
    Should Not Be Equal    ${execute_result}    ${1}

查询配置的REMOTE ACCESS FLOW
    ${flow_id}    Evaluate    17 << 25 | 0
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    np_is_flow_exist    ${flow_id}
    ...    <40>
    ...    <16>    ${2}
    Log    ${execute_result}
    Should Be Equal    ${execute_result}    ${1}

查询删除的REMOTE ACCESS FLOW
    ${flow_id}    Evaluate    17 << 25 | 0
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    np_is_flow_exist    ${flow_id}
    ...    <40>
    ...    <16>    ${2}
    Log    ${execute_result}
    Should Not Be Equal    ${execute_result}    ${1}

查询配置的REMOTE FTP CONTROL CATCH FLOW
    ${flow_id}    Evaluate    18 << 25 | 0
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    np_is_flow_exist    ${flow_id}
    ...    <40>
    ...    <16>    ${2}
    Log    ${execute_result}
    Should Be Equal    ${execute_result}    ${1}

查询删除的REMOTE FTP CONTROL CATCH FLOW
    ${flow_id}    Evaluate    18 << 25 | 0
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    np_is_flow_exist    ${flow_id}
    ...    <40>
    ...    <16>    ${2}
    Log    ${execute_result}
    Should Not Be Equal    ${execute_result}    ${1}

查询配置的REMOTE FTP CONTROL FLOW
    ${flow_id}    Evaluate    19 << 25 | 0
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    np_is_flow_exist    ${flow_id}
    ...    <40>
    ...    <16>    ${2}
    Log    ${execute_result}
    Should Be Equal    ${execute_result}    ${1}

查询删除的REMOTE FTP CONTROL FLOW
    ${flow_id}    Evaluate    19 << 25 | 0
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    np_is_flow_exist    ${flow_id}
    ...    <40>
    ...    <16>    ${2}
    Log    ${execute_result}
    Should Not Be Equal    ${execute_result}    ${1}

查询配置的REMOTE FTP DATA FLOW
    ${flow_id}    Evaluate    20 << 25 | 0
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    np_is_flow_exist    ${flow_id}
    ...    <40>
    ...    <16>    ${2}
    Log    ${execute_result}
    Should Be Equal    ${execute_result}    ${1}

查询删除的REMOTE FTP DATA FLOW
    ${flow_id}    Evaluate    20 << 25 | 0
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    np_is_flow_exist    ${flow_id}
    ...    <40>
    ...    <16>    ${2}
    Log    ${execute_result}
    Should Not Be Equal    ${execute_result}    ${1}
# npAddNbRemoteNbFlow 0,0x0a0001c1, 0x0a0001c0,0xc0a80005,0xc0a80006
查询配置的NB REMOTE NB FLOW
    ${flow_id}    Evaluate    24 << 25 | 99
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    np_is_flow_exist    ${flow_id}
    ...    <12,[N;1;0;10],[N;1;1;0],[N;1;2;1],[N;1;3;193],[N;1;4;10],[N;1;5;0],[N;1;6;1],[N;1;7;192]>
    ...    <12,[N;1;0;192],[N;1;1;168],[N;1;2;0],[N;1;3;5],[N;1;4;192],[N;1;5;168],[N;1;6;0],[N;1;7;6]>    ${2}
    Log    ${execute_result}
    Should Be Equal    ${execute_result}    ${1}

查询删除的NB REMOTE NB FLOW
    ${flow_id}    Evaluate    24 << 25 | 99
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    np_is_flow_exist    ${flow_id}
    ...    <12,[N;1;0;10],[N;1;1;0],[N;1;2;1],[N;1;3;193],[N;1;4;10],[N;1;4;0],[N;1;6;1],[N;1;7;192]>
    ...    <12,[N;1;0;192],[N;1;1;168],[N;1;2;0],[N;1;3;5],[N;1;4;192],[N;1;4;168],[N;1;6;0],[N;1;7;6]>    ${2}
    Log    ${execute_result}
    Should Not Be Equal    ${execute_result}    ${1}
# npAddCompJtFlow 99, 0, 0xC0A80005, 0xC0A80001, 5, 2, 6, 0x0a0001c1, 0x0a0004c7, 1
查询配置的COMP JT FLOW
    ${flow_id}    Evaluate    25 << 25 | 99
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    np_is_flow_exist    ${flow_id}
    ...    <20,[N;1;0;192],[N;1;1;168],[N;1;2;0],[N;1;3;5],[N;1;4;192],[N;1;5;168],[N;1;6;0],[N;1;7;1],[N;2;8;20000],[N;2;10;20000],[N;4;12;05],[N;1;16;2],[N;1;17;6],[N;1;18;0]>
    ...    <16,[N;1;0;10],[N;1;1;0],[N;1;2;1],[N;1;3;193],[N;1;4;10],[N;1;5;0],[N;1;6;4],[N;1;7;199],[N;2;8;8270],[N;2;10;8270]>    ${1}
    Log    ${execute_result}
    Should Be Equal    ${execute_result}    ${1}

查询删除的COMP JT FLOW
    ${flow_id}    Evaluate    25 << 25 | 99
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    np_is_flow_exist    ${flow_id}
    ...    <20,[N;1;0;192],[N;1;1;168],[N;1;2;0],[N;1;3;5],[N;1;4;192],[N;1;5;168],[N;1;6;0],[N;1;7;1],[N;2;8;20000],[N;2;10;20000],[N;4;12;05],[N;1;16;2],[N;1;17;6],[N;1;18;0]>
    ...    <16,[N;1;0;10],[N;1;1;0],[N;1;2;1],[N;1;3;193],[N;1;4;10],[N;1;5;0],[N;1;6;4],[N;1;7;199],[N;2;8;8270],[N;2;10;8270]>    ${1}
    Log    ${execute_result}
    Should Not Be Equal    ${execute_result}    ${1}


查询配置的DOWN TRAFFIC FLOW
    ${flow_id}    Evaluate    26 << 25 | 99
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    np_is_flow_exist    ${flow_id}
    ...    <18,[N;1;0;192],[N;1;1;168],[N;1;2;0],[N;1;3;5],[N;1;4;192],[N;1;5;168],[N;1;6;0],[N;1;7;1],[N;2;8;20000],[N;2;10;20000],[N;2;12;264]>
    ...    <16>    ${1}
    Log    ${execute_result}
    Should Be Equal    ${execute_result}    ${1}

查询删除的DOWN TRAFFIC FLOW
    ${flow_id}    Evaluate    26 << 25 | 99
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    np_is_flow_exist    ${flow_id}
    ...    <18,[N;1;0;192],[N;1;1;168],[N;1;2;0],[N;1;3;5],[N;1;4;192],[N;1;5;168],[N;1;6;0],[N;1;7;1],[N;2;8;20000],[N;2;10;20000],[N;2;12;264]>
    ...    <16>    ${1}
    Log    ${execute_result}
    Should Not Be Equal    ${execute_result}    ${1}
# npAddDownGtpcFlow 0, 0x01010100, 0x0a0a0a0a, 2152, 2152, 0, 0, 0x0a0001c1, 0x0a0004c7, 40000, 20003, 1
查询配置的DOWN GTPC FLOW
    ${flow_id}    Evaluate    27 << 25 | 99
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    np_is_flow_exist    ${flow_id}
    ...    <24,[N;1;0;1],[N;1;1;1],[N;1;2;1],[N;1;3;0],[N;1;4;10],[N;1;5;10],[N;1;6;10],[N;1;7;10],[N;2;8;2152],[N;2;10;2152],[N;4;12;0],[N;4;16;0]>
    ...    <16>    ${1}
    Log    ${execute_result}
    Should Be Equal    ${execute_result}    ${1}

查询删除的DOWN GTPC FLOW
    ${flow_id}    Evaluate    27 << 25 | 99
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    np_is_flow_exist    ${flow_id}
    ...    <24,[N;1;0;1],[N;1;1;1],[N;1;2;1],[N;1;3;0],[N;1;4;10],[N;1;5;10],[N;1;6;10],[N;1;7;10],[N;2;8;2152],[N;2;10;2152],[N;4;12;0],[N;4;16;0]>
    ...    <16>    ${1}
    Log    ${execute_result}
    Should Not Be Equal    ${execute_result}    ${1}
# npAddUpTrafficFlow 99, 0, 0xC0A80000, 0xC0A80001, 2152, 2152, 0
查询配置的UP TRAFFIC FLOW
    ${flow_id}    Evaluate    29 << 25 | 99
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    np_is_flow_exist    ${flow_id}
    ...    <24,[N;1;0;192],[N;1;1;168],[N;1;2;0],[N;1;3;0],[N;1;4;192],[N;1;5;168],[N;1;6;0],[N;1;7;1],[N;2;8;2152],[N;2;10;2152],[N;4;12;0],[N;4;16;0]>
    ...    <16>    ${0}
    Log    ${execute_result}
    Should Be Equal    ${execute_result}    ${1}

查询删除的UP TRAFFIC FLOW
    ${flow_id}    Evaluate    29 << 25 | 99
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    np_is_flow_exist    ${flow_id}
    ...    <24,[N;1;0;192],[N;1;1;168],[N;1;2;0],[N;1;3;0],[N;1;4;192],[N;1;5;168],[N;1;6;0],[N;1;7;1],[N;2;8;2152],[N;2;10;2152],[N;4;12;0],[N;4;16;0]>
    ...    <16>    ${0}
    Log    ${execute_result}
    Should Not Be Equal    ${execute_result}    ${1}

查询配置的IPV6 REMOTE ACCESS FLOW
    ${flow_id}    Evaluate    30 << 25 | 0
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    np_is_flow_exist    ${flow_id}
    ...    <24,[N;1;0;192],[N;1;1;168],[N;1;2;0],[N;1;3;0],[N;1;4;192],[N;1;5;168],[N;1;6;0],[N;1;7;1],[N;2;8;2152],[N;2;10;2152],[N;4;12;0],[N;4;16;0]>
    ...    <16>    ${0}
    Log    ${execute_result}
    Should Be Equal    ${execute_result}    ${1}

查询删除的IPV6 REMOTE ACCESS FLOW
    ${flow_id}    Evaluate    30 << 25 | 0
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    np_is_flow_exist    ${flow_id}
    ...    <24,[N;1;0;192],[N;1;1;168],[N;1;2;0],[N;1;3;0],[N;1;4;192],[N;1;5;168],[N;1;6;0],[N;1;7;1],[N;2;8;2152],[N;2;10;2152],[N;4;12;0],[N;4;16;0]>
    ...    <16>    ${0}
    Log    ${execute_result}
    Should Not Be Equal    ${execute_result}    ${1}

查询配置的IPV6 REMOTE FTP CONTROL CATCH FLOW
    ${flow_id}    Evaluate    31 << 25 | 0
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    np_is_flow_exist    ${flow_id}
    ...    <24,[N;1;0;192],[N;1;1;168],[N;1;2;0],[N;1;3;0],[N;1;4;192],[N;1;5;168],[N;1;6;0],[N;1;7;1],[N;2;8;2152],[N;2;10;2152],[N;4;12;0],[N;4;16;0]>
    ...    <16>    ${0}
    Log    ${execute_result}
    Should Be Equal    ${execute_result}    ${1}

查询删除的IPV6 REMOTE FTP CONTROL CATCH FLOW
    ${flow_id}    Evaluate    31 << 25 | 0
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    np_is_flow_exist    ${flow_id}
    ...    <24,[N;1;0;192],[N;1;1;168],[N;1;2;0],[N;1;3;0],[N;1;4;192],[N;1;5;168],[N;1;6;0],[N;1;7;1],[N;2;8;2152],[N;2;10;2152],[N;4;12;0],[N;4;16;0]>
    ...    <16>    ${0}
    Log    ${execute_result}
    Should Not Be Equal    ${execute_result}    ${1}

查询配置的IPV6 REMOTE FTP CONTROL FLOW
    ${flow_id}    Evaluate    32 << 25 | 0
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    np_is_flow_exist    ${flow_id}
    ...    <24,[N;1;0;192],[N;1;1;168],[N;1;2;0],[N;1;3;0],[N;1;4;192],[N;1;5;168],[N;1;6;0],[N;1;7;1],[N;2;8;2152],[N;2;10;2152],[N;4;12;0],[N;4;16;0]>
    ...    <16>    ${0}
    Log    ${execute_result}
    Should Be Equal    ${execute_result}    ${1}

查询删除的IPV6 REMOTE FTP CONTROL FLOW
    ${flow_id}    Evaluate    32 << 25 | 0
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    np_is_flow_exist    ${flow_id}
    ...    <24,[N;1;0;192],[N;1;1;168],[N;1;2;0],[N;1;3;0],[N;1;4;192],[N;1;5;168],[N;1;6;0],[N;1;7;1],[N;2;8;2152],[N;2;10;2152],[N;4;12;0],[N;4;16;0]>
    ...    <16>    ${0}
    Log    ${execute_result}
    Should Not Be Equal    ${execute_result}    ${1}

查询配置的IPV6 REMOTE FTP DATA FLOW
    ${flow_id}    Evaluate    33 << 25 | 0
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    np_is_flow_exist    ${flow_id}
    ...    <24,[N;1;0;192],[N;1;1;168],[N;1;2;0],[N;1;3;0],[N;1;4;192],[N;1;5;168],[N;1;6;0],[N;1;7;1],[N;2;8;2152],[N;2;10;2152],[N;4;12;0],[N;4;16;0]>
    ...    <16>    ${0}
    Log    ${execute_result}
    Should Be Equal    ${execute_result}    ${1}
查询删除的IPV6 REMOTE FTP DATA FLOW
    ${flow_id}    Evaluate    33 << 25 | 0
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    np_is_flow_exist    ${flow_id}
    ...    <24,[N;1;0;192],[N;1;1;168],[N;1;2;0],[N;1;3;0],[N;1;4;192],[N;1;5;168],[N;1;6;0],[N;1;7;1],[N;2;8;2152],[N;2;10;2152],[N;4;12;0],[N;4;16;0]>
    ...    <16>    ${0}
    Log    ${execute_result}
    Should Not Be Equal    ${execute_result}    ${1}









# ******************* 删除FLOW ********************
删除配置的UDP FLOW
    ${execute_result}=    Execute Command by UAgent    npDelFlow    ${1}    ${0}
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}

删除配置的GTPU FLOW
    ${execute_result}=    Execute Command by UAgent    npDelFlow    ${2}    ${0}
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}

删除配置的ROUTE FLOW
    ${execute_result}=    Execute Command by UAgent    npDelFlow    ${3}    ${55}
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}

删除配置的SCTP FLOW
    ${execute_result}=    Execute Command by UAgent    npDelFlow    ${4}    ${20}
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}

删除配置的IPV6 DOWN TRAFFIC FLOW
    ${execute_result}=    Execute Command by UAgent    npDelFlow    ${11}    ${5}
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}

删除配置的IPV6 UP TRAFFIC FLOW
    ${execute_result}=    Execute Command by UAgent    npDelFlow    ${12}    ${10}
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}

删除配置的IPV6 UDP FLOW
    ${execute_result}=    Execute Command by UAgent    npDelFlow    ${13}    ${2}
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}

删除配置的IPV6 GTPU FLOW
    ${execute_result}=    Execute Command by UAgent    npDelFlow    ${14}    ${0}
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}

删除配置的IPV6 ROUTE FLOW
    ${execute_result}=    Execute Command by UAgent    npDelFlow    ${15}    ${60}
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}

删除配置的IPV6 SCTP FLOW
    ${execute_result}=    Execute Command by UAgent    npDelFlow    ${16}    ${0}
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}

删除配置的REMOTE ACCESS FLOW
    ${execute_result}=    Execute Command by UAgent    npDelFlow    ${17}    ${0}
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}

删除配置的REMOTE FTP CONTROL CATCH FLOW
    ${execute_result}=    Execute Command by UAgent    npDelFlow    ${18}    ${0}
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}

删除配置的REMOTE FTP CONTROL FLOW
    ${execute_result}=    Execute Command by UAgent    npDelFlow    ${19}    ${0}
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}

删除配置的REMOTE FTP DATA FLOW
    ${execute_result}=    Execute Command by UAgent    npDelFlow    ${20}    ${0}
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}

删除配置的NB REMOTE NB FLOW
    ${execute_result}=    Execute Command by UAgent    npDelFlow    ${24}    ${0}
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}

删除配置的COMP JT FLOW
    ${execute_result}=    Execute Command by UAgent    npDelFlow    ${25}    ${0}
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}

删除配置的DOWN TRAFFIC FLOW
    ${execute_result}=    Execute Command by UAgent    npDelFlow    ${26}    ${0}
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}

删除配置的DOWN GTPC FLOW
    ${execute_result}=    Execute Command by UAgent    npDelFlow    ${27}    ${0}
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}

删除配置的UP TRAFFIC FLOW
    ${execute_result}=    Execute Command by UAgent    npDelFlow    ${29}    ${0}
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}

删除配置的IPV6 REMOTE ACCESS FLOW
    ${execute_result}=    Execute Command by UAgent    npDelFlow    ${30}    ${0}
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}

删除配置的IPV6 REMOTE FTP CONTROL CATCH FLOW
    ${execute_result}=    Execute Command by UAgent    npDelFlow    ${31}    ${0}
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}

删除配置的IPV6 REMOTE FTP CONTROL FLOW
    ${execute_result}=    Execute Command by UAgent    npDelFlow    ${32}    ${0}
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}

删除配置的IPV6 REMOTE FTP DATA FLOW
    ${execute_result}=    Execute Command by UAgent    npDelFlow    ${33}    ${0}
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}


