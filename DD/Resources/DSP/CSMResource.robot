# encoding utf-8
'''
*************************************************************
*** COPYRIGHT DaTang Mobile Communications Equipment CO.,LTD
*************************************************************
*文件名称：CSMResource.robot
*功能描述：CSM准出相关资源文件：准出涉及关键字列表
*使用方法：

-----------------------------------------------------------------------------------
*修改记录：                                                                       |
*##修改日期    |    修改人    |    修改描述    |                                  |
*2018-11-1        wangxiaohe       创建文件                                       |
----------------------------------------------------------------------------------|
*************************************************************
______________________________________________________________________________________
*关键字目录：                                                                        |
-------------------------------------------------------------------------            |
*## CSM相关 ##                                                                       |
*A1.获取时隙号                     ->      Test function get the slotnum             |
*A2.获取时隙偏移                   ->      Test function get the slot->usoffset      |
*A3.获取半帧号                     ->      Test function get the halfsfn             |
*A4.获取半帧偏移                   ->      Test functino get the halfsfn->usoffset   |
*A5.获取帧号                       ->      Test function get the sfn                 |
*A6.获取 125us 计数                ->      Test function get the 125uscnt            |
*A7.获取cycle偏移                  ->      Test function get the cycleoffset         |
 ____________________________________________________________________________________|

************************************************资源文件头结束**************************************************
'''
from pysnmp.smi.rfc1902 import ObjectIdentity

*** Settings ***
Library    SnmpLibrary

*** Variables ***
${hbpod_x86}    'HBPOD'
${hbpod_plp1}    'PLP1'
${hbpod_plp2}    'PLP2'
${hbpod_addr_base}    172.27.246
${som}    som
${aom}    aom
${Mib}    DTM-TD-LTE-ENODEB-ENBMIB

*** Keywords ***
#***********************************************************************************
#功能     ：A1.获取时隙号                                                          *
#标签     ：mandatory                                                              *
#索引     ：                                                                       *
#入参     ：地址指针                                                               *
#返回值   ：函数调用结果                                                           *
#后处理   ：无                                                                     *
#超时     ：2S                                                                     *
#所属模块 ：CSM                                                                    *
#适用用例 ：                                                                       *
#负责人   ：                                                                       *
#调用方法 ：调用关键字，输入地址指针                                               *
#备注     ：                                                                       *
#***********************************************************************************
Test function get the slotnum
    [Documentation]    获取时隙号
    [Tags]    mandatory
    [Arguments]    @{parameters}
    [Teardown]    Log    get the slotnum
    [Timeout]    2S
    ${execute_result}   ${result_list}=   Execute Command With Out Datas by UAgent    dd_csm_tslot_get    @{parameters}
    ${slotnum}    Evaluate    int.from_bytes(${result_list}[0],byteorder="little")
    Run Keyword If    ${slotnum} > 19    Should be Equal ${1}   ${0}  ...    ElSE    Log    get  slotnum true
    Log    ${slotnum}
    Should Be Equal    ${execute_result}    ${0}

#***********************************************************************************
#功能     ：A2.获取时隙偏移                                                        *
#标签     ：mandatory                                                              *
#索引     ：                                                                       *
#入参     ：地址指针                                                               *
#返回值   ：函数调用结果                                                           *
#后处理   ：无                                                                     *
#超时     ：2S                                                                     *
#所属模块 ：CSM                                                                    *
#适用用例 ：                                                                       *
#负责人   ：                                                                       *
#调用方法 ：调用关键字，输入地址指针                                               *
#备注     ：                                                                       *
#***********************************************************************************
Test function get the slot->usoffset
    [Documentation]    获取时隙偏移
    [Tags]    mandatory
    [Arguments]   @{parameters}
    [Teardown]    Log    get the slot->usoffset
    [Timeout]    2S
    ${execute_result}  ${result_list}=  Execute Command With Out Datas by UAgent  dd_csm_slot_us_offset_get  @{parameters}
    ${slotusoffset}    Evaluate    int.from_bytes(${result_list}[0],byteorder="little")
    Log    ${slotusoffset}
    Run Keyword If   ${slotusoffset} > 500   Should be Equal   ${1}   ${0}   ...    ElSE    Log    get  slot-usoffset true
    Should Be Equal    ${execute_result}    ${0}

#***********************************************************************************
#功能     ：A3.获取半帧号                                                          *
#标签     ：mandatory                                                              *
#索引     ：                                                                       *
#入参     ：地址指针                                                               *
#返回值   ：函数调用结果                                                           *
#后处理   ：无                                                                     *
#超时     ：2S                                                                     *
#所属模块 ：CSM                                                                    *
#适用用例 ：                                                                       *
#负责人   ：                                                                       *
#调用方法 ：调用关键字，输入地址指针                                               *
#备注     ：                                                                       *
#***********************************************************************************
Test function get the halfsfn
    [Documentation]    获取半帧号
    [Tags]    mandatory
    [Arguments]   @{parameters}
    [Teardown]    Log    get the halfsfn
    [Timeout]    2S
    ${execute_result}   ${result_list}=   Execute Command With Out Datas by UAgent  dd_csm_halfsfn_get  @{parameters}
    ${halfsfn}   Evaluate    int.from_bytes(${result_list}[0],byteorder="little")
    Log    ${halfsfn}
    Run Keyword If    ${halfsfn} > 2047    Should be equal   ${1}   ${0}   ...   ElSE    Log   get  halfsfn true
    Should be equal    ${execute_result}    ${0}

#***********************************************************************************
#功能     ：A4.获取半帧偏移                                                        *
#标签     ：mandatory                                                              *
#索引     ：                                                                       *
#入参     ：地址指针                                                               *
#返回值   ：函数调用结果                                                           *
#后处理   ：无                                                                     *
#超时     ：2S                                                                     *
#所属模块 ：CSM                                                                    *
#适用用例 ：                                                                       *
#负责人   ：                                                                       *
#调用方法 ：调用关键字，输入地址指针                                               *
#备注     ：                                                                       *
#***********************************************************************************
Test functino get the halfsfn->usoffset
    [Documentation]    获取半帧偏移
    [Tags]    mandatory
    [Arguments]   @{parameters}
    [Teardown]    Log    get the halfsfn->usoffset
    [Timeout]    2S
    ${execute_result}    ${result_list}=   Execute Command With Out Datas by UAgent   dd_csm_halfframe_us_offset_get    @{parameters}
    ${halfsfnusoffset}    Evaluate    int.from_bytes(${result_list}[0],byteorder="little")
    Log    ${halfsfnusoffset}
    Run Keyword If    ${halfsfnusoffset} > 5000   Should be equal   ${1}   ${0}   ...    ElSE    Log    get halfsfn-usoffset true
    Should Be Equal    ${execute_result}    ${0}

#***********************************************************************************
#功能     ：A5.获取帧号                                                            *
#标签     ：mandatory                                                              *
#索引     ：                                                                       *
#入参     ：地址指针                                                               *
#返回值   ：函数调用结果                                                           *
#后处理   ：无                                                                     *
#超时     ：2S                                                                     *
#所属模块 ：CSM                                                                    *
#适用用例 ：                                                                       *
#负责人   ：                                                                       *
#调用方法 ：调用关键字，输入地址指针                                               *
#备注     ：                                                                       *
#***********************************************************************************
Test function get the sfn
    [Documentation]    获取帧号
    [Tags]    mandatory
    [Arguments]   @{parameters}
    [Teardown]    Log    get the sfn
    [Timeout]    2S
    ${execute_result}    ${result_list}=    Execute Command With Out Datas by UAgent    dd_csm_sfn_get    @{parameters}
    ${sfnnum}   Evaluate   int.from_bytes(${result_list}[0],byteorder="little")
    Log    ${sfnnum}
    Run Keyword If    ${sfnnum} > 1023    Should be equal   ${1}   ${0}   ...  ElSE   Log   get  sfnnum true
    Should be equal    ${execute_result}    ${0}

#***********************************************************************************
#功能     ：A6.获取 125us 计数                                                     *
#标签     ：mandatory                                                              *
#索引     ：                                                                       *
#入参     ：地址指针                                                               *
#返回值   ：函数调用结果                                                           *
#后处理   ：无                                                                     *
#超时     ：2S                                                                     *
#所属模块 ：CSM                                                                    *
#适用用例 ：                                                                       *
#负责人   ：                                                                       *
#调用方法 ：调用关键字，输入地址指针                                               *
#备注     ：                                                                       *
#***********************************************************************************
Test function get the 125us_cnt
    [Documentation]    获取 125us 计数
    [Tags]    mandatory
    [Arguments]   @{parameters}
    [Teardown]    Log    get the 125us_cnt
    [Timeout]    2S
    ${execute_result}   ${result_list}=   Execute Command With Out Datas by UAgent  dd_csm_125us_cnt_get   @{parameters}
    ${125uscnt}    Evaluate    int.from_bytes(${result_list}[0],byteorder="little")
    Log    ${125uscnt}
    Should be equal    ${execute_result}    ${0}

#***********************************************************************************
#功能     ：A7.获取cysle偏移                                                       *
#标签     ：mandatory                                                              *
#索引     ：                                                                       *
#入参     ：地址指针                                                               *
#返回值   ：函数调用结果                                                           *
#后处理   ：无                                                                     *
#超时     ：2S                                                                     *
#所属模块 ：CSM                                                                    *
#适用用例 ：                                                                       *
#负责人   ：                                                                       *
#调用方法 ：调用关键字，输入地址指针                                               *
#备注     ：                                                                       *
#***********************************************************************************
Test function get the cycleoffset
    [Documentation]    获取cycle偏移
    [Tags]    mandatory
    [Arguments]   @{parameters}
    [Teardown]    Log    get the cycleoffset
    [Timeout]    2S
    ${execute_result}   ${result_list}=   Execute Command With Out Datas by UAgent   dd_csm_slot_cpu_cycle_offset_get   @{parameters}
    ${cycleoffset}   Evaluate   int.from_bytes(${result_list}[0],byteorder="little")
    Log    ${cycleoffset}
    Should be equal    ${execute_result}    ${0}
