*** Settings ***
Resource    ../resources/UAgentWrapper.robot
Library    ../utils/CiUtils.py

*** Variables ***
${host_name}    'SCTF'
${host_address}    172.27.45.251
${pId}    ${-1}

*** Test Cases ***
Connect Device
    Connect Device By UAgent Use Pid    ${host_name}    ${host_address}    ${pId}

Should IFPOWER & TXOPD test successv
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    rru_dl_pow_dect_wait
    ...  <4>
    :FOR    ${loop}    IN RANGE    16
    \    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    rru_dl_pow_dect_reg_read
    \    ...  ${loop}    ${1}    <2>
    \    ${result_decode}    member_decode_to_integer_negative    ${reslut_list}
    \    log to console    \n ANT ${loop} IF POWER:${result_decode}(dBfs)
    \    Should be equal    ${execute_result}    ${0}

    :FOR    ${loop}    IN RANGE    16
    \    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    rru_dl_pow_dect_reg_read
    \    ...  ${loop}    ${2}    <2>
    \    ${result_decode}    member_decode_to_integer_negative    ${reslut_list}
    \    log to console    \n ANT ${loop} TXOPD:${result_decode}(dB)
    \    Should be equal    ${execute_result}    ${0}


Disconnect UAgent
    Disconnect UAgent Use Pid

*** Keywords ***

