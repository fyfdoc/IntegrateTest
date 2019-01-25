# encoding utf-8
# *************************************************************
# *** COPYRIGHT DaTang Mobile Communications Equipment CO.,LTD
# *************************************************************
# *文件名称：remote_002_functional_test.robot
# *功能描述：远端场景 功能测试
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
Resource    ../../Resources/TSP/TspResource.robot
Resource    ../../Resources/TSP/LogInHelper.robot
Resource    ../../Resources/_COMM_/SnmpMibHelper.robot
Suite Setup    Open Snmp Connection And Load Private MIB
*** Test Cases ***
NpSetPortTest
    [Documentation]    np 配置phy 口速率测试
    [Tags]
    [Setup]    remote Login HSCTD Process    ${2}
    [Teardown]    Disconnect UAgent Use Pid
    [Timeout]
    记录PHY口默认速率
    配置PHY口速率
    检查配置是否成功
    恢复PHY口默认速率
    PHY口状态查询功能测试

Ipv4 Ping Test
    [Documentation]    np ipv4 ping 测试
    [Tags]
    [Setup]    remote Login HSCTD Process    ${2}
    [Teardown]    Disconnect UAgent Use Pid
    [Timeout]
    NpHost Set Ping DF
    Is Ping Relpy DF
    NpHost Del Ping DF
    NpHost Set Ping F
    Is Ping Relpy F
    NpHost Del Ping F