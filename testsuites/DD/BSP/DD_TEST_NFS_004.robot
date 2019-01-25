from pysnmp.smi.rfc1902 import ObjectIdentity


*** Keywords ***
Open Snmp Connection And Load Private MIB
   [Arguments]   ${dstIp}       ${Comitty}      ${mib}
   Open Snmp Connection       ${dstIp}          ${Comitty}
   Load Mib      DTM-TD-LTE-ENODEB-ENBMIB


hsctd idxaddr
    ${boardEntry}    Get Oid By Name    ${Mib}    boardRowStatus
    Log    ${boardEntry}
    @{aom_slotNo_list}    Get board of aom or som    aom    ${boardEntry}    ${16}
    [Return]    @{aom_slotNo_list}

#hbpod idxaddr
#    ${boardEntry}    Get Oid By Name    ${Mib}    boardRowStatus
#    Log    ${boardEntry}
#    @{som_slotNo_list}    Get board of aom or som    som    ${boardEntry}    ${16}
#    [Return]    @{som_slotNo_list}

#Test
for mountnfs test
    [Arguments]    ${slot}    ${rangeno}
    :FOR    ${loop}    IN RANGE    ${rangeno}
    \   ${mkdir}=    Execute Command by UAgent    cmd    'mkdir /test -p'    ''
    \   log    ${mkdir}
    \   Sleep    1
    \   ${mountnfs_result}=    Execute Command by UAgent    mountnfs    '10.0.${hsctd_slot}.192:/ramDisk'    '/test'    'nfs'    ${0}    'nolock'    ''
    \   Log    ${mountnfs_result}
    \   Should be equal    ${mountnfs_result}    ${0}
    \   Sleep    2
    \   ${umount}=    Execute Command by UAgent    umount    '/test'    ''
    \   log    ${umount}
    \   Should be equal    ${umount}    ${0}
    \   Sleep    1
    \   ${rm}=    Execute Command by UAgent    cmd    'rm /test -r'    ''
    \   log    ${rm}
    \   Sleep    1

*** Settings ***
Resource    ../../../resources/UAgentWrapper.robot
Library     DateTime
Library    SnmpLibrary
Library    BuiltIn
Library    ../../../utils/CiUtils.py
Resource    ../../../resources/SnmpMibHelper.robot
Resource    ../../../resources/LogHelper.robot
Resource    ../../../resources/UploadLogsAndRecoverGnb.robot
Suite Setup           Open Snmp Connection And Load Private MIB          ${IP}         ${Comitty}       ${Mib}

*** Variables ***
${IP}             172.27.245.92
${Comitty}        public
#${Comitty}       dtm.1234
${Mib}            DTM-TD-LTE-ENODEB-ENBMIB

${hsctd_address_base}    172.27.245
${data}    'nolock'
${mkdir}    'mkdir /test -p'
${umounttest}    'umount /test'
${rmtest}    'rm /test -r'
${hbpod_address_base}    172.27.246

@{hbpod_slots}
@{hsctd_slots}
${som}    som

*** Test Cases ***
get idxaddr
    @{hsctd_slots}    hsctd idxaddr
   #@{hbpod_slots}    hbpod idxaddr
    ${slot1}    Evaluate    int(@{hsctd_slots}[0])
    Set Suite Variable    ${hsctd_slot}    ${slot1}
    # log to console    ${hsctd_slot}
   #${slot2}    Evaluate    int(@{hbpod_slots}[0])
   #Set Suite Variable    ${hbpod_slot}    ${slot2}
    # log to console    ${hbpod0_slot}

hsctd mountnfs test
    ${ip_address}    Catenate    SEPARATOR=.    ${hsctd_address_base}    ${hsctd_slot + 91}
    ${pid}    Set Variable    ${2}
    Connect Device By UAgent Use Pid    hsctd    ${ip_address}    ${pid}
    :FOR    ${loop}    in    20
    \   ${mkdir}=    Execute Command by UAgent    cmd    ${mkdir}    ''
    \   log    ${mkdir}
    \   #Should be equal    ${mkdir}    ${0}
    \   Sleep    1
    \   ${mountnfs_result}=    Execute Command by UAgent    mountnfs    '10.0.${hsctd_slot}.192:/ramDisk'    '/test'    'nfs'    ${0}    ${data}    ''
    \   Log    ${mountnfs_result}
    \   Should be equal    ${mountnfs_result}    ${0}
    \   Sleep    2
    \   ${umount}=    Execute Command by UAgent    umount    '/test'    ''
    \   log    ${umount}
    \   Should be equal    ${umount}    ${0}
    \   Sleep    1
    \   ${rm}=    Execute Command by UAgent    cmd    ${rmtest}    ''
    \   log    ${rm}
    \   #Should be equal    ${rm}    ${0}
    \   Sleep    1
    Disconnect UAgent Use Pid
hbpod x86 mountnfs test
    ${boardEntry}    Get Oid By Name    ${Mib}    boardRowStatus
    Log    ${boardEntry}
    @{som_slotNo_list}    Get board of aom or som    ${som}    ${boardEntry}    ${16}
    :FOR    ${loop_slotNo}    in    @{som_slotNo_list}
    \   ${hbpod_slot}    Evaluate    int(${loop_slotNo})
    \   ${ip_address}    Catenate    SEPARATOR=.    ${hbpod_address_base}    ${hbpod_slot + 1}
    \   Log    ${loop_slotNo}'s board log upload is complete!
    \   ${pid}    Set Variable    ${2}
    \   Connect Device By UAgent Use Pid    hbpod x86    ${ip_address}    ${pid}
    \   for mountnfs test    ${hbpod_slot}    ${20}
    \   Disconnect UAgent Use Pid

hbpod plp1 mountnfs test
    ${boardEntry}    Get Oid By Name    ${Mib}    boardRowStatus
    Log    ${boardEntry}
    @{som_slotNo_list}    Get board of aom or som    ${som}    ${boardEntry}    ${16}
    :FOR    ${loop_slotNo}    in    @{som_slotNo_list}
    \   ${hbpod_slot}    Evaluate    int(${loop_slotNo})
    \   ${ip_address}    Catenate    SEPARATOR=.    ${hbpod_address_base}    ${hbpod_slot + 11}
    \   Log    ${loop_slotNo}'s board log upload is complete!
    \   ${pid}    Set Variable    ${0}
    \   Connect Device By UAgent Use Pid    hbpod plp1    ${ip_address}    ${pid}
    \   for mountnfs test    ${hbpod_slot}    ${20}
    \   Disconnect UAgent Use Pid

hbpod plp2 mountnfs test
    ${boardEntry}    Get Oid By Name    ${Mib}    boardRowStatus
    Log    ${boardEntry}
    @{som_slotNo_list}    Get board of aom or som    ${som}    ${boardEntry}    ${16}
    :FOR    ${loop_slotNo}    in    @{som_slotNo_list}
    \   ${hbpod_slot}    Evaluate    int(${loop_slotNo})
    \   ${ip_address}    Catenate    SEPARATOR=.    ${hbpod_address_base}    ${hbpod_slot + 21}
    \   Log    ${loop_slotNo}'s board log upload is complete!
    \   ${pid}    Set Variable    ${0}
    \   Connect Device By UAgent Use Pid    hbpod plp2    ${ip_address}    ${pid}
    \   for mountnfs test    ${hbpod_slot}    ${20}
    \   Disconnect UAgent Use Pid

