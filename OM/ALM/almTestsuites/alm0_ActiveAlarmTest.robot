# encoding utf-8
'''
*************************************************************
*** COPYRIGHT DaTang Mobile Communications Equipment CO.,LTD
*************************************************************
*文件名称：alm0_ActiveAlarmTest.robot
*功能描述：
*使用方法：

-----------------------------------------------------------------------------------
*修改记录：                                                                       |
*##修改日期    |    修改人    |    修改描述    |                                  |
*2018-10-20        morunzhang       创建文件                                      |
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
Resource    ../almResources/activeAlarmResource.robot
Resource    ../../COMM/commResources/SnmpMibHelper.robot
Suite Setup           Open Snmp Connection And Load Private MIB

*** Variables ***

*** test case ***
#~ #----------------------------------------------------------------------
ActiveAlarmCauseNo Test
    [Documentation]    查询活跃告警原因号测试
    [Tags]
    &{ALARMINFO_DICT}    Create Dictionary
    ${ALARMINFO_DICT}    Get ActiveAlarmCauseNo
    Log    ${ALARMINFO_DICT}

#~ #----------------------------------------------------------------------
ActiveAlarmSubCauseNo Test
    [Documentation]    查询活跃告警子原因号测试
    [Tags]
    &{ALARMINFO_DICT}    Create Dictionary
    ${ALARMINFO_DICT}    Get ActiveAlarmSubCauseNo
    Log    ${ALARMINFO_DICT}

#~ #----------------------------------------------------------------------
activeAlarmType Test
    [Documentation]    查询活跃告警类型测试
    [Tags]
    &{ALARMINFO_DICT}    Create Dictionary
    ${ALARMINFO_DICT}    Get activeAlarmType
    Log    ${ALARMINFO_DICT}