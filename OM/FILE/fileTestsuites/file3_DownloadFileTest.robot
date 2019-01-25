# encoding utf-8
'''
*************************************************************
*** COPYRIGHT DaTang Mobile Communications Equipment CO.,LTD
*************************************************************
*文件名称：file3_DownloadFileTest.robot
*功能描述：测试文件下载用例
*使用方法：

-----------------------------------------------------------------------------------
*修改记录：                                                                       |
*##修改日期    |    修改人    |    修改描述    |                                  |
*2018-12-06        morunzhang       创建文件                                      |
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
Library    Collections
Resource    ../../COMM/commResources/SnmpMibHelper.robot
Resource    ../../COMM/commResources/UAgentWrapper.robot
Resource    ../fileResources/CommonLogResource.robot
Resource    ../fileResources/BoardLogResource.robot
Resource    ../fileResources/RruLogResource.robot
Suite Setup           Open Snmp Connection And Load Private MIB

*** Variables ***
${host_name}        'SCTF'
${host_address}     172.27.245.92
${pId}              ${-1}




*** test case ***
#~ #----------------------------------------------------------------------
Connect Device Test
    [Documentation]    连接设备
    [Tags]
    Connect Device By UAgent Use Pid    ${host_name}    ${host_address}    ${pId}

#~ #----------------------------------------------------------------------
DownloadFile Test
    [Documentation]    普通文件下载
    [Tags]
    ${rs}    File Download      ${FtpServerIp}:\/\/D:\/file_download\/lm.dtz     \/ramDisk\/lm.dtz    
    Should be equal    ${rs}    ${True}

#~ #----------------------------------------------------------------------
Disconnect Device Test
    [Documentation]    断开连接
    [Tags]
    Disconnect UAgent