
# @company: Datang Mobile
# @license: (c) Copyright 2018, Datang Mobile
# @author: sunshixu
# @file:    npHostSetTest.robot
# @desc: TSP NpHost 测试     增->查->删->查

*** Settings ***
Resource    ../../../resources/LogInHelper.robot
Suite Setup    Open Snmp Connection And Load Private MIB    ${DeviceIp}    ${Community}    ${MibName}

*** Test Cases ***
Connect
    Local Login HSCTD Process    ${2}

NpHostSetPhy
    配置PHY口MAC
    配置后查找PHYID和MAC对应关系
    删除PHY口MAC
    删除后查找PHYID和MAC对应关系

NpHostSetIp
    配置PHY口IP
    配置后查找PHYID和IP对应关系
    删除PHY口IP
    删除后查找PHYID和IP对应关系

NpHostSetRoute
    配置同网段IP
    配置ROUTE
    配置后查找ROUTE
    删除ROUTE
    删除后查找ROUTE
    删除配置的同网段IP

NpHostSetVlan
    配置VLAN
    配置后查找VLAN
    删除VLAN
    删除后查找VLAN

Disconnect
    Disconnect UAgent Use Pid









*** Keywords ***
#****************** PHY ******************
配置PHY口MAC
    ${execute_result}=    Execute Command by UAgent    nh_ipv6_set_phy_test    ${2}    '00:11:22:33:44:55'
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}

配置后查找PHYID和MAC对应关系
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    nphost_get_phy_mac    ${2}    <6>
    Log    ${execute_result}
    Log    ${reslut_list}
    ${mem_0}    member_decode    ${reslut_list}
    Log   ${mem_0}
    Should be equal    ${mem_0}    0x1122334455
    Should be equal    ${execute_result}    ${0}

删除PHY口MAC
    Sleep    2
    ${execute_result}=    Execute Command by UAgent    nh_ipv6_del_phy_test    ${2}    '00:11:22:33:44:55\n'
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}

删除后查找PHYID和MAC对应关系
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    nphost_get_phy_mac    ${2}    <6>
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${-1}
# ***************  ip ************************

配置PHY口IP
    ${execute_result}=    Execute Command by UAgent    nh_set_ip_test    '192.168.1.80\n'    '255.255.255.0\n'    ${2}
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}

配置后查找PHYID和IP对应关系
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    nphost_is_ip_phy_item_exist    <12,[N;4;0;2],[N;1;4;192],[N;1;5;168],[N;1;6;1],[N;1;7;80]>
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}

删除PHY口IP
    Sleep    1
    ${execute_result}=    Execute Command by UAgent    nh_del_ip_test    '192.168.1.80\n'    ${2}
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}

删除后查找PHYID和IP对应关系
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    nphost_is_ip_phy_item_exist    <12,[N;4;0;2],[N;1;4;192],[N;1;5;168],[N;1;6;1],[N;1;7;80]>
    Log    ${execute_result}
    Should Not Be Equal    ${execute_result}    ${0}

# ***************  route ************************
配置同网段IP
    ${execute_result}=    Execute Command by UAgent    nh_set_ip_test    '192.168.0.80\n'    '255.255.255.0\n'    ${0}
    Log    ${execute_result}
    # Should be equal    ${execute_result}    ${0}

配置ROUTE
    ${execute_result}=    Execute Command by UAgent    nh_set_route_test    '192.168.0.5\n'    '255.255.255.0\n'    '192.168.0.1\n'    ${0}
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}

配置后查找ROUTE
    ${execute_result}    ${place}=    Execute Command With Out Datas by UAgent    nphost_is_route_item_exist    ${0x0500a8c0}    ${0x00ffffff}
    Log    ${execute_result}
    Should Be Equal    ${execute_result}    ${0}

删除ROUTE
    Sleep    3
    ${execute_result}=    Execute Command by UAgent    nh_del_route_test    '192.168.0.5\n'    '255.255.255.0\n'    '192.168.0.1\n'
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}

删除后查找ROUTE
    ${execute_result}    ${place}=    Execute Command With Out Datas by UAgent    nphost_is_route_item_exist    ${83994816}    ${16777215}
    Log    ${execute_result}
    Should Not Be Equal    ${execute_result}    ${0}

删除配置的同网段IP
    Sleep    1
    ${execute_result}=    Execute Command by UAgent    nh_del_ip_test    '192.168.0.80\n'    ${0}
    Log    ${execute_result}
    # Should be equal    ${execute_result}    ${0}

# ***************  vlan ************************

配置VLAN
    ${execute_result}=    Execute Command by UAgent    nh_set_vlanid_test    '192.168.1.5\n'    ${1}
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}

配置后查找VLAN
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    nphost_is_vlanid_item_exist    ${83994816}
    Log    ${execute_result}
    Should Be Equal    ${execute_result}    ${0}

删除VLAN
    Sleep    3
    ${execute_result}=    Execute Command by UAgent    nh_del_vlanid_test    '192.168.1.5\n'    ${1}
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}

删除后查找VLAN
    ${execute_result}    ${place}=    Execute Command With Out Datas by UAgent    nphost_is_route_item_exist    ${83994816}
    Log    ${execute_result}
    Should Not Be Equal    ${execute_result}    ${0}