# encoding utf-8
'''
*************************************************************
*** COPYRIGHT DaTang Mobile Communications Equipment CO.,LTD
*************************************************************
*文件名称：AAUVerUpAndBack.robot
*功能描述：AAU托包升级回退压力测试
*使用方法：修改用例中的大包路径 以及 大包的下载方式 来实现对基站的升级与回退
-----------------------------------------------------------------------------------
*修改记录：                                                                       |
*##修改日期    |    修改人    |    修改描述    |                                  |
*2018-11-09         zhaobaoxin     创建文件                                       |
*2018-12-06         zhaobaoxin     修改文件                                       |
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
Resource                ../../RRU/rruResources/OM/omResource.robot

Resource                ../../COMM/commResources/SnmpMibHelper.robot
Resource                ../../../DD/Resources/_COMM_/UploadLogsAndRecoverGnb.robot
Suite Setup             Open Snmp Connection And Load Private MIB
#Suite Teardown          Run Keyword If Any Tests Failed    Upload Logs And Recover Gnb

*** Variables ***
${dstIp}    172.27.245.92
${community}    public
${MIB}    DTM-TD-LTE-ENODEB-ENBMIB

${FullPath_VerUp}       None    #目前需要手动填写
${FullPath_VerBack}     None    #目前需要手动填写
${DownloadIndicator}    forcedDownload
*** test case ***
AAU版本升级回退测试用例
#********************************
#第一个参数为存放大包的全路径
#第二个参数为下载标志 instantDownload:对应为立即激活 | forcedDownload:对应为强制激活
#注：此用例需要解压工具，确保OM文件夹下有tools文件夹及解压工具
#********************************
    [Documentation]    AAU反复升级回退测试
    [Tags]    mandatory
    #[Arguments]
    :FOR    ${loop}    IN RANGE    20
    \    Log To Console    \n正在执行第${loop+1}次升级回退
    \    ${ret}    AAU VerUpAndBack    ${FullPath_VerUp}    ${DownloadIndicator}
    \    ${ret}    AAU VerUpAndBack    ${FullPath_VerBack}    ${DownloadIndicator}
