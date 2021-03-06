# encoding utf-8
'''
*************************************************************
*** COPYRIGHT DaTang Mobile Communications Equipment CO.,LTD
*************************************************************
*文件名称：RRU10_AAU_DD_Equip_Recover_Auto.robot
*功能描述：实现一键换AAU小包功能，整体恢复AAU环境
*使用方法：
-----------------------------------------------------------------------------------
*修改记录：                                                                       |
*##修改日期    |    修改人    |    修改描述    |                                  |
*2018-11-14        zhaobaoxin       创建文件                                      |
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

*** Keywords ***

*** Settings ***
Resource        ../../rruResources/DD/ddResources.robot
#Suite Setup     Open Snmp Connection And Load Private MIB

*** Variables ***

*** test case ***
AAU DD EquipEnv Recover
    #Device Enviroment Recover    Auto
    Log    \n AAU DD EquipEnv Recover