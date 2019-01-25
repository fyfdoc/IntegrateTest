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

Should CPU test success
    ${execute_result}=    Execute Command by UAgent    tst_rru_cpu_reg_write    ${8}    ${0}    ${0x12345678}
    Should be equal    ${execute_result}    ${0}
    ${execute_result}=    Execute Command by UAgent    tst_rru_cpu_reg_write    ${9}    ${0}    ${0x12345678}
    Should be equal    ${execute_result}    ${0}
    ${execute_result}=    Execute Command by UAgent    tst_rru_cpu_reg_write    ${10}    ${0}    ${0x12345678}
    Should be equal    ${execute_result}    ${0}
    ${execute_result}=    Execute Command by UAgent    tst_rru_cpu_reg_write    ${11}    ${0}    ${0x12345678}
    Should be equal    ${execute_result}    ${0}


Should GPIO test success

    ${execute_result}=    Execute Command by UAgent    tst_rru_gpio_bitwrite    ${74}    ${0}
    Should be equal    ${execute_result}    ${0}


Should LED test successv

    ${execute_result}=    Execute Command by UAgent    tst_rru_led_control    ${102}    ${0}
    Should be equal    ${execute_result}    ${0}
    ${execute_result}=    Execute Command by UAgent    tst_rru_led_control    ${103}    ${0}
    Should be equal    ${execute_result}    ${0}
    ${execute_result}=    Execute Command by UAgent    tst_rru_led_control    ${74}    ${0}
    Should be equal    ${execute_result}    ${0}


Should IIC test successv

    ${execute_result}=    Execute Command by UAgent    tst_rru_eeprom_bit_write    ${0}    ${0}    ${1}
    Should be equal    ${execute_result}    ${0}


Should EEPROM test successv

    ${execute_result}=    Execute Command by UAgent    tst_rru_eeprom_bit_write    ${0}    ${0}    ${1}
    Should be equal    ${execute_result}    ${0}

Should OPT test successv

    ${execute_result}=    Execute Command by UAgent    rru_gpio_iic_pincfg    ${5}    ${0}
    ${execute_result}=    Execute Command by UAgent    rru_gpio_iic_bytewrite    ${0x50}    ${0}    ${0}    ${0}
    Should be equal    ${execute_result}    ${0}

Should MP2953 test successv

    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    rru_power_volt_read_mp2953
    ...  ${0}    <2>
    ${result_decode}    member_decode_to_integer_little    ${reslut_list}
    log to console    \n MP2953A VOLT:${result_decode}mV

    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    rru_power_current_read_mp2953
    ...  ${0}    <2>
    ${result_decode}    member_decode_to_integer_little    ${reslut_list}
    log to console    \n MP2953A CURR:${result_decode}A

    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    rru_power_temp_read_mp2953
    ...  ${0}    <2>
    ${result_decode}    member_decode_to_integer_little    ${reslut_list}
    log to console    \n MP2953A TEMP:${result_decode}C

    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    rru_power_volt_read_mp2953
    ...  ${1}    <2>
    ${result_decode}    member_decode_to_integer_little    ${reslut_list}
    log to console    \n MP2953B VOLT:${result_decode}mV

    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    rru_power_current_read_mp2953
    ...  ${1}    <2>
    ${result_decode}    member_decode_to_integer_little    ${reslut_list}
    log to console    \n MP2953B CURR:${result_decode}A

    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    rru_power_temp_read_mp2953
    ...  ${1}    <2>
    ${result_decode}    member_decode_to_integer_little    ${reslut_list}
    log to console    \n MP2953B TEMP:${result_decode}C

Should EM2120 test successv
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    rru_power_volt_read_em2120
    ...  ${2}    <2>
    ${result_decode}    member_decode_to_integer_little    ${reslut_list}
    log to console    \n EM2120 VOLT:${result_decode}mV

    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    rru_power_curr_read_em2120
    ...  ${2}    <2>
    ${result_decode}    member_decode_to_integer_little    ${reslut_list}
    log to console    \n EM2120 CURR:${result_decode}mA

    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    rru_power_temp_read_em2120
    ...  ${2}    <2>
    ${result_decode}    member_decode_to_integer_little    ${reslut_list}
    log to console    \n EM2120 TEMP:${result_decode}C

Should SPI test success

    ${execute_result}=    Execute Command by UAgent    rru_gpio_spi_pincfg    ${7}    ${0}
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    rru_pll_reg_read
    ...  ${0x508}    <1>
    ${result_decode}    member_decode_to_hex_little    ${reslut_list}
    log to console    \n PLL 2953 REG:${result_decode}

Should PLL test successv

    ${execute_result}=    Execute Command by UAgent    rru_gpio_spi_pincfg    ${7}    ${0}
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    rru_pll_reg_read
    ...  ${0x508}    <1>
    ${result_decode}    member_decode_to_hex_little    ${reslut_list}
    log to console    \n PLL 2953 REG:${result_decode}
    Should be equal    ${execute_result}    ${0}

Should CLKBUF test successv

    ${execute_result}=    Execute Command by UAgent    tst_rru_clkbuf_gpio_regread    ${0}
    Should be equal    ${execute_result}    ${0}

Should FPGAREG test successv

    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    rru_fpga_reg_read_spi
    ...  ${0}    ${0}    <4>
    ${result_decode}    member_decode_to_hex_little    ${reslut_list}
    log to console    \n FPGA VRESION:${result_decode}

Disconnect UAgent
    Disconnect UAgent Use Pid

*** Keywords ***

