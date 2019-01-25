# encoding utf-8
# *************************************************************
# *** COPYRIGHT DaTang Mobile Communications Equipment CO.,LTD
# *************************************************************
# *文件名称：local_002_configuration_test.robot
# *功能描述：近端场景 配置功能测试
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
NpHost Set Phy Test
    [Documentation]    nphost 配置PHY口Mac
    [Tags]
    [Setup]    Local Login HSCTD Process    ${2}
    [Teardown]    Disconnect UAgent Use Pid
    [Timeout]
    配置PHY口MAC
    配置后查找PHYID和MAC对应关系
    删除PHY口MAC
    删除后查找PHYID和MAC对应关系

NpHost Set Ip Test
    [Documentation]    nphost 配置PHY口ip
    [Tags]
    [Setup]    Local Login HSCTD Process    ${2}
    [Teardown]    Disconnect UAgent Use Pid
    [Timeout]
    配置PHY口IP
    配置后查找PHYID和IP对应关系
    删除PHY口IP
    删除后查找PHYID和IP对应关系

NpHost Set Route Test
    [Documentation]    nphost 配置Route
    [Tags]
    [Setup]    Local Login HSCTD Process    ${2}
    [Teardown]    Disconnect UAgent Use Pid
    [Timeout]
    配置同网段IP
    配置ROUTE
    配置后查找ROUTE
    删除ROUTE
    删除后查找ROUTE
    删除配置的同网段IP

NpHost Set Vlan Test
    [Documentation]    nphost 配置Vlanid
    [Tags]
    [Setup]    Local Login HSCTD Process    ${2}
    [Teardown]    Disconnect UAgent Use Pid
    [Timeout]
    配置VLAN
    配置后查找VLAN
    删除VLAN
    删除后查找VLAN

Np Set Mtu Mode Test
    [Documentation]   NP配置channel MTU 模式
    [Tags]
    [Setup]    Local Login HSCTD Process    ${2}
    [Teardown]    Disconnect UAgent Use Pid
    [Timeout]
    记录当前MTU
    配置MTU
    校验配置
    恢复MTU

Dal Malloc Free Test
    [Documentation]    NP Dal_malloc & dal_free 测试
    [Tags]
    [Setup]    Local Login HSCTD Process    ${2}
    [Teardown]    Disconnect UAgent Use Pid
    [Timeout]
    Dal Malloc Free