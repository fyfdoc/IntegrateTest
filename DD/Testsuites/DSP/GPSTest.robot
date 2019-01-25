 #    encoding utf-8

'''
GPS测试
'''
from pysnmp.smi.rfc1902 import ObjectIdentity
*** Settings ***
Resource    ../../Resources/DSP/GPSResource.robot
Resource    ../../Resources/_COMM_/UAgentWrapper.robot
Resource    ../../Resources/_COMM_/SnmpMibHelper.robot
Resource    ../../Resources/_COMM_/LogHelper.robot
Library     ../../../utils/CiUtils.py
Suite Setup           Open Snmp Connection And Load Private MIB

*** Variables ***

*** Keywords ***

*** Test Cases ***
Test GPS
    ${boardEntry}    Get Oid By Name    ${Mib}    boardRowStatus
    Log    ${boardEntry}
    @{aom_slotNo_list}    Get board of aom or som    aom    ${boardEntry}    ${16}
    :FOR    ${loop_slotNo}    in    @{aom_slotNo_list}
    \    ${hsctd_slot}    Evaluate    int(${loop_slotNo})
    \    ${ip_addr}    Catenate    SEPARATOR=.    ${hsctd_addr_base}    ${hsctd_slot + 91}
    \    ${pid}    Set Variable    ${2}
    \    Connect Device By UAgent Use Pid    hsctd scp 2     ${ip_addr}    ${pid}
    \    gps_pp1s_test    ${0x4101b}
    \    gps_tod_test     ${0x4101c}
    \    link_pp1s_test
    \    link_tod_test    <4>     <4>
    \    gps_lock_test    ${0x4101a}
    \    disconnect by pid



