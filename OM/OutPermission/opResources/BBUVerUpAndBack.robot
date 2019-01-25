# encoding utf-8
'''
*************************************************************
*** COPYRIGHT DaTang Mobile Communications Equipment CO.,LTD
*************************************************************
*文件名称：BBUVerUpAndBack.robot
*功能描述：BBU版本升级与回退资源文件
*使用方法：

-----------------------------------------------------------------------------------
*修改记录：                                                                       |
*##修改日期    |    修改人    |    修改描述    |                                  |
*2018-11-09       wangruixuan      创建文件                                       |
----------------------------------------------------------------------------------|
*************************************************************
______________________________________________________________________________________
*关键字目录：                                                                        |
-------------------------------------------------------------------------            |
*##版本升级类关键字##                                                                |
*A1.版本升级回退                         -> BBU VerUpAndBack                         |
_____________________________________________________________________________________|

************************************************资源文件头结束**************************************************
'''
from pysnmp.smi.rfc1902 import ObjectIdentity

*** Settings ***
Library    SnmpLibrary
Library    ../../utils/CiUtils.py
Library    ../../utils/FileHandler.py
Resource    ../../COMM/commResources/SnmpMibHelper.robot
Resource    ../../OutPermission/opResources/BBUStatusCheck.robot

*** Variables ***
${Mib}    DTM-TD-LTE-ENODEB-ENBMIB

${ActivateIndicator}    instantActivate

*** Keywords ***
#***********************************************************************************
#功能     ：BBU版本升级命令的下发                                                  *
#标签     ：                                                                       *
#索引     ：XXXXXXXX                                                               *
#入参     ：大包全路径  下载标志                                                   *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：SFT                                                                    *
#适用用例 ：BBU版本的升级与回退                                                    *
#负责人   ：wangruixuan                                                            *
#调用方法 ：调用关键字，输入BBU VerUpAndBack 加参数                                *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
BBU VerUpAndBack
    # 参数说明: FullPath:待升级包的全路径    DownloadIndicator:下载标志
    [Arguments]    ${FullPath}    ${DownloadIndicator}
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
    ...    swPackPlanActivateIndicator    ${ActivateIndicator}    idx=${1}    # 激活标志
#    ...    swPackPlanScheduleActivateTime    1900-01-01    idx=${1}    # 软件包定时激活或去激活时间
    ...    swPackPlanRelyVesion    null    idx=${1}             # 补丁包依赖版本
    ...    swPackPlanFwActiveIndicator    active    idx=${1}    # 固件激活标志
    ...    swPackPlanSubPackNumber    ${subpackageNum}    idx=${1}          # 外设软件拆包个数

    Log To Console    \nBBU正在进行版本下载，请等待20分钟
    Sleep    20min

    delSplitedPackage    ${subpackageNum}    ${FullPath}
    BBU Status Check After Restart