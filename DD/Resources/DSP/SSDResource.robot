# encoding utf-8
'''
*************************************************************
*** COPYRIGHT DaTang Mobile Communications Equipment CO.,LTD
*************************************************************
*文件名称：SSDResource.robot
*功能描述：SSD准出相关资源文件：准出涉及关键字列表
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
*## SSD相关 ##                                                                       |
*A1.FPGA读、写功能                     ->      FUN FPGA write read                   |
*A2.获取FPGA版本(VU9P,PLP1，PLP2)      ->      FUN get fpga version                  |
*A3.获取core版本                       ->      FUN get core version                  |
*A4.获取boot版本                       ->      FUN get boot version                  |
*A5.获取epld版本                       ->      FUN get epld version                  |
*A6.获取fsbl版本                       ->      FUN get fsbl version                  |
*A7.获取dpdk版本                       ->      FUN get dpdk version                  |
*A8.获取pcb_hardware版本               ->      FUN get hardware version              |
*A9.获取si版本                         ->      FUN get si version                    |
*A10.获取板卡类型                      ->      FUN get board type                    |
_____________________________________________________________________________________|

************************************************资源文件头结束**************************************************
'''
from pysnmp.smi.rfc1902 import ObjectIdentity

*** Settings ***
Library    SnmpLibrary

*** Variables ***
${Mib}    DTM-TD-LTE-ENODEB-ENBMIB
${hsctd_addr_base}    172.27.245
${hbpod_addr_base}    172.27.246
${som}    som
${aom}    aom

*** Keywords ***

#***********************************************************************************
#功能     ：验证FPGA读、写功能                                                     *
#标签     ：mandatory                                                              *
#索引     ：                                                                       *
#入参     ：写入value                                                              *
#返回值   ：函数调用结果                                                           *
#后处理   ：无                                                                     *
#超时     ：2S                                                                     *
#所属模块 ：SSD                                                                    *
#适用用例 ：                                                                       *
#负责人   ：                                                                       *
#调用方法 ：调用关键字，输入值value                                                *
#备注     ：                                                                       *
#***********************************************************************************
FUN FPGA write read      #only hbpod
    [Documentation]    FPGA读、写功能
    [Tags]    mandatory
    [Arguments]   ${parameters}
    [Teardown]    Log    FPGA write,read function
    [Timeout]    2S
    ${execute_result}=    Execute Command by UAgent    ssd_fpga_write_test    ${0x20D}    ${parameters}
    Should be equal    ${execute_result}    ${0}
    ${execute_result}    ${result_list}=    Execute Command With Out Datas by UAgent    fdd_hal_fpga_read    ${0x20D}    <4>
    ${intval}    Evaluate    int.from_bytes(${result_list}[0],byteorder="little")
    Log    ${intval}
    Should be equal    ${intval}    ${parameters}
    Should be equal    ${execute_result}    ${0}

#***********************************************************************************
#功能     ：获取FPGA版本                                                           *
#标签     ：mandatory                                                              *
#索引     ：                                                                       *
#入参     ：FPGA寄存器地址、储存version的地址指针                                  *
#返回值   ：函数调用结果                                                           *
#后处理   ：无                                                                     *
#超时     ：2S                                                                     *
#所属模块 ：SSD                                                                    *
#适用用例 ：                                                                       *
#负责人   ：                                                                       *
#调用方法 ：                                                                       *               
#备注     ：                                                                       *
#***********************************************************************************
FUN get fpga version
    [Documentation]    获取FPGA版本(VU9P,PLP1，PLP2)
    [Tags]    mandatory
    [Arguments]   ${parameters1}    ${parameters2}
    [Teardown]    Log    get FPGA version
    [Timeout]    2S
    ${execute_result}    ${result_list}=    Execute Command With Out Datas by UAgent    fdd_hal_fpga_read    ${parameters1}    ${parameters2}
    ${intval}    Evaluate    int.from_bytes(${result_list}[0],byteorder="little")
    Log    PLP0_${intval}
    Should be equal    ${execute_result}    ${0}

#***********************************************************************************
#功能     ：获取板卡版本                                                           *
#标签     ：mandatory                                                              *
#索引     ：                                                                       *
#入参     ：地址指针                                                               *
#返回值   ：函数调用结果                                                           *
#后处理   ：无                                                                     *
#超时     ：2S                                                                     *
#所属模块 ：SSD                                                                    *
#适用用例 ：                                                                       *
#负责人   ：                                                                       *
#调用方法 ：                                                                       *               
#备注     ：                                                                       *
#***********************************************************************************
FUN get board type
    [Documentation]    获取板卡类型
    [Tags]    mandatory
    [Arguments]   @{parameters}
    [Teardown]    Log    get the slot->usoffset
    [Timeout]    2S
    ${execute_result}    ${result_list}=    Execute Command With Out Datas by UAgent     ssd_ioctl   ${0x14009}    @{parameters}
    Log    ${result_list[0]}
    Should be equal    ${execute_result}    ${0}

#***********************************************************************************
#功能     ：获取...版本                                                            *
#标签     ：mandatory                                                              *
#索引     ：                                                                       *
#入参     ：储存版本数据地址指针                                                   *
#返回值   ：函数调用结果                                                           *
#后处理   ：无                                                                     *
#超时     ：2S                                                                     *
#所属模块 ：SSD                                                                    *
#适用用例 ：                                                                       *
#负责人   ：                                                                       *
#调用方法 ：调用关键字，地址指针                                                   *
#备注     ：                                                                       *
#***********************************************************************************
FUN get core version
    [Documentation]    获取core版本
    [Tags]    mandatory
    [Arguments]   @{parameters}
    [Teardown]    Log    get core version
    [Timeout]    2S
    ${execute_result}    ${result_list}=    Execute Command With Out Datas by UAgent     get_core_version    @{parameters}
    Log    ${result_list[0]}
    Should be equal    ${execute_result}    ${0}

FUN get boot version      #PLP_ARM    X86无
    [Documentation]    获取boot版本
    [Tags]    mandatory
    [Arguments]   @{parameters}
    [Teardown]    Log    get boot version
    [Timeout]    2S
    ${execute_result}    ${result_list}=    Execute Command With Out Datas by UAgent     get_boot_version    @{parameters}
    Log    ${result_list[0]}
    Should be equal    ${execute_result}    ${0}

FUN get epld version
    [Documentation]    获取epld版本
    [Tags]    mandatory
    [Arguments]   @{parameters}
    [Teardown]    Log    get epld version
    [Timeout]    2S
    ${execute_result}    ${result_list}=    Execute Command With Out Datas by UAgent     get_epld_version    @{parameters}
    Log    ${result_list[0]}
    Should be equal    ${execute_result}    ${0}

FUN get fsbl version      #PLP_ARM    X86无
    [Documentation]    获取fsbl版本
    [Tags]    mandatory
    [Arguments]   @{parameters}
    [Teardown]    Log    get the slot->usoffset
    [Timeout]    2S
    ${execute_result}    ${result_list}=    Execute Command With Out Datas by UAgent     get_fsbl_version    @{parameters}
    Log    ${result_list[0]}
    Should be equal    ${execute_result}    ${0}

FUN get dpdk version      #仅支持HSCTA/HBPOA
    [Documentation]    获取dpdk版本
    [Tags]    mandatory
    [Arguments]   @{parameters}
    [Teardown]    Log    get the slot->usoffset
    [Timeout]    2S
    ${execute_result}    ${result_list}=    Execute Command With Out Datas by UAgent     get_dpdk_version     @{parameters}
    Log    ${result_list[0]}
    Should be equal    ${execute_result}    ${0}

FUN get hardware version
    [Documentation]    获取pcb_hardware版本
    [Tags]    mandatory
    [Arguments]   @{parameters}
    [Teardown]    Log    get the slot->usoffset
    [Timeout]    2S
    ${execute_result}    ${result_list}=    Execute Command With Out Datas by UAgent     get_pcb_hardware_version    @{parameters}
    Log    ${result_list[0]}
    Should be equal    ${execute_result}    ${0}

FUN get si version       #ARM si version
    [Documentation]    获取si版本
    [Tags]    mandatory
    [Arguments]   @{parameters}
    [Teardown]    Log    get the slot->usoffset
    [Timeout]    2S
    ${execute_result}    ${result_list}=    Execute Command With Out Datas by UAgent     get_si_version     @{parameters}
    Log    ${result_list[0]}
    Should be equal    ${execute_result}    ${0}

