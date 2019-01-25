# encoding utf-8
'''
*************************************************************
*** COPYRIGHT DaTang Mobile Communications Equipment CO.,LTD
*************************************************************
*文件名称：BBUCtrlSwitch.robot
*功能描述：BBU包裁剪检查资源文件
*使用方法：

-----------------------------------------------------------------------------------
*修改记录：                                                                       |
*##修改日期    |    修改人    |    修改描述    |                                  |
*2018-12-06      wangruixuan       创建文件                                       |
----------------------------------------------------------------------------------|
*************************************************************
______________________________________________________________________________________
*关键字目录：                                                                        |
-------------------------------------------------------------------------            |
*##功能类关键字##                                                                    |
*A1.BBU版本升级命令的下发             -> Set Upgrade Commands                        |
*A2.BBU拖包升级                       -> BBU Version Upgrade                         |
_____________________________________________________________________________________|

************************************************资源文件头结束**************************************************
'''
from pysnmp.smi.rfc1902 import ObjectIdentity

*** Settings ***
Library    SnmpLibrary
Library    ../../utils/CiUtils.py
Library    ../../utils/FileHandler.py
Resource    ../../COMM/commResources/GnbCommands.robot
Resource    ../../OutPermission/opResources/opResource.robot

*** Variables ***
${Mib}    DTM-TD-LTE-ENODEB-ENBMIB

*** Keywords ***
#***********************************************************************************
#功能     ：A1.BBU版本升级命令的下发                                               *
#标签     ：                                                                       *
#索引     ：XXXXXXXX                                                               *
#入参     ：大包全路径  下载标志                                                   *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：SFT                                                                    *
#适用用例 ：BBU版本的升级与回退                                                    *
#负责人   ：wangruixuan                                                            *
#调用方法 ：调用关键字，输入Set Upgrade Commands 加参数                            *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Set Upgrade Commands
    [Documentation]    下发BBU升级命令
    [Tags]    mandatory
    [Arguments]    ${FullPath}    ${DownloadIndicator}
    [Teardown]
    [Timeout]
    [Return]

    ${subpackageNum}    newSpiltPackage    ${FullPath}
    ${splitBBUPath}    get_splitBBUPath
    ${Version}    newGetVerNum    ${FullPath}

    Set Many By Name
    ...    swPackPlanPackName    5GIIIBBU.dtz   idx=${1}    # 软件包名称
    ...    swPackPlanVendor    null    idx=${1}             # 厂家信息
    ...    swPackPlanVersion    ${Version}    idx=${1}      # 软件包版本
    ...    swPackPlanDownloadIndicator    ${DownloadIndicator}    idx=${1}    # 软件包自动下载标志
#    ...    swPackPlanScheduleDownloadTime    1900-01-01    idx=${1}          #  软件包下载时间
    ...    swPackPlanDownloadDirectory    ${splitBBUPath}    idx=${1}         # 软件包自动下载路径
    ...    swPackPlanActivateIndicator    instantActivate    idx=${1}    # 激活标志
#    ...    swPackPlanScheduleActivateTime    1900-01-01    idx=${1}    # 软件包定时激活或去激活时间
    ...    swPackPlanRelyVesion    null    idx=${1}             # 补丁包依赖版本
    ...    swPackPlanFwActiveIndicator    active    idx=${1}    # 固件激活标志
    ...    swPackPlanSubPackNumber    ${subpackageNum}    idx=${1}          # 外设软件拆包个数

    Log To Console    \n等待一分钟，小包下载结束后删除小包
    Sleep    1min
    delSplitedPackage    ${subpackageNum}    ${FullPath}


#***********************************************************************************
#功能     ：A2.BBU拖包升级                                                         *
#标签     ：                                                                       *
#索引     ：XXXXXXXX                                                               *
#入参     ：大包全路径  下载标志  处理器索引  板卡索引                             *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：SFT                                                                    *
#适用用例 ：BBU版本的升级与回退                                                    *
#负责人   ：wangruixuan                                                            *
#调用方法 ：调用关键字，输入BBU Version Upgrade加参数                              *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
BBU Version Upgrade
    [Arguments]    ${fullPath}    ${DownloadSignal}

    @{processorIndex_list}    Get All Actual Processors Index List
    Log List    @{processorIndex_list}
    @{boardIndex_list}    Get All Actual Boards Index List
    Log List    @{boardIndex_list}

    Set Upgrade Commands    ${fullPath}    ${DownloadSignal}
    Log To Console    \nBBU正在进行版本下载，请等待14分钟
    Sleep    14min
    Log To Console    \n开始进行无时钟源情况下的处理器可用性检查
    Get All Processors Until Enabled When No Clock    @{processorIndex_list}
    Set No Clk Mode
    Log To Console    \n开始进行板卡和处理器可用性检查
    Get All Processors Until Enabled    @{processorIndex_list}
    Get All Boards Until Enabled    @{boardIndex_list}
    Log To Console    \n开始进行RRU接入检查
    Get AAU Access Phase Until Available
    Log To Console    \n开始进行小区可用性检查
    ${nrCellCfgRowStatus_oid}    Get Oid By Name    ${Mib}    nrCellCfgRowStatus
    Log    ${nrCellCfgRowStatus_oid}
    @{CellIdList}    get_CellIDList    ${nrCellCfgRowStatus_oid}    ${35}
    Get Cell Until Enabled    @{CellIdList}
    Log To Console    \n拖包升级结束，小区建立成功