# encoding utf-8
'''
*************************************************************
*** COPYRIGHT DaTang Mobile Communications Equipment CO.,LTD
*************************************************************
*文件名称：DD_TEST_FILE.robot
*功能描述：文件系统测试
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
主控x86文件系统测试
    [Documentation]    主控x86文件系统测试
    [Tags]    BSP_TEST
    hsctd file test

基带 x86文件系统测试
    [Documentation]    基带x86文件系统测试
    [Tags]    BSP_TEST
    hbpod x86 file test

基带 plp1 文件系统测试
    [Documentation]    基带plp1文件系统测试
    [Tags]    BSP_TEST
    hbpod plp1 file test

基带 plp2 文件系统测试
    [Documentation]    基带plp2文件系统测试
    [Tags]    BSP_TEST
    hbpod plp2 file test