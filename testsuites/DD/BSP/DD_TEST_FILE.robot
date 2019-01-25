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

hbpod idxaddr
    ${boardEntry}    Get Oid By Name    ${Mib}    boardRowStatus
    Log    ${boardEntry}
    @{som_slotNo_list}    Get board of aom or som    som    ${boardEntry}    ${16}
    [Return]    @{som_slotNo_list}


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

${pc_ipconfig}
${hsctd_address_base}    172.27.245
${hbpod_address_base}    172.27.246
${FtpServerx86Ip}    172.27.245.100
${FtpServerarmIp}    172.27.246.100
${som}    som
@{hbpod_slots}
@{hsctd_slots}

*** Test Cases ***
get idxaddr
    @{hsctd_slots}    hsctd idxaddr
    @{hbpod_slots}    hbpod idxaddr
    ${slot1}    Evaluate    int(@{hsctd_slots}[0])
    Set Suite Variable    ${hsctd_slot}    ${slot1}
    # log to console    ${hsctd_slot}
    ${slot2}    Evaluate    int(@{hbpod_slots}[0])
    Set Suite Variable    ${hbpod_slot}    ${slot2}
    # log to console    ${hbpod0_slot}

hsctd file test
    ${ip_address}    Catenate    SEPARATOR=.    ${hsctd_address_base}    ${hsctd_slot + 91}
    ${pid}    Set Variable    ${2}
    Connect Device By UAgent Use Pid    hsctd scp 2    ${ip_address}    ${pid}
    File Download      ${FtpServerx86Ip}:\/\/D:\/xinjin\/soc\/libtest.so     \/ramDisk\/libtest.so
    Execute Command by UAgent    loadModule    '/ramDisk/libtest.so'    ''
    Sleep    1
    ${execute_result}=    Execute Command by UAgent    filetest    ''
    Should be equal    ${execute_result}    ${0}
    Sleep    1
    Execute Command by UAgent    unloadModule    '/ramDisk/libtest.so'    ''
    Execute Command by UAgent    cmd    'rm /ramDisk/libtest.so -rf'    ''
    Disconnect UAgent Use Pid


hbpod x86 file test
    ${boardEntry}    Get Oid By Name    ${Mib}    boardRowStatus
    Log    ${boardEntry}
    @{som_slotNo_list}    Get board of aom or som    ${som}    ${boardEntry}    ${16}
    :FOR    ${loop_slotNo}    in    @{som_slotNo_list}
    \   ${hbpod_slot}    Evaluate    int(${loop_slotNo})
    \   ${ip_address}    Catenate    SEPARATOR=.    ${hbpod_address_base}    ${hbpod_slot + 1}
    \   Log    ${loop_slotNo}'s board log upload is complete!
    \   ${pid}    Set Variable    ${2}
    \   Connect Device By UAgent Use Pid    hbpod scp 2    ${ip_address}    ${pid}
    \   File Download      ${FtpServerx86Ip}:\/\/D:\/xinjin\/soc\/libtest.so     \/ramDisk\/libtest.so
    \   Execute Command by UAgent    loadModule    '/ramDisk/libtest.so'    ''
    \   Sleep    1
    \   ${execute_result}=    Execute Command by UAgent    filetest    ''
    \   Log    ${execute_result}'s board log upload is complete!
    \   Should be equal    ${execute_result}    ${0}
    \   Sleep    1
    \   Execute Command by UAgent    unloadModule    '/ramDisk/libtest.so'    ''
    \   Execute Command by UAgent    cmd    'rm /ramDisk/libtest.so -rf'    ''
    \   Disconnect UAgent Use Pid


hbpod plp1 file test
    ${boardEntry}    Get Oid By Name    ${Mib}    boardRowStatus
    Log    ${boardEntry}
    @{som_slotNo_list}    Get board of aom or som    ${som}    ${boardEntry}    ${16}
    :FOR    ${loop_slotNo}    in    @{som_slotNo_list}
    \   ${hbpod_slot}    Evaluate    int(${loop_slotNo})
    \   ${ip_address}    Catenate    SEPARATOR=.    ${hbpod_address_base}    ${hbpod_slot + 11}
    \   Log    ${loop_slotNo}'s board log upload is complete!
    \   ${pid}    Set Variable    ${0}
    \   Connect Device By UAgent Use Pid    hbpod plp1    ${ip_address}    ${pid}
    \   File Download      ${FtpServerarmIp}:\/\/D:\/xinjin\/soc\/libtest_arm.so     \/ramDisk\/libtest_arm.so
    \   Execute Command by UAgent    loadModule    '/ramDisk/libtest_arm.so'    ''
    \   Sleep    1
    \   ${execute_result}=    Execute Command by UAgent    filetest    ''
    \   Log    ${execute_result}'s board log upload is complete!
    \   Should be equal    ${execute_result}    ${0}
    \   Sleep    1
    \   Execute Command by UAgent    unloadModule    '/ramDisk/libtest_arm.so'    ''
    \   Execute Command by UAgent    cmd    'rm /ramDisk/libtest_arm.so -rf'    ''
    \   Disconnect UAgent Use Pid



hbpod plp2 file test
    ${boardEntry}    Get Oid By Name    ${Mib}    boardRowStatus
    Log    ${boardEntry}
    @{som_slotNo_list}    Get board of aom or som    ${som}    ${boardEntry}    ${16}
    :FOR    ${loop_slotNo}    in    @{som_slotNo_list}
    \   ${hbpod_slot}    Evaluate    int(${loop_slotNo})
    \   ${ip_address}    Catenate    SEPARATOR=.    ${hbpod_address_base}    ${hbpod_slot + 21}
    \   Log    ${loop_slotNo}'s board log upload is complete!
    \   ${pid}    Set Variable    ${0}
    \   Connect Device By UAgent Use Pid    hbpod plp 2    ${ip_address}    ${pid}
    \   File Download      ${FtpServerarmIp}:\/\/D:\/xinjin\/soc\/libtest_arm.so     \/ramDisk\/libtest_arm.so
    \   Execute Command by UAgent    loadModule    '/ramDisk/libtest_arm.so'    ''
    \   Sleep    1
    \   ${execute_result}=    Execute Command by UAgent    filetest    ''
    \   Log    ${execute_result}'s board log upload is complete!
    \   Should be equal    ${execute_result}    ${0}
    \   Sleep    1
    \   Execute Command by UAgent    unloadModule    '/ramDisk/libtest_arm.so'    ''
    \   Execute Command by UAgent    cmd    'rm /ramDisk/libtest_arm.so -rf'    ''
    \   Disconnect UAgent Use Pid


