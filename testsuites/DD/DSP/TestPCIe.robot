# encoding utf-8
'''
pcie链路测试
'''
from pysnmp.smi.rfc1902 import ObjectIdentity
*** Settings ***
Library     DateTime
Resource    ../../../resources/UAgentWrapper.robot
Library    SnmpLibrary
Library    BuiltIn
Library    ../../../utils/CiUtils.py
Resource    ../../../resources/SnmpMibHelper.robot
Resource    ../../../resources/LogHelper.robot
Suite Setup    Open Snmp Connection And Load Private MIB    ${DeviceIp}    ${Community}    ${MibName}


*** Variables ***
${DeviceIp}    172.27.245.92
${Community}    public
${MibName}    DTM-TD-LTE-ENODEB-ENBMIB

${hsctd_address_base}    172.27.245
${hbpod_address_base}    172.27.246

@{hbpod_slots}
@{hsctd_slots}

*** Test Cases ***
#获取基带板槽位号
#    @{hbpod_slots}    获取基带板槽位列表
#    Log    ${hbpod_slots}

Test Fun x86到plp ARM链路状态
    @{hbpod_slots}    获取基带板槽位列表
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

#Test Fun x86到plp2 ARM链路状态
#    @{hbpod_slots}    获取基带板槽位列表
#    :For    ${loop_slotNo}    in    @{hbpod_slots}
#    \    ${loop_slotNo}    Evaluate    int(${loop_slotNo})
#    \    ${ip_address}    Catenate    SEPARATOR=.    ${hbpod_address_base}    ${loop_slotNo + 1}
#    \    ${pid}    Set Variable    ${8}
#    \    ${ret}=    Connect Device By UAgent Use Pid    hbpod bcp 8    ${ip_address}    ${pid}
#    \    Should be equal    ${ret}    ${0}
#    \    Execute Command by UAgent    dd_pcie_test_srcbuf_init
    \    ${execute_result}=    Execute Command by UAgent    fdd_osp_pcie_msg_link_test    ${0}    ${10}    ${130}    ${100}
    \    Should be equal    ${execute_result}    ${0}
    \    Sleep    1
    \    ${ret}=    Execute Command by UAgent    dd_pcie_get_x86_2_plp2_link_status
    \    Run Keyword If    ${ret} == 1    Log    x86到plp2链路正常
    \    ...    ELSE    Log    x86到plp2链路错误
    \    Disconnect UAgent Use Pid



Test Fun plp1 ARM到plp2 ARM链路状态
    @{hbpod_slots}    获取基带板槽位列表
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

*** Keywords ***
获取主控板槽位列表
    ${boardEntry}    Get Oid By Name    ${MibName}    boardRowStatus
    Log    ${boardEntry}
    @{aom_slotNo_list}    Get board of aom or som    aom    ${boardEntry}    ${16}
    [Return]    @{aom_slotNo_list}

获取基带板槽位列表
    ${boardEntry}    Get Oid By Name    ${MibName}    boardRowStatus
    Log    ${boardEntry}
    @{som_slotNo_list}    Get board of aom or som    som    ${boardEntry}    ${16}
    [Return]    @{som_slotNo_list}
