#        encoding utf-8
'''
SSD测试
'''
from pysnmp.smi.rfc1902 import Object Identity

*** Settings ***
Resource    ../../../resources/UAgentWrapper.robot
Library     DateTime
Library    SnmpLibrary
Library    BuiltIn
Library    ../../../utils/CiUtils.py
Resource    ../../../resources/SnmpMibHelper.robot
Resource    ../../../resources/LogHelper.robot
Resource    ../../../resources/UploadLogsAndRecoverGnb.robot
Suite Setup           Open Snmp Connection And Load Private MIB       ${DeviceIP}       ${Community}       ${Mib}

*** Variables ***

${DeviceIP}    172.27.245.92
${Community}    public
${Mib}    DTM-TD-LTE-ENODEB-ENBMIB
${hsctd_addr_base}    172.27.245
${hbpod_addr_base}    172.27.246
${som}    som
${aom}    aom
${write_val}    ${269488146}
*** Keywords ***

FUN FPGA write read      #only hbpod
    ${execute_result}=    Execute Command by UAgent    ssd_fpga_write_test    ${0x20D}    ${write_val}
    Should be equal    ${execute_result}    ${0}
    ${execute_result}    ${result_list}=    Execute Command With Out Datas by UAgent    fdd_hal_fpga_read    ${0x20D}    <4>
    ${intval}    Evaluate    int.from_bytes(${result_list}[0],byteorder="little")
    Log    ${intval}
    Should be equal    ${intval}    ${write_val}
    Should be equal    ${execute_result}    ${0}
FUN FPGA get version VU9P
    ${execute_result}    ${result_list}=    Execute Command With Out Datas by UAgent    fdd_hal_fpga_read    ${0x0000}    <4>
    ${intval}    Evaluate    int.from_bytes(${result_list}[0],byteorder="little")
    Log    PLP0_${intval}
    Should be equal    ${execute_result}    ${0}

FUN FPGA get version PLP1_FPGA
    ${execute_result}    ${result_list}=    Execute Command With Out Datas by UAgent    fdd_hal_fpga_read    ${0x4000}    <4>
    ${intval}    Evaluate    int.from_bytes(${result_list}[0],byteorder="little")
    Log    PLP1_${intval}
    Should be equal    ${execute_result}    ${0}

FUN FPGA get version PLP2_FPGA
    ${execute_result}    ${result_list}=    Execute Command With Out Datas by UAgent    fdd_hal_fpga_read    ${0x6000}    <4>
    ${intval}    Evaluate    int.from_bytes(${result_list}[0],byteorder="little")
    Log    PLP2_${intval}
    Should be equal    ${execute_result}    ${0}

FUN FPGA reset
    ${execute_result}    ${result_list}=    Execute Command With Out Datas by UAgent    fdd_hal_fpga_read    ${0x0000}    <4>
    ${early_intval}    Evaluate    int.from_bytes(${result_list}[0],byteorder="little")
    Log    before reset PLP0_${early_intval}
    Should be equal    ${execute_result}    ${0}
    ${execute_result}=    Execute Command by UAgent    fdd_hal_epld_OR     ${7}    ${32}
    ${execute_result}    ${result_list}=    Execute Command With Out Datas by UAgent    fdd_hal_fpga_read    ${0x0000}    <4>
    ${centre_intval}    Evaluate    int.from_bytes(${result_list}[0],byteorder="little")
    Log    when reset PLP0_${centre_intval}
    Should be equal    ${centre_intval}    ${0xFFFFFFFF}
    Should be equal    ${execute_result}    ${0}
    ${execute_result}=    Execute Command by UAgent    init_fpga_device
    Log    init successed
    Should be equal    ${execute_result}    ${0}
    Sleep    500
    ${execute_result}    ${result_list}=    Execute Command With Out Datas by UAgent    fdd_hal_fpga_read    ${0x0000}    <4>
    ${late_intval}    Evaluate    int.from_bytes(${result_list}[0],byteorder="little")
    Log    after reset PLP0_${late_intval}
    Should be equal    ${late_intval}    ${early_intval}
    Should be equal    ${execute_result}    ${0}

FUN get version core
    ${execute_result}    ${result_list}=    Execute Command With Out Datas by UAgent     get_core_version    <19,[S;0;0;0]>
    Log    ${result_list[0]}
    Should be equal    ${execute_result}    ${0}

FUN get version boot      #PLP_ARM    X86无
    ${execute_result}    ${result_list}=    Execute Command With Out Datas by UAgent     get_boot_version    <16,[S;0;0;0]>
    Log    ${result_list[0]}
    Should be equal    ${execute_result}    ${0}

FUN get version epld
    ${execute_result}    ${result_list}=    Execute Command With Out Datas by UAgent     get_epld_version    <22,[S;0;0;0]>
    Log    ${result_list[0]}
    Should be equal    ${execute_result}    ${0}

FUN get version fsbl      #PLP_ARM    X86无
    ${execute_result}    ${result_list}=    Execute Command With Out Datas by UAgent     get_fsbl_version    <16,[S;0;0;0]>
    Log    ${result_list[0]}
    Should be equal    ${execute_result}    ${0}

FUN get version dpdk      #仅支持HSCTA/HBPOA
    ${execute_result}    ${result_list}=    Execute Command With Out Datas by UAgent     get_dpdk_version    <21,[S;0;0;0]>
    Log    ${result_list[0]}
    Should be equal    ${execute_result}    ${0}

FUN get version hardware
    ${execute_result}    ${result_list}=    Execute Command With Out Datas by UAgent     get_pcb_hardware_version    <6,[S;0;0;0]>
    Log    ${result_list[0]}
    Should be equal    ${execute_result}    ${0}

FUN get version si       #ARM si version
    ${execute_result}    ${result_list}=    Execute Command With Out Datas by UAgent     get_si_version    <5,[S;0;0;0]>
    Log    ${result_list[0]}
    Should be equal    ${execute_result}    ${0}

FUN get board type
    ${execute_result}    ${result_list}=    Execute Command With Out Datas by UAgent     ssd_ioctl   ${0x14009}    <1,[S;0;0;0]>
    Log    ${result_list[0]}
    Should be equal    ${execute_result}    ${0}

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
    \    FUN get version core
#   \    FUN get version boot
    \    FUN get version epld
#   \    FUN get version fsbl
    \    FUN get version dpdk
    \    FUN get version hardware
#   \    FUN get version si
    \    FUN get board type
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
    \    FUN FPGA write read
    \    FUN FPGA get version VU9P
    \    FUN FPGA get version PLP1_FPGA
    \    FUN FPGA get version PLP2_FPGA
#   \    FUN FPGA reset
    \    FUN get version core
#   \    FUN get version boot
    \    FUN get version epld
#   \    FUN get version fsbl
    \    FUN get version dpdk
    \    FUN get version hardware
#   \    FUN get version si
    \    FUN get board type
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
    \    FUN get version core
    \    FUN get version boot
#   \    FUN get version epld
    \    FUN get version fsbl
#   \    FUN get version dpdk
#   \    FUN get version hardware
    \    FUN get version si
#   \    FUN get board type
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
    \    FUN get version core
    \    FUN get version boot
#   \    FUN get version epld
    \    FUN get version fsbl
#   \    FUN get version dpdk
#   \    FUN get version hardware
    \    FUN get version si
#   \    FUN get board type
    \    disconnect by pid
