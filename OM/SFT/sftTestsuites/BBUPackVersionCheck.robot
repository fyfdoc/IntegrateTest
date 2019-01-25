# encoding utf-8
'''
*************************************************************
*** COPYRIGHT DaTang Mobile Communications Equipment CO.,LTD
*************************************************************
*文件名称：BBUPackVersionCheck.robot
*功能描述：检查BBU大包的版本信息与升级后的基站包信息是否一致
*使用方法：通过BBU大包路径触发大包版本检查

-----------------------------------------------------------------------------------
*修改记录：                                                                       |
*##修改日期    |    修改人    |    修改描述    |                                  |
*2018-11-13      wangruixuan       创建文件                                       |
----------------------------------------------------------------------------------|
*************************************************************
______________________________________________________________________________________
*用例记录：（记录用例测试出的问题，引用关键字遇到的异常问题等等）                    |
**                                                                                   |
**                                                                                   |
_____________________________________________________________________________________|

************************************************用例文件头结束**************************************************
'''
from pysnmp.smi.rfc1902 import ObjectIdentity

*** Settings ***
Library    BuiltIn
Resource    ../../SFT/sftResources/BBUPackVerCheck.robot
Resource    ../../COMM/commResources/GnbCommands.robot
Resource    ../../OutPermission/opResources/opResource.robot
Resource    ../../COMM/commResources/SnmpMibHelper.robot
Suite Setup           Open Snmp Connection And Load Private MIB

*** Variables ***

*** test case ***
BBU大包版本号检查用例
    ${PackVersion}    Get BBU Pack Ver    E:\\wrx\\Test\\BBU1109.dtz

    @{processorIndex_list}    Get All Actual Processors Index List
    Log List    @{processorIndex_list}
    @{boardIndex_list}    Get All Actual Boards Index List
    Log List    @{boardIndex_list}

    :FOR    ${loop}    IN RANGE    1
    #版本升级
    \    Set Upgrade Commands    E:\\wrx\\Test\\BBU1109_Test.dtz    instantDownload
    \    Log To Console    \nBBU正在进行版本下载，请等待14分钟
    \    Sleep    14min
    \    Set No Clk Mode
    \    Get All Boards Until Enabled    @{boardIndex_list}
    \    Get All Processors Until Enabled    @{processorIndex_list}
    
    ${PackRunVersion}    Get BBU Running Pack Ver
    ${Result}    Should Be Equal For Str    ${PackVersion}    ${PackRunVersion}
    Should be equal    ${Result}    ${True}
    #${PackPlanVersion}    Get BBU Plan Pack Ver