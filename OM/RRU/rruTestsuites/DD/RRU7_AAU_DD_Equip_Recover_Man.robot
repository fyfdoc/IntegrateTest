# encoding utf-8
'''
*************************************************************
*** COPYRIGHT DaTang Mobile Communications Equipment CO.,LTD
*************************************************************
*文件名称：RRU10_AAU_DD_Equip_Recover_Man.robot
*功能描述：实现手动换AAU小包功能，换要测试的小包
*使用方法：
1.首先在PC端放置好要Mount的文件及文件夹，现在默认需要文件路径如下：d/nfsroot
2.Mount文件到对应设备
3.执行文件中的shell脚本
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
#Resource        ../../COMM/commResources/SnmpMibHelper.robot
Resource        ../../rruResources/DD/ddResources.robot
#Suite Setup     Open Snmp Connection And Load Private MIB

*** Variables ***

*** test case ***
AAU DD EquipEnv Recover
    #Device Enviroment Recover    Man
    Log    \n AAU DD EquipEnv Recover Man
