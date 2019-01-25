# encoding utf-8
'''
*************************************************************
*** COPYRIGHT DaTang Mobile Communications Equipment CO.,LTD
*************************************************************
*文件名称：DD_TEST_MEMSET.robot
*功能描述：内存memset测试
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
主控x86内存memset测试
    [Documentation]    主控x86内存memset测试
    [Tags]    BSP_TEST
    #[Arguments]
    hsctd memset test

基带 x86内存memset测试
    [Documentation]    基带x86内存memset测试
    [Tags]    BSP_TEST
    #[Arguments]
    hbpod x86 memset test

基带 plp1 内存memset测试
    [Documentation]    基带plp1内存memset测试
    [Tags]    BSP_TEST
    #[Arguments]
    hbpod plp1 memset test

基带 plp2 内存memset测试
    [Documentation]    基带plp2内存memset测试
    [Tags]    BSP_TEST
    #[Arguments]
    hbpod plp2 memset test