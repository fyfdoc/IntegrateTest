# encoding utf-8
'''
*************************************************************
*** COPYRIGHT DaTang Mobile Communications Equipment CO.,LTD
*************************************************************
*文件名称：DD_TEST_TIMERINT.robot
*功能描述：定时中断测试
*使用方法：

-----------------------------------------------------------------------------------
*修改记录：                                                                       |
*##修改日期    |    修改人    |    修改描述    |                                  |
*2018-10-31        xinjin       创建文件                                       |
----------------------------------------------------------------------------------|
*************************************************************
______________________________________________________________________________________
*用例记录：                                                                          |
-------------------------------------------------------------------------            |
**                                                                                   |
_____________________________________________________________________________________|

************************************************资源文件头结束**************************************************
'''
from pysnmp.smi.rfc1902 import ObjectIdentity

*** Settings ***
Resource    ../../Resources/_COMM_/SnmpMibHelper.robot
Resource    ../../Resources/BSP/bspResource.robot
Suite Setup           Open Snmp Connection And Load Private MIB

*** Variables ***



*** test case ***
主控x86定时中断测试
    [Documentation]    主控x86定时中断测试
    [Tags]    BSP_TEST
    #[Arguments]
    hsctd timer Interruption test

基带 x86定时中断测试
    [Documentation]    基带x86定时中断测试
    [Tags]    BSP_TEST
    #[Arguments]
    hbpod x86 timer Interruption test

基带 plp1 定时中断测试
    [Documentation]    基带plp1定时中断测试
    [Tags]    BSP_TEST
    #[Arguments]
    hbpod plp1 timer Interruption test

基带 plp2 定时中断测试
    [Documentation]    基带plp2定时中断测试
    [Tags]    BSP_TEST
    #[Arguments]
    hbpod plp2 timer Interruption test