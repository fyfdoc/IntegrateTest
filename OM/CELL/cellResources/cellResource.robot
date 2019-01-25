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
*A1.根据名称查询有效列表              -> Get List By Name                            |
*A2.根据名称查询有效一维索引列表      -> Get Index List By Name                      |
*A3.查询有效小区列表                  -> Get Useful Cell List                        |
*A4.根据本地小区ID查询RRUNO           -> Get RruNo By LcID                           |
*A5.天线校准结果查询                  -> PeriodCalRowStatus Should be CreateAndGo    |
*##动作类关键字##                                                                    |
*B1.去激活后重新激活小区              -> Reset Cell Active Trigger                   |
*B2.设置校准开关                      -> Set CalAc Switch                            |
*B3.设置周期校准参数                  -> Set PeriodCal                               |
*B4.下载配置文件                      -> Cur Cfg File Download                       |
*##命令类关键字##                                                                    |
*C1.设置天线校准命令                  -> Set AntCal Command                          |
_____________________________________________________________________________________|

************************************************资源文件头结束**************************************************
'''
from pysnmp.smi.rfc1902 import ObjectIdentity

*** Settings ***
Library                            SnmpLibrary
Library                            BuiltIn
Library                            Collections
Library                            ../../utils/CiUtils.py
Resource                           ../../COMM/commResources/SnmpMibHelper.robot
Resource                           ../../COMM/commResources/GnbCommands.robot
Resource                           ../../SFT/sftResources/BBUupgrade_Res.robot
Resource                           ../../OutPermission/opResources/opResource.robot

*** Variables ***
${Mib}                    DTM-TD-LTE-ENODEB-ENBMIB
${Cell_enabled}           enabled
${Trigger_is_active}      active
${ANTCAL_CMD_SET}    OM_MCELL_Ant_SetTest1Switch    1
${ANTCAL_CMD_REC}    OM_MCELL_Ant_SetTest1Switch    0

*** Keywords ***
#***********************************************************************************
#功能     ：A1.根据名称查询有效列表                                                *
#标签     ：                                                                       *
#索引     ：无                                                                     *
#入参     ：Name        节点名称                                                   *
#         : MaxRange    最大循环                                                   *
#返回值   ：Result_List 有效的结果list                                             *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：CELL                                                                   *
#适用用例 ：                                                                       *
#负责人   : libo8                                                                  *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Get List By Name
    [Documentation]    根据名称查询有效列表
    [Tags]
    [Arguments]    ${Name}    ${MaxRange}
    [Teardown]
    [Timeout]
    [Return]     @{Result_List}

    @{Result_List}    Create List
    ${oid}    Get Oid By Name    ${Mib}    ${Name}    #根据名称获取Oid
    :FOR    ${n}    IN RANGE    ${MaxRange}
    \    ${oidAndVal}    Get Next    ${oid}
    \    Log    oidAndVal = ${oidAndVal}
    \    Run Keyword If    ${oidAndVal} == ()    Exit For Loop
    \    Log Many    oid=${oidAndVal[0]}    value=${oidAndVal[1]}
    \    Append to List    ${Result_List}    ${oidAndVal[1]}
    \    ${oid}    Set Variable    ${oidAndVal[0]}
    log    ${Result_List}

#***********************************************************************************
#功能     ：A2.根据名称查询有效列表                                                *
#标签     ：                                                                       *
#索引     ：无                                                                     *
#入参     ：Name        节点名称                                                   *
#         : MaxRange    最大循环                                                   *
#返回值   ：Result_List 有效的结果list                                             *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：CELL                                                                   *
#适用用例 ：                                                                       *
#负责人   : libo8                                                                  *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Get Index List By Name
    [Documentation]    根据名称查询有效一维索引列表
    [Tags]
    [Arguments]    ${Name}    ${MaxRange}
    [Teardown]
    [Timeout]
    [Return]     @{Result_List}

    @{Result_List}    Create List
    ${oid}    Get Oid By Name    ${Mib}    ${Name}    #根据名称获取Oid
    :FOR    ${n}    IN RANGE    ${MaxRange}
    \    ${oidAndVal}    Get Next    ${oid}
    \    Log    oidAndVal = ${oidAndVal}
    \    Run Keyword If    ${oidAndVal} == ()    Exit For Loop
    \    Log Many    oid=${oidAndVal[0]}    value=${oidAndVal[1]}
    \    ${oid_index}    Get Oid Index    ${oidAndVal[0]}
    \    Append to List    ${Result_List}    ${oid_index}
    \    log    ${oid_index}
    \    ${oid}    Set Variable    ${oidAndVal[0]}
    log    ${Result_List}

#***********************************************************************************
#功能     ：A3.查询有效小区列表                                                    *
#标签     ：                                                                       *
#索引     ：无                                                                     *
#入参     ：无                                                                     *
#返回值   ：Result_List 有效的结果list                                             *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：CELL                                                                   *
#适用用例 ：                                                                       *
#负责人   : libo8                                                                  *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Get Useful Cell List
    [Documentation]    查询有效小区列表
    [Tags]
    [Arguments]
    [Teardown]
    [Timeout]
    [Return]     @{Result_List}

    @{Result_List}    Create List
    @{LcID_List}    Get Index List By Name    nrCellRowStatus    ${36}
    :FOR    ${idx}    IN    @{LcID_List}
    \    ${Trigger_Value}    Get By Name    nrCellActiveTrigger    idx=${idx}
    \    Log    ${Trigger_Value}
    \    Continue For Loop If    '${Trigger_Value}' != '${Trigger_is_active}'

    #获取小区状态
    \    ${curCellStatus_Value}    Get By Name    nrCellOperationalState    idx=${idx}
    \    Log        ${curCellStatus_Value}
    \    Continue For Loop If    '${curCellStatus_Value}' != '${Cell_enabled}'

    \    Append to List    ${Result_List}    ${idx}
    log    @{Result_List}

#***********************************************************************************
#功能     ：A4.根据本地小区ID查询RRUNO                                             *
#标签     ：                                                                       *
#索引     ：无                                                                     *
#入参     ：LcID        本地小区ID                                                 *
#返回值   ：RruNo                                                                  *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：CELL                                                                   *
#适用用例 ：                                                                       *
#负责人   : libo8                                                                  *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Get RruNo By LcID
    [Documentation]    根据本地小区ID查询RRUNO
    [Tags]
    [Arguments]    ${LcID}
    [Teardown]
    [Timeout]
    [Return]     ${RruNo}

    ${RruNo}    Set Variable    ${-1}
    @{RruNO_List}    Get Index List By Name    netRRURowStatus    ${96}
    #根据RRU列表获取小区ID
    :FOR    ${rruNo}    IN    @{RruNO_List}
    \    ${localCellID}    Get By Name    netSetRRUPortSubtoLocalCellId    idx=@{${rruNo},1}
    \    Continue For Loop If    ${localCellID} != ${LcID}
    \    ${RruNo}    Set Variable    ${rruNo}
    \    Exit for Loop

#***********************************************************************************
#功能     ：A5.天线校准结果查询                                                    *
#标签     ：                                                                       *
#索引     ：无                                                                     *
#入参     ：LcID     本地小区ID                                                    *
#         ：RruNo    RRU编号                                                       *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：CELL                                                                   *
#适用用例 ：                                                                       *
#负责人   : libo8                                                                  *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
PeriodCalRowStatus Should be CreateAndGo
    [Documentation]    天线校准结果查询
    [Tags]
    [Arguments]    ${LcID}    ${RruNo}
    [Teardown]
    [Timeout]
    [Return]

    ${perCalRowStatus_Value}    ${error}   Get With Error By Name    periodCalibrationRowStatus    idx=@{${RruNo}, 1}
    Should Not Be Equal    ${error}    ${OM_SNMP_GET_NOT_EXIST}
    Should Be Equal    ${perCalRowStatus_Value}    ${RowStatus_createAndGo}

#***********************************************************************************
#功能     ：B1.去激活后重新激活小区                                                *
#标签     ：                                                                       *
#索引     ：无                                                                     *
#入参     ：LcID        本地小区ID                                                 *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：CELL                                                                   *
#适用用例 ：                                                                       *
#负责人   : libo8                                                                  *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Reset Cell Active Trigger
    [Documentation]    去激活后重新激活小区
    [Tags]
    [Arguments]    ${LcID}
    [Teardown]
    [Timeout]
    [Return]

    DeActive Cell    ${LcID}
    Cell Should be Disabled    ${LcID}
    Active Cell    ${LcID}
    Cell Should be enabled    ${LcID}

#***********************************************************************************
#功能     ：B2.设置校准开关                                                        *
#标签     ：                                                                       *
#索引     ：无                                                                     *
#入参     ：calAcValue  校准开关                                                   *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：CELL                                                                   *
#适用用例 ：                                                                       *
#负责人   : libo8                                                                  *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Set CalAc Switch
    [Documentation]    设置校准开关
    [Tags]
    [Arguments]    ${calAcValue}
    [Teardown]
    [Timeout]
    [Return]

    Set By Name    calAcEnable    ${calAcValue}
    ${calAc_Value}    Get By Name    calAcEnable
    Should be equal    ${calAc_Value}    ${calAcValue}

#***********************************************************************************
#功能     ：B3.设置周期校准参数                                                    *
#标签     ：                                                                       *
#索引     ：无                                                                     *
#入参     ：无                                                                     *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：CELL                                                                   *
#适用用例 ：                                                                       *
#负责人   : libo8                                                                  *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Set PeriodCal
    [Documentation]    设置周期校准参数
    [Tags]
    [Arguments]
    [Teardown]
    [Timeout]
    [Return]

    Set By Name    calAcPeriod    ${60}
    Set CalAc Switch    enable

#***********************************************************************************
#功能     ：B4.下载配置文件                                                        *
#标签     ：                                                                       *
#索引     ：无                                                                     *
#入参     ：FullPath  待升级包的全路径                                             *
#         ：feName    文件扩展名                                                   *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：CELL                                                                   *
#适用用例 ：                                                                       *
#负责人   : libo8                                                                  *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Cur Cfg File Download
    [Documentation]    下载配置文件
    [Tags]
    [Arguments]    ${FullPath}    ${feName}
    [Teardown]
    [Timeout]
    [Return]

    #文件路径预处理
    ${result}    ${dirName}   ${fileName}    File Path Prepare    ${FullPath}    ${feName}
    log    ${result}
    Should be equal    ${result}    ${True}

    #获取文件传输编号
    ${AvailableID}    Get By Name    fileTransNextAvailableIDForOthers
    log    ${AvailableID}

    #设置文件传输任务
    Set Many By Name
    ...                         fileTransRowStatus    createAndGo    idx=${AvailableID}
    ...                         fileTransType    cfgPatchFile   idx=${AvailableID}              # 传输文件类型
    ...                         fileTransIndicator    download    idx=${AvailableID}            # 上下载指示
    ...                         fileTransFTPDirectory    ${dirName}    idx=${AvailableID}       # FTP服务器上的文件路径
    ...                         fileTransFileName    ${fileName}    idx=${AvailableID}          # 文件名称

    
    #结果验证
    ${fileTransPercent_Value}    ${error}   Get With Error By Name    fileTransRowStatus    idx=${AvailableID}
    Should not be equal    ${error}    ${OM_SNMP_GET_NOT_EXIST}
    Sleep    7
    ${fileTransPercent_Value}    ${error}   Get With Error By Name    fileTransRowStatus    idx=${AvailableID}
    Should be equal    ${error}    ${OM_SNMP_GET_NOT_EXIST}
    
    #保存配置文件
    Set Many By Name
    ...                         configFileSaveTrigger    on
    ...							configFileSaveName    NULL
    
    Sleep    10

#***********************************************************************************
#功能     ：B5.下载配置文件升级BBU版本建小区                                       *
#标签     ：                                                                       *
#索引     ：无                                                                     *
#入参     ：cfgPath    配置文件路径                                                *
#         ：bbuPath    BBU大包路径                                                 *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：CELL                                                                   *
#适用用例 ：                                                                       *
#负责人   : libo8                                                                  *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Cell Should be enabled For CfgAndVer Upgrade
    [Documentation]    下载配置文件
    [Tags]
    [Arguments]    ${cfgPath}    ${bbuPath}
    [Teardown]
    [Timeout]
    [Return]

    #获取可用的板卡和处理器
    @{processorIndex_list}    Get All Actual Processors Index List
    Log List    @{processorIndex_list}
    @{boardIndex_list}    Get All Actual Boards Index List
    Log List    @{boardIndex_list}

    #获取可用的小区ID
    ${nrCellCfgRowStatus_oid}    Get Oid By Name    ${Mib}    nrCellCfgRowStatus
    Log    ${nrCellCfgRowStatus_oid}

    #更换配置文件
    Log To Console    \nBBU正在更换配置文件
    Cur Cfg File Download    ${cfgPath}   .cfg

    #版本升级
    Set Upgrade Commands    ${bbuPath}    instantDownload
    Log To Console    \nBBU正在进行版本下载，请等待14分钟
    Sleep    14min
    Set No Clk Mode
    Get All Boards Until Enabled    @{boardIndex_list}
    Get All Processors Until Enabled    @{processorIndex_list}

    Connect Hsctd Pid2
    ${Ret_NoAAU}    Set No AAU Mode
    Log    ${Ret_NoAAU}
    Disconnect UAgent Use Pid

    #小区建立
    :for    ${lcId}    in    @{CellIdList}
    \    Setup LocalCell    ${lcId}
    \    LocalCell Should be Setup    ${lcId}
    \    Active Cell    ${lcId}
    \    Cell Should be enabled    ${lcId}

#***********************************************************************************
#功能     ：B6.恢复配置文件恢复BBU版本建小区                                       *
#标签     ：                                                                       *
#索引     ：无                                                                     *
#入参     ：cfgPath    配置文件路径                                                *
#         ：bbuPath    BBU大包路径                                                 *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：CELL                                                                   *
#适用用例 ：                                                                       *
#负责人   : libo8                                                                  *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Cell Should be enabled For CfgAndVer Recover
    [Documentation]    下载配置文件
    [Tags]
    [Arguments]    ${cfgPath}    ${bbuPath}
    [Teardown]
    [Timeout]
    [Return]

    #更换配置文件
    Log To Console    \nBBU正在更换配置文件
    Cur Cfg File Download    ${cfgPath}   .cfg

    #获取可用的板卡和处理器
    @{processorIndex_list}    Get All Actual Processors Index List
    Log List    @{processorIndex_list}
    @{boardIndex_list}    Get All Actual Boards Index List
    Log List    @{boardIndex_list}

    #获取可用的小区ID
    ${nrCellCfgRowStatus_oid}    Get Oid By Name    ${Mib}    nrCellCfgRowStatus
    Log    ${nrCellCfgRowStatus_oid}

    #版本升级
    Set Upgrade Commands    ${bbuPath}    instantDownload
    Log To Console    \nBBU正在进行版本下载，请等待14分钟
    Sleep    14min
    Set No Clk Mode
    Get All Boards Until Enabled    @{boardIndex_list}
    Get All Processors Until Enabled    @{processorIndex_list}

    Connect Hsctd Pid2
    ${Ret_NoAAU}    Set No AAU Mode
    Log    ${Ret_NoAAU}
    Disconnect UAgent Use Pid

    #小区建立
    :for    ${lcId}    in    @{CellIdList}
    \    Setup LocalCell    ${lcId}
    \    LocalCell Should be Setup    ${lcId}
    \    Active Cell    ${lcId}
    \    Cell Should be enabled    ${lcId}
#***********************************************************************************
#功能     ：C1.设置天线校准命令                                                    *
#标签     ：                                                                       *
#索引     ：无                                                                     *
#入参     ：LcID     本地小区ID                                                    *
#         ：RruNo    RRU编号                                                       *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：CELL                                                                   *
#适用用例 ：                                                                       *
#负责人   : libo8                                                                  *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Set AntCal Command
    [Documentation]    设置天线校准命令
    [Tags]
    [Arguments]    ${LcID}    ${RruNo}
    [Teardown]
    [Timeout]
    [Return]

    Execute Command    ${ANTCAL_CMD_SET}
    ${execute_result}=    Execute Command by UAgent    OM_MCAL_AntCalStart    ${LcID}    ${RruNo}
    Should be equal    ${execute_result}    ${0}
    Sleep    5
    Execute Command    ${ANTCAL_CMD_REC}

