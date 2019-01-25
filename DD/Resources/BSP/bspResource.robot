 # encoding utf-8
'''
*************************************************************
*** COPYRIGHT DaTang Mobile Communications Equipment CO.,LTD
*************************************************************
*文件名称：bspopResource.robot
*功能描述：BSP用例资源：准出涉及关键字列表
*使用方法：

-----------------------------------------------------------------------------------
*修改记录：                                                                       |
*##修改日期    |    修改人    |    修改描述    |                                  |
*2018-10-31       xinjin       创建文件                                           |
----------------------------------------------------------------------------------|
*************************************************************
______________________________________________________________________________________
*关键字目录：                                                                        |
-------------------------------------------------------------------------            |
*##主控x86相关关键字##                                                               |
*A1.文件系统测试                       -> hsctd file test                            |
*A2.FTP上传下载测试                    -> hsctd ftp test                             |
*A3.定时中断测试                       -> hsctd timer Interruption test              |
*A4.内存memcpy测试                     -> hsctd memcpy test                          |
*A5.内存读写测试                       -> hsctd memory test                          |
*A6.内存memset测试                     -> hsctd memset test                          |
*A7.mq_perf测试                        -> hsctd mq perf test                         |
*A8.mountnfs压力测试                   -> hsctd mountnfs test                        |
*A9.TPF测试                            -> hsctd tpf test                             |
*##基带x86相关关键字##                                                               |
*B1.文件系统测试                       -> hbpod x86 file test                        |
*B2.FTP上传下载测试                    -> hbpod x86 ftp test                         |
*B3.定时中断测试                       -> hbpod x86 timer Interruption test          |
*B4.内存memcpy测试                     -> hbpod x86 memcpy test                      |
*B5.内存读写测试                       -> hbpod x86 memory test                      |
*B6.内存memset测试                     -> hbpod x86 memset test                      |
*B7.mq_perf测试                        -> hbpod x86 mq perf test                     |
*B8.mountnfs压力测试                   -> hbpod x86 mountnfs test                    |
*B9.TPF测试                            -> hbpod x86 tpf test                         |
*##基带plp1相关关键字##                                                              |
*C1.文件系统测试                       -> hbpod plp1 file test                       |
*C2.FTP上传下载测试                    -> hbpod plp1 ftp test                        |
*C3.定时中断测试                       -> hbpod plp1 timer Interruption test         |
*C4.内存memcpy测试                     -> hbpod plp1 memcpy test                     |
*C5.内存读写测试                       -> hbpod plp1 memory test                     |
*C6.内存memset测试                     -> hbpod plp1 memset test                     |
*C7.mq_perf测试                        -> hbpod plp1 mq perf test                    |
*C8.mountnfs压力测试                   -> hbpod plp1 mountnfs test                   |
*C9.TPF测试                            -> hbpod plp1 tpf test                        |
*##基带plp2相关关键字##                                                              |
*D1.文件系统测试                       -> hbpod plp2 file test                       |
*D2.FTP上传下载测试                    -> hbpod plp2 ftp test                        |
*D3.定时中断测试                       -> hbpod plp2 timer Interruption test         |
*D4.内存memcpy测试                     -> hbpod plp2 memcpy test                     |
*D5.内存读写测试                       -> hbpod plp2 memory test                     |
*D6.内存memset测试                     -> hbpod plp2 memset test                     |
*D7.mq_perf测试                        -> hbpod plp2 mq perf test                    |
*D8.mountnfs压力测试                   -> hbpod plp2 mountnfs test                   |
*D9.TPF测试                            -> hbpod plp2 tpf test                        |
*##mountnfs相关关键字##                                                              |
*E1.循环执行mountnfs                   -> mountnfs test                              |
_____________________________________________________________________________________|


************************************************资源文件头结束**************************************************
'''
from pysnmp.smi.rfc1902 import ObjectIdentity

*** Settings ***
Resource    ../_COMM_/UAgentWrapper.robot
Library     DateTime
Library     SnmpLibrary
Library     BuiltIn
Library     ../../utils/CiUtils.py
Resource    ../_COMM_/SnmpMibHelper.robot
Resource    ../_COMM_/LogHelper.robot
Resource    ../_COMM_/UploadLogsAndRecoverGnb.robot
*** Variables ***
#Variables of Keyword：file test

${hsctd_address_base}    172.27.245
${hbpod_address_base}    172.27.246
${FtpServerx86Ip}    172.27.245.100
${FtpServerarmIp}    172.27.246.100
${som}    som
${aom}    aom
${Mib}    DTM-TD-LTE-ENODEB-ENBMIB

*** Keywords ***
#***********************************************************************************
#功能     ： hsctd file test                                                       *
#标签     ：BSP                                                                    *
#索引     ：无                                                                     *
#入参     ：无                                                                     *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：2S                                                                     *
#所属模块 ：BSP                                                                    *
#适用用例 ：                                                                       *
#负责人   ：xinjin                                                                 *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：确保.so文件为最新，文件可下载至板卡                                    *
#                                                                                  *
#***********************************************************************************
hsctd file test
    [Documentation]    主控x86 文件系统测试
    [Tags]    BSP
    [Arguments]
    [Teardown]    Log    hsctd file test finish!

    ${boardEntry}    Get Oid By Name    ${Mib}    boardRowStatus
    Log    ${boardEntry}
    @{hsctd_slots}    Get board of aom or som    aom    ${boardEntry}    ${16}
    ${slot1}    Evaluate    int(@{hsctd_slots}[0])
    Set Suite Variable    ${hsctd_slot}    ${slot1}
    ${ip_address}    Catenate    SEPARATOR=.    ${hsctd_address_base}    ${hsctd_slot + 91}
    ${pid}    Set Variable    ${2}
    Connect Device By UAgent Use Pid    hsctd scp 2    ${ip_address}    ${pid}
    File Download      ${FtpServerx86Ip}:\/\/D:\/soc\/\/libtest.so     \/ramDisk\/libtest.so
    Execute Command by UAgent    loadModule    '/ramDisk/libtest.so'    ''
    Sleep    1
    ${execute_result}=    Execute Command by UAgent    filetest    ''
    Should be equal    ${execute_result}    ${0}
    Sleep    1
    Execute Command by UAgent    unloadModule    '/ramDisk/libtest.so'    ''
    Execute Command by UAgent    cmd    'rm /ramDisk/libtest.so -rf'    ''
    Disconnect UAgent Use Pid

#***********************************************************************************
#功能     ：hbpod x86 file test                                                    *
#标签     ：BSP                                                                    *
#索引     ：无                                                                     *
#入参     ：无                                                                     *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：2S                                                                     *
#所属模块 ：BSP                                                                    *
#适用用例 ：                                                                       *
#负责人   ：xinjin                                                                 *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ： 确保.so文件为最新，文件可下载至板卡                                   *
#                                                                                  *
#***********************************************************************************
hbpod x86 file test
    [Documentation]    基带 x86 文件系统测试
    [Tags]    BSP
    [Arguments]
    [Teardown]    Log    hbpod x86 file test finish!

    ${boardEntry}    Get Oid By Name    ${Mib}    boardRowStatus
    Log    ${boardEntry}
    @{som_slotNo_list}    Get board of aom or som    ${som}    ${boardEntry}    ${16}
    :FOR    ${loop_slotNo}    in    @{som_slotNo_list}
    \   ${hbpod_slot}    Evaluate    int(${loop_slotNo})
    \   ${ip_address}    Catenate    SEPARATOR=.    ${hbpod_address_base}    ${hbpod_slot + 1}
    \   Log    ${loop_slotNo}'s board log upload is complete!
    \   ${pid}    Set Variable    ${2}
    \   Connect Device By UAgent Use Pid    hbpod scp 2    ${ip_address}    ${pid}
    \   File Download      ${FtpServerx86Ip}:\/\/D:\/soc\/\/libtest.so     \/ramDisk\/libtest.so
    \   Execute Command by UAgent    loadModule    '/ramDisk/libtest.so'    ''
    \   Sleep    1
    \   ${execute_result}=    Execute Command by UAgent    filetest    ''
    \   Log    ${execute_result}'s board log upload is complete!
    \   Should be equal    ${execute_result}    ${0}
    \   Sleep    1
    \   Execute Command by UAgent    unloadModule    '/ramDisk/libtest.so'    ''
    \   Execute Command by UAgent    cmd    'rm /ramDisk/libtest.so -rf'    ''
    \   Disconnect UAgent Use Pid

#***********************************************************************************
#功能     ：hbpod plp1 file test                                                   *
#标签     ：BSP                                                                    *
#索引     ：无                                                                     *
#入参     ：无                                                                     *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：2S                                                                     *
#所属模块 ：BSP                                                                    *
#适用用例 ：                                                                       *
#负责人   ：xinjin                                                                 *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：确保.so文件为最新，文件可下载至板卡                                    *
#                                                                                  *
#***********************************************************************************
hbpod plp1 file test
    [Documentation]    基带 plp1 文件系统测试
    [Tags]    BSP
    [Arguments]
    [Teardown]    Log    hbpod plp1 file test finish!

    ${boardEntry}    Get Oid By Name    ${Mib}    boardRowStatus
    Log    ${boardEntry}
    @{som_slotNo_list}    Get board of aom or som    ${som}    ${boardEntry}    ${16}
    :FOR    ${loop_slotNo}    in    @{som_slotNo_list}
    \   ${hbpod_slot}    Evaluate    int(${loop_slotNo})
    \   ${ip_address}    Catenate    SEPARATOR=.    ${hbpod_address_base}    ${hbpod_slot + 11}
    \   Log    ${loop_slotNo}'s board log upload is complete!
    \   ${pid}    Set Variable    ${0}
    \   Connect Device By UAgent Use Pid    hbpod plp1    ${ip_address}    ${pid}
    \   File Download      ${FtpServerarmIp}:\/\/D:\/soc\/\/libtest_arm.so     \/ramDisk\/libtest_arm.so
    \   Execute Command by UAgent    loadModule    '/ramDisk/libtest_arm.so'    ''
    \   Sleep    1
    \   ${execute_result}=    Execute Command by UAgent    filetest    ''
    \   Log    ${execute_result}'s board log upload is complete!
    \   Should be equal    ${execute_result}    ${0}
    \   Sleep    1
    \   Execute Command by UAgent    unloadModule    '/ramDisk/libtest_arm.so'    ''
    \   Execute Command by UAgent    cmd    'rm /ramDisk/libtest_arm.so -rf'    ''
    \   Disconnect UAgent Use Pid

#***********************************************************************************
#功能     ：hbpod plp2 file test                                                   *
#标签     ：BSP                                                                    *
#索引     ：无                                                                     *
#入参     ：无                                                                     *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：2S                                                                     *
#所属模块 ：BSP                                                                    *
#适用用例 ：                                                                       *
#负责人   ：xinjin                                                                 *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：确保.so文件为最新，文件可下载至板卡                                    *
#                                                                                  *
#***********************************************************************************
hbpod plp2 file test
    [Documentation]    基带 plp2 文件系统测试
    [Tags]    BSP
    [Arguments]
    [Teardown]    Log    hbpod plp2 file test finish!


    ${boardEntry}    Get Oid By Name    ${Mib}    boardRowStatus
    Log    ${boardEntry}
    @{som_slotNo_list}    Get board of aom or som    ${som}    ${boardEntry}    ${16}
    :FOR    ${loop_slotNo}    in    @{som_slotNo_list}
    \   ${hbpod_slot}    Evaluate    int(${loop_slotNo})
    \   ${ip_address}    Catenate    SEPARATOR=.    ${hbpod_address_base}    ${hbpod_slot + 21}
    \   Log    ${loop_slotNo}'s board log upload is complete!
    \   ${pid}    Set Variable    ${0}
    \   Connect Device By UAgent Use Pid    hbpod plp 2    ${ip_address}    ${pid}
    \   File Download      ${FtpServerarmIp}:\/\/D:\/soc\/\/libtest_arm.so     \/ramDisk\/libtest_arm.so
    \   Execute Command by UAgent    loadModule    '/ramDisk/libtest_arm.so'    ''
    \   Sleep    1
    \   ${execute_result}=    Execute Command by UAgent    filetest    ''
    \   Log    ${execute_result}'s board log upload is complete!
    \   Should be equal    ${execute_result}    ${0}
    \   Sleep    1
    \   Execute Command by UAgent    unloadModule    '/ramDisk/libtest_arm.so'    ''
    \   Execute Command by UAgent    cmd    'rm /ramDisk/libtest_arm.so -rf'    ''
    \   Disconnect UAgent Use Pid



#***********************************************************************************
#功能     ： hsctd ftp test                                                        *
#标签     ：BSP                                                                    *
#索引     ：无                                                                     *
#入参     ：无                                                                     *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：2S                                                                     *
#所属模块 ：BSP                                                                    *
#适用用例 ：                                                                       *
#负责人   ：xinjin                                                                 *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：确保.so文件为最新，文件可下载至板卡                                    *
#                                                                                  *
#***********************************************************************************
hsctd ftp test
    [Documentation]    主控x86 ftp上传下载测试
    [Tags]    BSP
    [Arguments]
    [Teardown]    Log    hsctd ftp test finish!

    ${boardEntry}    Get Oid By Name    ${Mib}    boardRowStatus
    Log    ${boardEntry}
    @{hsctd_slots}    Get board of aom or som    aom    ${boardEntry}    ${16}
    ${slot1}    Evaluate    int(@{hsctd_slots}[0])
    Set Suite Variable    ${hsctd_slot}    ${slot1}
    ${ip_address}    Catenate    SEPARATOR=.    ${hsctd_address_base}    ${hsctd_slot + 91}
    ${pid}    Set Variable    ${2}
    Connect Device By UAgent Use Pid    hsctd scp 2    ${ip_address}    ${pid}
    File Download      ${FtpServerx86Ip}:\/\/D:\/soc\/\/libtest.so     \/ramDisk\/libtest.so
    Execute Command by UAgent    loadModule    '/ramDisk/libtest.so'    ''
    Sleep    1
    ${execute_result}=    Execute Command by UAgent    cmd    'ifconfig eth2 inet add 10.10.10.5'    ''
    Sleep    1
    ${execute_result}=    Execute Command by UAgent    Sendfile    '10.10.10.10\n'
    Should be equal    ${execute_result}    ${0}
    Sleep    1
    ${execute_result}=    Execute Command by UAgent    getfile    '10.10.10.10\n'
    Should be equal    ${execute_result}    ${0}
    Sleep    1
    Execute Command by UAgent    unloadModule    '/ramDisk/libtest.so'    ''
    Execute Command by UAgent    cmd    'rm /ramDisk/libtest.so -rf'    ''
    Disconnect UAgent Use Pid

#***********************************************************************************
#功能     ：hbpod x86 ftp test                                                     *
#标签     ：BSP                                                                    *
#索引     ：无                                                                     *
#入参     ：无                                                                     *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：2S                                                                     *
#所属模块 ：BSP                                                                    *
#适用用例 ：                                                                       *
#负责人   ：xinjin                                                                 *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ： 确保.so文件为最新，文件可下载至板卡                                   *
#                                                                                  *
#***********************************************************************************
hbpod x86 ftp test
    [Documentation]    基带 x86 ftp上传下载测试
    [Tags]    BSP
    [Arguments]
    [Teardown]    Log    hbpod x86 ftp test finish!

    ${boardEntry}    Get Oid By Name    ${Mib}    boardRowStatus
    Log    ${boardEntry}
    @{som_slotNo_list}    Get board of aom or som    ${som}    ${boardEntry}    ${16}
    :FOR    ${loop_slotNo}    in    @{som_slotNo_list}
    \   ${hbpod_slot}    Evaluate    int(${loop_slotNo})
    \   ${ip_address}    Catenate    SEPARATOR=.    ${hbpod_address_base}    ${hbpod_slot + 1}
    \   Log    ${loop_slotNo}'s board log upload is complete!
    \   ${pid}    Set Variable    ${2}
    \   Connect Device By UAgent Use Pid    hbpod scp 2    ${ip_address}    ${pid}
    \   File Download      ${FtpServerx86Ip}:\/\/D:\/soc\/\/libtest.so     \/ramDisk\/libtest.so
    \   Execute Command by UAgent    loadModule    '/ramDisk/libtest.so'    ''
    \   Sleep    1
    # \   ${execute_result}=    Execute Command by UAgent    cmd    'ifconfig eth2 inet add 10.10.10.2'    ''
    # \   Sleep    1
    \   ${execute_result}=    Execute Command by UAgent    Sendfile    '172.27.246.100'    ''
    \   Should be equal    ${execute_result}    ${0}
    \   Sleep    1
    \
    \   ${execute_result}=    Execute Command by UAgent    getfile    '172.27.246.100'    ''
    \   Log    ${execute_result}'s board log upload is complete!
    \   Should be equal    ${execute_result}    ${0}
    \   Sleep    1
    \   Execute Command by UAgent    unloadModule    '/ramDisk/libtest.so'    ''
    \   Execute Command by UAgent    cmd    'rm /ramDisk/libtest.so -rf'    ''
    \   Disconnect UAgent Use Pid

#***********************************************************************************
#功能     ：hbpod plp1 ftp test                                                    *
#标签     ：BSP                                                                    *
#索引     ：无                                                                     *
#入参     ：无                                                                     *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：2S                                                                     *
#所属模块 ：BSP                                                                    *
#适用用例 ：                                                                       *
#负责人   ：xinjin                                                                 *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：确保.so文件为最新，文件可下载至板卡                                    *
#                                                                                  *
#***********************************************************************************
hbpod plp1 ftp test
    [Documentation]    基带 plp1 ftp上传下载测试
    [Tags]    BSP
    [Arguments]
    [Teardown]    Log    hbpod plp1 ftp test finish!

    ${boardEntry}    Get Oid By Name    ${Mib}    boardRowStatus
    Log    ${boardEntry}
    @{som_slotNo_list}    Get board of aom or som    ${som}    ${boardEntry}    ${16}
    :FOR    ${loop_slotNo}    in    @{som_slotNo_list}
    \   ${hbpod_slot}    Evaluate    int(${loop_slotNo})
    \   ${ip_address}    Catenate    SEPARATOR=.    ${hbpod_address_base}    ${hbpod_slot + 11}
    \   Log    ${loop_slotNo}'s board log upload is complete!
    \   ${pid}    Set Variable    ${0}
    \   Connect Device By UAgent Use Pid    hbpod plp1    ${ip_address}    ${pid}
    \   File Download      ${FtpServerarmIp}:\/\/D:\/soc\/\/libtest_arm.so     \/ramDisk\/libtest_arm.so
    \   Execute Command by UAgent    loadModule    '/ramDisk/libtest_arm.so'    ''
    \   Sleep    1
    # \   ${execute_result}=    Execute Command by UAgent    cmd    'ifconfig eth2 inet add 10.10.10.3'    ''
    # \   Sleep    1
    \   ${execute_result}=    Execute Command by UAgent    Sendfile    '172.27.246.100'    ''
    \   Log    ${execute_result}'s board log upload is complete!
    \   Should be equal    ${execute_result}    ${0}
    \   Sleep    1
    \
    \   ${execute_result}=    Execute Command by UAgent    getfile    '172.27.246.100'    ''
    \   Log    ${execute_result}'s board log upload is complete!
    \   Should be equal    ${execute_result}    ${0}
    \   Sleep    1
    \   Execute Command by UAgent    unloadModule    '/ramDisk/libtest_arm.so'    ''
    \   Execute Command by UAgent    cmd    'rm /ramDisk/libtest_arm.so -rf'    ''
    \   Disconnect UAgent Use Pid

#***********************************************************************************
#功能     ：hbpod plp2 ftp test                                                    *
#标签     ：BSP                                                                    *
#索引     ：无                                                                     *
#入参     ：无                                                                     *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：2S                                                                     *
#所属模块 ：BSP                                                                    *
#适用用例 ：                                                                       *
#负责人   ：xinjin                                                                 *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：确保.so文件为最新，文件可下载至板卡                                    *
#                                                                                  *
#***********************************************************************************
hbpod plp2 ftp test
    [Documentation]    基带 plp2 ftp上传下载测试
    [Tags]    BSP
    [Arguments]
    [Teardown]    Log    hbpod plp2 ftp test finish!


    ${boardEntry}    Get Oid By Name    ${Mib}    boardRowStatus
    Log    ${boardEntry}
    @{som_slotNo_list}    Get board of aom or som    ${som}    ${boardEntry}    ${16}
    :FOR    ${loop_slotNo}    in    @{som_slotNo_list}
    \   ${hbpod_slot}    Evaluate    int(${loop_slotNo})
    \   ${ip_address}    Catenate    SEPARATOR=.    ${hbpod_address_base}    ${hbpod_slot + 21}
    \   Log    ${loop_slotNo}'s board log upload is complete!
    \   ${pid}    Set Variable    ${0}
    \   Connect Device By UAgent Use Pid    hbpod plp 2    ${ip_address}    ${pid}
    \   File Download      ${FtpServerarmIp}:\/\/D:\/soc\/\/libtest_arm.so     \/ramDisk\/libtest_arm.so
    \   Execute Command by UAgent    loadModule    '/ramDisk/libtest_arm.so'    ''
    \   Sleep    1
    # \   ${execute_result}=    Execute Command by UAgent    cmd    'ifconfig eth2 inet add 10.10.10.6'
    # \   Sleep    1
    \   ${execute_result}=    Execute Command by UAgent    Sendfile    '172.27.246.100'    ''
    \   Log    ${execute_result}'s board log upload is complete!
    \   Should be equal    ${execute_result}    ${0}
    \   Sleep    1
    \
    \   ${execute_result}=    Execute Command by UAgent    getfile    '172.27.246.100'    ''
    \   Log    ${execute_result}'s board log upload is complete!
    \   Should be equal    ${execute_result}    ${0}
    \   Sleep    1
    \   Execute Command by UAgent    unloadModule    '/ramDisk/libtest_arm.so'    ''
    \   Execute Command by UAgent    cmd    'rm /ramDisk/libtest_arm.so -rf'    ''
    \   Disconnect UAgent Use Pid


#***********************************************************************************
#功能     ：hsctd timer Interruption test                                          *
#标签     ：BSP                                                                    *
#索引     ：无                                                                     *
#入参     ：无                                                                     *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：2S                                                                     *
#所属模块 ：BSP                                                                    *
#适用用例 ：                                                                       *
#负责人   ：xinjin                                                                 *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：确保.so文件为最新，文件可下载至板卡                                    *
#                                                                                  *
#***********************************************************************************
hsctd timer Interruption test
    [Documentation]    主控x86 定时中断测试
    [Tags]    BSP
    [Arguments]
    [Teardown]    Log    hsctd timer Interruption test finish!

    ${boardEntry}    Get Oid By Name    ${Mib}    boardRowStatus
    Log    ${boardEntry}
    @{hsctd_slots}    Get board of aom or som    aom    ${boardEntry}    ${16}
    ${slot1}    Evaluate    int(@{hsctd_slots}[0])
    Set Suite Variable    ${hsctd_slot}    ${slot1}
    ${ip_address}    Catenate    SEPARATOR=.    ${hsctd_address_base}    ${hsctd_slot + 91}
    ${pid}    Set Variable    ${2}
    Connect Device By UAgent Use Pid    hsctd scp 2    ${ip_address}    ${pid}
    File Download      ${FtpServerx86Ip}:\/\/D:\/soc\/\/libtest.so     \/ramDisk\/libtest.so
    Execute Command by UAgent    loadModule    '/ramDisk/libtest.so'    ''
    Sleep    1
    ${execute_result}=    Execute Command by UAgent    timer_INT_test    ${15}    ''
    Should be equal    ${execute_result}    ${0}
    Sleep    1
    Execute Command by UAgent    unloadModule    '/ramDisk/libtest.so'    ''
    Execute Command by UAgent    cmd    'rm /ramDisk/libtest.so -rf'    ''
    Disconnect UAgent Use Pid

#***********************************************************************************
#功能     ：hbpod x86 timer Interruption test                                      *
#标签     ：BSP                                                                    *
#索引     ：无                                                                     *
#入参     ：无                                                                     *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：2S                                                                     *
#所属模块 ：BSP                                                                    *
#适用用例 ：                                                                       *
#负责人   ：xinjin                                                                 *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ： 确保.so文件为最新，文件可下载至板卡                                   *
#                                                                                  *
#***********************************************************************************
hbpod x86 timer Interruption test
    [Documentation]    基带 x86 定时中断测试
    [Tags]    BSP
    [Arguments]
    [Teardown]    Log    hbpod x86 timer Interruption test finish!

    ${boardEntry}    Get Oid By Name    ${Mib}    boardRowStatus
    Log    ${boardEntry}
    @{som_slotNo_list}    Get board of aom or som    ${som}    ${boardEntry}    ${16}
    :FOR    ${loop_slotNo}    in    @{som_slotNo_list}
    \   ${hbpod_slot}    Evaluate    int(${loop_slotNo})
    \   ${ip_address}    Catenate    SEPARATOR=.    ${hbpod_address_base}    ${hbpod_slot + 1}
    \   Log    ${loop_slotNo}'s board log upload is complete!
    \   ${pid}    Set Variable    ${2}
    \   Connect Device By UAgent Use Pid    hbpod scp 2    ${ip_address}    ${pid}
    \   File Download      ${FtpServerx86Ip}:\/\/D:\/soc\/\/libtest.so     \/ramDisk\/libtest.so
    \   Execute Command by UAgent    loadModule    '/ramDisk/libtest.so'    ''
    \   Sleep    1
    \   ${execute_result}=    Execute Command by UAgent    timer_INT_test    ${27}    ''
    \   Should be equal    ${execute_result}    ${0}
    \   Sleep    1
    \   ${execute_result}=    Execute Command by UAgent    timer_INT_test    ${28}    ''
    \   Should be equal    ${execute_result}    ${0}
    \   Sleep    1
    \   Execute Command by UAgent    unloadModule    '/ramDisk/libtest.so'    ''
    \   Execute Command by UAgent    cmd    'rm /ramDisk/libtest.so -rf'    ''
    \   Disconnect UAgent Use Pid

#***********************************************************************************
#功能     ：hbpod plp1 timer Interruption test                                     *
#标签     ：BSP                                                                    *
#索引     ：无                                                                     *
#入参     ：无                                                                     *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：2S                                                                     *
#所属模块 ：BSP                                                                    *
#适用用例 ：                                                                       *
#负责人   ：xinjin                                                                 *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：确保.so文件为最新，文件可下载至板卡                                    *
#                                                                                  *
#***********************************************************************************
hbpod plp1 timer Interruption test
    [Documentation]    基带 plp1 定时中断测试
    [Tags]    BSP
    [Arguments]
    [Teardown]    Log    hbpod plp1 timer Interruption test finish!

    ${boardEntry}    Get Oid By Name    ${Mib}    boardRowStatus
    Log    ${boardEntry}
    @{som_slotNo_list}    Get board of aom or som    ${som}    ${boardEntry}    ${16}
    :FOR    ${loop_slotNo}    in    @{som_slotNo_list}
    \   ${hbpod_slot}    Evaluate    int(${loop_slotNo})
    \   ${ip_address}    Catenate    SEPARATOR=.    ${hbpod_address_base}    ${hbpod_slot + 11}
    \   Log    ${loop_slotNo}'s board log upload is complete!
    \   ${pid}    Set Variable    ${0}
    \   Connect Device By UAgent Use Pid    hbpod plp1    ${ip_address}    ${pid}
    \   File Download      ${FtpServerarmIp}:\/\/D:\/soc\/\/libtest_arm.so     \/ramDisk\/libtest_arm.so
    \   Execute Command by UAgent    loadModule    '/ramDisk/libtest_arm.so'    ''
    \   Sleep    1
    \   ${execute_result}=    Execute Command by UAgent    timer_INT_test    ${83}    ''
    \   Should be equal    ${execute_result}    ${0}
    \   Sleep    1
    \   ${execute_result}=    Execute Command by UAgent    timer_INT_test    ${84}    ''
    \   Should be equal    ${execute_result}    ${0}
    \   Sleep    1
    \   ${execute_result}=    Execute Command by UAgent    timer_INT_test    ${85}    ''
    \   Should be equal    ${execute_result}    ${0}
    \   Sleep    1
    \   Execute Command by UAgent    unloadModule    '/ramDisk/libtest_arm.so'    ''
    \   Execute Command by UAgent    cmd    'rm /ramDisk/libtest_arm.so -rf'    ''
    \   Disconnect UAgent Use Pid

#***********************************************************************************
#功能     ：hbpod plp2 timer Interruption test                                     *
#标签     ：BSP                                                                    *
#索引     ：无                                                                     *
#入参     ：无                                                                     *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：2S                                                                     *
#所属模块 ：BSP                                                                    *
#适用用例 ：                                                                       *
#负责人   ：xinjin                                                                 *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：确保.so文件为最新，文件可下载至板卡                                    *
#                                                                                  *
#***********************************************************************************
hbpod plp2 timer Interruption test
    [Documentation]    基带 plp2 定时中断测试
    [Tags]    BSP
    [Arguments]
    [Teardown]    Log    hbpod plp2 timer Interruption test finish!


    ${boardEntry}    Get Oid By Name    ${Mib}    boardRowStatus
    Log    ${boardEntry}
    @{som_slotNo_list}    Get board of aom or som    ${som}    ${boardEntry}    ${16}
    :FOR    ${loop_slotNo}    in    @{som_slotNo_list}
    \   ${hbpod_slot}    Evaluate    int(${loop_slotNo})
    \   ${ip_address}    Catenate    SEPARATOR=.    ${hbpod_address_base}    ${hbpod_slot + 21}
    \   Log    ${loop_slotNo}'s board log upload is complete!
    \   ${pid}    Set Variable    ${0}
    \   Connect Device By UAgent Use Pid    hbpod plp 2    ${ip_address}    ${pid}
    \   File Download      ${FtpServerarmIp}:\/\/D:\/soc\/\/libtest_arm.so     \/ramDisk\/libtest_arm.so
    \   Execute Command by UAgent    loadModule    '/ramDisk/libtest_arm.so'    ''
    \   Sleep    1
    \   ${execute_result}=    Execute Command by UAgent    timer_INT_test    ${83}    ''
    \   Should be equal    ${execute_result}    ${0}
    \   Sleep    1
    \   ${execute_result}=    Execute Command by UAgent    timer_INT_test    ${84}    ''
    \   Should be equal    ${execute_result}    ${0}
    \   Sleep    1
    \   ${execute_result}=    Execute Command by UAgent    timer_INT_test    ${85}    ''
    \   Should be equal    ${execute_result}    ${0}
    \   Sleep    1
    \   Execute Command by UAgent    unloadModule    '/ramDisk/libtest_arm.so'    ''
    \   Execute Command by UAgent    cmd    'rm /ramDisk/libtest_arm.so -rf'    ''
    \   Disconnect UAgent Use Pid

#***********************************************************************************
#功能     ：hsctd memcpy test                                                      *
#标签     ：BSP                                                                    *
#索引     ：无                                                                     *
#入参     ：无                                                                     *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：2S                                                                     *
#所属模块 ：BSP                                                                    *
#适用用例 ：                                                                       *
#负责人   ：xinjin                                                                 *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：确保.so文件为最新，文件可下载至板卡                                    *
#                                                                                  *
#***********************************************************************************
hsctd memcpy test
    [Documentation]    主控x86 内存memcpy测试
    [Tags]    BSP
    [Arguments]
    [Teardown]    Log    hsctd memcpy test finish!

    ${boardEntry}    Get Oid By Name    ${Mib}    boardRowStatus
    Log    ${boardEntry}
    @{hsctd_slots}    Get board of aom or som    aom    ${boardEntry}    ${16}
    ${slot1}    Evaluate    int(@{hsctd_slots}[0])
    Set Suite Variable    ${hsctd_slot}    ${slot1}
    ${ip_address}    Catenate    SEPARATOR=.    ${hsctd_address_base}    ${hsctd_slot + 91}
    ${pid}    Set Variable    ${2}
    Connect Device By UAgent Use Pid    hsctd scp 2    ${ip_address}    ${pid}
    File Download      ${FtpServerx86Ip}:\/\/D:\/soc\/\/libtest.so     \/ramDisk\/libtest.so
    Execute Command by UAgent    loadModule    '/ramDisk/libtest.so'    ''
    Sleep    1
    ${execute_result}=    Execute Command by UAgent    memcpy_test2    ''
    Sleep    2
    Should be equal    ${execute_result}    ${0}
    Execute Command by UAgent    unloadModule    '/ramDisk/libtest.so'    ''
    Execute Command by UAgent    cmd    'rm /ramDisk/libtest.so -rf'    ''
    Disconnect UAgent Use Pid

#***********************************************************************************
#功能     ：hbpod x86 memcpy test                                                  *
#标签     ：BSP                                                                    *
#索引     ：无                                                                     *
#入参     ：无                                                                     *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：2S                                                                     *
#所属模块 ：BSP                                                                    *
#适用用例 ：                                                                       *
#负责人   ：xinjin                                                                 *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ： 确保.so文件为最新，文件可下载至板卡                                   *
#                                                                                  *
#***********************************************************************************
hbpod x86 memcpy test
    [Documentation]    基带 x86 内存memcpy测试
    [Tags]    BSP
    [Arguments]
    [Teardown]    Log    hbpod x86 memcpy test finish!

    ${boardEntry}    Get Oid By Name    ${Mib}    boardRowStatus
    Log    ${boardEntry}
    @{som_slotNo_list}    Get board of aom or som    ${som}    ${boardEntry}    ${16}
    :FOR    ${loop_slotNo}    in    @{som_slotNo_list}
    \   ${hbpod_slot}    Evaluate    int(${loop_slotNo})
    \   ${ip_address}    Catenate    SEPARATOR=.    ${hbpod_address_base}    ${hbpod_slot + 1}
    \   Log    ${loop_slotNo}'s board log upload is complete!
    \   ${pid}    Set Variable    ${2}
    \   Connect Device By UAgent Use Pid    hbpod scp 2    ${ip_address}    ${pid}
    \   File Download      ${FtpServerx86Ip}:\/\/D:\/soc\/\/libtest.so     \/ramDisk\/libtest.so
    \   Execute Command by UAgent    loadModule    '/ramDisk/libtest.so'    ''
    \   Sleep    1
    \   ${execute_result}=    Execute Command by UAgent    memcpy_test2    ''
    \   Sleep    2
    \   Log    ${execute_result}'s board log upload is complete!
    \   Should be equal    ${execute_result}    ${0}
    \   Execute Command by UAgent    unloadModule    '/ramDisk/libtest.so'    ''
    \   Execute Command by UAgent    cmd    'rm /ramDisk/libtest.so -rf'    ''
    \   Disconnect UAgent Use Pid

#***********************************************************************************
#功能     ：hbpod plp1 memcpy test                                                 *
#标签     ：BSP                                                                    *
#索引     ：无                                                                     *
#入参     ：无                                                                     *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：2S                                                                     *
#所属模块 ：BSP                                                                    *
#适用用例 ：                                                                       *
#负责人   ：xinjin                                                                 *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：确保.so文件为最新，文件可下载至板卡                                    *
#                                                                                  *
#***********************************************************************************
hbpod plp1 memcpy test
    [Documentation]    基带 plp1 内存memcpy测试
    [Tags]    BSP
    [Arguments]
    [Teardown]    Log    hbpod plp1 memcpy test finish!

    ${boardEntry}    Get Oid By Name    ${Mib}    boardRowStatus
    Log    ${boardEntry}
    @{som_slotNo_list}    Get board of aom or som    ${som}    ${boardEntry}    ${16}
    :FOR    ${loop_slotNo}    in    @{som_slotNo_list}
    \   ${hbpod_slot}    Evaluate    int(${loop_slotNo})
    \   ${ip_address}    Catenate    SEPARATOR=.    ${hbpod_address_base}    ${hbpod_slot + 11}
    \   Log    ${loop_slotNo}'s board log upload is complete!
    \   ${pid}    Set Variable    ${0}
    \   Connect Device By UAgent Use Pid    hbpod plp1    ${ip_address}    ${pid}
    \   File Download      ${FtpServerarmIp}:\/\/D:\/soc\/\/libtest_arm.so     \/ramDisk\/libtest_arm.so
    \   Execute Command by UAgent    loadModule    '/ramDisk/libtest_arm.so'    ''
    \   Sleep    1
    \   ${execute_result}=    Execute Command by UAgent    memcpy_test2    ''
    \   Sleep    1
    \   Log    ${execute_result}'s board log upload is complete!
    \   Should be equal    ${execute_result}    ${0}
    \   Execute Command by UAgent    unloadModule    '/ramDisk/libtest_arm.so'    ''
    \   Execute Command by UAgent    cmd    'rm /ramDisk/libtest_arm.so -rf'    ''
    \   Disconnect UAgent Use Pid

#***********************************************************************************
#功能     ：hbpod plp2 memcpy test                                                 *
#标签     ：BSP                                                                    *
#索引     ：无                                                                     *
#入参     ：无                                                                     *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：2S                                                                     *
#所属模块 ：BSP                                                                    *
#适用用例 ：                                                                       *
#负责人   ：xinjin                                                                 *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：确保.so文件为最新，文件可下载至板卡                                    *
#                                                                                  *
#***********************************************************************************
hbpod plp2 memcpy test
    [Documentation]    基带 plp2 内存读写测试
    [Tags]    BSP
    [Arguments]
    [Teardown]    Log    hbpod plp2 memcpy test finish!


    ${boardEntry}    Get Oid By Name    ${Mib}    boardRowStatus
    Log    ${boardEntry}
    @{som_slotNo_list}    Get board of aom or som    ${som}    ${boardEntry}    ${16}
    :FOR    ${loop_slotNo}    in    @{som_slotNo_list}
    \   ${hbpod_slot}    Evaluate    int(${loop_slotNo})
    \   ${ip_address}    Catenate    SEPARATOR=.    ${hbpod_address_base}    ${hbpod_slot + 21}
    \   Log    ${loop_slotNo}'s board log upload is complete!
    \   ${pid}    Set Variable    ${0}
    \   Connect Device By UAgent Use Pid    hbpod plp 2    ${ip_address}    ${pid}
    \   File Download      ${FtpServerarmIp}:\/\/D:\/soc\/\/libtest_arm.so     \/ramDisk\/libtest_arm.so
    \   Execute Command by UAgent    loadModule    '/ramDisk/libtest_arm.so'    ''
    \   Sleep    1
    \   ${execute_result}=    Execute Command by UAgent    memcpy_test2    ''
    \   Sleep    1
    \   Log    ${execute_result}'s board log upload is complete!
    \   Should be equal    ${execute_result}    ${0}
    \   Execute Command by UAgent    unloadModule    '/ramDisk/libtest_arm.so'    ''
    \   Execute Command by UAgent    cmd    'rm /ramDisk/libtest_arm.so -rf'    ''
    \   Disconnect UAgent Use Pid

#***********************************************************************************
#功能     ：hsctd memory test                                                      *
#标签     ：BSP                                                                    *
#索引     ：无                                                                     *
#入参     ：无                                                                     *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：2S                                                                     *
#所属模块 ：BSP                                                                    *
#适用用例 ：                                                                       *
#负责人   ：xinjin                                                                 *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：确保.so文件为最新，文件可下载至板卡                                    *
#                                                                                  *
#***********************************************************************************
hsctd memory test
    [Documentation]    主控x86 内存读写测试
    [Tags]    BSP
    [Arguments]
    [Teardown]    Log    hsctd memory test finish!

    ${boardEntry}    Get Oid By Name    ${Mib}    boardRowStatus
    Log    ${boardEntry}
    @{hsctd_slots}    Get board of aom or som    aom    ${boardEntry}    ${16}
    ${slot1}    Evaluate    int(@{hsctd_slots}[0])
    Set Suite Variable    ${hsctd_slot}    ${slot1}
    ${ip_address}    Catenate    SEPARATOR=.    ${hsctd_address_base}    ${hsctd_slot + 91}
    ${pid}    Set Variable    ${2}
    Connect Device By UAgent Use Pid    hsctd scp 2    ${ip_address}    ${pid}
    File Download      ${FtpServerx86Ip}:\/\/D:\/soc\/\/libtest.so     \/ramDisk\/libtest.so
    Execute Command by UAgent    loadModule    '/ramDisk/libtest.so'    ''
    Sleep    1
    ${cache_result}=    Execute Command by UAgent    cache_memory_test    ''
    Should be equal    ${cache_result}    ${0}
    Sleep    1
    ${nocache_result}=    Execute Command by UAgent    nocache_memory_test    ''
    Should be equal    ${nocache_result}    ${0}
    Sleep    1
    Execute Command by UAgent    unloadModule    '/ramDisk/libtest.so'    ''
    Execute Command by UAgent    cmd    'rm /ramDisk/libtest.so -rf'    ''
    Disconnect UAgent Use Pid

#***********************************************************************************
#功能     ：hbpod x86 memory test                                                  *
#标签     ：BSP                                                                    *
#索引     ：无                                                                     *
#入参     ：无                                                                     *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：2S                                                                     *
#所属模块 ：BSP                                                                    *
#适用用例 ：                                                                       *
#负责人   ：xinjin                                                                 *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ： 确保.so文件为最新，文件可下载至板卡                                   *
#                                                                                  *
#***********************************************************************************
hbpod x86 memory test
    [Documentation]    基带 x86 内存读写测试
    [Tags]    BSP
    [Arguments]
    [Teardown]    Log    hbpod x86 memory test finish!

    ${boardEntry}    Get Oid By Name    ${Mib}    boardRowStatus
    Log    ${boardEntry}
    @{som_slotNo_list}    Get board of aom or som    ${som}    ${boardEntry}    ${16}
    :FOR    ${loop_slotNo}    in    @{som_slotNo_list}
    \   ${hbpod_slot}    Evaluate    int(${loop_slotNo})
    \   ${ip_address}    Catenate    SEPARATOR=.    ${hbpod_address_base}    ${hbpod_slot + 1}
    \   Log    ${loop_slotNo}'s board log upload is complete!
    \   ${pid}    Set Variable    ${2}
    \   Connect Device By UAgent Use Pid    hbpod scp 2    ${ip_address}    ${pid}
    \   File Download      ${FtpServerx86Ip}:\/\/D:\/soc\/\/libtest.so     \/ramDisk\/libtest.so
    \   Execute Command by UAgent    loadModule    '/ramDisk/libtest.so'    ''
    \   Sleep    1
    \   ${cache_result}=    Execute Command by UAgent    cache_memory_test    ''
    \   Should be equal    ${cache_result}    ${0}
    \   Sleep    1
    \   ${nocache_result}=    Execute Command by UAgent    nocache_memory_test    ''
    \   Should be equal    ${nocache_result}    ${0}
    \   Sleep    1
    \   Execute Command by UAgent    unloadModule    '/ramDisk/libtest.so'    ''
    \   Execute Command by UAgent    cmd    'rm /ramDisk/libtest.so -rf'    ''
    \   Disconnect UAgent Use Pid

#***********************************************************************************
#功能     ：hbpod plp1 memory test                                                 *
#标签     ：BSP                                                                    *
#索引     ：无                                                                     *
#入参     ：无                                                                     *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：2S                                                                     *
#所属模块 ：BSP                                                                    *
#适用用例 ：                                                                       *
#负责人   ：xinjin                                                                 *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：确保.so文件为最新，文件可下载至板卡                                    *
#                                                                                  *
#***********************************************************************************
hbpod plp1 memory test
    [Documentation]    基带 plp1 内存读写测试
    [Tags]    BSP
    [Arguments]
    [Teardown]    Log    hbpod plp1 memory test finish!

    ${boardEntry}    Get Oid By Name    ${Mib}    boardRowStatus
    Log    ${boardEntry}
    @{som_slotNo_list}    Get board of aom or som    ${som}    ${boardEntry}    ${16}
    :FOR    ${loop_slotNo}    in    @{som_slotNo_list}
    \   ${hbpod_slot}    Evaluate    int(${loop_slotNo})
    \   ${ip_address}    Catenate    SEPARATOR=.    ${hbpod_address_base}    ${hbpod_slot + 11}
    \   Log    ${loop_slotNo}'s board log upload is complete!
    \   ${pid}    Set Variable    ${0}
    \   Connect Device By UAgent Use Pid    hbpod plp1    ${ip_address}    ${pid}
    \   File Download      ${FtpServerarmIp}:\/\/D:\/soc\/\/libtest_arm.so     \/ramDisk\/libtest_arm.so
    \   Execute Command by UAgent    loadModule    '/ramDisk/libtest_arm.so'    ''
    \   Sleep    1
    \   ${cache_result}=    Execute Command by UAgent    cache_memory_test    ''
    \   Should be equal    ${cache_result}    ${0}
    \   Sleep    1
    \   ${nocache_result}=    Execute Command by UAgent    nocache_memory_test    ''
    \   Should be equal    ${nocache_result}    ${0}
    \   Sleep    1
    \   Execute Command by UAgent    unloadModule    '/ramDisk/libtest_arm.so'    ''
    \   Execute Command by UAgent    cmd    'rm /ramDisk/libtest_arm.so -rf'    ''
    \   Disconnect UAgent Use Pid

#***********************************************************************************
#功能     ：hbpod plp2 memory test                                                 *
#标签     ：BSP                                                                    *
#索引     ：无                                                                     *
#入参     ：无                                                                     *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：2S                                                                     *
#所属模块 ：BSP                                                                    *
#适用用例 ：                                                                       *
#负责人   ：xinjin                                                                 *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：确保.so文件为最新，文件可下载至板卡                                    *
#                                                                                  *
#***********************************************************************************
hbpod plp2 memory test
    [Documentation]    基带 plp2 内存读写测试
    [Tags]    BSP
    [Arguments]
    [Teardown]    Log    hbpod plp2 memory test finish!


    ${boardEntry}    Get Oid By Name    ${Mib}    boardRowStatus
    Log    ${boardEntry}
    @{som_slotNo_list}    Get board of aom or som    ${som}    ${boardEntry}    ${16}
    :FOR    ${loop_slotNo}    in    @{som_slotNo_list}
    \   ${hbpod_slot}    Evaluate    int(${loop_slotNo})
    \   ${ip_address}    Catenate    SEPARATOR=.    ${hbpod_address_base}    ${hbpod_slot + 21}
    \   Log    ${loop_slotNo}'s board log upload is complete!
    \   ${pid}    Set Variable    ${0}
    \   Connect Device By UAgent Use Pid    hbpod plp 2    ${ip_address}    ${pid}
    \   File Download      ${FtpServerarmIp}:\/\/D:\/soc\/\/libtest_arm.so     \/ramDisk\/libtest_arm.so
    \   Execute Command by UAgent    loadModule    '/ramDisk/libtest_arm.so'    ''
    \   Sleep    1
    \   ${cache_result}=    Execute Command by UAgent    cache_memory_test    ''
    \   Should be equal    ${cache_result}    ${0}
    \   Sleep    1
    \   ${nocache_result}=    Execute Command by UAgent    nocache_memory_test    ''
    \   Should be equal    ${nocache_result}    ${0}
    \   Sleep    1
    \   Execute Command by UAgent    unloadModule    '/ramDisk/libtest_arm.so'    ''
    \   Execute Command by UAgent    cmd    'rm /ramDisk/libtest_arm.so -rf'    ''
    \   Disconnect UAgent Use Pid

#***********************************************************************************
#功能     ：hsctd memset test                                                      *
#标签     ：BSP                                                                    *
#索引     ：无                                                                     *
#入参     ：无                                                                     *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：2S                                                                     *
#所属模块 ：BSP                                                                    *
#适用用例 ：                                                                       *
#负责人   ：xinjin                                                                 *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：确保.so文件为最新，文件可下载至板卡                                    *
#                                                                                  *
#***********************************************************************************
hsctd memset test
    [Documentation]    主控x86 内存memset测试
    [Tags]    BSP
    [Arguments]
    [Teardown]    Log    hsctd memset test finish!

    ${boardEntry}    Get Oid By Name    ${Mib}    boardRowStatus
    Log    ${boardEntry}
    @{hsctd_slots}    Get board of aom or som    aom    ${boardEntry}    ${16}
    ${slot1}    Evaluate    int(@{hsctd_slots}[0])
    Set Suite Variable    ${hsctd_slot}    ${slot1}
    ${ip_address}    Catenate    SEPARATOR=.    ${hsctd_address_base}    ${hsctd_slot + 91}
    ${pid}    Set Variable    ${2}
    Connect Device By UAgent Use Pid    hsctd scp 2    ${ip_address}    ${pid}
    File Download      ${FtpServerx86Ip}:\/\/D:\/soc\/\/libtest.so     \/ramDisk\/libtest.so
    Execute Command by UAgent    loadModule    '/ramDisk/libtest.so'    ''
    Sleep    1
    ${execute_result}=    Execute Command by UAgent    memset_test    ''
    Sleep    2
    Should be equal    ${execute_result}    ${0}
    Execute Command by UAgent    unloadModule    '/ramDisk/libtest.so'    ''
    Execute Command by UAgent    cmd    'rm /ramDisk/libtest.so -rf'    ''
    Disconnect UAgent Use Pid

#***********************************************************************************
#功能     ：hbpod x86 memset test                                                  *
#标签     ：BSP                                                                    *
#索引     ：无                                                                     *
#入参     ：无                                                                     *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：2S                                                                     *
#所属模块 ：BSP                                                                    *
#适用用例 ：                                                                       *
#负责人   ：xinjin                                                                 *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ： 确保.so文件为最新，文件可下载至板卡                                   *
#                                                                                  *
#***********************************************************************************
hbpod x86 memset test
    [Documentation]    基带 x86 内存memset测试
    [Tags]    BSP
    [Arguments]
    [Teardown]    Log    hbpod x86 memset test finish!

    ${boardEntry}    Get Oid By Name    ${Mib}    boardRowStatus
    Log    ${boardEntry}
    @{som_slotNo_list}    Get board of aom or som    ${som}    ${boardEntry}    ${16}
    :FOR    ${loop_slotNo}    in    @{som_slotNo_list}
    \   ${hbpod_slot}    Evaluate    int(${loop_slotNo})
    \   ${ip_address}    Catenate    SEPARATOR=.    ${hbpod_address_base}    ${hbpod_slot + 1}
    \   Log    ${loop_slotNo}'s board log upload is complete!
    \   ${pid}    Set Variable    ${2}
    \   Connect Device By UAgent Use Pid    hbpod scp 2    ${ip_address}    ${pid}
    \   File Download      ${FtpServerx86Ip}:\/\/D:\/soc\/\/libtest.so     \/ramDisk\/libtest.so
    \   Execute Command by UAgent    loadModule    '/ramDisk/libtest.so'    ''
    \   Sleep    1
    \   ${execute_result}=    Execute Command by UAgent    memset_test    ''
    \   Sleep    2
    \   Log    ${execute_result}'s board log upload is complete!
    \   Should be equal    ${execute_result}    ${0}
    \   Execute Command by UAgent    unloadModule    '/ramDisk/libtest.so'    ''
    \   Execute Command by UAgent    cmd    'rm /ramDisk/libtest.so -rf'    ''
    \   Disconnect UAgent Use Pid

#***********************************************************************************
#功能     ：hbpod plp1 memset test                                                 *
#标签     ：BSP                                                                    *
#索引     ：无                                                                     *
#入参     ：无                                                                     *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：2S                                                                     *
#所属模块 ：BSP                                                                    *
#适用用例 ：                                                                       *
#负责人   ：xinjin                                                                 *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：确保.so文件为最新，文件可下载至板卡                                    *
#                                                                                  *
#***********************************************************************************
hbpod plp1 memset test
    [Documentation]    基带 plp1 内存memset测试
    [Tags]    BSP
    [Arguments]
    [Teardown]    Log    hbpod plp1 memset test finish!

    ${boardEntry}    Get Oid By Name    ${Mib}    boardRowStatus
    Log    ${boardEntry}
    @{som_slotNo_list}    Get board of aom or som    ${som}    ${boardEntry}    ${16}
    :FOR    ${loop_slotNo}    in    @{som_slotNo_list}
    \   ${hbpod_slot}    Evaluate    int(${loop_slotNo})
    \   ${ip_address}    Catenate    SEPARATOR=.    ${hbpod_address_base}    ${hbpod_slot + 11}
    \   Log    ${loop_slotNo}'s board log upload is complete!
    \   ${pid}    Set Variable    ${0}
    \   Connect Device By UAgent Use Pid    hbpod plp1    ${ip_address}    ${pid}
    \   File Download      ${FtpServerarmIp}:\/\/D:\/soc\/\/libtest_arm.so     \/ramDisk\/libtest_arm.so
    \   Execute Command by UAgent    loadModule    '/ramDisk/libtest_arm.so'    ''
    \   Sleep    1
    \   ${execute_result}=    Execute Command by UAgent    memset_test    ''
    \   Sleep    1
    \   Log    ${execute_result}'s board log upload is complete!
    \   Should be equal    ${execute_result}    ${0}
    \   Execute Command by UAgent    unloadModule    '/ramDisk/libtest_arm.so'    ''
    \   Execute Command by UAgent    cmd    'rm /ramDisk/libtest_arm.so -rf'    ''
    \   Disconnect UAgent Use Pid

#***********************************************************************************
#功能     ：hbpod plp2 memset test                                                 *
#标签     ：BSP                                                                    *
#索引     ：无                                                                     *
#入参     ：无                                                                     *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：2S                                                                     *
#所属模块 ：BSP                                                                    *
#适用用例 ：                                                                       *
#负责人   ：xinjin                                                                 *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：确保.so文件为最新，文件可下载至板卡                                    *
#                                                                                  *
#***********************************************************************************
hbpod plp2 memset test
    [Documentation]    基带 plp2 内存memset测试
    [Tags]    BSP
    [Arguments]
    [Teardown]    Log    hbpod plp2 memset test finish!


    ${boardEntry}    Get Oid By Name    ${Mib}    boardRowStatus
    Log    ${boardEntry}
    @{som_slotNo_list}    Get board of aom or som    ${som}    ${boardEntry}    ${16}
    :FOR    ${loop_slotNo}    in    @{som_slotNo_list}
    \   ${hbpod_slot}    Evaluate    int(${loop_slotNo})
    \   ${ip_address}    Catenate    SEPARATOR=.    ${hbpod_address_base}    ${hbpod_slot + 21}
    \   Log    ${loop_slotNo}'s board log upload is complete!
    \   ${pid}    Set Variable    ${0}
    \   Connect Device By UAgent Use Pid    hbpod plp 2    ${ip_address}    ${pid}
    \   File Download      ${FtpServerarmIp}:\/\/D:\/soc\/\/libtest_arm.so     \/ramDisk\/libtest_arm.so
    \   Execute Command by UAgent    loadModule    '/ramDisk/libtest_arm.so'    ''
    \   Sleep    1
    \   ${execute_result}=    Execute Command by UAgent    memset_test    ''
    \   Sleep    1
    \   Log    ${execute_result}'s board log upload is complete!
    \   Should be equal    ${execute_result}    ${0}
    \   Execute Command by UAgent    unloadModule    '/ramDisk/libtest_arm.so'    ''
    \   Execute Command by UAgent    cmd    'rm /ramDisk/libtest_arm.so -rf'    ''
    \   Disconnect UAgent Use Pid

#***********************************************************************************
#功能     ：hsctd mq perf test                                                     *
#标签     ：BSP                                                                    *
#索引     ：无                                                                     *
#入参     ：无                                                                     *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：2S                                                                     *
#所属模块 ：BSP                                                                    *
#适用用例 ：                                                                       *
#负责人   ：xinjin                                                                 *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：确保.so文件为最新，文件可下载至板卡                                    *
#                                                                                  *
#***********************************************************************************
hsctd mq perf test
    [Documentation]    主控x86 mq_perf测试
    [Tags]    BSP
    [Arguments]
    [Teardown]    Log    hsctd mq perf test finish!

    ${boardEntry}    Get Oid By Name    ${Mib}    boardRowStatus
    Log    ${boardEntry}
    @{hsctd_slots}    Get board of aom or som    aom    ${boardEntry}    ${16}
    ${slot1}    Evaluate    int(@{hsctd_slots}[0])
    Set Suite Variable    ${hsctd_slot}    ${slot1}
    ${ip_address}    Catenate    SEPARATOR=.    ${hsctd_address_base}    ${hsctd_slot + 91}
    ${pid}    Set Variable    ${2}
    Connect Device By UAgent Use Pid    hsctd scp 2    ${ip_address}    ${pid}
    File Download      ${FtpServerx86Ip}:\/\/D:\/soc\/\/libtest.so     \/ramDisk\/libtest.so
    Execute Command by UAgent    loadModule    '/ramDisk/libtest.so'    ''
    Sleep    1
    ${execute_result}=    Execute Command by UAgent    mq_perf_test    ${0}    ${80}    ${0}    ${80}    ${100}    ''
    Should be equal    ${execute_result}    ${0}
    Sleep    1
    ${execute_result}=    Execute Command by UAgent    mq_perf_test    ${0}    ${80}    ${2}    ${80}    ${100}    ''
    Should be equal    ${execute_result}    ${0}
    Sleep    1
    ${execute_result}=    Execute Command by UAgent    mq_perf_test    ${2}    ${80}    ${2}    ${80}    ${100}    ''
    Should be equal    ${execute_result}    ${0}
    Sleep    1
    ${execute_result}=    Execute Command by UAgent    mq_perf_test    ${2}    ${80}    ${4}    ${80}    ${100}    ''
    Should be equal    ${execute_result}    ${0}
    Sleep    1
    ${execute_result}=    Execute Command by UAgent    mq_perf_test    ${4}    ${80}    ${4}    ${80}    ${100}    ''
    Should be equal    ${execute_result}    ${0}
    Sleep    1
    Execute Command by UAgent    unloadModule    '/ramDisk/libtest.so'    ''
    Execute Command by UAgent    cmd    'rm /ramDisk/libtest.so -rf'    ''
    Disconnect UAgent Use Pid

#***********************************************************************************
#功能     ：hbpod x86 mq perf test                                                 *
#标签     ：BSP                                                                    *
#索引     ：无                                                                     *
#入参     ：无                                                                     *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：2S                                                                     *
#所属模块 ：BSP                                                                    *
#适用用例 ：                                                                       *
#负责人   ：xinjin                                                                 *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ： 确保.so文件为最新，文件可下载至板卡                                   *
#                                                                                  *
#***********************************************************************************
hbpod x86 mq perf test
    [Documentation]    基带 x86 mq_perf测试
    [Tags]    BSP
    [Arguments]
    [Teardown]    Log    hbpod x86 mq perf test finish!

    ${boardEntry}    Get Oid By Name    ${Mib}    boardRowStatus
    Log    ${boardEntry}
    @{som_slotNo_list}    Get board of aom or som    ${som}    ${boardEntry}    ${16}
    :FOR    ${loop_slotNo}    in    @{som_slotNo_list}
    \   ${hbpod_slot}    Evaluate    int(${loop_slotNo})
    \   ${ip_address}    Catenate    SEPARATOR=.    ${hbpod_address_base}    ${hbpod_slot + 1}
    \   Log    ${loop_slotNo}'s board log upload is complete!
    \   ${pid}    Set Variable    ${2}
    \   Connect Device By UAgent Use Pid    hbpod scp 2    ${ip_address}    ${pid}
    \   File Download      ${FtpServerx86Ip}:\/\/D:\/soc\/\/libtest.so     \/ramDisk\/libtest.so
    \   Execute Command by UAgent    loadModule    '/ramDisk/libtest.so'    ''
    \   Sleep    1
    \   ${execute_result}=    Execute Command by UAgent    mq_perf_test    ${0}    ${80}    ${0}    ${80}    ${100}    ''
    \   Should be equal    ${execute_result}    ${0}
    \   Sleep    1
    \   ${execute_result}=    Execute Command by UAgent    mq_perf_test    ${0}    ${80}    ${2}    ${80}    ${100}    ''
    \   Should be equal    ${execute_result}    ${0}
    \   Sleep    1
    \   ${execute_result}=    Execute Command by UAgent    mq_perf_test    ${2}    ${80}    ${2}    ${80}    ${100}    ''
    \   Should be equal    ${execute_result}    ${0}
    \   Sleep    1
    \   ${execute_result}=    Execute Command by UAgent    mq_perf_test    ${2}    ${80}    ${4}    ${80}    ${100}    ''
    \   Should be equal    ${execute_result}    ${0}
    \   Sleep    1
    \   ${execute_result}=    Execute Command by UAgent    mq_perf_test    ${4}    ${80}    ${4}    ${80}    ${100}    ''
    \   Should be equal    ${execute_result}    ${0}
    \   Sleep    1
    \   Execute Command by UAgent    unloadModule    '/ramDisk/libtest.so'    ''
    \   Execute Command by UAgent    cmd    'rm /ramDisk/libtest.so -rf'    ''
    \   Disconnect UAgent Use Pid

#***********************************************************************************
#功能     ：hbpod plp1 mq perf test                                                *
#标签     ：BSP                                                                    *
#索引     ：无                                                                     *
#入参     ：无                                                                     *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：2S                                                                     *
#所属模块 ：BSP                                                                    *
#适用用例 ：                                                                       *
#负责人   ：xinjin                                                                 *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：确保.so文件为最新，文件可下载至板卡                                    *
#                                                                                  *
#***********************************************************************************
hbpod plp1 mq perf test
    [Documentation]    基带 plp1 mq_perf测试
    [Tags]    BSP
    [Arguments]
    [Teardown]    Log    hbpod plp1 mq perf test finish!

    ${boardEntry}    Get Oid By Name    ${Mib}    boardRowStatus
    Log    ${boardEntry}
    @{som_slotNo_list}    Get board of aom or som    ${som}    ${boardEntry}    ${16}
    :FOR    ${loop_slotNo}    in    @{som_slotNo_list}
    \   ${hbpod_slot}    Evaluate    int(${loop_slotNo})
    \   ${ip_address}    Catenate    SEPARATOR=.    ${hbpod_address_base}    ${hbpod_slot + 11}
    \   Log    ${loop_slotNo}'s board log upload is complete!
    \   ${pid}    Set Variable    ${0}
    \   Connect Device By UAgent Use Pid    hbpod plp1    ${ip_address}    ${pid}
    \   File Download      ${FtpServerarmIp}:\/\/D:\/soc\/\/libtest_arm.so     \/ramDisk\/libtest_arm.so
    \   Execute Command by UAgent    loadModule    '/ramDisk/libtest_arm.so'    ''
    \   Sleep    1
    \   ${execute_result}=    Execute Command by UAgent    mq_perf_test    ${0}    ${80}    ${0}    ${80}    ${100}    ''
    \   Should be equal    ${execute_result}    ${0}
    \   Sleep    1
    \   ${execute_result}=    Execute Command by UAgent    mq_perf_test    ${0}    ${80}    ${2}    ${80}    ${100}    ''
    \   Should be equal    ${execute_result}    ${0}
    \   Sleep    1
    \   ${execute_result}=    Execute Command by UAgent    mq_perf_test    ${2}    ${80}    ${2}    ${80}    ${100}    ''
    \   Should be equal    ${execute_result}    ${0}
    \   Sleep    1
    \   ${execute_result}=    Execute Command by UAgent    mq_perf_test    ${2}    ${80}    ${4}    ${80}    ${100}    ''
    \   Should be equal    ${execute_result}    ${0}
    \   Sleep    1
    \   ${execute_result}=    Execute Command by UAgent    mq_perf_test    ${4}    ${80}    ${4}    ${80}    ${100}    ''
    \   Should be equal    ${execute_result}    ${0}
    \   Sleep    1
    \   Execute Command by UAgent    unloadModule    '/ramDisk/libtest_arm.so'    ''
    \   Execute Command by UAgent    cmd    'rm /ramDisk/libtest_arm.so -rf'    ''
    \   Disconnect UAgent Use Pid

#***********************************************************************************
#功能     ：hbpod plp2 mq perf test                                                *
#标签     ：BSP                                                                    *
#索引     ：无                                                                     *
#入参     ：无                                                                     *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：2S                                                                     *
#所属模块 ：BSP                                                                    *
#适用用例 ：                                                                       *
#负责人   ：xinjin                                                                 *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：确保.so文件为最新，文件可下载至板卡                                    *
#                                                                                  *
#***********************************************************************************
hbpod plp2 mq perf test
    [Documentation]    基带 plp2 mq_perf测试
    [Tags]    BSP
    [Arguments]
    [Teardown]    Log    hbpod plp2 mq perf test finish!


    ${boardEntry}    Get Oid By Name    ${Mib}    boardRowStatus
    Log    ${boardEntry}
    @{som_slotNo_list}    Get board of aom or som    ${som}    ${boardEntry}    ${16}
    :FOR    ${loop_slotNo}    in    @{som_slotNo_list}
    \   ${hbpod_slot}    Evaluate    int(${loop_slotNo})
    \   ${ip_address}    Catenate    SEPARATOR=.    ${hbpod_address_base}    ${hbpod_slot + 21}
    \   Log    ${loop_slotNo}'s board log upload is complete!
    \   ${pid}    Set Variable    ${0}
    \   Connect Device By UAgent Use Pid    hbpod plp 2    ${ip_address}    ${pid}
    \   File Download      ${FtpServerarmIp}:\/\/D:\/soc\/\/libtest_arm.so     \/ramDisk\/libtest_arm.so
    \   Execute Command by UAgent    loadModule    '/ramDisk/libtest_arm.so'    ''
    \   Sleep    1
    \   ${execute_result}=    Execute Command by UAgent    mq_perf_test    ${0}    ${80}    ${0}    ${80}    ${100}    ''
    \   Should be equal    ${execute_result}    ${0}
    \   Sleep    1
    \   ${execute_result}=    Execute Command by UAgent    mq_perf_test    ${0}    ${80}    ${2}    ${80}    ${100}    ''
    \   Should be equal    ${execute_result}    ${0}
    \   Sleep    1
    \   ${execute_result}=    Execute Command by UAgent    mq_perf_test    ${2}    ${80}    ${2}    ${80}    ${100}    ''
    \   Should be equal    ${execute_result}    ${0}
    \   Sleep    1
    \   ${execute_result}=    Execute Command by UAgent    mq_perf_test    ${2}    ${80}    ${4}    ${80}    ${100}    ''
    \   Should be equal    ${execute_result}    ${0}
    \   Sleep    1
    \   ${execute_result}=    Execute Command by UAgent    mq_perf_test    ${4}    ${80}    ${4}    ${80}    ${100}    ''
    \   Should be equal    ${execute_result}    ${0}
    \   Sleep    1
    \   Execute Command by UAgent    unloadModule    '/ramDisk/libtest_arm.so'    ''
    \   Execute Command by UAgent    cmd    'rm /ramDisk/libtest_arm.so -rf'    ''
    \   Disconnect UAgent Use Pid

#***********************************************************************************
#功能     ：mountnfs test                                                          *
#标签     ：nfstest                                                                *
#索引     ：无                                                                     *
#入参     ：板卡槽位号；循环次数；nfs挂载函数参数                                  *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：2S                                                                     *
#所属模块 ：BSP_use                                                                *
#适用用例 ：                                                                       *
#负责人   ：xinjin                                                                 *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：确保.so文件为最新，文件可下载至板卡                                    *
#                                                                                  *
#***********************************************************************************
mountnfs test
    [Documentation]    mountnfs test所调用测试函数
    [Tags]    nfstest
    [Arguments]    ${slot}    ${rangeno}    ${data}
    [Teardown]    Log    mountnfs test finish!

    :FOR    ${loop}    IN RANGE    ${rangeno}
    \   ${mkdir}=    Execute Command by UAgent    cmd    'mkdir /test -p'    ''
    \   log    ${mkdir}
    \   Sleep    1
    \   ${mountnfs_result}=    Execute Command by UAgent    mountnfs    '10.0.${slot}.192:/ramDisk'    '/test'    'nfs'    ${0}    ${data}    ''
    \   Log    ${mountnfs_result}
    \   Should be equal    ${mountnfs_result}    ${0}
    \   Sleep    2
    \   ${umount}=    Execute Command by UAgent    umount    '/test'    ''
    \   log    ${umount}
    \   Should be equal    ${umount}    ${0}
    \   Sleep    1
    \   ${rm}=    Execute Command by UAgent    cmd    'rm /test -r'    ''
    \   log    ${rm}
    \   Sleep    1

#***********************************************************************************
#功能     ：hsctd mountnfs test                                                    *
#标签     ：BSP                                                                    *
#索引     ：无                                                                     *
#入参     ：循环次数；nfs挂载参数                                                  *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：2S                                                                     *
#所属模块 ：BSP                                                                    *
#适用用例 ：                                                                       *
#负责人   ：xinjin                                                                 *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
hsctd mountnfs test
    [Documentation]    主控x86 mountnfs测试
    [Tags]    BSP
    [Arguments]    ${rangeno}    ${data}
    [Teardown]    Log    hsctd mountnfs test finish!

    ${boardEntry}    Get Oid By Name    ${Mib}    boardRowStatus
    Log    ${boardEntry}
    @{hsctd_slots}    Get board of aom or som    aom    ${boardEntry}    ${16}
    ${slot1}    Evaluate    int(@{hsctd_slots}[0])
    Set Suite Variable    ${hsctd_slot}    ${slot1}
    ${ip_address}    Catenate    SEPARATOR=.    ${hsctd_address_base}    ${hsctd_slot + 91}
    ${pid}    Set Variable    ${2}
    Connect Device By UAgent Use Pid    hsctd scp 2    ${ip_address}    ${pid}
    mountnfs test    ${hsctd_slot}      ${rangeno}    ${data}
    Disconnect UAgent Use Pid

#***********************************************************************************
#功能     ：hbpod x86 mountnfs test                                                *
#标签     ：BSP                                                                    *
#索引     ：无                                                                     *
#入参     ：循环次数；nfs挂载参数                                                  *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：2S                                                                     *
#所属模块 ：BSP                                                                    *
#适用用例 ：                                                                       *
#负责人   ：xinjin                                                                 *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
hbpod x86 mountnfs test
    [Documentation]    基带 x86 mountnfs测试
    [Tags]    BSP
    [Arguments]    ${rangeno}    ${data}
    [Teardown]    Log    hbpod x86 mountnfs test finish!

    ${boardEntry}    Get Oid By Name    ${Mib}    boardRowStatus
    Log    ${boardEntry}
    @{som_slotNo_list}    Get board of aom or som    ${som}    ${boardEntry}    ${16}
    :FOR    ${loop_slotNo}    in    @{som_slotNo_list}
    \   ${hbpod_slot}    Evaluate    int(${loop_slotNo})
    \   ${ip_address}    Catenate    SEPARATOR=.    ${hbpod_address_base}    ${hbpod_slot + 1}
    \   Log    ${loop_slotNo}'s board log upload is complete!
    \   ${pid}    Set Variable    ${2}
    \   Connect Device By UAgent Use Pid    hbpod scp 2    ${ip_address}    ${pid}
    \   mountnfs test    ${hbpod_slot}      ${rangeno}    ${data}
    \   Disconnect UAgent Use Pid

#***********************************************************************************
#功能     ：hbpod plp1 mountnfs test                                               *
#标签     ：BSP                                                                    *
#索引     ：无                                                                     *
#入参     ：循环次数；nfs挂载参数                                                  *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：2S                                                                     *
#所属模块 ：BSP                                                                    *
#适用用例 ：                                                                       *
#负责人   ：xinjin                                                                 *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
hbpod plp1 mountnfs test
    [Documentation]    基带 plp1 mountnfs测试
    [Tags]    BSP
    [Arguments]    ${rangeno}    ${data}
    [Teardown]    Log    hbpod plp1 mountnfs test finish!

    ${boardEntry}    Get Oid By Name    ${Mib}    boardRowStatus
    Log    ${boardEntry}
    @{som_slotNo_list}    Get board of aom or som    ${som}    ${boardEntry}    ${16}
    :FOR    ${loop_slotNo}    in    @{som_slotNo_list}
    \   ${hbpod_slot}    Evaluate    int(${loop_slotNo})
    \   ${ip_address}    Catenate    SEPARATOR=.    ${hbpod_address_base}    ${hbpod_slot + 11}
    \   Log    ${loop_slotNo}'s board log upload is complete!
    \   ${pid}    Set Variable    ${0}
    \   Connect Device By UAgent Use Pid    hbpod plp1    ${ip_address}    ${pid}
    \   mountnfs test    ${hbpod_slot}      ${rangeno}    ${data}
    \   Disconnect UAgent Use Pid

#***********************************************************************************
#功能     ：hbpod plp2 mountnfs test                                               *
#标签     ：BSP                                                                    *
#索引     ：无                                                                     *
#入参     ：循环次数；nfs挂载参数                                                  *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：2S                                                                     *
#所属模块 ：BSP                                                                    *
#适用用例 ：                                                                       *
#负责人   ：xinjin                                                                 *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
hbpod plp2 mountnfs test
    [Documentation]    基带 plp2 mountnfs测试
    [Tags]    BSP
    [Arguments]    ${rangeno}    ${data}
    [Teardown]    Log    hbpod plp2 mountnfs test finish!


    ${boardEntry}    Get Oid By Name    ${Mib}    boardRowStatus
    Log    ${boardEntry}
    @{som_slotNo_list}    Get board of aom or som    ${som}    ${boardEntry}    ${16}
    :FOR    ${loop_slotNo}    in    @{som_slotNo_list}
    \   ${hbpod_slot}    Evaluate    int(${loop_slotNo})
    \   ${ip_address}    Catenate    SEPARATOR=.    ${hbpod_address_base}    ${hbpod_slot + 21}
    \   Log    ${loop_slotNo}'s board log upload is complete!
    \   ${pid}    Set Variable    ${0}
    \   Connect Device By UAgent Use Pid    hbpod plp 2    ${ip_address}    ${pid}
    \   mountnfs test    ${hbpod_slot}      ${rangeno}    ${data}
    \   Disconnect UAgent Use Pid

#***********************************************************************************
#功能     ：hsctd tpf test                                                         *
#标签     ：BSP                                                                    *
#索引     ：无                                                                     *
#入参     ：无                                                                     *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：2S                                                                     *
#所属模块 ：BSP                                                                    *
#适用用例 ：                                                                       *
#负责人   ：xinjin                                                                 *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
hsctd tpf test
    [Documentation]    主控x86 tpf测试
    [Tags]    BSP
    [Arguments]
    [Teardown]    Log    hsctd tpf test finish!

    ${boardEntry}    Get Oid By Name    ${Mib}    boardRowStatus
    Log    ${boardEntry}
    @{hsctd_slots}    Get board of aom or som    aom    ${boardEntry}    ${16}
    ${slot1}    Evaluate    int(@{hsctd_slots}[0])
    Set Suite Variable    ${hsctd_slot}    ${slot1}
    ${ip_address}    Catenate    SEPARATOR=.    ${hsctd_address_base}    ${hsctd_slot + 91}
    ${pid}    Set Variable    ${2}
    Connect Device By UAgent Use Pid    hsctd scp 2    ${ip_address}    ${pid}
    ${execute_result}=    Execute Command by UAgent    i    ''
    Log    ${execute_result}
    Should be equal    ${execute_result}    ${0}
    Sleep    1
    Disconnect UAgent Use Pid

#***********************************************************************************
#功能     ：hbpod x86 tpf test                                                     *
#标签     ：BSP                                                                    *
#索引     ：无                                                                     *
#入参     ：无                                                                     *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：2S                                                                     *
#所属模块 ：BSP                                                                    *
#适用用例 ：                                                                       *
#负责人   ：xinjin                                                                 *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
hbpod x86 tpf test
    [Documentation]    基带 x86 tpf测试
    [Tags]    BSP
    [Arguments]
    [Teardown]    Log    hbpod x86 tpf test finish!

    ${boardEntry}    Get Oid By Name    ${Mib}    boardRowStatus
    Log    ${boardEntry}
    @{som_slotNo_list}    Get board of aom or som    ${som}    ${boardEntry}    ${16}
    :FOR    ${loop_slotNo}    in    @{som_slotNo_list}
    \   ${hbpod_slot}    Evaluate    int(${loop_slotNo})
    \   ${ip_address}    Catenate    SEPARATOR=.    ${hbpod_address_base}    ${hbpod_slot + 1}
    \   Log    ${loop_slotNo}'s board log upload is complete!
    \   ${pid}    Set Variable    ${2}
    \   Connect Device By UAgent Use Pid    hbpod scp 2    ${ip_address}    ${pid}
    \   ${execute_result}=    Execute Command by UAgent    i    ''
    \   Log    ${execute_result}
    \   Should be equal    ${execute_result}    ${0}
    \   Sleep    1
    \   Disconnect UAgent Use Pid

#***********************************************************************************
#功能     ：hbpod plp1 tpf test                                                    *
#标签     ：BSP                                                                    *
#索引     ：无                                                                     *
#入参     ：无                                                                     *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：2S                                                                     *
#所属模块 ：BSP                                                                    *
#适用用例 ：                                                                       *
#负责人   ：xinjin                                                                 *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
hbpod plp1 tpf test
    [Documentation]    基带 plp1 tpf测试
    [Tags]    BSP
    [Arguments]
    [Teardown]    Log    hbpod plp1 tpf test finish!

    ${boardEntry}    Get Oid By Name    ${Mib}    boardRowStatus
    Log    ${boardEntry}
    @{som_slotNo_list}    Get board of aom or som    ${som}    ${boardEntry}    ${16}
    :FOR    ${loop_slotNo}    in    @{som_slotNo_list}
    \   ${hbpod_slot}    Evaluate    int(${loop_slotNo})
    \   ${ip_address}    Catenate    SEPARATOR=.    ${hbpod_address_base}    ${hbpod_slot + 11}
    \   Log    ${loop_slotNo}'s board log upload is complete!
    \   ${pid}    Set Variable    ${0}
    \   Connect Device By UAgent Use Pid    hbpod plp1    ${ip_address}    ${pid}
    \   ${execute_result}=    Execute Command by UAgent    i    ''
    \   Log    ${execute_result}
    \   Should be equal    ${execute_result}    ${0}
    \   Sleep    1
    \   Disconnect UAgent Use Pid

#***********************************************************************************
#功能     ：hbpod plp2 tpf test                                                    *
#标签     ：BSP                                                                    *
#索引     ：无                                                                     *
#入参     ：无                                                                     *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：2S                                                                     *
#所属模块 ：BSP                                                                    *
#适用用例 ：                                                                       *
#负责人   ：xinjin                                                                 *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
hbpod plp2 tpf test
    [Documentation]    基带 plp2 tpf测试
    [Tags]    BSP
    [Arguments]
    [Teardown]    Log    hbpod plp2 tpf test finish!


    ${boardEntry}    Get Oid By Name    ${Mib}    boardRowStatus
    Log    ${boardEntry}
    @{som_slotNo_list}    Get board of aom or som    ${som}    ${boardEntry}    ${16}
    :FOR    ${loop_slotNo}    in    @{som_slotNo_list}
    \   ${hbpod_slot}    Evaluate    int(${loop_slotNo})
    \   ${ip_address}    Catenate    SEPARATOR=.    ${hbpod_address_base}    ${hbpod_slot + 21}
    \   Log    ${loop_slotNo}'s board log upload is complete!
    \   ${pid}    Set Variable    ${0}
    \   Connect Device By UAgent Use Pid    hbpod plp 2    ${ip_address}    ${pid}
    \   ${execute_result}=    Execute Command by UAgent    i    ''
    \   Log    ${execute_result}
    \   Should be equal    ${execute_result}    ${0}
    \   Sleep    1
    \   Disconnect UAgent Use Pid
