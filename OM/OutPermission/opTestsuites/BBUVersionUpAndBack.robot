# encoding utf-8
'''
*************************************************************
*** COPYRIGHT DaTang Mobile Communications Equipment CO.,LTD
*************************************************************
*文件名称：BBUVersionUpAndBack.robot
*功能描述：BBU版本的升级与回退
*使用方法：修改用例中的大包路径 以及 大包的下载方式 来实现对基站的升级与回退

-----------------------------------------------------------------------------------
*修改记录：                                                                       |
*##修改日期    |    修改人    |    修改描述    |                                  |
*2018-11-09       wangruixuan      创建文件                                       |
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
Resource    ../../COMM/commResources/SnmpMibHelper.robot
Resource    ../../SFT/sftResources/BBUupgrade_Res.robot
Suite Setup           Open Snmp Connection And Load Private MIB

*** Variables ***
${Mib}    DTM-TD-LTE-ENODEB-ENBMIB

*** test case ***
BBU版本升级回退测试用例
#********************************
#第一个参数为存放大包的全路径
#第二个参数为下载标志 instantDownload:对应为立即激活 | forcedDownload:对应为强制激活
#注：此用例需要解压工具，确保OM文件夹下有tools文件夹及解压工具
#********************************
    :FOR    ${loop}    IN RANGE    10
    #版本升级
    \    BBU Version Upgrade    E:\\wrx\\Test\\BBU1205.dtz    instantDownload
    
    #版本回退
    \    BBU Version Upgrade    E:\\wrx\\Test\\BBU1126.dtz    instantDownload