# encoding utf-8
'''
*************************************************************
*** COPYRIGHT DaTang Mobile Communications Equipment CO.,LTD
*************************************************************
*文件名称：opResource.robot
*功能描述：OM准出相关资源文件：准出涉及关键字列表
*使用方法：

----------------------------------------------------------------------------------------
*修改记录：                                                                             |
*##修改日期    |    修改人    |    修改描述    |                                        |
*2018-10-20        majingwei       创建文件                                             |
*2018-11-15        yangnan1        添加整站复位用例                                     |
*2018-11-09        zhaobaoxin      添加AAU版本升级回退用例                              |
*2018-11-16        wangyan11       添加AAU托包升级回退后版本号比较用例                  |
*2018-11-16        zhaobaoxin      修正关键字注释                                       |
*2018-11-20        zhaobaoxin      修改获取RRU接入状态关键字处理                        |
*2018-11-23        wangyan11       添加AAU托包升级回退后子版本号比较关键字              |
*2018-12-06        zhaobaoxin      将AAU关键字移到RRU/rruResources/OM/omResource.robot  |
----------------------------------------------------------------------------------------|
*************************************************************
______________________________________________________________________________________
*关键字目录：                                                                        |
-------------------------------------------------------------------------            |
*##小区相关关键字##                                                                  |
*A1.查询指定小区激活可用              -> Cell Should be Enabled                      |
*A2.查询指定小区去激活不可用          -> Cell Should be Disabled                     |
*A3.查询指定本地小区是否已建立        -> LocalCell Should be Setup                   |
*A4.激活指定小区                      -> Active Cell                                 |
*A5.去激活指定小区                    -> DeActive Cell                               |
*A6.建立指定本地小区                  -> Setup LocalCell                             |
*A7.删除指定本地小区                  -> Delete LocalCell                            |
*A8.反复删建指定ID的小区              -> DelAddNrCellRepeatedly                      |
*##AAU相关关键字##                                                                   |
*B1.查询指定AAU是否接入完成且可用     -> AAU Should be Enabled                       |
*B2.复位指定AAU                       -> Reset AAU                                   |
*##板卡相关关键字##                                                                  |
*C1.查询指定槽位板卡状态              -> Board Should be Enabled                     |
*C2.查询指定处理器状态                                                               |
*##板卡相关关键字##                                                                  |
*D1.BBU版本升级命令的下发                                                            |
_____________________________________________________________________________________|

************************************************资源文件头结束**************************************************
'''
from pysnmp.smi.rfc1902 import ObjectIdentity

*** Settings ***
Library    SnmpLibrary
Library    DateTime
Library    Collections
Library    ../../utils/CiUtils.py
Library    ../../utils/FileHandler.py
#Library    ../../utils/OM_SFT_ApiFile.py

*** Variables ***
#Variables of Keyword：Cell Should be Enabled

${ActiveStateVal}    0
${DeActiveStateVal}    1

${Cell_enabled}    enabled
${Cell_disabled}    disabled
${LcCell_enabled}    enabled
${LcCell_disabled}    disabled
${Trigger_is_active}    active
${Trigger_is_deactive}    deactive
${LcTrigger_is_add}    add
${LcTrigger_is_delete}    delete
${Mib}    DTM-TD-LTE-ENODEB-ENBMIB
${enabled}    enabled

#AAU Resource Use.


${DownloadIndicator}   forcedDownload
${ActivateIndicator}    instantActivate
${OM_SNMP_GET_NOT_EXIST}    ${342}
${OM_SNMP_SET_NOT_EXIST}    ${345}
#最大射频单元数量
${topoRRUNo_Max}    ${95}

#射频单元接入状态
#0:unknown|未知/1:broadcastAccess|广播接入完成,通道建立阶段/
#2:pathSetup|通道建立完成,版本更新阶段/
#3:versionUpdate|版本更新完成,时延测量阶段/
#4:timeDelayMeasure|时延测量完成,天线参数配置阶段/
#5:antConfig|天线参数配置完成,初始化校准结果上报阶段
#/6:available|RRU接入完成
${RRUAccessPhase_0}    'unknown'
${RRUAccessPhase_1}    'broadcastAccess'
${RRUAccessPhase_2}    'pathSetup'
${RRUAccessPhase_3}    'versionUpdate'
${RRUAccessPhase_4}    'timeDelayMeasure'
${RRUAccessPhase_5}    'antConfig'
${RRUAccessPhase_6}    'available'
#0:enabled|可用/1:disabled|不可用/2:invalid|初始不可用
${RRUOperationalState_0}    'enabled'
${RRUOperationalState_1}    'disabled'
${RRUOperationalState_2}    'invalid'

*** Keywords ***
#***********************************************************************************
#功能     ：A1查询指定小区激活可用                                                 *
#标签     ：mandatory                                                              *
#索引     ：小区ID  一维                                                           *
#入参     ：小区ID                                                                 *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：2S                                                                     *
#所属模块 ：CELL                                                                   *
#适用用例 ：                                                                       *
#负责人   ：majingwei                                                              *
#调用方法 ：调用关键字，输入小区ID                                                 *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Cell Should be Enabled
    [Documentation]    查询指定小区是否激活可用
    [Tags]    mandatory
    [Arguments]    ${idx}
    [Teardown]    Log    Cell is enabled!
    [Timeout]    2S

    ${curTrigger}    Get Oid By Name    ${Mib}    nrCellActiveTrigger
    ${Trigger_Value}    Get    ${curTrigger}    ${idx}
    Log    ${Trigger_Value}
    Should be equal    ${Trigger_Value}    ${Trigger_is_active}

    ${curCellStatus}    Get Oid By Name    ${Mib}    nrCellOperationalState
    ${curCellStatus_Value}    Get    ${curCellStatus}    ${idx}
    Log    ${curCellStatus_Value}
    Should be equal    ${curCellStatus_Value}    ${Cell_enabled}

#***********************************************************************************
#功能     ：A2查询指定小区去激活不可用                                             *
#标签     ：mandatory                                                              *
#索引     ：小区ID  一维                                                           *
#入参     ：小区ID                                                                 *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：2S                                                                     *
#所属模块 ：CELL                                                                   *
#适用用例 ：                                                                       *
#负责人   ：majingwei                                                              *
#调用方法 ：调用关键字，输入小区ID                                                 *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Cell Should be Disabled
    [Documentation]    查询指定小区去激活不可用
    [Tags]    mandatory
    [Arguments]    ${idx}
    [Teardown]    Log    Cell is disabled!
    [Timeout]    2S

    ${curTrigger}    Get Oid By Name    ${Mib}    nrCellActiveTrigger
    ${Trigger_Value}    Get    ${curTrigger}    ${idx}
    Log    ${Trigger_Value}
    Should be equal    ${Trigger_Value}    ${Trigger_is_deactive}

    ${curCellStatus}    Get Oid By Name    ${Mib}    nrCellOperationalState
    ${curCellStatus_Value}    Get    ${curCellStatus}    ${idx}
    Log    ${curCellStatus_Value}
    Should be equal    ${curCellStatus_Value}    ${Cell_disabled}

#***********************************************************************************
#功能     ：A3.查询指定本地小区是否已建立                                          *
#标签     ：mandatory                                                              *
#索引     ：小区ID  一维                                                           *
#入参     ：小区ID                                                                 *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：2S                                                                     *
#所属模块 ：CELL                                                                   *
#适用用例 ：                                                                       *
#负责人   ：majingwei                                                              *
#调用方法 ：调用关键字，输入小区ID                                                 *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
LocalCell Should be Setup
    [Documentation]    查询指定本地小区是否已建立${idx}
    [Tags]    mandatory
    [Arguments]    ${idx}
    [Teardown]    Log    Local Cell is enabled!
    [Timeout]    2S

    ${curLcTrigger}    Get Oid By Name    ${Mib}    nrLocalCellConfigTrigger
    ${LcTrigger_Value}    Get    ${curLcTrigger}    ${idx}
    Log    ${LcTrigger_Value}
    Should be equal    ${LcTrigger_Value}    ${LcTrigger_is_add}

    ${curLcCellStatus}    Get Oid By Name    ${Mib}    nrLocalCellOperationalState
    ${curLcCellStatus_Value}    Get    ${curLcCellStatus}    ${idx}
    Log    ${curLcCellStatus_Value}
    Should be equal    ${curLcCellStatus_Value}    ${LcCell_enabled}

#***********************************************************************************
#功能     ：A4.激活指定小区                                                        *
#标签     ：mandatory                                                              *
#索引     ：小区ID  一维                                                           *
#入参     ：小区ID                                                                 *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：2S                                                                     *
#所属模块 ：CELL                                                                   *
#适用用例 ：                                                                       *
#负责人   ：majingwei                                                              *
#调用方法 ：调用关键字，输入小区ID                                                 *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Active Cell
    [Documentation]    激活指定小区${idx}
    [Tags]    mandatory
    [Arguments]    ${idx}
    [Teardown]    Log    Cell is disabled!
    [Timeout]    20S

    ${curTrigger}    Get Oid By Name    ${Mib}    nrCellActiveTrigger
    Set    ${curTrigger}    ${ActiveStateVal}    ${idx}
    Sleep    15

#***********************************************************************************
#功能     ：A5.去激活指定小区                                                      *
#标签     ：mandatory                                                              *
#索引     ：小区ID  一维                                                           *
#入参     ：小区ID                                                                 *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：2S                                                                     *
#所属模块 ：CELL                                                                   *
#适用用例 ：                                                                       *
#负责人   ：majingwei                                                              *
#调用方法 ：调用关键字，输入小区ID                                                 *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
DeActive Cell
    [Documentation]    去激活指定小区
    [Tags]    mandatory
    [Arguments]    ${idx}
    [Teardown]    Log    Cell is disabled!
    [Timeout]    10S

    ${curTrigger}    Get Oid By Name    ${Mib}    nrCellActiveTrigger
    Set    ${curTrigger}    ${DeActiveStateVal}    ${idx}
    Sleep    8

#***********************************************************************************
#功能     ：A6.建立指定本地小区                                                    *
#标签     ：mandatory                                                              *
#索引     ：小区ID  一维                                                           *
#入参     ：小区ID                                                                 *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：2S                                                                     *
#所属模块 ：CELL                                                                   *
#适用用例 ：                                                                       *
#负责人   ：majingwei                                                              *
#调用方法 ：调用关键字，输入小区ID                                                 *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Setup LocalCell
    [Documentation]    建立指定本地小区${idx}
    [Tags]    mandatory
    [Arguments]    ${idx}
    [Teardown]    Log    Cell is disabled!
    [Timeout]    10S

    ${curLcTrigger}    Get Oid By Name    ${Mib}    nrLocalCellConfigTrigger
    Set    ${curLcTrigger}    ${ActiveStateVal}    ${idx}
    Sleep    8

#***********************************************************************************
#功能     ：A7.删除指定本地小区                                                    *
#标签     ：mandatory                                                              *
#索引     ：小区ID  一维                                                           *
#入参     ：小区ID                                                                 *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：2S                                                                     *
#所属模块 ：CELL                                                                   *
#适用用例 ：                                                                       *
#负责人   ：majingwei                                                              *
#调用方法 ：调用关键字，输入小区ID                                                 *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Delete LocalCell
    [Documentation]    删除指定本地小区
    [Tags]    mandatory
    [Arguments]    ${idx}
    [Teardown]    Log    Cell is disabled!
    [Timeout]    10S

    ${curLcTrigger}    Get Oid By Name    ${Mib}    nrLocalCellConfigTrigger
    Set    ${curLcTrigger}    ${DeActiveStateVal}    ${idx}
    Sleep    4

#***********************************************************************************
#功能     ：A7.分别获得机框上主控和基带在位的板卡槽位号                            *
#标签     ：mandatory                                                              *
#索引     ：无                                                                     *
#入参     ：aom/som  入参是aom,返回值是主控在位板卡槽位号；som同理                 *
#返回值   ：主控或基带实际槽位号列表                                               *
#后处理   ：无                                                                     *
#超时     ：5S                                                                     *
#所属模块 ：CELL                                                                   *
#适用用例 ：                                                                       *
#负责人   ：majingwei                                                              *
#调用方法 ：调用关键字，输入小区ID                                                 *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Get Actual SlotNos In Gnb
    [Documentation]    分别获得机框上主控和基带在位的板卡槽位号
    [Tags]    mandatory
    [Arguments]    ${boardType}
    [Teardown]
    [Timeout]    2S
    [Return]    @{slotNo_list}

    ${RowStatus_oid}    Get Oid By Name    ${Mib}    boardRowStatus
    Log    ${RowStatus_oid}
    @{slotNo_list}    Get board of aom or som    ${boardType}    ${RowStatus_oid}    ${16}

#***********************************************************************************
#功能     ：A7.根据槽位号列表获得处理器表索引                                      *
#标签     ：mandatory                                                              *
#索引     ：无                                                                     *
#入参     ：aom/som  入参是aom,返回值是主控在位板卡槽位号；som同理                 *
#返回值   ：主控或基带实际槽位号列表                                               *
#后处理   ：无                                                                     *
#超时     ：5S                                                                     *
#所属模块 ：CELL                                                                   *
#适用用例 ：                                                                       *
#负责人   ：majingwei                                                              *
#调用方法 ：调用关键字，输入小区ID                                                 *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Get Processors Of All SlotNos
    [Documentation]    根据槽位号列表获得处理器表索引
    [Tags]    mandatory
    [Arguments]    @{slotNo_list}
    [Teardown]
    [Timeout]    5S
    [Return]    @{processorIndex_list}
    @{processorIndex_list}    Create List
    :FOR    ${SlotNo}    IN    @{slotNo_list}
    \    @{processorIndex_list_of_one_slotNo}    Get procIndex By SlotNo    ${SlotNo}
    \    @{processorIndex_list}    Combine Lists    ${processorIndex_list}    ${processorIndex_list_of_one_slotNo}

#***********************************************************************************
#功能     ：A7.获得所有实际在位的处理器索引列表                                    *
#标签     ：mandatory                                                              *
#索引     ：无                                                                     *
#入参     ：aom/som  入参是aom,返回值是主控在位板卡槽位号；som同理                 *
#返回值   ：主控或基带实际槽位号列表                                               *
#后处理   ：无                                                                     *
#超时     ：5S                                                                     *
#所属模块 ：CELL                                                                   *
#适用用例 ：                                                                       *
#负责人   ：majingwei                                                              *
#调用方法 ：调用关键字，输入小区ID                                                 *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Get All Actual Processors Index List
    [Documentation]    获得所有实际在位的处理器索引列表
    [Tags]    mandatory
    [Arguments]
    [Teardown]
    [Timeout]    5S
    [Return]    @{processorIndex_list}
    @{processorIndex_list}    Create List
    @{aom_slotNo_list}    Get Actual SlotNos In Gnb    aom
    @{som_slotNo_list}    Get Actual SlotNos In Gnb    som
    @{all_slotNo_list}    Combine Lists     ${aom_slotNo_list}    ${som_slotNo_list}
    @{processorIndex_list}    Get Processors Of All SlotNos    @{all_slotNo_list}

#***********************************************************************************
#功能     ：A7.持续地Get处理器状态，直到可用                                       *
#标签     ：mandatory                                                              *
#索引     ：无                                                                     *
#入参     ：处理器索引，例如0.0.0.0, 0.0.6.1等                                     *
#返回值   ：主控或基带实际槽位号列表                                               *
#后处理   ：无                                                                     *
#超时     ：3600S                                                                     *
#所属模块 ：CELL                                                                   *
#适用用例 ：                                                                       *
#负责人   ：majingwei                                                              *
#调用方法 ：调用关键字，输入小区ID                                                 *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Get All Processors Until Enabled
    [Documentation]    持续地Get处理器状态，直到可用
    [Tags]    mandatory
    [Arguments]    @{processorIndex_list}
    [Teardown]
    [Timeout]    3600S
    [Return]
    ${procRowStatus_oid}    Get Oid By Name    ${Mib}    procRowStatus
    :FOR    ${processorIdx}    IN    @{processorIndex_list}
    \    ${procRowStatus}    Get Until CreateGo    ${procRowStatus_oid}    ${processorIdx}
    \    ${procOperationalState_oid}    Get Oid By Name    ${Mib}    procOperationalState
    \    ${procOperationalState}    Get Until Enabled    ${procOperationalState_oid}    ${processorIdx}
    \    Log    ${procOperationalState}

#***********************************************************************************
#功能     ：A7.根据指定索引查询一个处理器是否可用                                    *
#标签     ：mandatory                                                              *
#索引     ：无                                                                     *
#入参     ：aom/som  入参是aom,返回值是主控在位板卡槽位号；som同理                 *
#返回值   ：主控或基带实际槽位号列表                                               *
#后处理   ：无                                                                     *
#超时     ：5S                                                                     *
#所属模块 ：CELL                                                                   *
#适用用例 ：                                                                       *
#负责人   ：majingwei                                                              *
#调用方法 ：调用关键字，输入小区ID                                                 *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Processor Should Be Enabled
    [Documentation]    根据指定索引查询一个处理器是否可用
    [Tags]    mandatory
    [Arguments]    ${processorIdx}
    [Teardown]
    [Timeout]    5S
    [Return]    True
    ${procOperationalState_oid}    Get Oid By Name    ${Mib}    procOperationalState
    ${procOperationalState}    Get    ${procOperationalState_oid}    ${processorIdx}
    Should Be Equal For Str    ${procOperationalState}    ${enabled}

Log List
    [Documentation]    打印输入的一个列表，用于调试
    [Tags]    mandatory
    [Arguments]    @{list}
    [Teardown]
    [Timeout]    2S

    :FOR    ${loop}    IN    @{list}
    \    Log    ${loop}

#***********************************************************************************
#功能     ：A7.根据槽位号列表获得板卡表索引                                      *
#标签     ：mandatory                                                              *
#索引     ：无                                                                     *
#入参     ：aom/som  入参是aom,返回值是主控在位板卡槽位号；som同理                 *
#返回值   ：主控或基带实际槽位号列表                                               *
#后处理   ：无                                                                     *
#超时     ：5S                                                                     *
#所属模块 ：CELL                                                                   *
#适用用例 ：                                                                       *
#负责人   ：majingwei                                                              *
#调用方法 ：调用关键字，输入小区ID                                                 *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Get boards Of All SlotNos
    [Documentation]    根据槽位号列表获得板卡表索引
    [Tags]    mandatory
    [Arguments]    @{slotNo_list}
    [Teardown]
    [Timeout]    5S
    [Return]    @{boardIndex_list}
    @{boardIndex_list}    Create List
    :FOR    ${SlotNo}    IN    @{slotNo_list}
    \    @{boardIndex_list_of_one_slotNo}    Get boardIndex By SlotNo    ${SlotNo}
    \    @{boardIndex_list}    Combine Lists    ${boardIndex_list}    ${boardIndex_list_of_one_slotNo}

#***********************************************************************************
#功能     ：A7.获得所有实际在位的板卡索引列表                                    *
#标签     ：mandatory                                                              *
#索引     ：无                                                                     *
#入参     ：aom/som  入参是aom,返回值是主控在位板卡槽位号；som同理                 *
#返回值   ：主控或基带实际槽位号列表                                               *
#后处理   ：无                                                                     *
#超时     ：5S                                                                     *
#所属模块 ：CELL                                                                   *
#适用用例 ：                                                                       *
#负责人   ：yangnan1                                                              *
#调用方法 ：调用关键字，输入小区ID                                                 *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Get All Actual boards Index List
    [Documentation]    获得所有实际在位的板卡索引列表
    [Tags]    mandatory
    [Arguments]
    [Teardown]
    [Timeout]    5S
    [Return]    @{boardIndex_list}
    @{board_list}    Create List
    @{aom_slotNo_list}    Get Actual SlotNos In Gnb    aom
    @{som_slotNo_list}    Get Actual SlotNos In Gnb    som
    @{all_slotNo_list}    Combine Lists     ${aom_slotNo_list}    ${som_slotNo_list}
    @{boardIndex_list}    Get Boards Of All SlotNos    @{all_slotNo_list}

#***********************************************************************************
#功能     ：A7.持续地Get板卡状态，直到可用                                       *
#标签     ：mandatory                                                              *
#索引     ：无                                                                     *
#入参     ：处理器索引，例如0.0.0.0, 0.0.6.1等                                     *
#返回值   ：主控或基带实际槽位号列表                                               *
#后处理   ：无                                                                     *
#超时     ：3600S                                                                     *
#所属模块 ：CELL                                                                   *
#适用用例 ：                                                                       *
#负责人   ：yangnan1                                                              *
#调用方法 ：调用关键字，输入小区ID                                                 *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Get All Boards Until Enabled
    [Documentation]    持续地Get板卡状态，直到可用
    [Tags]    mandatory
    [Arguments]    @{boardIndex_list}
    [Teardown]
    [Timeout]    3600S
    [Return]
    ${boardRowStatus_oid}    Get Oid By Name    ${Mib}    boardRowStatus
    :FOR    ${boardIdx}    IN    @{boardIndex_list}
    \    ${boardRowStatus}    Get Until CreateGo    ${boardRowStatus_oid}    ${boardIdx}
    \    ${boardOperationalState_oid}    Get Oid By Name    ${Mib}    boardOperationalState
    \    ${boardOperationalState}    Get Until Enabled    ${boardOperationalState_oid}    ${boardIdx}
    \    Log    ${boardOperationalState}

#***********************************************************************************
#功能     ：A7.根据指定索引查询一个板卡是否可用                                    *
#标签     ：mandatory                                                              *
#索引     ：无                                                                     *
#入参     ：aom/som  入参是aom,返回值是主控在位板卡槽位号；som同理                 *
#返回值   ：主控或基带实际槽位号列表                                               *
#后处理   ：无                                                                     *
#超时     ：5S                                                                     *
#所属模块 ：CELL                                                                   *
#适用用例 ：                                                                       *
#负责人   ：yangnan1                                                              *
#调用方法 ：调用关键字，输入小区ID                                                 *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Board Should Be Enabled
    [Documentation]    根据指定索引查询一个板卡是否可用
    [Tags]    mandatory
    [Arguments]    ${boardIdx}
    [Teardown]
    [Timeout]    5S
    [Return]    True
    ${boardOperationalState_oid}    Get Oid By Name    ${Mib}    boardOperationalState
    ${boardOperationalState}    Get    ${boardOperationalState_oid}    ${boardIdx}
    Should Be Equal For Str    ${boardOperationalState}    ${enabled}

#***********************************************************************************
#功能     ：A7.获得所有HBPOD在位的处理器索引列表                                    *
#标签     ：mandatory                                                              *
#索引     ：无                                                                     *
#入参     ：som  入参是som,返回值是基带在位板卡槽位号                 *
#返回值   ：主控或基带实际槽位号列表                                               *
#后处理   ：无                                                                     *
#超时     ：5S                                                                     *
#所属模块 ：CELL                                                                   *
#适用用例 ：                                                                       *
#负责人   ：yangnan1                                                              *
#调用方法 ：调用关键字，输入小区ID                                                 *
Get HBPOD Actual Processors Index List
    [Documentation]    获得所有HBPOD实际在位的处理器索引列表
    [Tags]    mandatory
    [Arguments]
    [Teardown]
    [Timeout]    5S
    [Return]    @{processorIndex_list}
    @{processorIndex_list}    Create List
    @{som_slotNo_list}    Get Actual SlotNos In Gnb    som
    @{processorIndex_list}    Get Processors Of All SlotNos    @{som_slotNo_list}

#***********************************************************************************
#功能     ：A7.获得所有HBPOD在位的板卡索引列表                                     *
#标签     ：mandatory                                                              *
#索引     ：无                                                                     *
#入参     ：som  入参是som,返回值是基带在位板卡槽位号                              *
#返回值   ：主控或基带实际槽位号列表                                               *
#后处理   ：无                                                                     *
#超时     ：5S                                                                     *
#所属模块 ：CELL                                                                   *
#适用用例 ：                                                                       *
#负责人   ：yangnan1                                                               *
#调用方法 ：调用关键字，输入小区ID                                                 *
Get HBPOD Actual Boards Index List
    [Documentation]    获得所有实际在位的板卡索引列表
    [Tags]    mandatory
    [Arguments]
    [Teardown]
    [Timeout]    5S
    [Return]    @{boardIndex_list}
    @{board_list}    Create List
    @{som_slotNo_list}    Get Actual SlotNos In Gnb    som
    @{boardIndex_list}    Get Boards Of All SlotNos    @{som_slotNo_list}

#***********************************************************************************
#功能     ：A7.持续地Get基带板处理器状态，直到可用                                       *
#标签     ：mandatory                                                              *
#索引     ：无                                                                     *
#入参     ：处理器索引，例如0.0.6.1等                                     *
#返回值   ：基带实际槽位号列表                                               *
#后处理   ：无                                                                     *
#超时     ：3600S                                                                     *
#所属模块 ：DEV                                                                   *
#适用用例 ：                                                                       *
#负责人   ：yangnan1                                                              *
#调用方法 ：调用关键字，输入基带板处理器索引，例如0.0.6.1等                                               *
Get HBPOD Processors Until Enabled
    [Documentation]    持续地Get处理器状态，直到可用
    [Tags]    mandatory
    [Arguments]    @{processorIndex_list}
    [Teardown]
    [Timeout]    3600S
    [Return]
    ${procRowStatus_oid}    Get Oid By Name    ${Mib}    procRowStatus
    :FOR    ${processorIdx}    IN    @{processorIndex_list}
    \    ${procRowStatus}    Get Until CreateGo    ${procRowStatus_oid}    ${processorIdx}
    \    ${procOperationalState_oid}    Get Oid By Name    ${Mib}    procOperationalState
    \    ${procOperationalState}    Get Until Enabled    ${procOperationalState_oid}    ${processorIdx}
    \    Log    ${procOperationalState}

#***********************************************************************************
#功能     ：A7.持续地Get基带板卡状态，直到可用                                       *
#标签     ：mandatory                                                              *
#索引     ：无                                                                     *
#入参     ：处理器索引，例如0.0.6.1等                                     *
#返回值   ：主控或基带实际槽位号列表                                               *
#后处理   ：无                                                                     *
#超时     ：3600S                                                                     *
#所属模块 ：DEV                                                                   *
#适用用例 ：                                                                       *
#负责人   ：yangnan1                                                              *
#调用方法 ：调用关键字，输入处理器索引，例如0.0.6.1等                                                *
Get HBPOD Boards Until Enabled
    [Documentation]    持续地Get板卡状态，直到可用
    [Tags]    mandatory
    [Arguments]    @{boardIndex_list}
    [Teardown]
    [Timeout]    3600S
    [Return]
    ${boardRowStatus_oid}    Get Oid By Name    ${Mib}    boardRowStatus
    :FOR    ${boardIdx}    IN    @{boardIndex_list}
    \    ${boardRowStatus}    Get Until CreateGo    ${boardRowStatus_oid}    ${boardIdx}
    \    ${boardOperationalState_oid}    Get Oid By Name    ${Mib}    boardOperationalState
    \    ${boardOperationalState}    Get Until Enabled    ${boardOperationalState_oid}    ${boardIdx}
    \    Log    ${boardOperationalState}

#***********************************************************************************
#功能     ：A7.持续地Get小区状态，直到可用                                       *
#标签     ：mandatory                                                              *
#索引     ：无                                                                     *
#入参     ：处理器索引，例如0.0.0.0, 0.0.6.1等                                     *
#返回值   ：主控或基带实际槽位号列表                                               *
#后处理   ：无                                                                     *
#超时     ：3600S                                                                     *
#所属模块 ：CELL                                                                   *
#适用用例 ：                                                                       *
#负责人   ：yangnan1                                                              *
#调用方法 ：调用关键字，输入小区ID                                                 *
Get Cell Until Enabled
    [Documentation]    持续地Get板卡状态，直到可用
    [Tags]    mandatory
    [Arguments]    @{CellIdList}
    [Teardown]
    [Timeout]    3600S
    [Return]
    ${nrCellRowStatus_oid}    Get Oid By Name    ${Mib}    nrCellRowStatus
    Log    ${nrCellRowStatus_oid}
    :FOR    ${nrCellIdx}    IN    @{CellIdList}
    \    ${nrCellRowStatus}    Get Until CreateGo    ${nrCellRowStatus_oid}    ${nrCellIdx}
    \    ${nrCellOperationalState_oid}    Get Oid By Name    ${Mib}    nrCellOperationalState
    \    Log    ${nrCellOperationalState_oid}
    \    ${nrCellOperationalState}    Get Until Enabled    ${nrCellOperationalState_oid}    ${nrCellIdx}
    \    Log    ${nrCellOperationalState}

#***********************************************************************************
#功能     ：A10.无时钟下持续地Get处理器状态，直到可用                               *
#标签     ：mandatory                                                              *
#索引     ：无                                                                     *
#入参     ：处理器索引，例如0.0.0.0, 0.0.6.1等                                     *
#返回值   ：主控或基带实际槽位号列表                                               *
#后处理   ：无                                                                     *
#超时     ：3600S                                                                  *
#所属模块 ：CELL                                                                   *
#适用用例 ：                                                                       *
#负责人   ：majingwei                                                              *
#调用方法 ：调用关键字，输入小区ID                                                 *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Get All Processors Until Enabled When No Clock
    [Documentation]    无时钟下持续地Get处理器状态，直到可用
    [Tags]    mandatory
    [Arguments]    @{processorIndex_list}
    [Teardown]
    [Timeout]    3600S
    [Return]
    ${procRowStatus_oid}    Get Oid By Name    ${Mib}    procRowStatus
    :FOR    ${processorIdx}    IN    @{processorIndex_list}
    \    ${procRowStatus}    Get Until CreateGo    ${procRowStatus_oid}    ${processorIdx}
    \    ${procOperationalState_oid}    Get Oid By Name    ${Mib}    procOperationalState
    \    ${procOperationalState}    Get Until Enabled For Processors    ${procOperationalState_oid}    ${processorIdx}
    \    Log    ${procOperationalState}


#***********************************************************************************
#功能     ：A8.反复删建指定ID的小区                                                *
#标签     ：                                                                       *
#索引     ：CellId                                                                 *
#入参     ：CellId                                                                 *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：SFT                                                                    *
#适用用例 ：反复删建指定小区                                                       *
#负责人   ：majingwei                                                              *
#调用方法 ：调用关键字，输入小区Id                                                 *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
DelAddNrCellRepeatedly
    [Documentation]    反复删建小区测试
    [Tags]    mandatory
    [Arguments]    ${NRCellId}
    Cell Should be enabled    ${NRCellId}
    DeActive Cell    ${NRCellId}
    Cell Should be Disabled    ${NRCellId}
    LocalCell Should be Setup    ${NRCellId}
    Delete LocalCell    ${NRCellId}
    Setup LocalCell    ${NRCellId}
    LocalCell Should be Setup    ${NRCellId}
    Active Cell    ${NRCellId}
    Cell Should be enabled    ${NRCellId}