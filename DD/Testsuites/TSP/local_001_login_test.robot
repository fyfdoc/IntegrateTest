# encoding utf-8
# *************************************************************
# *** COPYRIGHT DaTang Mobile Communications Equipment CO.,LTD
# *************************************************************
# *文件名称：local_001_login_test.robot
# *功能描述：近端场景  连通测试
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
Resource    ../../Resources/TSP/LogInHelper.robot
Resource    ../../Resources/_COMM_/SnmpMibHelper.robot
Suite Setup    Open Snmp Connection And Load Private MIB

*** Test Cases ***

Local Login Hsctd Scp Pid2 Test
    [Documentation]    近端链接HSCTD_SCP主进程PID2
    [Tags]
    [Setup]
    [Teardown]    Disconnect UAgent Use Pid
    [Timeout]
    Local Login HSCTD Process    ${2}

Local Login Hsctd Scp Pid3 Test
    [Documentation]    近端链接HSCTD_SCP从进程PID3
    [Tags]
    [Setup]
    [Teardown]    Disconnect UAgent Use Pid
    [Timeout]
    Local Login HSCTD Process    ${3}

Local Login Hsctd Scp Pid4 Test
    [Documentation]    近端链接HSCTD_SCP从进程PID4
    [Tags]
    [Setup]
    [Teardown]    Disconnect UAgent Use Pid
    [Timeout]
    Local Login HSCTD Process    ${4}

Local Login Hsctd Scp Pid5 Test
    [Documentation]    近端链接HSCTD_SCP从进程PID5
    [Tags]
    [Setup]
    [Teardown]    Disconnect UAgent Use Pid
    [Timeout]
    Local Login HSCTD Process    ${5}

Local Login Hbpod Bcp Pid2 Test
    [Documentation]    近端链接HBPOD_BCP主进程PID2
    [Tags]
    [Setup]
    [Teardown]    Disconnect UAgent Use Pid
    [Timeout]
    Local Login HBPOD Process    ${2}

Local Login Hbpod Bcp Pid3 Test
    [Documentation]    近端链接HBPOD_BCP从进程PID3
    [Tags]
    [Setup]
    [Teardown]    Disconnect UAgent Use Pid
    [Timeout]
    Local Login HBPOD Process    ${3}

Local Login Hbpod Bcp Pid4 Test
    [Documentation]    近端链接HBPOD_BCP从进程PID4
    [Tags]
    [Setup]
    [Teardown]    Disconnect UAgent Use Pid
    [Timeout]
    Local Login HBPOD Process    ${4}

Local Login Hbpod Bcp Pid5 Test
    [Documentation]    近端链接HBPOD_BCP从进程PID5
    [Tags]
    [Setup]
    [Teardown]    Disconnect UAgent Use Pid
    [Timeout]
    Local Login HBPOD Process    ${5}

Local Login Hbpod Bcp Pid6 Test
    [Documentation]    近端链接HBPOD_BCP从进程PID6
    [Tags]
    [Setup]
    [Teardown]    Disconnect UAgent Use Pid
    [Timeout]
    Local Login HBPOD Process    ${6}

Local Login Hbpod Bcp Pid7 Test
    [Documentation]    近端链接HBPOD_BCP从进程PID7
    [Tags]
    [Setup]
    [Teardown]    Disconnect UAgent Use Pid
    [Timeout]
    Local Login HBPOD Process    ${7}

Local Login Hbpod Bcp Pid8 Test
    [Documentation]    近端链接HBPOD_BCP从进程PID8
    [Tags]
    [Setup]
    [Teardown]    Disconnect UAgent Use Pid
    [Timeout]
    Local Login HBPOD Process    ${8}

Local Login Hbpod Arm Plp1 Test
    [Documentation]    近端链接HBPOD_PLP1_ARM
    [Tags]
    [Setup]
    [Teardown]    Disconnect UAgent Use Pid
    [Timeout]
    Local Login HBPOD Process    ${11}

Local Login Hbpod Arm Plp2 Test
    [Documentation]    近端链接HBPOD_PLP2_ARM
    [Tags]
    [Setup]
    [Teardown]    Disconnect UAgent Use Pid
    [Timeout]
    Local Login HBPOD Process    ${21}


