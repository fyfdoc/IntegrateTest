# encoding utf-8
'''
*************************************************************
*** COPYRIGHT DaTang Mobile Communications Equipment CO.,LTD
*************************************************************
*文件名称：GPSResource.robot
*功能描述：GPS准出相关资源文件：准出涉及关键字列表
*使用方法：

-----------------------------------------------------------------------------------
*修改记录：                                                                       |
*##修改日期    |    修改人    |    修改描述    |                                  |
*2018-12-3         wangxiaohe       创建文件                                      |
----------------------------------------------------------------------------------|
*************************************************************
______________________________________________________________________________________
*关键字目录：                                                                        |
-------------------------------------------------------------------------            |
*## GPS相关 ##                                                                       |
*A1.GPS_PP1S                     ->     gps_pp1s_test                                |
*A2.GPS_TOD                      ->     gps_tod_test                                 |
*A3.级联PP1S                     ->     link_pp1s_test                               |
*A4.级联TOD                      ->     link_tod_test                                |
*A5.GPS锁定判断                  ->     gps_lock_test                                |
_____________________________________________________________________________________|

************************************************资源文件头结束**************************************************
'''
from pysnmp.smi.rfc1902 import ObjectIdentity

*** Settings ***
Library    SnmpLibrary

*** Variables ***
${Mib}    DTM-TD-LTE-ENODEB-ENBMIB
${hsctd_addr_base}    172.27.245
${aom}    aom

*** Keywords ***

#***********************************************************************************
#功能     ：GPS_PP1S检测                                                           *
#标签     ：mandatory                                                              *
#索引     ：                                                                       *
#入参     ：                                                                       *
#返回值   ：函数调用结果                                                           *
#后处理   ：无                                                                     *
#超时     ：2S                                                                     *
#所属模块 ：GPS                                                                    *
#适用用例 ：                                                                       *
#负责人   ：                                                                       *
#调用方法 ：调用关键字，输入值value                                                *
#备注     ：                                                                       *
#***********************************************************************************
gps_pp1s_test
    [Documentation]    GPS_PP1S检测
    [Tags]    mandatory
    [Arguments]   ${parameters}
    [Teardown]    Log    GPS_PP1S
    [Timeout]    2S
    ${execute_result}=    Execute Command by UAgent    Osp_Ioctl    ${parameters}    ${0}
    Should be equal    ${execute_result}    ${0}

#***********************************************************************************
#功能     ：GPS_TOD检测                                                            *
#标签     ：mandatory                                                              *
#索引     ：                                                                       *
#入参     ：                                                                       *
#返回值   ：函数调用结果                                                           *
#后处理   ：无                                                                     *
#超时     ：2S                                                                     *
#所属模块 ：GPS                                                                    *
#适用用例 ：                                                                       *
#负责人   ：                                                                       *
#调用方法 ：调用关键字，输入值value                                                *
#备注     ：                                                                       *
#***********************************************************************************
gps_tod_test
    [Documentation]    GPS_TOD检测
    [Tags]    mandatory
    [Arguments]   ${parameters}
    [Teardown]    Log    GPS_TOD
    [Timeout]    2S
    ${execute_result}=    Execute Command by UAgent    Osp_Ioctl    ${parameters}    ${0}
    Should be equal    ${execute_result}    ${0}

#***********************************************************************************
#功能     ：级联PP1S                                                               *
#标签     ：mandatory                                                              *
#索引     ：                                                                       *
#入参     ：                                                                       *
#返回值   ：函数调用结果                                                           *
#后处理   ：无                                                                     *
#超时     ：10S                                                                    *
#所属模块 ：GPS                                                                    *
#适用用例 ：                                                                       *
#负责人   ：                                                                       *
#调用方法 ：调用关键字                                                             *
#备注     ：                                                                       *
#***********************************************************************************
link_pp1s_test
    [Documentation]    级联PP1S
    [Tags]    mandatory
    [Arguments]
    [Teardown]    Log   link_pp1s
    [Timeout]    10S
    ${execute_result}=    Execute Command by UAgent    fdd_gps_without_ante_startup   ${1}
#    Should be equal    ${execute_result}    ${0}
    ${execute_result}=    Execute Command by UAgent    fdd_hal_epld_write    ${0x2d}   ${0x40}
    ${execute_result}=    Execute Command by UAgent    fdd_hal_epld_write    ${0x26}   ${0xc0}
#    Sleep    2
    ${execute_result1}=    Execute Command by UAgent    PRODUCT_TEST_PP1S
    Should be equal    ${execute_result1}    ${0}


#***********************************************************************************
#功能     ：级联TOD                                                                *
#标签     ：mandatory                                                              *
#索引     ：                                                                       *
#入参     ：                                                                       *
#返回值   ：函数调用结果                                                           *
#后处理   ：无                                                                     *
#超时     ：60S                                                                    *
#所属模块 ：GPS                                                                    *
#适用用例 ：                                                                       *
#负责人   ：                                                                       *
#调用方法 ：                                                                       *
#备注     ：                                                                       *
#***********************************************************************************
link_tod_test
    [Documentation]    级联TOD
    [Tags]    mandatory
    [Arguments]   ${parameters1}    ${parameters2}
    [Teardown]    Log    link_tod
    [Timeout]    60S
    ${execute_result}    ${result_list}=    Execute Command With Out Datas by UAgent    BD_PPS_TEST    ${parameters1}    ${parameters2}
    ${intval}    Evaluate    int.from_bytes(${result_list}[1],byteorder="little")
    Should be equal    ${intval}    ${3}
    Should be equal    ${execute_result}    ${0}

#***********************************************************************************
#功能     ：GPS锁定判断                                                            *
#标签     ：mandatory                                                              *
#索引     ：                                                                       *
#入参     ：                                                                       *
#返回值   ：函数调用结果                                                           *
#后处理   ：无                                                                     *
#超时     ：800S                                                                   *
#所属模块 ：GPS                                                                    *
#适用用例 ：                                                                       *
#负责人   ：                                                                       *
#调用方法 ：调用关键字，输入值value                                                *
#备注     ：                                                                       *
#***********************************************************************************
gps_lock_test2
    log to console    Wait 600s
    Sleep    600
    ${execute_result}=    Execute Command by UAgent    Osp_Ioctl    ${parameters}    ${0}
    log to console    33333
    Run Keyword If    ${execute_result} == ${0}   Should be equal    ${0}    ${0}
    ...    ELSE    Should be equal    ${1}    ${0}
gps_lock_test1
    ${execute_result}=   Execute Command by UAgent    Osp_Ioctl    ${0x41019}    ${0}
    log to console    222222
    Run Keyword If    ${execute_result} != ${0}    Should be equal    ${1}    ${0}
    ...   ELSE    gps_lock_test2
gps_lock_test
    [Documentation]    GPS锁定判断
    [Tags]    mandatory
    [Arguments]   ${parameters}
    [Teardown]    Log    GPS_LOCK
    [Timeout]    800S
    ${execute_result}=    Execute Command by UAgent    Osp_Ioctl    ${parameters}    ${0}
    log to console    111111
    Run Keyword If    ${execute_result} == ${0}   Should be equal    ${0}    ${0}
    ...    ELSE    gps_lock_test1