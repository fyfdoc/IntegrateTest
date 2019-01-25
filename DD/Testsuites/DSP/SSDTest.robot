 #    encoding utf-8

'''
SSD测试
'''
from pysnmp.smi.rfc1902 import ObjectIdentity
*** Settings ***
Resource    ../../Resources/DSP/SSDResource.robot
Resource    ../../Resources/_COMM_/UAgentWrapper.robot
Resource    ../../Resources/_COMM_/SnmpMibHelper.robot
Resource    ../../Resources/_COMM_/LogHelper.robot
Library     ../../../utils/CiUtils.py
Suite Setup           Open Snmp Connection And Load Private MIB

*** Variables ***
${write_val}    ${269488146}

*** Keywords ***

*** Test Cases ***
Test SSD HSCTD
    ${boardEntry}    Get Oid By Name    ${Mib}    boardRowStatus
    Log    ${boardEntry}
    @{aom_slotNo_list}    Get board of aom or som    aom    ${boardEntry}    ${16}
    :FOR    ${loop_slotNo}    in    @{aom_slotNo_list}
    \    ${hsctd_slot}    Evaluate    int(${loop_slotNo})
    \    ${ip_addr}    Catenate    SEPARATOR=.    ${hsctd_addr_base}    ${hsctd_slot + 91}
    \    ${pid}    Set Variable    ${2}
    \    Connect Device By UAgent Use Pid    hsctd scp 2     ${ip_addr}    ${pid}
    \    FUN get core version    <19,[S;0;0;0]>
#   \    FUN get boot version    <16,[S;0;0;0]>
    \    FUN get epld version    <22,[S;0;0;0]>
#   \    FUN get fsbl version    <16,[S;0;0;0]>
    \    FUN get dpdk version    <21,[S;0;0;0]>
    \    FUN get hardware version    <6,[S;0;0;0]>
#   \    FUN get si version    <5,[S;0;0;0]>
    \    FUN get board type    <1,[S;0;0;0]>
    \    disconnect by pid

Test SSD HBPOD_x86
    ${boardEntry}    Get Oid By Name    ${Mib}    boardRowStatus
    Log    ${boardEntry}
    @{som_slotNo_list}    Get board of aom or som    som    ${boardEntry}    ${16}
    :FOR    ${loop_slotNo}    in    @{som_slotNo_list}
    \    ${hbpod_slot}    Evaluate    int(${loop_slotNo})
    \    ${ip_addr}    Catenate    SEPARATOR=.    ${hbpod_addr_base}    ${hbpod_slot + 1}
    \    ${pid}    Set Variable    ${2}
    \    Connect Device By UAgent Use Pid    hbpod scp 2    ${ip_addr}    ${pid}
    \    FUN FPGA write read    ${write_val}
    \    FUN get fpga version   ${0x0000}    <4>
    \    FUN get fpga version   ${0x4000}    <4>
    \    FUN get fpga version   ${0x6000}    <4>
    \    FUN get core version    <19,[S;0;0;0]>
#   \    FUN get version boot    <16,[S;0;0;0]>
    \    FUN get epld version    <22,[S;0;0;0]>
#   \    FUN get version fsbl    <16,[S;0;0;0]>
    \    FUN get dpdk version    <21,[S;0;0;0]>
    \    FUN get hardware version    <6,[S;0;0;0]>
#   \    FUN get version si    <5,[S;0;0;0]>
    \    FUN get board type    <1,[S;0;0;0]>
    \    disconnect by pid

Test SSD HBPOD_PLP1
    ${boardEntry}    Get Oid By Name    ${Mib}    boardRowStatus
    Log    ${boardEntry}
    @{som_slotNo_list}    Get board of aom or som    som    ${boardEntry}    ${16}
    :FOR    ${loop_slotNo}    in    @{som_slotNo_list}
    \    ${hbpod_slot}    Evaluate    int(${loop_slotNo})
    \    ${ip_addr}    Catenate    SEPARATOR=.    ${hbpod_addr_base}    ${hbpod_slot + 11}
    \    ${pid}    Set Variable    ${0}
    \    Connect Device By UAgent Use Pid    hbpod plp1    ${ip_addr}    ${pid}
    \    FUN get core version    <19,[S;0;0;0]>
    \    FUN get boot version    <16,[S;0;0;0]>
#   \    FUN get epld version    <22,[S;0;0;0]>
    \    FUN get fsbl version    <16,[S;0;0;0]>
#   \    FUN get dpdk version    <21,[S;0;0;0]>
#   \    FUN get hardware version    <6,[S;0;0;0]>
    \    FUN get si version    <5,[S;0;0;0]>
#   \    FUN get board type    <1,[S;0;0;0]>
    \    disconnect by pid

Test SSD HBPOD_PLP2
    ${boardEntry}    Get Oid By Name    ${Mib}    boardRowStatus
    Log    ${boardEntry}
    @{som_slotNo_list}    Get board of aom or som    som    ${boardEntry}    ${16}
    :FOR    ${loop_slotNo}    in    @{som_slotNo_list}
    \    ${hbpod_slot}    Evaluate    int(${loop_slotNo})
    \    ${ip_addr}    Catenate    SEPARATOR=.    ${hbpod_addr_base}    ${hbpod_slot + 21}
    \    ${pid}    Set Variable    ${0}
    \    Connect Device By UAgent Use Pid    hbpod plp2    ${ip_addr}    ${pid}
    \    FUN get core version    <19,[S;0;0;0]>
    \    FUN get boot version    <16,[S;0;0;0]>
#   \    FUN get epld version    <22,[S;0;0;0]>
    \    FUN get fsbl version    <16,[S;0;0;0]>
#   \    FUN get dpdk version    <21,[S;0;0;0]>
#   \    FUN get hardware version    <6,[S;0;0;0]>
    \    FUN get si version    <5,[S;0;0;0]>
#   \    FUN get board type    <1,[S;0;0;0]>
    \    disconnect by pid