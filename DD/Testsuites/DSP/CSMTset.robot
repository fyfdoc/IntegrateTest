# encoding utf-8
'''
CSM测试
'''
from pysnmp.smi.rfc1902 import ObjectIdentity
*** Settings ***
Resource    ../../Resources/DSP/CSMResource.robot
Resource    ../../Resources/_COMM_/UAgentWrapper.robot
Resource    ../../Resources/_COMM_/SnmpMibHelper.robot
Suite Setup    Open Snmp Connection And Load Private MIB

*** Variables ***


*** Keywords ***


*** Test Cases ***
test_csm_hbpod_x86
    ${boardEntry}    Get Oid By Name    ${Mib}    boardRowStatus
    @{som_slotNo_list}    Get board of aom or som    som    ${boardEntry}    ${16}
    :FOR    ${loop_slotNo}    in    @{som_slotNo_list}
    \    ${hbpod_slot}    Evaluate    int(${loop_slotNo})
    \    ${ip_addr}    Catenate    SEPARATOR=.    ${hbpod_addr_base}    ${hbpod_slot + 1}
    \    Connect Device By UAgent Use Pid    ${hbpod_x86}    ${ip_addr}    ${2}
    \    Test function get the slotnum    <4>
    \    Test functino get the halfsfn->usoffset    <4>
    \    Test function get the slot->usoffset    <4>
    \    Test function get the 125uscnt    <4>
    \    Test function get the cycleoffset    <4>
    \    Test function get the sfn    <4>
    \    Test function get the halfsfn    <4>
    \    disconnect by pid

test_csm_plp1
    ${boardEntry}    Get Oid By Name    ${Mib}    boardRowStatus
    @{som_slotNo_list}    Get board of aom or som    som    ${boardEntry}    ${16}
    :FOR    ${loop_slotNo}    in    @{som_slotNo_list}
    \    ${hbpod_slot}    Evaluate    int(${loop_slotNo})
    \    ${ip_addr}    Catenate    SEPARATOR=.    ${hbpod_addr_base}    ${hbpod_slot + 1 + 10}
    \    Connect Device By UAgent Use Pid    ${hbpod_plp1}    ${ip_addr}    ${0}
    \    Test function get the slotnum    <4>
    \    Test functino get the halfsfn->usoffset    <4>
    \    Test function get the slot->usoffset    <4>
#   \    Test function get the 125uscnt    <4>
#   \    Test function get the cycleoffset    <4>
    \    Test function get the sfn    <4>
    \    Test function get the halfsfn    <4>
    \    log to console    我是你的爸爸
    \    disconnect by pid

test_csm_plp2
    ${boardEntry}    Get Oid By Name    ${Mib}    boardRowStatus
    @{som_slotNo_list}    Get board of aom or som    som    ${boardEntry}    ${16}
    :FOR    ${loop_slotNo}    in    @{som_slotNo_list}
    \    ${hbpod_slot}    Evaluate    int(${loop_slotNo})
    \    ${ip_addr}    Catenate    SEPARATOR=.    ${hbpod_addr_base}    ${hbpod_slot + 1 + 20}
    \   Connect Device By UAgent Use Pid    ${hbpod_plp2}    ${ip_addr}    ${0}
    \    Test function get the slotnum    <4>
    \    Test functino get the halfsfn->usoffset    <4>
    \    Test function get the slot->usoffset    <4>
#   \    Test function get the 125uscnt    <4>
#   \    Test function get the cycleoffset    <4>
    \    Test function get the sfn    <4>
    \    Test function get the halfsfn    <4>
    \    disconnect by pid
