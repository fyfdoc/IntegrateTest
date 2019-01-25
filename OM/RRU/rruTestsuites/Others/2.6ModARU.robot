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
Should TXPGC test success

Should CPU test success
    #Connect Device by UAgent Use Pid    ${host_name}    ${host_address}    ${pId}
    ${execute_result}=    Execute Command by UAgent    tst_rru_cpu_reg_write    ${8}    ${0}    ${0x12345678}
    Should be equal    ${execute_result}    ${0}
    ${execute_result}=    Execute Command by UAgent    tst_rru_cpu_reg_write    ${9}    ${0}    ${0x12345678}
    Should be equal    ${execute_result}    ${0}
    ${execute_result}=    Execute Command by UAgent    tst_rru_cpu_reg_write    ${10}    ${0}    ${0x12345678}
    Should be equal    ${execute_result}    ${0}
    ${execute_result}=    Execute Command by UAgent    tst_rru_cpu_reg_write    ${11}    ${0}    ${0x12345678}
    Should be equal    ${execute_result}    ${0}
    #Disconnect UAgent Use Pid

Should 2593 test successv
    #Connect Device by UAgent Use Pid    ${host_name}    ${host_address}    ${pId}
    ${execute_result}=    Execute Command by UAgent    tst_rru_power_read_mp2953    ${2}
    Should be equal    ${execute_result}    ${0}
    #Disconnect UAgent Use Pid

Should IIC test successv
    #Connect Device by UAgent Use Pid    ${host_name}    ${host_address}    ${pId}
    ${execute_result}=    Execute Command by UAgent    tst_rru_eeprom_bit_write    ${0}    ${0}    ${1}
    Should be equal    ${execute_result}    ${0}
    #Disconnect UAgent Use Pid

Should MP2953 test successv
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    rru_power_current_read_mp2953
    ...  ${0}    <4>
    ${result_decode}    member_decode_to_hex_little    ${reslut_list}
    log to console    \n ${result_decode}mA

Disconnect UAgent
    Disconnect UAgent Use Pid

*** Keywords ***

