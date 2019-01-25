# encoding utf-8
'''
*************************************************************
*** COPYRIGHT DaTang Mobile Communications Equipment CO.,LTD
*************************************************************
*文件名称：almResource.robot
*功能描述：OM告警模块相关资源文件
*使用方法：

-----------------------------------------------------------------------------------
*修改记录：                                                                       |
*##修改日期    |    修改人    |    修改描述    |                                  |
*2018-10-20        majingwei       创建文件                                       |
----------------------------------------------------------------------------------|
*************************************************************
______________________________________________________________________________________
*关键字目录：                                                                        |
-------------------------------------------------------------------------            |
*##查询类关键字##                                                                    |
*A1.查询指定告警是否发生              -> Alarm Should be Occured                     |
*##动作类关键字##                                                                    |
*B1.清除指定告警                      -> Clean Alarm                                 |
_____________________________________________________________________________________|

************************************************资源文件头结束**************************************************
'''
from pysnmp.smi.rfc1902 import ObjectIdentity

*** Settings ***
Library    SnmpLibrary
Library    ../../utils/CiUtils.py

*** Variables ***
${Mib}    DTM-TD-LTE-ENODEB-ENBMIB
${Cell_enabled}    enabled
${Power_Off}    powerOff
${Power_On}    normal
${ProceduralStatus}    terminating
${OperationalStatus}    enabled
${MibName}    DTM-TD-LTE-ENODEB-ENBMIB
${aom}    aom
${som}    som

*** Keywords ***
#***********************************************************************************
#功能     ：查询设备下电状态                                                       *
#标签     ：                                                                       *
#索引     ：                                                                       *
#入参     ：${arm_idx}    ${rangeno}                                               *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：DEV                                                                    * 
#适用用例 ：                                                                       *
#负责人   ：                                                                       *
#调用方法 ：调用关键字，${arm_idx}    ${rangeno}                                   *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Get Device Status
    [Documentation]    查询设备下电状态
    [Tags]
    [Arguments]    ${arm_idx}    ${rangeno} 
    [Teardown]
    [Timeout]
               
   :FOR    ${loop}    IN RANGE    ${rangeno}
   \   ${curCellStatus}    Get Oid By Name    ${Mib}    nrCellOperationalState
   \   ${curCellStatus_Value}    Get    ${curCellStatus}
   \   ${ProceduralStatus_Value}    Get By Name    boardProceduralStatus    idx=${arm_idx}
   \   ${OperationalStatus_Value}    Get By Name    boardOperationalState    idx=${arm_idx}
   \   Log    ${curCellStatus_Value}
   \   Log    ${ProceduralStatus_Value}
   \   Log    ${OperationalStatus_Value}
   \   Should be equal    ${curCellStatus_Value}    ${Cell_enabled}
   \   Should be equal    ${ProceduralStatus_Value}    ${ProceduralStatus}
   \   Should be equal    ${OperationalStatus_Value}    ${OperationalStatus}
   
   \   ${boardPowerOff}    Get Oid By Name    ${Mib}    boardPowerState
   \   Set    ${boardPowerOff}    ${Power_Off}    idx=${arm_idx}
   \   log    ${boardPowerOff}
   \   Sleep    30
   
   \   ${boardPowerOn}    Get Oid By Name    ${Mib}    boardPowerState
   \   Set    ${boardPowerOn}    ${Power_On}    idx=${arm_idx}
   \   Sleep    420
   
   \   ${curCellStatus}    Get Oid By Name    ${Mib}    nrCellOperationalState
   \   ${curCellStatus_Value}    Get    ${curCellStatus}
   \   ${ProceduralStatus_Value}    Get By Name    boardProceduralStatus    idx=${arm_idx}
   \   ${OperationalStatus_Value}    Get By Name    boardOperationalState    idx=${arm_idx}
   \   Log    ${curCellStatus_Value}
   \   Log    ${ProceduralStatus_Value}
   \   Log    ${OperationalStatus_Value}
   \   Should be equal    ${ProceduralStatus_Value}    ${ProceduralStatus}
   \   Should be equal    ${OperationalStatus_Value}    ${OperationalStatus}
   \   Should be equal    ${curCellStatus_Value}    ${Cell_enabled}
   
   
#***********************************************************************************
#功能     ：BBU基带设备下电                                                        *
#标签     ：                                                                       *
#索引     ：                                                                       *
#入参     ：                                                                       *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：DEV                                                                    * 
#适用用例 ：                                                                       *
#负责人   ：                                                                       *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Bbu All Baseband Board PowerOff
		[Documentation]    BBU基带设备下电
    [Tags]
    [Arguments]    ${rangeno}    
    [Teardown]
    [Timeout]

    ${boardEntry}    Get Oid By Name    ${MibName}    boardRowStatus
    Log    ${boardEntry}
    @{som_slotNo_list}    Get board of aom or som    ${som}    ${boardEntry}    ${16}

    :FOR    ${loop_slotNo}    in    @{som_slotNo_list}
    \    ${arm_idx}    Get Index By SlotNo Two    ${loop_slotNo}
    \    Log    ${loop_slotNo}'s board log upload is complete!
    \    Get Device Status    ${arm_idx}    ${rangeno}   
