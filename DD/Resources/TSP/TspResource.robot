# encoding utf-8
# *************************************************************
# *** COPYRIGHT DaTang Mobile Communications Equipment CO.,LTD
# *************************************************************
# *文件名称：TspResource.robot
# *功能描述：TSP用例相关资源文件
# *使用方法：

# -----------------------------------------------------------------------------------
# *修改记录：                                                                       |
# *##修改日期    |    修改人    |    修改描述    |                                  |
# *2018-11-01        sunshixu       创建文件                                        |
# ----------------------------------------------------------------------------------|
# **************************************************************************************
# ______________________________________________________________________________________
# *关键字目录：                                                                        |
#    1.local_002_configuration_test 私有关键字集
#    2.local_003_flow_test 私有关键字集
#    3.remote_002_functional_test 私有关键字集
# _____________________________________________________________________________________|

# **************************************************************************************
*** Settings ***
# Library    ScpLibrary
Library    SnmpLibrary
Library    ../../utils/CiUtils.py
Resource    ../_COMM_/LogHelper.robot
Resource    ../_COMM_/UAgentWrapper.robot



*** Variables ***

*** Keywords ***
# **********************************************************
# ****                                                  ****
# ****                Add Channel                       ****
# ****                                                  ****
# ****                                                  ****
# ****                                                  ****
# ****                                                  ****
# **********************************************************
AddChannel
    [Documentation]    np 配置 channel
    [Tags]
    [Arguments]    ${PhyIndex}    ${ChanIndex}    ${Rate}
    ${execute_result}=    Execute Command by UAgent    npAddChan
    ...    ${PhyIndex}    ${ChanIndex}    ${Rate}
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}
# **********************************************************
# ****                                                  ****
# ****                Del Channel                       ****
# ****                                                  ****
# ****                                                  ****
# ****                                                  ****
# ****                                                  ****
# **********************************************************
DelChannel
    [Documentation]    np 删除 channel
    [Tags]
    [Arguments]    ${ChanType}    ${ChanIndex}
    ${execute_result}=    Execute Command by UAgent    npDelChan    ${ChanType}    ${ChanIndex}
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}

# **********************************************************
# ****                                                  ****
# ****                AddIpv6UdpFlow                    ****
# ****                                                  ****
# ****                                                  ****
# ****                                                  ****
# ****                                                  ****
# **********************************************************
# npAddIpv6UdpFlow 99,2,0x20010011,0,0,0x9,0x20010011,0,0,0x3,9378,9143,0xc101000a,0xc106000a,9378,9143,1
AddIpv6UdpFlow
    [Documentation]    np 配置 ipv6 udp flow
    [Tags]
    [Arguments]    ${ChanIndex}    ${FlowIndex}    ${SIPA1}    ${SIPA2}    ${SIPA3}    ${SIPA4}
    ...    ${DIPA1}    ${DIPA2}    ${DIPA3}    ${DIPA4}    ${SPortA}    ${DPortA}
    ...    ${SIPB}    ${DIPB}    ${SPortB}    ${DPortB}    ${UpDownFlag}

    ${execute_result}=    Execute Command by UAgent    npAddIpv6UdpFlow
    ...    ${ChanIndex}    ${FlowIndex}    ${SIPA1}    ${SIPA2}    ${SIPA3}    ${SIPA4}
    ...    ${DIPA1}    ${DIPA2}    ${DIPA3}    ${DIPA4}    ${SPortA}    ${DPortA}
    ...    ${SIPB}    ${DIPB}    ${SPortB}    ${DPortB}    ${UpDownFlag}
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}

# **********************************************************
# ****                                                  ****
# ****                AddIpv6DownTrafficFlow            ****
# ****                                                  ****
# ****                                                  ****
# ****                                                  ****
# ****                                                  ****
# **********************************************************
# npAddIpv6DownTrafficFlow 5,0x20010011,0,0,0x9,0x20010011,0,0,0x3,2152,2152,192,0,0x0a0001c1,0x0a0006c1,40000,20003,1
AddIpv6DownTrafficFlow
    [Documentation]    np 配置 Ipv6DownTrafficFlow
    [Tags]
    [Arguments]    ${FlowIndex}    ${SIPA1}    ${SIPA2}    ${SIPA3}    ${SIPA4}
    ...    ${DIPA1}    ${DIPA2}    ${DIPA3}    ${DIPA4}    ${SPortA}    ${DPortA}
    ...    ${DownPdcpId}    ${DscpValue}    ${SIPB}    ${DIPB}
    ...    ${SPortB}    ${DPortB}    ${UpDownFlag}

    ${execute_result}=    Execute Command by UAgent    npAddIpv6DownTrafficFlow
    ...    ${FlowIndex}    ${SIPA1}    ${SIPA2}    ${SIPA3}    ${SIPA4}
    ...    ${DIPA1}    ${DIPA2}    ${DIPA3}    ${DIPA4}    ${SPortA}    ${DPortA}
    ...    ${DownPdcpId}    ${DscpValue}    ${SIPB}    ${DIPB}
    ...    ${SPortB}    ${DPortB}    ${UpDownFlag}
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}

# **********************************************************
# ****                                                  ****
# ****                AddIpv6UpTrafficFlow            ****
# ****                                                  ****
# ****                                                  ****
# ****                                                  ****
# ****                                                  ****
# **********************************************************
# npAddIpv6UpTrafficFlow 99,12,0x20010011,0,0,9,0x20010011,0,0,3,2152,2152,0
AddIpv6UpTrafficFlow
    [Documentation]    np 配置 Ipv6UpTrafficFlow
    [Tags]
    [Arguments]    ${ChanIndex}    ${FlowIndex}    ${SIPA1}    ${SIPA2}    ${SIPA3}    ${SIPA4}
    ...    ${DIPA1}    ${DIPA2}    ${DIPA3}    ${DIPA4}    ${SPortA}    ${DPortA}    ${UpDownFlag}

    ${execute_result}=    Execute Command by UAgent    npAddIpv6UpTrafficFlow
    ...    ${ChanIndex}    ${FlowIndex}    ${SIPA1}    ${SIPA2}    ${SIPA3}    ${SIPA4}
    ...    ${DIPA1}    ${DIPA2}    ${DIPA3}    ${DIPA4}    ${SPortA}    ${DPortA}    ${UpDownFlag}
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}

# **********************************************************
# ****                                                  ****
# ****                AddIpv6SctpFlow                   ****
# ****                                                  ****
# ****                                                  ****
# ****                                                  ****
# ****                                                  ****
# **********************************************************
# 16 npAddipv6sctpFlow 99,0,0x20010011,0,0,0x9,0x20010011,0,0,0x3,36422,36422,36422,36422,1
AddIpv6SctpFlow
    [Documentation]    np 配置 Ipv6UpTrafficFlow
    [Tags]
    [Arguments]    ${ChanIndex}    ${FlowIndex}    ${SIPA1}    ${SIPA2}    ${SIPA3}    ${SIPA4}
    ...    ${DIPA1}    ${DIPA2}    ${DIPA3}    ${DIPA4}    ${SPortA}    ${DPortA}
    ...    ${SPortB}    ${DPortB}    ${UpDownFlag}

    ${execute_result}=    Execute Command by UAgent    npAddipv6sctpFlow
    ...    ${ChanIndex}    ${FlowIndex}    ${SIPA1}    ${SIPA2}    ${SIPA3}    ${SIPA4}
    ...    ${DIPA1}    ${DIPA2}    ${DIPA3}    ${DIPA4}    ${SPortA}    ${DPortA}
    ...    ${SPortB}    ${DPortB}    ${UpDownFlag}
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}

# **********************************************************
# ****                                                  ****
# ****                AddDownGtpcFlow                   ****
# ****                                                  ****
# ****                                                  ****
# ****                                                  ****
# ****                                                  ****
# **********************************************************
# npAddDownGtpcFlow 0, 0x01010100, 0x0a0a0a0a, 2152, 2152, 0, 0, 0x0a0001c1, 0x0a0004c7, 40000, 20003, 1
AddDownGtpcFlow
[Documentation]    np 配置 DownGtpcFlow
    [Tags]
    [Arguments]    ${FlowIndex}    ${SIPA}    ${DIPA}    ${SPortA}    ${DPortA}
    ...    ${IngressTeidA}    ${EgressTeidA}
    ...    ${SIPB}    ${DIPB}    ${SPortB}    ${DPortB}    ${UpDownFlag}

    ${execute_result}=    Execute Command by UAgent    npAddDownGtpcFlow
    ...    ${FlowIndex}    ${SIPA}    ${DIPA}    ${SPortA}    ${DPortA}
    ...    ${IngressTeidA}    ${EgressTeidA}
    ...    ${SIPB}    ${DIPB}    ${SPortB}    ${DPortB}    ${UpDownFlag}
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}

# **********************************************************
# ****                                                  ****
# ****                AddUpTrafficFlow                   ****
# ****                                                  ****
# ****                                                  ****
# ****                                                  ****
# ****                                                  ****
# **********************************************************
# npAddUpTrafficFlow 99, 0, 0xC0A80000, 0xC0A80001, 2152, 2152, 0
AddUpTrafficFlow
[Documentation]    np 配置 DownGtpcFlow
    [Tags]
    [Arguments]    ${ChanIndex}    ${FlowIndex}    ${SIPA}    ${DIPA}
    ...    ${SPortA}    ${DPortA}    ${UpDownFlag}

    ${execute_result}=    Execute Command by UAgent    npAddUpTrafficFlow
    ...    ${ChanIndex}    ${FlowIndex}    ${SIPA}    ${DIPA}
    ...    ${SPortA}    ${DPortA}    ${UpDownFlag}
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}

# **********************************************************
# ****                                                  ****
# ****                AddIpv6RemoteAccessFlow           ****
# ****                                                  ****
# ****                                                  ****
# ****                                                  ****
# ****                                                  ****
# **********************************************************
# npAddIpv6RemoteAccessFlow 0,0,0x20010011,0,0,0x9,0x20010011,0,0,0x3, 40000, 20003, 0xc0a80001, 0xc0a80002, 40000,20003
AddIpv6RemoteAccessFlow
[Documentation]    np 配置 Ipv6UpTrafficFlow
    [Tags]
    [Arguments]    ${ChanIndex}    ${FlowIndex}    ${SIPA1}    ${SIPA2}    ${SIPA3}    ${SIPA4}
    ...    ${DIPA1}    ${DIPA2}    ${DIPA3}    ${DIPA4}    ${SPortA}    ${DPortA}
    ...    ${SIPB}    ${DIPB}    ${SPortB}    ${DPortB}

    ${execute_result}=    Execute Command by UAgent    npAddIpv6RemoteAccessFlow
    ...    ${ChanIndex}    ${FlowIndex}    ${SIPA1}    ${SIPA2}    ${SIPA3}    ${SIPA4}
    ...    ${DIPA1}    ${DIPA2}    ${DIPA3}    ${DIPA4}    ${SPortA}    ${DPortA}
    ...    ${SIPB}    ${DIPB}    ${SPortB}    ${DPortB}
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}

# **********************************************************
# ****                                                  ****
# ****                AddIpv6remoteFtpControlCatchFlow  ****
# ****                                                  ****
# ****                                                  ****
# ****                                                  ****
# ****                                                  ****
# **********************************************************
# npAddIpv6remoteFtpControlCatchFlow 0, 0xC0A80000, 0xC0A80001, 0, 0
AddIpv6remoteFtpControlCatchFlow
[Documentation]    np 配置 Ipv6UpTrafficFlow
    [Tags]
    [Arguments]    ${FlowIndex}    ${SIPB}    ${DIPB}    ${SPortB}    ${DPortB}

    ${execute_result}=    Execute Command by UAgent    npAddIpv6remoteFtpControlCatchFlow
    ...    ${FlowIndex}    ${SIPB}    ${DIPB}    ${SPortB}    ${DPortB}
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}


# **********************************************************
# ****                                                  ****
# ****                AddIpv6RemoteFtpControlFlow       ****
# ****                                                  ****
# ****                                                  ****
# ****                                                  ****
# ****                                                  ****
# **********************************************************
# npAddIpv6RemoteFtpControlFlow 0,0,0x20010011,0,0,0x9,0x20010011,0,0,0x3, 40000, 20003, 0xc0a80001, 0xc0a80002, 40000,20003
AddIpv6RemoteFtpControlFlow
[Documentation]    np 配置 Ipv6UpTrafficFlow
    [Tags]
    [Arguments]    ${ChanIndex}    ${FlowIndex}    ${SIPA1}    ${SIPA2}    ${SIPA3}    ${SIPA4}
    ...    ${DIPA1}    ${DIPA2}    ${DIPA3}    ${DIPA4}    ${SPortA}    ${DPortA}
    ...    ${SIPB}    ${DIPB}    ${SPortB}    ${DPortB}

    ${execute_result}=    Execute Command by UAgent    npAddIpv6RemoteFtpControlFlow
    ...    ${ChanIndex}    ${FlowIndex}    ${SIPA1}    ${SIPA2}    ${SIPA3}    ${SIPA4}
    ...    ${DIPA1}    ${DIPA2}    ${DIPA3}    ${DIPA4}    ${SPortA}    ${DPortA}
    ...    ${SIPB}    ${DIPB}    ${SPortB}    ${DPortB}
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}

# **********************************************************
# ****                                                  ****
# ****                AddIpv6RemoteFtpDataFlow          ****
# ****                                                  ****
# ****                                                  ****
# ****                                                  ****
# ****                                                  ****
# **********************************************************
# npAddIpv6RemoteFtpDataFlow 0,0,0x20010011,0,0,0x9,0x20010011,0,0,0x3, 40000, 20003, 0xc0a80001, 0xc0a80002, 40000,20003
AddIpv6RemoteFtpDataFlow
[Documentation]    np 配置 Ipv6UpTrafficFlow
    [Tags]
    [Arguments]    ${ChanIndex}    ${FlowIndex}    ${SIPA1}    ${SIPA2}    ${SIPA3}    ${SIPA4}
    ...    ${DIPA1}    ${DIPA2}    ${DIPA3}    ${DIPA4}    ${SPortA}    ${DPortA}
    ...    ${SIPB}    ${DIPB}    ${SPortB}    ${DPortB}

    ${execute_result}=    Execute Command by UAgent    npAddIpv6RemoteFtpDataFlow
    ...    ${ChanIndex}    ${FlowIndex}    ${SIPA1}    ${SIPA2}    ${SIPA3}    ${SIPA4}
    ...    ${DIPA1}    ${DIPA2}    ${DIPA3}    ${DIPA4}    ${SPortA}    ${DPortA}
    ...    ${SIPB}    ${DIPB}    ${SPortB}    ${DPortB}
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}
# **********************************************************
# ****                                                  ****
# ****                Del Flow                          ****
# ****                                                  ****
# ****                                                  ****
# ****                                                  ****
# ****                                                  ****
# **********************************************************
DelFlow
    [Documentation]    np 删除 Flow
    [Tags]
    [Arguments]    ${FlowType}    ${FlowIndex}
    ${execute_result}=    Execute Command by UAgent    npDelFlow    ${FlowType}    ${FlowIndex}
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}
# **********************************************************
# ****                                                  ****
# ****                Del Flow                          ****
# ****                                                  ****
# ****                                                  ****
# ****                                                  ****
# ****                                                  ****
# **********************************************************
SetMac
    [Documentation]    np mac 打桩
    [Tags]
    [Arguments]
    ${execute_result}=    Execute Command by UAgent    npSetMac    '00:11:22:33:44:55\n'    '00:01:02:03:04:05\n'
    ...    '00:11:22:33:44:55\n'    '00:01:02:03:04:05\n'
    Log    ${execute_result}

# **********************************************************
# ****                                                  ****
# ****  forward ipv6 udp pkgs should be sniffed         ****
# ****                                                  ****
# ****                                                  ****
# ****                                                  ****
# ****                                                  ****
# **********************************************************
# forward_udp_check_udp('2001:11::3', '2001:11::9', 9999, 9999, '2001:11::3', '2001:11::9', 9999, 9999, 0, 'udp')
# ForwardIpv6UdpPkgsShouldBeSniffed
#     [Documentation]    ForwardIpv6UdpPkgsShouldBeSniffed
#     [Tags]
#     [Arguments]
#     ${ret1}    forward_udp_check_udp    ''
#     log    ${ret1}
#     Should Be Equal    ${ret1}    ${1}























# **********************************************************
# ****                                                  ****
# ****         local_002_configuration_test.robot       ****
# ****                                                  ****
# ****                                                  ****
# ****                                                  ****
# ****                                                  ****
# **********************************************************
配置PHY口MAC
    [Documentation]    配置PHY口MAC
    [Tags]
    [Arguments]
    ${execute_result}=    Execute Command by UAgent    nh_ipv6_set_phy_test    ${2}    '00:11:22:33:44:55'
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}

配置后查找PHYID和MAC对应关系
    [Documentation]    配置后查找PHYID和MAC对应关系
    [Tags]
    [Arguments]
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    nphost_get_phy_mac    ${2}    <6>
    Log    ${execute_result}
    Log    ${reslut_list}
    ${mem_0}    member_decode    ${reslut_list}
    Log   ${mem_0}
    Should be equal    ${mem_0}    0x1122334455
    Should be equal    ${execute_result}    ${0}

删除PHY口MAC
    [Documentation]    删除PHY口MAC
    [Tags]
    [Arguments]
    Sleep    2
    ${execute_result}=    Execute Command by UAgent    nh_ipv6_del_phy_test    ${2}    '00:11:22:33:44:55\n'
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}

删除后查找PHYID和MAC对应关系
    [Documentation]    删除后查找PHYID和MAC对应关系
    [Tags]
    [Arguments]
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    nphost_get_phy_mac    ${2}    <6>
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${-1}
# ***************  ip ************************

配置PHY口IP
    [Documentation]    配置PHY口IP
    [Tags]
    [Arguments]
    ${execute_result}=    Execute Command by UAgent    nh_set_ip_test    '192.168.1.80\n'    '255.255.255.0\n'    ${2}
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}

配置后查找PHYID和IP对应关系
    [Documentation]    配置后查找PHYID和IP对应关系
    [Tags]
    [Arguments]
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    nphost_is_ip_phy_item_exist    <12,[N;4;0;2],[N;1;4;192],[N;1;5;168],[N;1;6;1],[N;1;7;80]>
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}

删除PHY口IP
    [Documentation]    删除PHY口IP
    [Tags]
    [Arguments]
    Sleep    1
    ${execute_result}=    Execute Command by UAgent    nh_del_ip_test    '192.168.1.80\n'    ${2}
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}

删除后查找PHYID和IP对应关系
    [Documentation]    删除后查找PHYID和IP对应关系
    [Tags]
    [Arguments]
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    nphost_is_ip_phy_item_exist    <12,[N;4;0;2],[N;1;4;192],[N;1;5;168],[N;1;6;1],[N;1;7;80]>
    Log    ${execute_result}
    Should Not Be Equal    ${execute_result}    ${0}

# ***************  route ************************
配置同网段IP
    [Documentation]    配置同网段IP
    [Tags]
    [Arguments]
    ${execute_result}=    Execute Command by UAgent    nh_set_ip_test    '192.168.0.80\n'    '255.255.255.0\n'    ${0}
    Log    ${execute_result}
    # Should be equal    ${execute_result}    ${0}

配置ROUTE
    [Documentation]    配置ROUTE
    [Tags]
    [Arguments]
    ${execute_result}=    Execute Command by UAgent    nh_set_route_test    '192.168.0.5\n'    '255.255.255.0\n'    '192.168.0.1\n'    ${0}
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}

配置后查找ROUTE
    [Documentation]    配置后查找ROUTE
    [Tags]
    [Arguments]
    ${execute_result}    ${place}=    Execute Command With Out Datas by UAgent    nphost_is_route_item_exist    ${0x0500a8c0}    ${0x00ffffff}
    Log    ${execute_result}
    Should Be Equal    ${execute_result}    ${0}

删除ROUTE
    [Documentation]    删除ROUTE
    [Tags]
    [Arguments]
    Sleep    3
    ${execute_result}=    Execute Command by UAgent    nh_del_route_test    '192.168.0.5\n'    '255.255.255.0\n'    '192.168.0.1\n'
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}

删除后查找ROUTE
    [Documentation]    删除后查找ROUTE
    [Tags]
    [Arguments]
    ${execute_result}    ${place}=    Execute Command With Out Datas by UAgent    nphost_is_route_item_exist    ${83994816}    ${16777215}
    Log    ${execute_result}
    Should Not Be Equal    ${execute_result}    ${0}

删除配置的同网段IP
    [Documentation]    删除配置的同网段IP
    [Tags]
    [Arguments]
    Sleep    1
    ${execute_result}=    Execute Command by UAgent    nh_del_ip_test    '192.168.0.80\n'    ${0}
    Log    ${execute_result}
    # Should be equal    ${execute_result}    ${0}

# ***************  vlan ************************

配置VLAN
    [Documentation]    配置VLAN
    [Tags]
    [Arguments]
    ${execute_result}=    Execute Command by UAgent    nh_set_vlanid_test    '192.168.1.5\n'    ${1}
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}

配置后查找VLAN
    [Documentation]    配置后查找VLAN
    [Tags]
    [Arguments]
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    nphost_is_vlanid_item_exist    ${83994816}
    Log    ${execute_result}
    Should Be Equal    ${execute_result}    ${0}

删除VLAN
    [Documentation]    删除VLAN
    [Tags]
    [Arguments]
    Sleep    3
    ${execute_result}=    Execute Command by UAgent    nh_del_vlanid_test    '192.168.1.5\n'    ${1}
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}

删除后查找VLAN
    [Documentation]    删除后查找VLAN
    [Tags]
    [Arguments]
    ${execute_result}    ${place}=    Execute Command With Out Datas by UAgent    nphost_is_route_item_exist    ${83994816}
    Log    ${execute_result}
    Should Not Be Equal    ${execute_result}    ${0}

记录当前MTU
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    npMtuMode    ${0}    ${55}    ${0}
    Log    ${execute_result}
    set suite variable    ${default_mtu}    ${execute_result}
    Should Be True    ${execute_result} > 0

配置MTU
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    npMtuMode    ${1}    ${0}    ${1600}
    Log    ${execute_result}
    Should Be Equal    ${execute_result}    ${0}

校验配置
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    npMtuMode    ${0}    ${55}    ${0}
    Log    ${execute_result}
    Should Be Equal    ${execute_result}    ${1600}

恢复MTU
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    npMtuMode    ${1}    ${0}    ${default_mtu}
    Log    ${execute_result}
    Should Be Equal    ${execute_result}    ${0}

Dal Malloc Free
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    dalMallocFreeTest
    Log    ${execute_result}
    Should Be Equal    ${execute_result}    ${0}

# **********************************************************
# ****                                                  ****
# ****              local_003_flow_test.robot           ****
# ****                                                  ****
# ****                                                  ****
# ****                                                  ****
# ****                                                  ****
# **********************************************************
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

# **********************************************************
# ****                                                  ****
# ****          remote_002_functional_test.robot        ****
# ****                                                  ****
# ****                                                  ****
# ****                                                  ****
# ****                                                  ****
# **********************************************************
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
