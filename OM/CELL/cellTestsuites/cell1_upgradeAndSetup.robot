# encoding utf-8
'''
*************************************************************
*** COPYRIGHT DaTang Mobile Communications Equipment CO.,LTD
*************************************************************
*文件名称：cell1_upgradeAndSetup.robot
*功能描述：拖配置文件然后拖包升级后建立小区
*使用方法：明确配置文件和大包的位置

-----------------------------------------------------------------------------------
*修改记录：                                                                       |
*##修改日期    |    修改人    |    修改描述    |                                  |
*2018-11-26         libo8          创建文件                                       |
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
Resource    ../cellResources/cellResource.robot
Resource    ../../COMM/commResources/GnbCommands.robot
Suite Setup           Open Snmp Connection And Load Private MIB

*** Variables ***
${CFG_PATH_NEW}    D:\\OM\\1123temp\\cur_new.cfg
${BBU_PATH_NEW}    D:\\OM\\1123temp\\BBU_new.dtz

*** test case ***
拖配置升级建小区测试用例
    Cell Should be enabled For CfgAndVer Upgrade    ${CFG_PATH_NEW}    ${BBU_PATH_NEW}
