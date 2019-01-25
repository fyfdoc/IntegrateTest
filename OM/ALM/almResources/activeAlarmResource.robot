# encoding utf-8
'''
*************************************************************
*** COPYRIGHT DaTang Mobile Communications Equipment CO.,LTD
*************************************************************
*文件名称：activeAlarmResource.robot
*功能描述：OM活跃告警模块相关资源文件
*使用方法：

-----------------------------------------------------------------------------------
*修改记录：                                                                       |
*##修改日期    |    修改人    |    修改描述    |                                  |
*2018-11-15        morunzhang      创建文件                                       |
----------------------------------------------------------------------------------|
*************************************************************
______________________________________________________________________________________
*关键字目录：                                                                        |
-------------------------------------------------------------------------            |
*##查询类关键字##                                                                    |
*A1.查询活跃告警原因号                -> Get ActiveAlarmCauseNo                      |
*A2.查询活跃告警子原因号              -> Get ActiveAlarmSubCauseNo                   |
*A3.查询活跃告警类型                  -> Get activeAlarmType                         |
*##动作类关键字##                                                                    |
*B1.                                  ->                                             |
_____________________________________________________________________________________|

************************************************资源文件头结束**************************************************
'''
from pysnmp.smi.rfc1902 import ObjectIdentity

*** Settings ***
Library    SnmpLibrary
Library    ../../utils/CiUtils.py

*** Variables ***
${Mib}    DTM-TD-LTE-ENODEB-ENBMIB

*** Keywords ***
#***********************************************************************************
#功能     ：查询活跃告警原因号                                                     *
#标签     ：                                                                       *
#索引     ：无                                                                     *
#入参     ：无                                                                     *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：ALM                                                                    *
#适用用例 ：                                                                       *
#负责人   ：morunzhang                                                             *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Get ActiveAlarmCauseNo
    [Documentation]    查询活跃告警原因号
    [Tags]
    [Arguments]    
    [Teardown]
    [Timeout]
    &{ALARMINFO_DICT}    Create Dictionary
    ${CauseNoOid}    Get Oid By Name    ${Mib}    activeAlarmCauseNo
    Log    ${CauseNoOid}
    :FOR    ${loop_num}    IN RANGE    ${2147483647}
    \    ${OidAndVal}    Get Next    ${CauseNoOid}
    \    Log    The oid and value is = ${OidAndVal} 
    \    run keyword if    ${OidAndVal}==()    exit for loop
    \    ${CauseNoOid}    set varible    ${OidAndVal[0]}
    \    Set To Dictionary    ${ALARMINFO_DICT}    ${loop_num}    ${OidAndVal[1]}
    [Return]    &{ALARMINFO_DICT}


#***********************************************************************************
#功能     ：查询活跃告警子原因号                                                   *
#标签     ：                                                                       *
#索引     ：无                                                                     *
#入参     ：无                                                                     *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：ALM                                                                    *
#适用用例 ：                                                                       *
#负责人   ：morunzhang                                                             *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Get ActiveAlarmSubCauseNo
    [Documentation]    查询活跃告警子原因号
    [Tags]
    [Arguments]    
    [Teardown]
    [Timeout]
    &{ALARMINFO_DICT}    Create Dictionary
    ${CauseNoOid}    Get Oid By Name    ${Mib}    activeAlarmSubCauseNo
    Log    ${CauseNoOid}
    :FOR    ${loop_num}    IN RANGE    ${2147483647}
    \    ${OidAndVal}    Get Next    ${CauseNoOid}
    \    Log    The oid and value is = ${OidAndVal} 
    \    run keyword if    ${OidAndVal}==()    exit for loop
    \    ${CauseNoOid}    set varible    ${OidAndVal[0]}
    \    Set To Dictionary    ${ALARMINFO_DICT}    ${loop_num}    ${OidAndVal[1]}
    [Return]    &{ALARMINFO_DICT}


#***********************************************************************************
#功能     ：查询活跃告警类型                                                       *
#标签     ：                                                                       *
#索引     ：无                                                                     *
#入参     ：无                                                                     *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：ALM                                                                    *
#适用用例 ：                                                                       *
#负责人   ：morunzhang                                                             *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Get activeAlarmType
    [Documentation]    查询活跃告警类型
    [Tags]
    [Arguments]    
    [Teardown]
    [Timeout]
    &{ALARMINFO_DICT}    Create Dictionary
    ${CauseNoOid}    Get Oid By Name    ${Mib}    activeAlarmType
    Log    ${CauseNoOid}
    :FOR    ${loop_num}    IN RANGE    ${2147483647}
    \    ${OidAndVal}    Get Next    ${CauseNoOid}
    \    Log    The oid and value is = ${OidAndVal} 
    \    run keyword if    ${OidAndVal}==()    exit for loop
    \    ${CauseNoOid}    set varible    ${OidAndVal[0]}
    \    Set To Dictionary    ${ALARMINFO_DICT}    ${loop_num}    ${OidAndVal[1]}
    [Return]    &{ALARMINFO_DICT}