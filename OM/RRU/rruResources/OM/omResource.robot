# encoding utf-8
'''
*************************************************************
*** COPYRIGHT DaTang Mobile Communications Equipment CO.,LTD
*************************************************************
*文件名称：omResource.robot
*功能描述：RRU OM相关资源文件：涉及关键字列表
*使用方法：

-----------------------------------------------------------------------------------
*修改记录：                                                                       |
*##修改日期    |    修改人    |    修改描述    |                                  |
*2018-12-06        zhaobaoxin      创建文件                                       |
*2018-12-06        wangyan11       添加AAU包裁剪功能测试关键字                    |
*2018-12-08        zhaobaoxin      移植关键字                                     |
----------------------------------------------------------------------------------|
*************************************************************
______________________________________________________________________________________
*关键字目录：                                                                        |
-------------------------------------------------------------------------------------|
*##AAU相关关键字##                                                                   |
*A1.创建AAU软件大包下载实例           -> Create Instance If Not Exist                |
*A2.修改软件大包下载实例              -> Modify Instance If Exist                    |
*A3.AAU托包升级回退                   -> AAU VerUpAndBack                            |
*A4.通过OID名称获取可用的AAU集        -> Get Useful RowStatus By Name                |
*A5.查询指定AAU接入状态               -> Display AAU Access Phase                    |
*A6.查询所有可用的AAU的接入状态       -> Get AAU Access Phase Until Available        |
*A7.AAU重启之后的状态检查             -> AAU Status Check After Restart              |
*A8.获取小区可操作状态                -> Get Cell Operational State Until Enable     |
*A9.激活已存在的实例小区              -> Set Cell Active Trigger                     |
*A10.激活小区后判断是否可用           -> NRCell Should Enabled After Active          |
*A11.AAU托包升级回退后版本号比较      -> AAU Compare Version After VerUpAndBack      |
*A12.AAU托包升级回退后子版本号比较    -> AAU Compare SubVersion After VerUpAndBack   |
*A13.获取软件包信息                   -> Get SoftPack Info                           |
*A14.根据软件包信息Set MIB节点        -> AAU PackDownload Set Instance               |
*A15.AAU包裁剪功能测试                -> AAU PackCut Function Check                  |
*A16.ata2目录下查找是否存在AAU小包    -> Find AAU Sub File In ATA2                   |
*A17.根据软件包信息Set MIB节点        -> AAU PackDownload Set Instance               |
*A18.AAU Power Off                    -> Power Off AAU                               |
*A19.设置重启方式                     -> Set RRUResetTrigger Value                   |
*A20.AAU不影响下一级掉电              -> AAU Reset                                   |
_____________________________________________________________________________________|

************************************************资源文件头结束**************************************************
'''
from pysnmp.smi.rfc1902 import ObjectIdentity

*** Settings ***
Library    SnmpLibrary
Library    DateTime
Library    Collections
Library    ../../../utils/CiUtils.py
Library    ../../../utils/FileHandler.py
Library    ../../../utils/OM_SFT_ApiFile.py

*** Variables ***
#Variables of Keyword：Cell Should be Enabled
${host_name_hsctd}    'HSCTD'
${host_address_hsctd}   172.27.245.92
${pId}    ${2}

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
#功能     ：A1.创建AAU软件大包下载实例                                              *
#标签     ：mandatory                                                              *
#索引     ：无                                                                     *
#入参     ：PackName      外设软件包名称                                           *
#           subpackageNum 外设软件拆包个数                                         *
#           splitAAUPath  外设软件包路径                                           *
#           Version       软件包路径                                               *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：RRU                                                                    *
#适用用例 ：                                                                       *
#负责人   : zhaobaoxin                                                             *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Create Instance If Not Exist
    [Documentation]    创建AAU软件大包下载实例
    [Tags]    mandatory
    [Arguments]    ${PackName}    ${subpackageNum}    ${splitAAUPath}    ${Version}
    [Teardown]
    [Timeout]
    [Return]    ${SetIsDone}

    ${ret}    ${error}    Get With Error By Name    peripheralPackPlanRowStatus    idx=${1}
    Log    ${error}

    Run Keyword If    ${error} == ${OM_SNMP_GET_NOT_EXIST}
    ...    Set Many By Name    peripheralPackPlanRowStatus    createAndGo    idx=${1}
    ...                                 peripheralPackPlanPackName    ${PackName}    idx=${1}    # 软件包名称
    ...                                 peripheralPackPlanVendor    null    idx=${1}    # 厂家信息
    ...                                 peripheralPackPlanVersion    ${Version}    idx=${1}    # 软件包版本
    ...                                 peripheralPackPlanDownloadIndicator    ${DownloadIndicator}    idx=${1}    # 软件包自动下载标志
#    ...                                 peripheralPackPlanScheduleDownloadTime    ${GetTime}    idx=${1}    # 软件包下载时间
    ...                                 peripheralPackPlanDownloadDirectory    ${splitAAUPath}    idx=${1}    # 软件包自动下载路径
    ...                                 peripheralPackPlanActivateIndicator    ${ActivateIndicator}    idx=${1}    # 激活标志
#    ...                                 peripheralPackPlanScheduleActivateTime    1900-01-01    idx=${1}    # 软件包定时激活或去激活时间
    ...                                 peripheralPackPlanRelyVesion    null    idx=${1}    # 补丁包依赖版本
    ...                                 peripheralPackPlanSubPackNumber    ${subpackageNum}    idx=${1}    # 外设软件拆包个数
    #SetIsDone：标记是否已经set动作
    ${SetIsDone}    Set Variable If    ${error} == ${OM_SNMP_GET_NOT_EXIST}    ${True}    ${False}

#***********************************************************************************
#功能     ：A2.修改软件大包下载实例                                                *
#标签     ：mandatory                                                              *
#索引     ：无                                                                     *
#入参     ：PackName      外设软件包名称                                           *
#           subpackageNum 外设软件拆包个数                                         *
#           splitAAUPath  外设软件包路径                                           *
#           Version       软件包路径                                               *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：RRU                                                                    *
#适用用例 ：                                                                       *
#负责人   : zhaobaoxin                                                             *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Modify Instance If Exist
    [Documentation]    修改软件大包下载实例
    [Tags]    mandatory
    [Arguments]    ${PackName}    ${subpackageNum}    ${splitAAUPath}    ${Version}
    [Teardown]
    [Timeout]
    [Return]    ${True}

    Set Many By Name
    ...                                 peripheralPackPlanPackName    ${PackName}    idx=${1}    # 软件包名称
    ...                                 peripheralPackPlanVendor    null    idx=${1}    # 厂家信息
    ...                                 peripheralPackPlanVersion    ${Version}    idx=${1}    # 软件包版本
    ...                                 peripheralPackPlanDownloadIndicator    ${DownloadIndicator}    idx=${1}   # 软件包自动下载标志
#    ...                                 peripheralPackPlanScheduleDownloadTime    ${GetTime}    idx=${1}     # 软件包下载时间
    ...                                 peripheralPackPlanDownloadDirectory    ${splitAAUPath}    idx=${1}    # 软件包自动下载路径
    ...                                 peripheralPackPlanActivateIndicator    ${ActivateIndicator}    idx=${1}    # 激活标志
#    ...                                 peripheralPackPlanScheduleActivateTime    1900-01-01    idx=${1}    # 软件包定时激活或去激活时间
    ...                                 peripheralPackPlanRelyVesion    null    idx=${1}    # 补丁包依赖版本
    ...                                 peripheralPackPlanSubPackNumber    ${subpackageNum}    idx=${1}    # 外设软件拆包个数

#***********************************************************************************
#功能     ：A3.AAU托包升级回退                                                     *
#标签     ：mandatory                                                              *
#索引     ：无                                                                     *
#入参     ：FullPath 软件包路径 DownloadIndicator 下载指示                         *
#返回值   ：成功 True  失败 False                                                  *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：RRU                                                                    *
#适用用例 ：                                                                       *
#负责人   : zhaobaoxin                                                             *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
AAU VerUpAndBack
    [Documentation]    AAU托包升级回退
    [Tags]    mandatory
    [Arguments]    ${FullPath}    ${DownloadIndicator}
    [Teardown]
    [Timeout]
    [Return]    ${True}

    #Step1:获取下载的AAU软件包信息
    ${subpackageNum}    ${splitAAUPath}    ${Version}     Get SoftPack Info    ${FullPath}

    Log to Console    \n 软件版本：${Version} 分包个数：${subpackageNum}
    Log to Console    \n 软件路径：${splitAAUPath}

    #Step2:根据软件包信息，触发set事件
    AAU PackDownload Set Instance    ${DownloadIndicator}    ${subpackageNum}    ${splitAAUPath}    ${Version}

    #Step3:删除下载的小包
    Log To Console    \n等待一分钟，小包下载结束后删除小包
    Sleep    1min
    delSplitedPackage    ${subpackageNum}    ${FullPath}

    #Step4:等待软件下载
    Log To Console    \nAAU正在进行版本下载，请等待10分钟
    Sleep    10min

    #Step5:重启后检查状态
    #RRU接入状态
    Get AAU Access Phase Until Available
    #小区激活后可用
    NRCell Should Enabled After Active
    #软件版本检查
    #AAU Compare SubVersion After VerUpAndBack   ${FullPath}


#***********************************************************************************
#功能     ：A4.通过OID名称获取可用的AAU集                                          *
#标签     ：mandatory                                                              *
#索引     ：无                                                                     *
#入参     ：RowStatusName 行状态名称                                               *
#返回值   ：RruNo_List 可用的AAU集                                                 *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：RRU                                                                    *
#适用用例 ：                                                                       *
#负责人   : zhaobaoxin                                                             *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Get Useful RowStatus By Name
    [Documentation]    通过OID名称获取可用的AAU集
    [Tags]    mandatory
    [Arguments]    ${RowStatusName}
    [Teardown]
    [Timeout]    10min
    [Return]     @{RruNo_List}

    @{RruNo_List}   Create List

    ${RruEntry}    Get Oid By Name    ${Mib}    ${RowStatusName}
    @{RruNo_Instance}    get topoRRUNo Instance    ${RruEntry}    ${topoRRUNo_Max}
    #Log    @{RruNo_Instance}
    Run Keyword If    @{RruNo_Instance} == [ ]    Log To Console    \n 无可用的射频单元！

    ${RruEntry}    Get Oid By Name    ${Mib}    topoRRURowStatus
    :FOR    ${RruNo}    IN    @{RruNo_Instance}
    \    ${RowStatus}    Get Until CreateGo    ${RruEntry}    ${RruNo}
    \    Run Keyword If    '${RowStatus}' == 'createAndGo'
    ...    Append to List     ${RruNo_List}    ${RruNo}

#***********************************************************************************
#功能     ：A5.查询指定AAU接入状态                                                 *
#标签     ：mandatory                                                              *
#索引     ：无                                                                     *
#入参     ：RRUNo 射频单元号                                                       *
#返回值   ：成功 True  失败 False                                                  *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：RRU                                                                    *
#适用用例 ：                                                                       *
#负责人   : zhaobaoxin                                                             *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Display AAU Access Phase
    [Documentation]    查询指定AAU接入状态
    [Tags]    mandatory
    [Arguments]    ${RRUNo}
    [Teardown]
    [Timeout]

    Log To Console    \n射频单元接入状态:
    :FOR    ${Loop_time}    IN RANGE    ${50}
    \    ${ret}    Get By Name    topoRRUAccessPhase    idx=${RRUNo}
    \    Run Keyword If    '${ret}' == ${RRUAccessPhase_0}    Log To Console    未知 \n
    \    Run Keyword If    '${ret}' == ${RRUAccessPhase_1}    Log To Console    广播接入完成,通道建立阶段 \n
    \    Run Keyword If    '${ret}' == ${RRUAccessPhase_2}    Log To Console    通道建立完成,版本更新阶段 \n
    \    Run Keyword If    '${ret}' == ${RRUAccessPhase_3}    Log To Console    版本更新完成,时延测量阶段 \n
    \    Run Keyword If    '${ret}' == ${RRUAccessPhase_4}    Log To Console    时延测量完成,天线参数配置阶段 \n
    \    Run Keyword If    '${ret}' == ${RRUAccessPhase_5}    Log To Console    天线参数配置完成,初始化校准结果上报阶段 \n
    \    Run Keyword If    '${ret}' == ${RRUAccessPhase_6}    Log To Console    RRU接入完成 \n
    \    Continue For Loop If    '${ret}' != ${RRUAccessPhase_6}
    \    Sleep    4s
    \    Return From Keyword If    '${ret}' == ${RRUAccessPhase_6}    ${True}
    [Return]    ${False}

#***********************************************************************************
#功能     ：A6.查询所有可用的AAU的接入状态                                         *
#标签     ：mandatory                                                              *
#索引     ：无                                                                     *
#入参     ：无                                                                     *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：RRU                                                                    *
#适用用例 ：                                                                       *
#负责人   : zhaobaoxin                                                             *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Get AAU Access Phase Until Available
    [Documentation]    查询所有可用的AAU的接入状态
    [Tags]    mandatory
    [Arguments]
    [Teardown]
    [Timeout]    10min

    #射频单元行状态 射频单元规划
    @{RRUNo_list}    Get Useful RowStatus By Name    netRRURowStatus
    ${RRUAccessPhase_oid}    Get Oid By Name    ${Mib}    topoRRUAccessPhase
    :FOR    ${RRUNo}    in    @{RRUNo_list}
    \    log    ${RRUNo}
    \    ${AauAccessPhase}    Get Until RRU Available    ${RRUAccessPhase_oid}    ${RRUNo}

#***********************************************************************************
#功能     ：A8.获取小区可操作状态                                                 *
#标签     ：mandatory                                                              *
#索引     ：无                                                                     *
#入参     ：CellLcId 可用的小区号                                                  *
#返回值   ：成功 True  失败 False                                                  *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：RRU                                                                    *
#适用用例 ：                                                                       *
#负责人   : zhaobaoxin                                                             *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Get Cell Operational State Until Enable
    [Documentation]    获取小区可操作状态
    [Tags]    mandatory
    [Arguments]    @{CellLcId}
    [Teardown]
    [Timeout]    10min

    :FOR    ${index}    IN     @{CellLcId}
    \    ${OperationalState_oid}    Get Oid By Name    ${Mib}    nrCellOperationalState
    \    ${OperationalState}    get until enabled    ${OperationalState_oid}     idx=${index}

#***********************************************************************************
#功能     ：A9.激活已存在的实例小区                                               *
#标签     ：mandatory                                                              *
#索引     ：无                                                                     *
#入参     ：CellLcId 可用的小区号                                                  *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：RRU                                                                    *
#适用用例 ：                                                                       *
#负责人   : zhaobaoxin                                                             *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Set Cell Active Trigger
    [Documentation]    激活已存在的实例小区
    [Tags]    mandatory
    [Arguments]    @{CellLcId}
    [Teardown]
    [Timeout]

    :FOR    ${CellLcId}    IN     @{CellLcId}
    \    ${ret}    ${error}   Get With Error By Name    nrCellActiveTrigger    idx=${CellLcId}
    \    Continue For Loop If    ${error} > ${0}
    \    Run Keyword If    '${ret}' == 'deactive'    Set By Name    nrCellActiveTrigger    active    idx=${CellLcId}

#***********************************************************************************
#功能     ：A10.激活小区后判断是否可用                                             *
#标签     ：mandatory                                                              *
#索引     ：无                                                                     *
#入参     ：无                                                                     *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：RRU                                                                    *
#适用用例 ：                                                                       *
#负责人   : zhaobaoxin                                                             *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
NRCell Should Enabled After Active
    [Documentation]    激活小区后判断是否可用
    [Tags]    mandatory
    [Arguments]
    [Teardown]
    [Timeout]    10min

    ${CellRowStatus_oid}    Get Oid By Name    ${Mib}    nrCellRowStatus
    Log    ${CellRowStatus_oid}
    @{CellIdList}    get CellIDList    ${CellRowStatus_oid}    ${35}
    Get Cell Until Enabled    @{CellIdList}

#***********************************************************************************
#功能     ：A7.AAU重启之后的状态检查                                               *
#标签     ：mandatory                                                              *
#索引     ：无                                                                     *
#入参     ：无                                                                     *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：RRU                                                                    *
#适用用例 ：                                                                       *
#负责人   : zhaobaoxin                                                             *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
AAU Status Check After Restart
    [Documentation]    AAU重启之后的状态检查
    [Tags]    mandatory
    [Arguments]
    [Teardown]
    [Timeout]
    [Return]
    #${retAccessPhase}    Get AAU Access Phase Until Available
    Get AAU Access Phase Until Available
    #Run Keyword If    ${retAccessPhase} == ${False}    Log To Console    'RRU接入状态错误'
    #Should be equal    ${retAccessPhase}    ${True}
    NRCell Should Enabled After Active
    # Run Keyword If    ${retCellActive} == ${False}    Log To Console    'NRCell小区激活后不可用'
    # Should be equal    ${retCellActive}    ${True}

#***********************************************************************************
#功能     ：A11.AAU托包升级回退后版本号比较                                        *
#标签     ：mandatory                                                              *
#索引     ：无                                                                     *
#入参     ：AAU大包名称，eg:5GIIIAAU_new.dtz                                       *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：RRU                                                                    *
#适用用例 ：                                                                       *
#负责人   : wangyan11                                                              *
#调用方法 ：调用关键字,，输入AAU大包名称                                           *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
AAU Compare Version After VerUpAndBack
    [Documentation]    AAU托包升级回退后版本号比较
    [Tags]     mandatory
    [Arguments]    ${PackName}
    [Teardown]
    [Timeout]
    [Return]
    ${PackPlanVersion}    newGetVerNum    ${PackName}
    ${PackRunningVersion}    ${error}    Get With Error By Name    peripheralPackRunningVersion    idx=@{${1}, ${1}}
    Run Keyword If    ${error} == ${OM_SNMP_GET_NOT_EXIST}    Log To Console    \n PackRunningVersion get failed
    ${RunningVersion}    asciiCodeToWords    ${PackRunningVersion}
    Should be equal    ${RunningVersion}    ${PackPlanVersion}

#***********************************************************************************
#功能     ：A12.AAU托包升级回退后子版本号比较                                        *
#标签     ：mandatory                                                              *
#索引     ：无                                                                     *
#入参     ：AAU大包名称，eg:5GIIIAAU_new.dtz                                       *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：RRU                                                                    *
#适用用例 ：                                                                       *
#负责人   : wangyan11                                                              *
#调用方法 ：调用关键字,，输入AAU大包名称                                           *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
AAU Compare SubVersion After VerUpAndBack
    [Documentation]    AAU托包升级回退后子版本号比较
    [Tags]     mandatory
    [Arguments]    ${PackName}
    [Teardown]
    [Timeout]
    [Return]

    #pheralFileVersion subcript start 0
    @{pheralFileVersion}    Create List

    #search MIB get subversion after VerUpAndBack
    :FOR    ${index}    IN RANGE   1    6
    \    ${Version_lmt}    Get By Name    peripheralFileVersion    idx=@{1,1,1,${index}}
    \    ${Version_cvt}    asciiCodeToWords    ${Version_lmt}
    \    Append To List    ${pheralFileVersion}    ${Version_cvt}

    #call getSubVer function get subversion before VerUpAndBack
    @{SubVer}    getSubVer    ${PackName}

    #AIUFW
    Should be equal    @SubVer[${0}]    @pheralFileVersion[${2}]
    #ARUFW
    Should be equal    @SubVer[${1}]    @pheralFileVersion[${3}]
    #RRU.INI
    Should be equal    @SubVer[${2}]    @pheralFileVersion[${4}]
    #TDAU5164N78
    Should be equal    @SubVer[${3}]    @pheralFileVersion[${1}]
    #TDAU5164N79
    Should be equal    @SubVer[${4}]    @pheralFileVersion[${0}]

#***********************************************************************************
#功能     ：A13.获取软件包信息                                                     *
#标签     ：mandatory                                                              *
#索引     ：无                                                                     *
#入参     ：FullPath 软件包路径                                                    *
#返回值   ：成功 True  失败 False                                                  *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：RRU                                                                    *
#适用用例 ：                                                                       *
#负责人   : zhaobaoxin                                                             *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Get SoftPack Info
    [Documentation]    获取软件包信息
    [Arguments]    ${FullPath}
    [Teardown]
    [Timeout]
    [Return]    ${subpackageNum}    ${splitAAUPath}    ${Version}
    ${subpackageNum}    newSpiltPackage    ${FullPath}
    ${splitAAUPath}     get_splitBBUPath
    ${Version}          newGetVerNum    ${FullPath}

#***********************************************************************************
#功能     ：A17.根据软件包信息Set MIB节点                                          *
#标签     ：mandatory                                                              *
#索引     ：无                                                                     *
#入参     ：FullPath 软件包路径                                                    *
#返回值   ：成功 True  失败 False                                                  *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：RRU                                                                    *
#适用用例 ：                                                                       *
#负责人   : zhaobaoxin                                                             *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
AAU PackDownload Set Instance
    [Documentation]    AAU托包设置MIB节点
    [Tags]    mandatory
    [Arguments]    ${DownloadIndicator}    ${subpackageNum}    ${splitAAUPath}    ${Version}
    [Teardown]
    [Timeout]
    [Return]    ${True}
    ${ret}    Create Instance If Not Exist    5GIIIAAU.dtz    ${subpackageNum}    ${splitAAUPath}    ${Version}
    Log     ${ret}
    #SetIsDone：如果实例存在，则直接修改
    Run Keyword If     ${ret} == ${False}
    ...    Modify Instance If Exist    5GIIIAAU.dtz    ${subpackageNum}    ${splitAAUPath}    ${Version}

#***********************************************************************************
#功能     ：A15-AAU包裁剪功能测试                                                  *
#标签     ：                                                                       *
#索引     ：                                                                       *
#入参     ：                                                                       *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：0                                                                      *
#所属模块 ：RRU                                                                    *
#适用用例 ：                                                                       *
#负责人   ：wangyan11                                                              *
#调用方法 ：                                                                       *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
AAU PackCut Function Check
    [Documentation]    AAU包裁剪功能测试
    [Tags]    mandatory
    [Arguments]    ${fullPath}    ${DownloadIndicator}
    [Teardown]
    [Timeout]

    #连接设备
    Open Snmp Connection And Load Private MIB
    Connect Device by UAgent Use Pid    ${host_name_hsctd}    ${host_address_hsctd}    ${pId}

    #打开AAU包裁剪开关
    Set By Name    packRRUUpgradeCtrlSwitch    on
    Log to console    \n Set packRRUUpgradeCtrlSwitch On succeed!!

    #Step1:获取下载的AAU软件包信息
    ${subpackageNum}    ${splitAAUPath}    ${Version}     Get SoftPack Info    ${FullPath}
    Log to Console    \n 软件版本：${Version} 分包个数：${subpackageNum}
    Log to Console    \n 软件路径：${splitAAUPath}

    #Step2:根据软件包信息，触发set事件
    Set Many By Name
    ...                                 peripheralPackPlanPackName    5GIIIAAU.dtz    idx=${1}    # 软件包名称
    ...                                 peripheralPackPlanVendor    null    idx=${1}    # 厂家信息
    ...                                 peripheralPackPlanVersion    ${Version}    idx=${1}    # 软件包版本
    ...                                 peripheralPackPlanDownloadIndicator    ${DownloadIndicator}    idx=${1}   # 软件包自动下载标志
#    ...                                peripheralPackPlanScheduleDownloadTime    ${GetTime}    idx=${1}     # 软件包下载时间
    ...                                 peripheralPackPlanDownloadDirectory    ${splitAAUPath}    idx=${1}    # 软件包自动下载路径
    ...                                 peripheralPackPlanActivateIndicator    doNothing    idx=${1}    # 激活标志
#    ...                                peripheralPackPlanScheduleActivateTime    1900-01-01    idx=${1}    # 软件包定时激活或去激活时间
    ...                                 peripheralPackPlanRelyVesion    null    idx=${1}    # 补丁包依赖版本
    ...                                 peripheralPackPlanSubPackNumber    ${subpackageNum}    idx=${1}    # 外设软件拆包个数

    #Step3:删除下载的小包
    Log To Console    \n等待一分钟，小包下载结束后删除小包
    Sleep    1min
    delSplitedPackage    ${subpackageNum}    ${FullPath}

    #Step4:检查ATA2目录下是否存在对应文件
    ${RRUTypeName_lmt}    Get By Name    topoRRUTypeName    idx=${0}
    ${RRUTypeName_base}    asciiCodeToWords    ${RRUTypeName_lmt}
    ${RRUTypeName_str}    get_RRUTypeName    ${RRUTypeName_base}
    ${Ret}    Find AAU Sub File In ATA2    ${RRUTypeName_str}
    Log To Console    \n FileName is ${RRUTypeName_str}
    Should be equal    ${Ret}    ${0}

    :FOR    ${FlagNum}    IN RANGE    3
    \    ${FileName}    GetAAUSubFileName    ${FlagNum+1}
    \    ${Ret}    Find AAU Sub File In ATA2    ${FileName}
    \    Log To Console    \n FileName is ${FileName}
    \    Should be equal    ${Ret}    ${0}

    #断开设备
    Disconnect UAgent Use Pid

#***********************************************************************************
#功能     ：A16-ata2目录下查找是否存在AAU小包                                      *
#标签     ：                                                                       *
#索引     ：                                                                       *
#入参     ：                                                                       *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：0                                                                      *
#所属模块 ：RRU                                                                    *
#适用用例 ：                                                                       *
#负责人   ：wangyan11                                                              *
#调用方法 ：调用关键字，输入Find AAU Sub File In ATA2  文件名称                    *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Find AAU Sub File In ATA2
    [Documentation]    查询指定小区是否激活可用
    [Tags]    mandatory
    [Arguments]    ${FileName}
    [Teardown]
    [Timeout]

    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    OM_MFILE_FindDirFile    <80,[S;0;0;/ata2/VER/RRU/VENDOR1/VERSION1]>    <80,[S;0;0;${FileName}]>
    [Return]    ${execute_result}

#***********************************************************************************
#功能     ：A17.根据软件包信息Set MIB节点                                          *
#标签     ：mandatory                                                              *
#索引     ：无                                                                     *
#入参     ：FullPath 软件包路径                                                    *
#返回值   ：成功 True  失败 False                                                  *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：RRU                                                                    *
#适用用例 ：                                                                       *
#负责人   : zhaobaoxin                                                             *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
AAU PackDownload Set Instance
    [Documentation]    AAU托包设置MIB节点
    [Tags]    mandatory
    [Arguments]    ${DownloadIndicator}    ${subpackageNum}    ${splitAAUPath}    ${Version}
    [Teardown]
    [Timeout]
    [Return]    ${True}
    ${ret}    Create Instance If Not Exist    5GIIIAAU.dtz    ${subpackageNum}    ${splitAAUPath}    ${Version}
    Log     ${ret}
    #SetIsDone：如果实例存在，则直接修改
    Run Keyword If     ${ret} == ${False}
    ...    Modify Instance If Exist    5GIIIAAU.dtz    ${subpackageNum}    ${splitAAUPath}    ${Version}

#***********************************************************************************
#功能     ：A18.AAU Power Off                                                      *
#标签     ：mandatory                                                              *
#索引     ：                                                                       *
#入参     ：                                                                       *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：RRU                                                                    *
#适用用例 ：                                                                       *
#负责人   ：majingwei                                                              *
#调用方法 ：调用关键字，输入                                                       *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Power Off AAU
    [Documentation]    Multiple times poweroff AAU
    [Tags]         poweroff AAU
    [Arguments]    ${rangeno}
    [Teardown]
    [Timeout]

    :FOR    ${loop}    IN RANGE    ${rangeno}
    \   Set Many By Name    topoRRUResetTrigger    ${11}
    \   Sleep   180

    \   ${curLocalCellConfigState}    Get By Name    nrLocalCellConfigTrigger
    \   Should be equal    ${curLocalCellConfigState}    add

    \   ${curCellActiveState}    Get By Name    nrCellActiveTrigger
    \   Should be equal    ${curCellActiveState}    active

    \   ${curCellOperationalState}    Get By Name    nrCellOperationalState
    \   Should be equal    ${curCellOperationalState}    enabled

#***********************************************************************************
#功能     ：A19.设置重启方式                                                       *
#标签     ：mandatory                                                              *
#索引     ：                                                                       *
#入参     ：                                                                       *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：RRU                                                                    *
#适用用例 ：                                                                       *
#负责人   ：majingwei                                                              *
#调用方法 ：调用关键字，输入                                                       *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
# #向对应的OID topoRRUResetTrigger设置Value
AAU Set Oid topoRRUResetTrigger Value
    # 要设置的值
    [Arguments]    ${SetValue}    ${index}
    Set Many By Name    topoRRUResetTrigger    ${SetValue}    idx=${index}
    # #在使用remoteRadioUnit的子节点时，先判断对应的rru是否可用
Set RRUResetTrigger Value
    #参数说明: SetValue:需要重启的方式
    [Arguments]    ${SetValue}
    :FOR    ${RRUNo}    IN RANGE    0    95     #RRUNo 0..95
    \    ${ret}    ${error}    Get With Error By Name    topoRRURowStatus    idx=${RRUNo}
    \    Continue For Loop If    ${error} == ${OM_SNMP_GET_NOT_EXIST}
    \    Run Keyword If    '${ret}' == 'createAndGo'    AAU Set Oid topoRRUResetTrigger Value    ${SetValue}    ${RRUNo}
    Run Keyword If    ${94} == ${RRUNo}    Log    There is not a useful RRU to Operate.

#***********************************************************************************
#功能     ：A20.AAU不影响下一级掉电                                                *
#标签     ：mandatory                                                              *
#索引     ：                                                                       *
#入参     ：                                                                       *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：RRU                                                                    *
#适用用例 ：                                                                       *
#负责人   ：majingwei                                                              *
#调用方法 ：调用关键字，输入                                                       *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
AAUReset
    [Documentation]    AAUReset
    [Tags]             mandatory
    [Arguments]    ${rangeno}
    [Teardown]
    [Timeout]

    :FOR    ${loop}    IN RANGE    ${rangeno}
    \   ${curAAUAcessPhase}    Get Oid By Name    ${Mib}    topoRRUAccessPhase
    \   ${curAAUOperState}    Get Oid By Name    ${Mib}  topoRRUOperationalState
    \   ${curAAUAcessPhase_Value}    Get    ${curAAUAcessPhase}
    \   ${curAAUOperState_Value}    Get    ${curAAUOperState}
    \   Log    ${curAAUAcessPhase_Value}
    \   Log    ${curAAUOperState_Value}
    \   Should be equal    ${curAAUAcessPhase_Value}    ${AAU_AcessFinish}
    \   Should be equal    ${curAAUOperState_Value}    ${AAU_OperationalState}

    #\   ${curAAUResetTrigger}    Get Oid By Name    ${Mib}  topoRRUResetTrigger
    #\   Set           ${curAAUResetTrigger}               ${AAU_ResetValue}
    #\   Sleep   300

    \   ${curAAUAcessPhase}    Get Oid By Name    ${Mib}    topoRRUAccessPhase
    \   ${curAAUOperState}    Get Oid By Name    ${Mib}  topoRRUOperationalState
    \   ${curAAUAcessPhase_Value}    Get    ${curAAUAcessPhase}
    \   ${curAAUOperState_Value}    Get    ${curAAUOperState}
    \   Log    ${curAAUAcessPhase_Value}
    \   Log    ${curAAUOperState_Value}
    \   Should be equal    ${curAAUAcessPhase_Value}    ${AAU_AcessFinish}
    \   Should be equal    ${curAAUOperState_Value}    ${AAU_OperationalState}