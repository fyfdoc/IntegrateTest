# encoding utf-8
# *************************************************************
# *** COPYRIGHT DaTang Mobile Communications Equipment CO.,LTD
# *************************************************************
# *文件名称：multi_001_ipv6_fearures_test.robot
# *功能描述：ipv6 特性 回归测试
# *使用方法：

# -----------------------------------------------------------------------------------
# *修改记录：                                                                       |
# *##修改日期    |    修改人    |    修改描述    |                                  |
# *2018-11-01        sunshixu         创建文件                                       |
# ----------------------------------------------------------------------------------|
# *************************************************************
# ______________________________________________________________________________________
# *用例记录：                                                                          |
# -------------------------------------------------------------------------            |
# **                                                                                   |
# _____________________________________________________________________________________|

# **************************************************************************************

*** Settings ***
Library    ScpLibrary
Resource    ../../Resources/TSP/TspResource.robot
Resource    ../../Resources/TSP/LogInHelper.robot
Resource    ../../Resources/_COMM_/SnmpMibHelper.robot
Resource    ../../Resources/_COMM_/LogHelper.robot
Suite Setup    Open Snmp Connection And Load Private MIB
*** Test Cases ***

Connection
    Local Login HSCTD Process    ${2}
    Port Mirroring    ${1}
    AddChannel    ${0}    ${99}    ${20000}
    SetMac

# 13 npAddIpv6UdpFlow 99,2,0x20010011,0,0,0x9,0x20010011,0,0,0x3,9378,9143,0xc101000a,0xc106000a,9378,9143,1
Ipv6 Udp Flow 灌包测试
    [Documentation]
    [Tags]
    [Setup]    AddIpv6UdpFlow    ${99}    ${2}    ${0x20010011}    ${0}    ${0}    ${9}
    ...    ${0x20010011}    ${0}    ${0}    ${3}    ${9378}    ${9143}
    ...    ${0xc101000a}    ${0xc106000a}    ${9999}    ${8888}    ${1}
    [Teardown]    Run Keyword And Ignore Error    DelFlow    ${13}    ${2}
    [Timeout]
    ${ret}    forward_udp_check_udp    2001:11::9    2001:11::3    ${9378}    ${9143}    10.0.1.193    10.0.6.193
    ...    ${8888}    ${9999}    ${1}    udp
    Should Be True    ${ret}

# 11 npAddIpv6DownTrafficFlow 5,0x20010011,0,0,0x9,0x20010011,0,0,0x3,2152,2152,192,0,0x0a0001c1,0x0a0006c1,40000,20003,1
Ipv6 Down Traffic Flow 灌包测试
    [Documentation]
    [Tags]
    [Setup]    AddIpv6DownTrafficFlow    ${5}    ${0x20010011}    ${0}    ${0}    ${9}
    ...    ${0x20010011}    ${0}    ${0}    ${3}    ${2152}    ${2152}    ${192}    ${0}
    ...    ${0x0a0001c1}    ${0x0a0006c1}    ${40000}    ${20003}    ${1}
    [Teardown]    Run Keyword And Ignore Error    DelFlow    ${11}    ${5}
    [Timeout]
    ${ret}    forward_gtpu_check_gtpu    2001:11::9    2001:11::3    ${2152}    ${2152}
    ...    ${0x03000000}    10.0.1.193    10.0.6.193
    ...    ${40000}    ${20003}    ${0x03000000}    ${1}    gtpu
    Should Be True    ${ret}

# 12 npAddIpv6UpTrafficFlow 99,12,0x20010011,0,0,9,0x20010011,0,0,3,2152,2152,0
Ipv6 Up Traffic Flow 灌包测试
    [Documentation]
    [Tags]
    [Setup]    AddIpv6UpTrafficFlow    ${99}    ${12}    ${0x20010011}    ${0}    ${0}    ${9}
    ...    ${0x20010011}    ${0}    ${0}    ${3}    ${2152}    ${2152}    ${0}
    # [Teardown]    Run Keyword And Ignore Error    DelFlow    ${12}    ${12}
    [Timeout]
    ${ret}    forward_gtpu_up_check_gtpu    10.0.1.193    10.0.6.193    ${20003}    ${40000}
    ...    2001:11::9    ${0x08080807}    ${0}    2001:11::3    2001:11::9
    ...    ${2152}    ${2152}    ${0}    ${0}    gtpu_up
    Should Be True    ${ret}
# forward_gtpu_up_check_gtpu(self, srca, dsta, sporta, dporta, remotea,
# qosa, teida, srcb, dstb, sportb, dportb, teidb, updownflag, pcapfile):

# # 16 npAddipv6sctpFlow 99,0,0x20010011,0,0,0x9,0x20010011,0,0,0x3,36422,36422,36422,36422,1
Ipv6 Sctp Flow 灌包测试
    [Documentation]
    [Tags]
    [Setup]    AddIpv6SctpFlow    ${99}    ${0}    ${0x20010011}    ${0}    ${0}    ${9}
    ...    ${0x20010011}    ${0}    ${0}    ${3}    ${36422}    ${36422}
    ...    ${36422}    ${36422}    ${1}
    [Teardown]    Run Keyword And Ignore Error    DelFlow    ${16}    ${0}
    [Timeout]
    ${ret}    forward_sctp_check_sctp    2001:11::9    2001:11::3    ${36422}    ${36422}
    ...    2001:11::9    2001:11::3    ${36422}    ${36422}
    ...    ${1}    sctp
    Should Be True    ${ret}
# npAddDownGtpcFlow 0, 0x01010100, 0x0a0a0a0a, 2152, 2152, 0, 0, 0x0a0001c1, 0x0a0004c7, 40000, 20003, 1
Down Gtpc Flow 灌包测试
    [Documentation]
    [Tags]
    [Setup]    AddDownGtpcFlow    ${0}    ${0x01010100}    ${0x0a0a0a0a}    ${2152}    ${2152}
    ...    ${0}    ${0}    ${0x0a0001c1}    ${0x0a0004c7}    ${40000}    ${20003}    ${1}
    [Teardown]    Run Keyword And Ignore Error    DelFlow    ${27}    ${0}

# npAddUpTrafficFlow 99, 0, 0xC0A80000, 0xC0A80001, 2152, 2152, 0
Up Traffic Flow 灌包测试
    [Documentation]
    [Tags]
    [Setup]    AddUpTrafficFlow    ${99}    ${0}    ${0xC0A80000}    ${0xC0A80001}
    ...    ${2152}    ${2152}    ${0}
    [Teardown]    Run Keyword And Ignore Error    DelFlow    ${29}    ${0}

# npAddIpv6RemoteAccessFlow 0,0,0x20010011,0,0,0x9,0x20010011,0,0,0x3, 40000, 20003, 0xc0a80001, 0xc0a80002, 40000,20003
Ipv6 Remote Access Flow 灌包测试
    [Documentation]
    [Tags]
    [Setup]    AddIpv6RemoteAccessFlow    ${0}    ${0}    ${0x20010011}    ${0}    ${0}    ${9}
    ...    ${0x20010011}    ${0}    ${0}    ${3}    ${40000}    ${20003}    ${0xc0a80001}    ${0xc0a80002}
    ...    ${40000}    ${20003}
    [Teardown]    Run Keyword And Ignore Error    DelFlow    ${30}    ${0}
# npAddIpv6remoteFtpControlCatchFlow 0, 0xC0A80000, 0xC0A80001, 0, 0
Ipv6 Remote Ftp Control Catch Flow 灌包测试
    [Documentation]
    [Tags]
    [Setup]    AddIpv6remoteFtpControlCatchFlow    ${0}    ${0xC0A80000}    ${0xC0A80001}    ${0}    ${0}
    [Teardown]    Run Keyword And Ignore Error    DelFlow    ${31}    ${0}

# npAddIpv6RemoteFtpControlFlow 0,0,0x20010011,0,0,0x9,0x20010011,0,0,0x3, 40000, 20003, 0xc0a80001, 0xc0a80002, 40000,20003
Ipv6 Remote Ftp Control Flow 灌包测试
    [Documentation]
    [Tags]
    [Setup]    AddIpv6RemoteFtpControlFlow    ${0}    ${0}    ${0x20010011}    ${0}    ${0}    ${9}
    ...    ${0x20010011}    ${0}    ${0}    ${3}    ${40000}    ${20003}    ${0xc0a80001}    ${0xc0a80002}
    ...    ${40000}    ${20003}
    [Teardown]    Run Keyword And Ignore Error    DelFlow    ${32}    ${0}

# npAddIpv6RemoteFtpDataFlow 0,0,0x20010011,0,0,0x9,0x20010011,0,0,0x3, 40000, 20003, 0xc0a80001, 0xc0a80002, 40000,20003
Ipv6 Remote Ftp Data Flow 灌包测试
    [Documentation]
    [Tags]
    [Setup]    AddIpv6RemoteFtpDataFlow    ${0}    ${0}    ${0x20010011}    ${0}    ${0}    ${9}
    ...    ${0x20010011}    ${0}    ${0}    ${3}    ${40000}    ${20003}    ${0xc0a80001}    ${0xc0a80002}
    ...    ${40000}    ${20003}
    [Teardown]    Run Keyword And Ignore Error    DelFlow    ${33}    ${0}

Disconnect
    Port Mirroring    ${0}
    DelChannel    ${0}    ${99}
    Disconnect UAgent Use Pid