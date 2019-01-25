# encoding utf-8
'''
*************************************************************
*** COPYRIGHT DaTang Mobile Communications Equipment CO.,LTD
*************************************************************
*文件名称：TestPCIe.robot
*功能描述：PCIe准出相关资源文件：准出涉及关键字列表
*使用方法：

-----------------------------------------------------------------------------------
*修改记录：                                                                       |
*##修改日期    |    修改人    |    修改描述    |                                  |
*2018-11-1          康凯辉         创建文件                                       |
----------------------------------------------------------------------------------|
*************************************************************
______________________________________________________________________________________
*关键字目录：                                                                        |
-------------------------------------------------------------------------------------|
*##PCIe链路相关关键字##                                                              |
*A1.测试x86到plp1 ARM的PCIe链路状态       -> Test x86 to plp1 ARM link status        |
*A2.测试x86到plp2 ARM的PCIe链路状态       -> Test x86 to plp2 ARM link status        |
*A3.测试plp1 ARM到plp2 ARM的PCIe链路状态  -> Test plp1 ARM to plp2 ARM link status   |
*##获取板卡所在槽位相关关键字##                                                      |
*B1.获取主控板所在槽位                    -> Get Slot Of Hsctd                       |
*B2.获取基带板所在槽位                    -> Get Slots Of Hbpod                      |
_____________________________________________________________________________________|

************************************************资源文件头结束**************************************************
'''
from pysnmp.smi.rfc1902 import ObjectIdentity
*** Settings ***
Library     DateTime
Resource    ../_COMM_/UAgentWrapper.robot
Library    SnmpLibrary
Library    BuiltIn
Library    ../../utils/CiUtils.py
Resource    ../_COMM_/SnmpMibHelper.robot
Resource    ../_COMM_/LogHelper.robot
#Suite Setup    Open Snmp Connection And Load Private MIB    ${DeviceIp}    ${Community}    ${MibName}
#Suite Setup    Open Snmp Connection And Load Private MIB

*** Variables ***
${DeviceIp}    172.27.245.92
${Community}    public
${MibName}    DTM-TD-LTE-ENODEB-ENBMIB

${hsctd_address_base}    172.27.245
${hbpod_address_base}    172.27.246

@{hbpod_slots}
@{hsctd_slots}

*** Keywords ***
#***********************************************************************************
#功能     ：测试基带板x86到plp1 ARM的PCIe链路状态                                   *
#标签     ：PCIe                                                                   *
#索引     ：无                                                                     *
#入参     ：无                                                                     *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：10S                                                                    *
#所属模块 ：PCIe                                                                   *
#适用用例 ：                                                                       *
#负责人   ：康凯辉                                                                 *
#调用方法 ：直接输入关键字                                                         *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Test x86 to plp1 ARM link status
    [Documentation]    测试x86到plp arm链路状态
    [Tags]    PCIe
    [Arguments]
    [Teardown]    Log    x86 to plp1 arm link ok!
    [Timeout]    10S

#    @{hbpod_slots}    Get Slots Of Hbpod
#    Log    ${hbpod_slots}
    :For    ${loop_slotNo}    in    @{hbpod_slots}
    \    ${loop_slotNo}    Evaluate    int(${loop_slotNo})
    \    ${ip_address}    Catenate    SEPARATOR=.    ${hbpod_address_base}    ${loop_slotNo + 1}
    \    ${pid}    Set Variable    ${8}
    \    ${ret}=    Connect Device By UAgent Use Pid    hbpod bcp 8    ${ip_address}    ${pid}
    \    Should be equal    ${ret}    ${0}
    \    Execute Command by UAgent    dd_pcie_test_srcbuf_init
    \    ${execute_result}=    Execute Command by UAgent    fdd_osp_pcie_msg_link_test    ${0}    ${8}    ${128}    ${100}
    \    Should be equal    ${execute_result}    ${0}
    \    Sleep    1
    \    ${ret}=    Execute Command by UAgent    dd_pcie_get_x86_2_plp1_link_status
    \    Run Keyword If    ${ret} == 1    Log    x86到plp1链路正常
    \    ...    ELSE    Log    x86到plp1链路错误
    \    Disconnect UAgent Use Pid

#***********************************************************************************
#功能     ：测试基带板x86到plp2 ARM的PCIe链路状态                                   *
#标签     ：PCIe                                                                   *
#索引     ：无                                                                     *
#入参     ：无                                                                     *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：10S                                                                    *
#所属模块 ：PCIe                                                                   *
#适用用例 ：                                                                       *
#负责人   ：康凯辉                                                                 *
#调用方法 ：直接输入关键字                                                         *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Test x86 to plp2 ARM link status
    [Documentation]    测试x86到plp arm链路状态
    [Tags]    PCIe
    [Arguments]
    [Teardown]    Log    x86 to plp2 arm link ok!
    [Timeout]    10S

#    @{hbpod_slots}    获取基带板槽位列表
    :For    ${loop_slotNo}    in    @{hbpod_slots}
    \    ${loop_slotNo}    Evaluate    int(${loop_slotNo})
    \    ${ip_address}    Catenate    SEPARATOR=.    ${hbpod_address_base}    ${loop_slotNo + 1}
    \    ${pid}    Set Variable    ${8}
    \    ${ret}=    Connect Device By UAgent Use Pid    hbpod bcp 8    ${ip_address}    ${pid}
    \    Should be equal    ${ret}    ${0}
    \    Execute Command by UAgent    dd_pcie_test_srcbuf_init
    \    ${execute_result}=    Execute Command by UAgent    fdd_osp_pcie_msg_link_test    ${0}    ${10}    ${130}    ${100}
    \    Should be equal    ${execute_result}    ${0}
    \    Sleep    1
    \    ${ret}=    Execute Command by UAgent    dd_pcie_get_x86_2_plp2_link_status
    \    Run Keyword If    ${ret} == 1    Log    x86到plp2链路正常
    \    ...    ELSE    Log    x86到plp2链路错误
    \    Disconnect UAgent Use Pid


#***********************************************************************************
#功能     ：测试基带板plp1 ARM到plp2 ARM的PCIe链路状态                             *
#标签     ：PCIe                                                                   *
#索引     ：无                                                                     *
#入参     ：无                                                                     *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：10S                                                                    *
#所属模块 ：PCIe                                                                   *
#适用用例 ：                                                                       *
#负责人   ：康凯辉                                                                 *
#调用方法 ：直接输入关键字                                                         *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Test plp1 ARM to plp2 ARM link status
    [Documentation]    测试plp1 arm到plp2 arm链路状态
    [Tags]    PCIe
    [Arguments]
    [Teardown]    Log    plp1 arm to plp2 arm link ok!
    [Timeout]    10S

#    @{hbpod_slots}    Get Slots Of Hbpod
    :For    ${loop_slotNo}    in    @{hbpod_slots}
    \    ${loop_slotNo}    Evaluate    int(${loop_slotNo})
    \    ${ip_address}    Catenate    SEPARATOR=.    ${hbpod_address_base}    ${loop_slotNo + 11}
    \    ${pid}    Set Variable    ${0}
    \    ${ret}=    Connect Device By UAgent Use Pid    hbpod plp1 0    ${ip_address}    ${pid}
    \    Should be equal    ${ret}    ${0}
    \    Execute Command by UAgent    dd_pcie_test_srcbuf_init
    \    ${execute_result}=    Execute Command by UAgent    fdd_osp_pcie_msg_link_test    ${0}    ${10}    ${133}    ${100}
    \    Should be equal    ${execute_result}    ${0}
    \    Sleep    1
    \    ${ret}=    Execute Command by UAgent    dd_pcie_get_plp1_2_plp2_link_status
    \    Run Keyword If    ${ret} == 1    Log    plp1到plp2链路正常
    \    ...    ELSE    Log    plp1到plp2链路错误
    \    Disconnect UAgent Use Pid

#***********************************************************************************
#功能     ：获取所有主控板所在槽位号                                               *
#标签     ：PCIe                                                                   *
#索引     ：无                                                                     *
#入参     ：无                                                                     *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：10S                                                                    *
#所属模块 ：PCIe                                                                   *
#适用用例 ：                                                                       *
#负责人   ：康凯辉                                                                 *
#调用方法 ：直接输入关键字                                                         *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Get Slot Of Hsctd
    [Documentation]    获取主控板所在槽位
    [Tags]
    [Arguments]
    [Teardown]    Log    get slot of hsctd slot ok!
    [Timeout]    10S

    ${boardEntry}    Get Oid By Name    ${MibName}    boardRowStatus
    Log    ${boardEntry}
    @{aom_slotNo_list}    Get board of aom or som    aom    ${boardEntry}    ${16}
    [Return]    @{aom_slotNo_list}

#***********************************************************************************
#功能     ：获取所有基带板所在槽位号                                               *
#标签     ：PCIe                                                                   *
#索引     ：无                                                                     *
#入参     ：无                                                                     *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：10S                                                                    *
#所属模块 ：PCIe                                                                   *
#适用用例 ：                                                                       *
#负责人   ：康凯辉                                                                 *
#调用方法 ：直接输入关键字                                                         *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Get Slots Of Hbpod
    [Documentation]    获取基带板所在槽位
    [Tags]
    [Arguments]
    [Teardown]    Log    get slots of hbpod slot ok!
    [Timeout]    10S

    ${boardEntry}    Get Oid By Name    ${MibName}    boardRowStatus
    Log    ${boardEntry}
    @{som_slotNo_list}    Get board of aom or som    som    ${boardEntry}    ${16}
    [Return]    @{som_slotNo_list}


