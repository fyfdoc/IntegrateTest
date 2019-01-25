 # encoding utf-8
'''
*************************************************************
*** COPYRIGHT DaTang Mobile Communications Equipment CO.,LTD
*************************************************************
*文件名称：SYSIICResource.robot
*功能描述：SYSIIC准出相关资源文件：准出涉及关键字列表
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
*## SYSIIC相关 ##                                                                    |
*A1.获取指定板卡的硬件在位状态     ->      get board hardware status                 |
*A2.获取指定板卡的软件在位状态     ->      get board software status                 |
*A3.获取主控板的温度               ->      get hsctd temp                            |
*A4.获取主控板12v输入电压          ->      get hsctd 12v input                       |
*A5.获取主控板输入功率             ->      get hsctd power input                     |
*A6.获取基带板温度                 ->      get hbpod temp                            |
*A7.获取基带板12v输入电压          ->      get hbpod 12v input                       |
*A8.获取基带板VU9P输入电压         ->      get hbpod vu9p volt                       |
*A9.获取基带板ZU21DR输入电压       ->      get hbpod zu21dr volt                     |
*A10.获取风扇温度                  ->      get fan temp                              |
*A11.获取风扇转速                  ->      get fan speed                             |
*A12.获取电源板厂家类型            ->      get psu vend type                         |
*A13.获取电源板pid标识             ->      get psu pid identify                      |
*A14.获取电源板温度                ->      get pus temp                              |
*A15.获取电源板输入电压            ->      get psu volt input                        |
*A16.获取电源板输入功率            ->      get psu power input                       |
*A17.获取电源板输入电流            ->      get psu electricflow input                |
*A18.获取电源板12v输出电压         ->      get psu 12v output                        |
*A19.获取电源板告警                ->      get psu alarm                             |
 ____________________________________________________________________________________|

************************************************资源文件头结束**************************************************
'''
from pysnmp.smi.rfc1902 import ObjectIdentity

*** Settings ***
Library    SnmpLibrary

*** Variables ***
${hsctd_addr_base}    172.27.245
${hbpod_addr_base}    172.27.246
${som}    som
${aom}    aom
${Mib}    DTM-TD-LTE-ENODEB-ENBMIB

*** Keywords ***
#***********************************************************************************
#功能     ：A1.获取指定板卡的硬件在位状态                                          *
#标签     ：mandatory                                                              *
#索引     ：                                                                       *
#入参     ：机框号（0）、槽位号                                                    *
#返回值   ：板卡状态                                                               *
#后处理   ：打印Log                                                                *
#超时     ：2S                                                                     *
#所属模块 ：SYSIIC                                                                 *
#适用用例 ：                                                                       *
#负责人   ：                                                                       *
#调用方法 ：调用关键字，输入槽位号                                                 *
#备注     ：                                                                       *
#***********************************************************************************
get board hardware status
    [Documentation]    获取指定板卡的硬件在位状态
    [Tags]    mandatory
    [Arguments]    ${parameters}
    [Teardown]    Log    board hardware status
    [Timeout]    2S
    ${execute_result}=    Execute Command by UAgent    board_hardware_test    ${0}    ${parameters}
    Should be equal    ${execute_result}    ${0}
    Log    ${parameters} slot hardware ok

#***********************************************************************************
#功能     ：A2.获取指定板卡的软件在位状态                                          *
#标签     ：mandatory                                                              *
#索引     ：                                                                       *
#入参     ：机框号（0）、槽位号                                                    *
#返回值   ：板卡状态                                                               *
#后处理   ：打印Log                                                                *
#超时     ：2S                                                                     *
#所属模块 ：SYSIIC                                                                 *
#适用用例 ：                                                                       *
#负责人   ：                                                                       *
#调用方法 ：调用关键字，输入槽位号                                                 *
#备注     ：                                                                       *
#***********************************************************************************
get board software status
    [Documentation]     获取指定板卡的软件在位状态
    [Tags]    mandatory
    [Arguments]    ${parameters}
    [Teardown]    Log    board software status
    [Timeout]    2S
    ${execute_result}=    Execute Command by UAgent    board_software_test    ${0}    ${parameters}
    Should be equal    ${execute_result}    ${0}
    Log    ${parameters} slot software ok

#***********************************************************************************
#功能     ：A3.获取主控板温度                                                      *
#标签     ：mandatory                                                              *
#索引     ：                                                                       *
#入参     ：结构体（自定义参数）                                                   *
#返回值   ：函数调用结果                                                           *
#后处理   ：                                                                       *
#超时     ：2S                                                                     *
#所属模块 ：SYSIIC                                                                 *
#适用用例 ：                                                                       *
#负责人   ：                                                                       *
#调用方法 ：调用关键字，输入板卡状态信息结构（自定义参数）                         *
#备注     ：                                                                       *
#***********************************************************************************
get hsctd temp
    [Documentation]     获取主控板温度
    [Tags]    mandatory
    [Arguments]    @{parameters}
    [Teardown]    Log   get hsctd temp
    [Timeout]    2S
    ${execute_result}    ${result_list}=    Execute Command With Out Datas by UAgent    get_board_and_env_param    @{parameters}
    ${intval}    member_decode_str_to_list    ${result_list}
#   log to console    ${result_list}
#   log to console    ${intval}
    Run Keyword If    ${intval[4]} < 70        Log    hsctd temp:${intval[4]}
    ...    ELSE    Should be equal    ${1}    ${0}
    Should be equal    ${execute_result}    ${0}

#***********************************************************************************
#功能     ：A4.获取主控板12v输入电压                                               *
#标签     ：mandatory                                                              *
#索引     ：                                                                       *
#入参     ：结构体（自定义参数）                                                   *
#返回值   ：函数调用结果                                                           *
#后处理   ：                                                                       *
#超时     ：2S                                                                     *
#所属模块 ：SYSIIC                                                                 *
#适用用例 ：                                                                       *
#负责人   ：                                                                       *
#调用方法 ：调用关键字，输入板卡状态信息结构（自定义参数）                         *
#备注     ：                                                                       *
#***********************************************************************************
get hsctd 12v input
    [Documentation]     获取主控板12v输入电压
    [Tags]    mandatory
    [Arguments]    @{parameters}
    [Teardown]    Log   get hsctd 12v input
    [Timeout]    2S
    ${execute_result}    ${result_list}=    Execute Command With Out Datas by UAgent    get_board_and_env_param     @{parameters}
    ${intval}    member_decode_str_to_list    ${result_list}
#    log to console    ${result_list}
#    log to console    ${intval}
    Run Keyword If    (1080 < ${intval[4]} and ${intval[4]} < 1320)    Log    hsctd 12v input:${intval[4]}
    ...    ELSE    SHould be equal   ${1}    ${0}
    Should be equal    ${execute_result}    ${0}

#***********************************************************************************
#功能     ：A5.获取主控板输入功率                                                  *
#标签     ：mandatory                                                              *
#索引     ：                                                                       *
#入参     ：结构体（自定义参数）                                                   *
#返回值   ：函数调用结果                                                           *
#后处理   ：                                                                       *
#超时     ：2S                                                                     *
#所属模块 ：SYSIIC                                                                 *
#适用用例 ：                                                                       *
#负责人   ：                                                                       *
#调用方法 ：调用关键字，输入板卡状态信息结构（自定义参数）                         *
#备注     ：                                                                       *
#***********************************************************************************
get hsctd power input
    [Documentation]     获取主控板输入功率
    [Tags]    mandatory
    [Arguments]    @{parameters}
    [Teardown]    Log   get hsctd power input
    [Timeout]    2S
    ${execute_result}    ${result_list}=    Execute Command With Out Datas by UAgent    get_board_and_env_param    @{parameters}
    ${intval}    member_decode_str_to_list    ${result_list}
#    log to console    ${result_list}
#    log to console    ${intval}
    Log    hsctd power input:${intval[4]}
    Should be equal    ${execute_result}    ${0}

#***********************************************************************************
#功能     ：A6.获取基带板温度                                                      *
#标签     ：mandatory                                                              *
#索引     ：                                                                       *
#入参     ：结构体（自定义参数）                                                   *
#返回值   ：函数调用结果                                                           *
#后处理   ：                                                                       *
#超时     ：2S                                                                     *
#所属模块 ：SYSIIC                                                                 *
#适用用例 ：                                                                       *
#负责人   ：                                                                       *
#调用方法 ：调用关键字，输入板卡状态信息结构（自定义参数）                         *
#备注     ：                                                                       *
#***********************************************************************************
get hbpod temp
    [Documentation]     获取基带板温度
    [Tags]    mandatory
    [Arguments]
    [Teardown]    Log   get hbpod temp
    [Timeout]    2S
    ${boardEntry}    Get Oid By Name    ${Mib}    boardRowStatus
    Log    ${boardEntry}
    @{som_slotNo_list}    Get board of aom or som    som    ${boardEntry}    ${16}
    :FOR    ${loop_slotNo}    in    @{som_slotNo_list}
    \    ${hbpod_slot}    Evaluate    int(${loop_slotNo})
    \    ${execute_result}    ${result_list}=    Execute Command With Out Datas by UAgent    get_board_and_env_param    <8,[N;1;0;0],[N;1;1;${hbpod_slot}],[N;1;2;2],[N;1;3;0],[N;4;4;0]>
    \    ${intval}    member_decode_str_to_list    ${result_list}
#   \    log to console    ${result_list}
#   \    log to console    ${intval}
#   \    log to console    hbpod temp:${intval[4]}
    \    Run Keyword If    (25 < ${intval[4]} and ${intval[4]} < 80)    Log    hbpod temp:${intval[4]}
    \    ...    ELSE    SHould be equal   ${1}    ${0}
    \    Should be equal    ${execute_result}    ${0}

#***********************************************************************************
#功能     ：A7.获取基带板12v输入电压                                               *
#标签     ：mandatory                                                              *
#索引     ：                                                                       *
#入参     ：                                                                       *
#返回值   ：函数调用结果                                                           *
#后处理   ：                                                                       *
#超时     ：2S                                                                     *
#所属模块 ：SYSIIC                                                                 *
#适用用例 ：                                                                       *
#负责人   ：                                                                       *
#调用方法 ：                                                                       *
#备注     ：                                                                       *
#***********************************************************************************
get hbpod 12v input   #基带volt=(((value&0x3FF)*31.25)/10.0)
    [Documentation]     获取基带板12v输入电压
    [Tags]    mandatory
    [Arguments]    ${parameters1}    ${parameters2}
    [Teardown]    Log   get hbpod 12v input
    [Timeout]    2S
    ${execute_result}    ${result_list}=    Execute Command With Out Datas by UAgent   fdd_hal_iic_read    ${0}    ${parameters1}    ${0x40}    ${0x8b}   ${parameters2}     ${2}
#    log to console    ${result_list}
    ${intval}    Evaluate    int.from_bytes(${result_list}[0],byteorder="little")
#    log to console    hbpod 12v input:${intval}
    Run Keyword If    (345 < ${intval} and ${intval} < 422)    Log    hbpod 12v input:${intval}
    ...    ELSE    Should be equal   ${1}    ${0}
    Should be equal    ${execute_result}    ${0}

#***********************************************************************************
#功能     ：A8.获取VU9P输入电压                                                    *
#标签     ：mandatory                                                              *
#索引     ：                                                                       *
#入参     ：                                                                       *
#返回值   ：函数调用结果                                                           *
#后处理   ：                                                                       *
#超时     ：2S                                                                     *
#所属模块 ：SYSIIC                                                                 *
#适用用例 ：                                                                       *
#负责人   ：                                                                       *
#调用方法 ：调用关键字，输入板卡状态信息结构（自定义参数）                         *
#备注     ：                                                                       *
#***********************************************************************************
get hbpod vu9p volt    #基带volt= ((0.85+(value-0x24)*0.01)*100
    [Documentation]     获取VU9P输入电压
    [Tags]    mandatory
    [Arguments]    ${parameters1}    ${parameters2}
    [Teardown]    Log   get hbpod vu9p volt
    [Timeout]    2S
    ${execute_result}    ${result_list}=    Execute Command With Out Datas by UAgent   fdd_hal_iic_read    ${0}    ${parameters1}    ${0x21}    ${0x8b}    ${parameters2}    ${1}
#    log to console    ${result_list}
    ${intval}    Evaluate    int.from_bytes(${result_list}[0],byteorder="little")
#    log to console    hbpod vu9p volt:${intval}
    Run Keyword If    (27 < ${intval} and ${intval} < 44)    Log    hbpod vu9p volt:${intval}
    ...    ELSE    Should be equal   ${1}    ${0}
    Should be equal    ${execute_result}    ${0}

#***********************************************************************************
#功能     ：A9.获取zu21dr输入电压                                                  *
#标签     ：mandatory                                                              *
#索引     ：                                                                       *
#入参     ：                                                                       *
#返回值   ：函数调用结果                                                           *
#后处理   ：                                                                       *
#超时     ：2S                                                                     *
#所属模块 ：SYSIIC                                                                 *
#适用用例 ：                                                                       *
#负责人   ：                                                                       *
#调用方法 ：调用关键字，输入板卡状态信息结构（自定义参数）                         *
#备注     ：                                                                       *
#***********************************************************************************
get hbpod zu21dr volt    #基带volt= ((0.85+(value-0x24)*0.01)*100
    [Documentation]     获取zu21dr输入电压
    [Tags]    mandatory
    [Arguments]    ${parameters1}    ${parameters2}
    [Teardown]    Log   get zu21dr volt
    [Timeout]    2S
    ${execute_result}    ${result_list}=    Execute Command With Out Datas by UAgent   fdd_hal_iic_read    ${0}    ${parameters1}    ${0x22}    ${0x8b}    ${parameters2}    ${1}
#    log to console    ${result_list}
    ${intval}    Evaluate    int.from_bytes(${result_list}[0],byteorder="little")
#    log to console    hbpod zu21dr volt:${intval}
    Run Keyword If    (27 < ${intval} and ${intval} < 44)    Log    hbpod zu21dr volt:${intval}
    ...    ELSE    Should be equal   ${1}    ${0}
    Should be equal    ${execute_result}    ${0}
    disconnect by pid

#***********************************************************************************
#功能     ：A10.获取风扇板温度                                                     *
#标签     ：mandatory                                                              *
#索引     ：                                                                       *
#入参     ：结构体（自定义参数）                                                   *
#返回值   ：函数调用结果                                                           *
#后处理   ：                                                                       *
#超时     ：2S                                                                     *
#所属模块 ：SYSIIC                                                                 *
#适用用例 ：                                                                       *
#负责人   ：                                                                       *
#调用方法 ：调用关键字，输入板卡状态信息结构（自定义参数）                         *
#备注     ：                                                                       *
#***********************************************************************************
get fan temp    #获取风扇板温度
    [Documentation]     获取风扇板温度
    [Tags]    mandatory
    [Arguments]    @{parameters}
    [Teardown]    Log   get fan temp
    [Timeout]    2S
    ${execute_result}    ${result_list}=    Execute Command With Out Datas by UAgent    get_board_and_env_param    @{parameters}
    ${intval}    member_decode_str_to_list    ${result_list}
#    log to console    ${result_list}
#    log to console    ${intval}
#    log to console    fan temp:${intval[4]}
    Run Keyword If    ${intval[4]} < 70    Log    fan temp:${intval[4]}
    ...    ELSE    SHould be equal   ${1}    ${0}
    Should be equal    ${execute_result}    ${0}

#***********************************************************************************
#功能     ：A11.获取风扇转速                                                       *
#标签     ：mandatory                                                              *
#索引     ：                                                                       *
#入参     ：结构体（自定义参数）                                                   *
#返回值   ：函数调用结果                                                           *
#后处理   ：                                                                       *
#超时     ：2S                                                                     *
#所属模块 ：SYSIIC                                                                 *
#适用用例 ：                                                                       *
#负责人   ：                                                                       *
#调用方法 ：调用关键字，输入板卡状态信息结构（自定义参数）                         *
#备注     ：                                                                       *
#***********************************************************************************
get fan speed    #获取风扇转速
    [Documentation]     获取风扇转速
    [Tags]    mandatory
    [Arguments]    @{parameters}
    [Teardown]    Log   get fan speed
    [Timeout]    2S
    :FOR    ${num}    IN RANGE    4
    \    ${execute_result}    ${result_list}=    Execute Command With Out Datas by UAgent    get_fan_speed   @{parameters}
    \    Should be equal    ${execute_result}    ${0}
    \    ${intval}    member_decode_str_to_list    ${result_list}
#    \    log to console    ${result_list}
#    \    log to console    ${intval}
#    \    log to console    the first group-fan ${num} speed:${intval[4]}
    \    Run Keyword If    ${intval[4]} < 11500    Log    the first group-fan ${num} speed:${intval[4]}
    \    ...    ELSE    SHould be equal   ${1}    ${0}
    \    ${execute_result}    ${result_list}=    Execute Command With Out Datas by UAgent    get_fan_speed   @{parameters}
    \    Should be equal    ${execute_result}    ${0}
    \    ${intval}    member_decode_str_to_list    ${result_list}
#    \    log to console    ${result_list}
#    \    log to console    ${intval}
#    \    log to console    the second group-fan ${num} speed:${intval[4]}
    \    Run Keyword If    ${intval[4]} < 11500    Log    the second group-fan ${num} speed:${intval[4]}
    \    ...    ELSE    SHould be equal   ${1}    ${0}
    :FOR    ${num}    IN RANGE    2
    \    ${execute_result}    ${result_list}=    Execute Command With Out Datas by UAgent    get_fan_speed     @{parameters}
    \    Should be equal    ${execute_result}    ${0}
    \    ${intval}    member_decode_str_to_list    ${result_list}
#    \    log to console    ${result_list}
#    \    log to console    ${intval}
#    \    log to console    the third group-fan ${num} speed:${intval[4]}
    \    Run Keyword If    ${intval[4]} < 11500    Log    the third group-fan ${num} speed:${intval[4]}
    \    ...    ELSE    SHould be equal   ${1}    ${0}

#***********************************************************************************
#功能     ：A12.获取电源板厂家类型                                                 *
#标签     ：mandatory                                                              *
#索引     ：                                                                       *
#入参     ：结构体（自定义参数）                                                   *
#返回值   ：函数调用结果                                                           *
#后处理   ：                                                                       *
#超时     ：2S                                                                     *
#所属模块 ：SYSIIC                                                                 *
#适用用例 ：                                                                       *
#负责人   ：                                                                       *
#调用方法 ：调用关键字，输入板卡状态信息结构（自定义参数）                         *
#备注     ：                                                                       *
#***********************************************************************************
get psu vend type
    [Documentation]     获取电源板厂家类型
    [Tags]    mandatory
    [Arguments]    @{parameters}
    [Teardown]    Log   get vend type
    [Timeout]    2S
    ${execute_result}    ${result_list}=    Execute Command With Out Datas by UAgent    get_board_and_env_param    @{parameters}
    ${intval}    member_decode_str_to_list    ${result_list}
#    log to console    ${result_list}
#    log to console    ${intval}
    Log    psu vend type:${intval[4]}
    Should be equal    ${execute_result}    ${0}

#***********************************************************************************
#功能     ：A13.获取电源板pid标识                                                  *
#标签     ：mandatory                                                              *
#索引     ：                                                                       *
#入参     ：结构体（自定义参数）                                                   *
#返回值   ：函数调用结果                                                           *
#后处理   ：                                                                       *
#超时     ：2S                                                                     *
#所属模块 ：SYSIIC                                                                 *
#适用用例 ：                                                                       *
#负责人   ：                                                                       *
#调用方法 ：调用关键字，输入板卡状态信息结构（自定义参数）                         *
#备注     ：                                                                       *
#***********************************************************************************
get psu pid identify
    [Documentation]     获取电源板pid标识
    [Tags]    mandatory
    [Arguments]    @{parameters}
    [Teardown]    Log   get pid identify
    [Timeout]    2S
    ${execute_result}    ${result_list}=    Execute Command With Out Datas by UAgent    get_board_and_env_param    @{parameters}
    ${intval}    member_decode_str_to_list    ${result_list}
#    log to console    ${result_list}
#    log to console    ${intval}
    Log    psu pid identify:${intval[4]}
    Should be equal    ${execute_result}    ${0}

#***********************************************************************************
#功能     ：A14.获取电源板温度                                                     *
#标签     ：mandatory                                                              *
#索引     ：                                                                       *
#入参     ：结构体（自定义参数）                                                   *
#返回值   ：函数调用结果                                                           *
#后处理   ：                                                                       *
#超时     ：2S                                                                     *
#所属模块 ：SYSIIC                                                                 *
#适用用例 ：                                                                       *
#负责人   ：                                                                       *
#调用方法 ：调用关键字，输入板卡状态信息结构（自定义参数）                         *
#备注     ：                                                                       *
#***********************************************************************************
get psu temp
    [Documentation]     获取电源板温度
    [Tags]    mandatory
    [Arguments]    @{parameters}
    [Teardown]    Log   get psu temp
    [Timeout]    2S
    ${execute_result}    ${result_list}=    Execute Command With Out Datas by UAgent    get_board_and_env_param    @{parameters}
    ${intval}    member_decode_str_to_list    ${result_list}
#    log to console    ${result_list}
#    log to console    ${intval}
#    log to console    psu temp:${intval[4]}
    Run Keyword If    ${intval[4]} < 70    Log    psu temp:${intval[4]}
    ...    ELSE    SHould be equal   ${1}    ${0}
    Should be equal    ${execute_result}    ${0}

#***********************************************************************************
#功能     ：A15.获取电源板输入电压                                                 *
#标签     ：mandatory                                                              *
#索引     ：                                                                       *
#入参     ：结构体（自定义参数）                                                   *
#返回值   ：函数调用结果                                                           *
#后处理   ：                                                                       *
#超时     ：2S                                                                     *
#所属模块 ：SYSIIC                                                                 *
#适用用例 ：                                                                       *
#负责人   ：                                                                       *
#调用方法 ：调用关键字，输入板卡状态信息结构（自定义参数）                         *
#备注     ：                                                                       *
#***********************************************************************************
get psu volt input
    [Documentation]     获取电源板输入电压
    [Tags]    mandatory
    [Arguments]    @{parameters}
    [Teardown]    Log   get psu volt input
    [Timeout]    2S
    ${execute_result}    ${result_list}=    Execute Command With Out Datas by UAgent    get_board_and_env_param    @{parameters}
    ${intval}    member_decode_str_to_list    ${result_list}
#    log to console    ${result_list}
#    log to console    ${intval}
#    log to console    psu volt input:${intval[4]}
    Run Keyword If    (4000 < ${intval[4]} and ${intval[4]} < 6000)    Log    psu volt input:${intval[4]}
    ...    ELSE    Should be equal   ${1}    ${0}
    Should be equal    ${execute_result}    ${0}

#***********************************************************************************
#功能     ：A16.获取电源板输入功率                                                 *
#标签     ：mandatory                                                              *
#索引     ：                                                                       *
#入参     ：结构体（自定义参数）                                                   *
#返回值   ：函数调用结果                                                           *
#后处理   ：                                                                       *
#超时     ：2S                                                                     *
#所属模块 ：SYSIIC                                                                 *
#适用用例 ：                                                                       *
#负责人   ：                                                                       *
#调用方法 ：调用关键字，输入板卡状态信息结构（自定义参数）                         *
#备注     ：                                                                       *
#***********************************************************************************
get psu power input
    [Documentation]     获取电源板输入功率
    [Tags]    mandatory
    [Arguments]    @{parameters}
    [Teardown]    Log   get psu power input
    [Timeout]    2S
    ${execute_result}    ${result_list}=    Execute Command With Out Datas by UAgent    get_board_and_env_param    @{parameters}
    ${intval}    member_decode_str_to_list    ${result_list}
#    log to console    ${result_list}
#    log to console    ${intval}
    Log    psu power input:${intval[4]}
    Should be equal    ${execute_result}    ${0}

 #***********************************************************************************
#功能     ：A17.获取电源板输入电流                                                 *
#标签     ：mandatory                                                              *
#索引     ：                                                                       *
#入参     ：结构体（自定义参数）                                                   *
#返回值   ：函数调用结果                                                           *
#后处理   ：                                                                       *
#超时     ：2S                                                                     *
#所属模块 ：SYSIIC                                                                 *
#适用用例 ：                                                                       *
#负责人   ：                                                                       *
#调用方法 ：调用关键字，输入板卡状态信息结构（自定义参数）                         *
#备注     ：                                                                       *
#***********************************************************************************
get psu electricflow input
    [Documentation]     获取电源板输入电流
    [Tags]    mandatory
    [Arguments]    @{parameters}
    [Teardown]    Log   get psu electricflow input
    [Timeout]    2S
    ${execute_result}    ${result_list}=    Execute Command With Out Datas by UAgent    get_board_and_env_param    @{parameters}
    ${intval}    member_decode_str_to_list    ${result_list}
#    log to console    ${result_list}
#    log to console    ${intval}
#    log to console    psu electricflow input:${intval[4]}
    Run Keyword If    (0 < ${intval[4]} and ${intval[4]} < 70)    Log    psu electricflow input:${intval[4]}
    ...    ELSE    Should be equal   ${1}    ${0}
    Should be equal    ${execute_result}    ${0}

 #***********************************************************************************
#功能     ：A18.获取电源板12v输出电压                                              *
#标签     ：mandatory                                                              *
#索引     ：                                                                       *
#入参     ：结构体（自定义参数）                                                   *
#返回值   ：函数调用结果                                                           *
#后处理   ：                                                                       *
#超时     ：2S                                                                     *
#所属模块 ：SYSIIC                                                                 *
#适用用例 ：                                                                       *
#负责人   ：                                                                       *
#调用方法 ：调用关键字，输入板卡状态信息结构（自定义参数）                         *
#备注     ：                                                                       *
#***********************************************************************************
get psu 12v output
    [Documentation]     获取电源板12v输出电压
    [Tags]    mandatory
    [Arguments]    @{parameters}
    [Teardown]    Log   get psu 12v output
    [Timeout]    2S
    ${execute_result}    ${result_list}=    Execute Command With Out Datas by UAgent    get_board_and_env_param    @{parameters}
    ${intval}    member_decode_str_to_list    ${result_list}
#    log to console    ${result_list}
#    log to console    ${intval}
#    log to console    psu 12v output:${intval[4]}
    Run Keyword If    (1164 < ${intval[4]} and ${intval[4]} < 1236)    Log    psu 12v output:${intval[4]}
    ...    ELSE    Should be equal   ${1}    ${0}
    Should be equal    ${execute_result}    ${0}

  #*********************************************************************************
#功能     ：A19.获取电源板告警                                                     *
#标签     ：mandatory                                                              *
#索引     ：                                                                       *
#入参     ：结构体（自定义参数）                                                   *
#返回值   ：函数调用结果                                                           *
#后处理   ：                                                                       *
#超时     ：2S                                                                     *
#所属模块 ：SYSIIC                                                                 *
#适用用例 ：                                                                       *
#负责人   ：                                                                       *
#调用方法 ：调用关键字，输入板卡状态信息结构（自定义参数）                         *
#备注     ：                                                                       *
#***********************************************************************************
get psu alarm
    [Documentation]     获取电源板告警
    [Tags]    mandatory
    [Arguments]    @{parameters}
    [Teardown]    Log   get psu alarm
    [Timeout]    2S
    ${execute_result}    ${result_list}=    Execute Command With Out Datas by UAgent    get_board_and_env_param    @{parameters}
    ${intval}    member_decode_str_to_list    ${result_list}
#    log to console    ${result_list}
#    log to console    ${intval}
    Log    psu alarm:${intval[4]}
    Should be equal    ${execute_result}    ${0}