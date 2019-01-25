 #    encoding utf-8

'''
SYSIIC测试
'''
from pysnmp.smi.rfc1902 import ObjectIdentity
*** Settings ***
Resource    ../../Resources/DSP/SYSIICResource.robot
Resource    ../../Resources/_COMM_/UAgentWrapper.robot
Resource    ../../Resources/_COMM_/SnmpMibHelper.robot
Resource    ../../Resources/_COMM_/LogHelper.robot
Library     ../../../utils/CiUtils.py
Suite Setup           Open Snmp Connection And Load Private MIB

*** Variables ***

*** Keywords ***

*** Test Cases ***
Test SYSIIC ABOUT HSCTD
    ${boardEntry}    Get Oid By Name    ${Mib}    boardRowStatus
    @{aom_slotNo_list}    Get board of aom or som    aom    ${boardEntry}    ${16}
    :FOR    ${loop_slotNo}    in    @{aom_slotNo_list}
    \    ${hsctd_slot}    Evaluate    int(${loop_slotNo})
    \    ${ip_addr}    Catenate    SEPARATOR=.    ${hsctd_addr_base}    ${hsctd_slot + 91}
    \    ${pid}    Set Variable    ${2}
    \    Connect Device By UAgent Use Pid    hsctd scp 2     ${ip_addr}    ${pid}
    \    Log     ${hsctd_slot}
    \    get board hardware status    ${hsctd_slot}
    \    get board software status    ${hsctd_slot}
    \    get hsctd temp         <8,[N;1;0;0],[N;1;1;${hsctd_slot}],[N;1;2;1],[N;1;3;0],[N;4;4;0]>
    \    get hsctd 12v input    <8,[N;1;0;0],[N;1;1;${hsctd_slot}],[N;1;2;20],[N;1;3;0],[N;4;4;0]>
    \    get hsctd power input  <8,[N;1;0;0],[N;1;1;${hsctd_slot}],[N;1;2;24],[N;1;3;0],[N;4;4;0]>
    get hbpod temp
    get fan temp                <8,[N;1;0;0],[N;1;1;12],[N;1;2;13],[N;1;3;0],[N;4;4;0]>
    get fan speed               <8,[N;1;0;0],[N;1;1;0],[N;1;2;0],[N;1;3;0],[N;2;4;0]>
    get fan speed               <8,[N;1;0;0],[N;1;1;1],[N;1;2;0],[N;1;3;0],[N;2;4;0]>
    get fan speed               <8,[N;1;0;0],[N;1;1;2],[N;1;2;0],[N;1;3;0],[N;2;4;0]>
    get psu vend type           <8,[N;1;0;0],[N;1;1;4],[N;1;2;12],[N;1;3;0],[N;4;4;0]>
    get psu pid identify        <8,[N;1;0;0],[N;1;1;4],[N;1;2;15],[N;1;3;0],[N;4;4;0]>
    get psu temp                <8,[N;1;0;0],[N;1;1;4],[N;1;2;3],[N;1;3;0],[N;4;4;0]>
    get psu volt input          <8,[N;1;0;0],[N;1;1;4],[N;1;2;10],[N;1;3;0],[N;4;4;0]>
    get psu power input         <8,[N;1;0;0],[N;1;1;4],[N;1;2;26],[N;1;3;0],[N;4;4;0]>
    get psu electricflow input  <8,[N;1;0;0],[N;1;1;4],[N;1;2;16],[N;1;3;0],[N;4;4;0]>
    get psu 12v output          <8,[N;1;0;0],[N;1;1;4],[N;1;2;19],[N;1;3;0],[N;4;4;0]>
    get psu alarm               <8,[N;1;0;0],[N;1;1;4],[N;1;2;17],[N;1;3;0],[N;4;4;0]>
    disconnect by pid

TEST SYSIIC ABOUT HBPOD
    ${boardEntry}    Get Oid By Name    ${Mib}    boardRowStatus
    @{som_slotNo_list}    Get board of aom or som    som    ${boardEntry}    ${16}
    :FOR    ${loop_slotNo}    in    @{som_slotNo_list}
    \    ${hbpod_slot}    Evaluate    int(${loop_slotNo})
    \    ${ip_addr}    Catenate    SEPARATOR=.    ${hbpod_addr_base}    ${hbpod_slot + 1}
    \    ${pid}    Set Variable    ${2}
    \    Connect Device By UAgent Use Pid    hbpod scp 2    ${ip_addr}    ${pid}
    \    get hbpod 12v input      ${hbpod_slot}     <4>
    \    get hbpod vu9p volt      ${hbpod_slot}     <4>
    \    get hbpod zu21dr volt    ${hbpod_slot}     <4>
    \    disconnect by pid
