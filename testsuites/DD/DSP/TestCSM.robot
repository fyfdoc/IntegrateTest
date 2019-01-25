#    encoding utf-8

'''
CSM测试
'''
from pysnmp.smi.rfc1902 import ObjectIdentity
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
${hbpod_x86}    'HBPOD'
${hbpod_plp1}    'PLP1'
${hbpod_plp2}    'PLP2'
${hbpod_addr_base}    172.27.246
${DeviceIP}    172.27.245.92
${Community}    public
${som}    som
${pId}    ${2}
${pId1}    ${0}
${pId2}    ${0}
${Mib}    DTM-TD-LTE-ENODEB-ENBMIB

*** Keywords ***
Test function get the slotnum
    ${execute_result}    ${result_list}=    Execute Command With Out Datas by UAgent    dd_csm_tslot_get    <4>
    ${slotnum}    Evaluate    int.from_bytes(${result_list}[0],byteorder="little")
    Run Keyword If    ${slotnum} > 19    Log    get  slotnum error  ...    ElSE    Log    get  slotnum true
    Log    ${slotnum}
    Should Be Equal    ${execute_result}    ${0}
Test functino get the halfsfn->usoffset
    ${execute_result}   ${result_list}=   Execute Command With Out Datas by UAgent  dd_csm_halfframe_us_offset_get    <4>
    ${halfsfnusoffset}    Evaluate    int.from_bytes(${result_list}[0],byteorder="little")
    Log    ${halfsfnusoffset}
    Run Keyword If    ${halfsfnusoffset} > 5000   Log   get  halfsfn-usoffset error   ...    ElSE    Log    get halfsfn-usoffset true
    Should Be Equal    ${execute_result}    ${0}
Test function get the slot->usoffset
    ${execute_result}  ${result_list}=  Execute Command With Out Datas by UAgent  dd_csm_slot_us_offset_get  <4>
    ${slotusoffset}    Evaluate    int.from_bytes(${result_list}[0],byteorder="little")
    Log    ${slotusoffset}
    Run Keyword If   ${slotusoffset} > 500   Log   get  slot-usoffset error   ...    ElSE    Log    get  slot-usoffset true
    Should Be Equal    ${execute_result}    ${0}
Test function get the 125uscnt
    ${execute_result}   ${result_list}=   Execute Command With Out Datas by UAgent  dd_csm_125us_cnt_get   <4>
    ${125uscnt}    Evaluate    int.from_bytes(${result_list}[0],byteorder="little")
    Log    ${125uscnt}
    Should be equal    ${execute_result}    ${0}
Test function get the cycleoffset
    ${execute_result}   ${result_list}=   Execute Command With Out Datas by UAgent   dd_csm_slot_cpu_cycle_offset_get   <4>
    ${cycleoffset}   Evaluate   int.from_bytes(${result_list}[0],byteorder="little")
    Log    ${cycleoffset}
    Should be equal    ${execute_result}    ${0}
Test function get the sfn
    ${execute_result}    ${result_list}=    Execute Command With Out Datas by UAgent    dd_csm_sfn_get    <4>
    ${sfnnum}   Evaluate   int.from_bytes(${result_list}[0],byteorder="little")
    Log    ${sfnnum}
    Run Keyword If    ${sfnnum} > 1023    Log   get  sfnnum error   ...  ElSE   Log   get  sfnnum true
    Should be equal    ${execute_result}    ${0}
Test function get the halfsfn
    ${execute_result}   ${result_list}=   Execute Command With Out Datas by UAgent    dd_csm_halfsfn_get    <4>
    ${halfsfn}   Evaluate    int.from_bytes(${result_list}[0],byteorder="little")
    Log    ${halfsfn}
    Run Keyword If    ${halfsfn} > 2047    Log   get  halfsfn error   ...   ElSE    Log   get  halfsfn true
    Should be equal    ${execute_result}    ${0}

*** Test Cases ***
test_csm_hbpod_x86
    ${boardEntry}    Get Oid By Name    ${Mib}    boardRowStatus
    Log    ${boardEntry}
    @{som_slotNo_list}    Get board of aom or som    som    ${boardEntry}    ${16}
    :FOR    ${loop_slotNo}    in    @{som_slotNo_list}
    \    ${hbpod_slot}    Evaluate    int(${loop_slotNo})
    \    ${ip_addr}    Catenate    SEPARATOR=.    ${hbpod_addr_base}    ${hbpod_slot + 1}
    \    Connect Device By UAgent Use Pid    ${hbpod_x86}    ${ip_addr}    ${pId}
    \    Test function get the slotnum
    \    Test functino get the halfsfn->usoffset
    \    Test function get the slot->usoffset
    \    Test function get the 125uscnt
    \    Test function get the cycleoffset
    \    Test function get the sfn
    \    Test function get the halfsfn
    \    disconnect by pid

test_csm_plp1
    ${boardEntry}    Get Oid By Name    ${Mib}    boardRowStatus
    Log    ${boardEntry}
    @{som_slotNo_list}    Get board of aom or som    som    ${boardEntry}    ${16}
    :FOR    ${loop_slotNo}    in    @{som_slotNo_list}
    \    ${hbpod_slot}    Evaluate    int(${loop_slotNo})
    \    ${ip_addr}    Catenate    SEPARATOR=.    ${hbpod_addr_base}    ${hbpod_slot + 1 + 10}
    \    Connect Device By UAgent Use Pid    ${hbpod_plp1}    ${ip_addr}    ${pId1}
    \    Test function get the slotnum
    \    Test functino get the halfsfn->usoffset
    \    Test function get the slot->usoffset
#   \    Test function get the 125uscnt
#   \    Test function get the cycleoffset
    \    Test function get the sfn
    \    Test function get the halfsfn
    \    disconnect by pid

test_csm_plp2
    ${boardEntry}    Get Oid By Name    ${Mib}    boardRowStatus
    Log    ${boardEntry}
    @{som_slotNo_list}    Get board of aom or som    som    ${boardEntry}    ${16}
    :FOR    ${loop_slotNo}    in    @{som_slotNo_list}
    \    ${hbpod_slot}    Evaluate    int(${loop_slotNo})
    \    ${ip_addr}    Catenate    SEPARATOR=.    ${hbpod_addr_base}    ${hbpod_slot + 1 + 20}
    \   Connect Device By UAgent Use Pid    ${hbpod_plp2}    ${ip_addr}    ${pId2}
    \    Test function get the slotnum
    \    Test functino get the halfsfn->usoffset
    \    Test function get the slot->usoffset
#   \    Test function get the 125uscnt
#   \    Test function get the cycleoffset
    \    Test function get the sfn
    \    Test function get the halfsfn
    \    disconnect by pid
