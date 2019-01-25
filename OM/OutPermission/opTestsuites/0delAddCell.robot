# encoding utf-8
'''
*************************************************************
*** COPYRIGHT DaTang Mobile Communications Equipment CO.,LTD
*************************************************************
*文件名称：0delAddCell.robot
*功能描述：反复删建小区和本地小区
*使用方法：

-----------------------------------------------------------------------------------
*修改记录：                                                                       |
*##修改日期    |    修改人    |    修改描述    |                                  |
*2018-10-20        majingwei       创建文件                                       |
----------------------------------------------------------------------------------|
*************************************************************
______________________________________________________________________________________
*用例记录：                                                                          |
**                                                                                   |
**                                                                                   |
_____________________________________________________________________________________|

************************************************用例文件头结束**************************************************
'''
from pysnmp.smi.rfc1902 import ObjectIdentity

*** Settings ***
Resource    ../../COMM/commResources/SnmpMibHelper.robot
Resource    ../opResources/opResource.robot
#Resource    ../resources/UploadLogsAndRecoverGnb.robot
Suite Setup           Open Snmp Connection And Load Private MIB
#Suite Teardown    Run Keyword If Any Tests Failed    Upload Logs And Recover Gnb

*** Variables ***
${teatTimes}    100
${Id}    0

*** test case ***
Active Cell Test
    [Documentation]    反复删建小区测试
    [Tags]    mandatory
    [Arguments]
    :FOR    ${loop}    IN RANGE    ${teatTimes}
    \    DelAddNrCellRepeatedly    ${Id}