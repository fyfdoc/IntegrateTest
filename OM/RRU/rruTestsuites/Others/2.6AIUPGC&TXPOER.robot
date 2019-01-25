*** Settings ***
Resource    ../resources/UAgentWrapper.robot
Library    ../utils/CiUtils.py

*** Variables ***
${host_name}    'SCTF'
${host_address}    172.27.45.250
${pId}    ${-1}

*** Test Cases ***
Connect Device
    Connect Device By UAgent Use Pid    ${host_name}    ${host_address}    ${pId}

Should PGC test successv
#    ${loop}    set Variable    ${0}
    :FOR    ${loop}    IN RANGE    8
    \    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    rru_osp_getpgc_remote
    \    ...  ${loop}    ${0}    <4>
    \    ${result_decode}    member_decode_to_integer_negative    ${reslut_list}
    \    log to console    \n ANT ${loop} TX PGC:${result_decode}(0.1dB)
    \    Should be equal    ${execute_result}    ${0}
    :FOR    ${loop}    IN RANGE    8
    \    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    rru_osp_getpgc_remote
    \    ...  ${loop}    ${1}    <4>
    \    ${result_decode}    member_decode_to_integer_negative    ${reslut_list}
    \    log to console    \n ANT ${loop} RX PGC:${result_decode}(0.1dB)
    \    Should be equal    ${execute_result}    ${0}
    :FOR    ${loop}    IN RANGE    8
    \    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    rru_osp_getpgc_remote
    \    ...  ${loop}    ${2}    <4>
    \    ${result_decode}    member_decode_to_integer_negative    ${reslut_list}
    \    log to console    \n ANT ${loop} FB PGC:${result_decode}(0.1dB)
    \    Should be equal    ${execute_result}    ${0}

Should TX POWER test successv
    ${execute_result}=    Execute Command by UAgent    AIU_WRITE_FPGA    ${0}    ${0x2107}    ${0}
    ${execute_result}=    Execute Command by UAgent    AIU_WRITE_FPGA    ${0}    ${0x2107}    ${0xffff}
    ${execute_result}=    Execute Command by UAgent    AIU_WRITE_FPGA    ${0}    ${0x2107}    ${0}
    ${execute_result}=    Execute Command by UAgent    Osp_Delay_Task    ${3000}
    :FOR    ${loop}    IN RANGE    8
    \    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    rru_ul_get_pow_dect_dmbg
    \    ...  ${loop}    ${4}    <4>
    \    ${result_decode}    member_decode_to_integer_negative    ${reslut_list}
    \    log to console    \n ANT ${loop} TX POWER SOLT 4:${result_decode}(0.1dBm)
    \    Should be equal    ${execute_result}    ${0}

    \    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    rru_ul_get_pow_dect_dmbg
    \    ...  ${loop}    ${9}    <4>
    \    ${result_decode}    member_decode_to_integer_negative    ${reslut_list}
    \    log to console    \n ANT ${loop} TX POWER SOLT 9:${result_decode}(0.1dBm)
    \    Should be equal    ${execute_result}    ${0}
Disconnect UAgent
    Disconnect UAgent Use Pid

*** Keywords ***

