# encoding utf-8
'''
*************************************************************
*** COPYRIGHT DaTang Mobile Communications Equipment CO.,LTD
*************************************************************
*文件名称：BBUPackVerCheck.robot
*功能描述：BBU大包版本检查资源文件
*使用方法：

-----------------------------------------------------------------------------------
*修改记录：                                                                       |
*##修改日期    |    修改人    |    修改描述    |                                  |
*2018-11-13      wangruixuan       创建文件                                       |
----------------------------------------------------------------------------------|
*************************************************************
______________________________________________________________________________________
*关键字目录：                                                                        |
-------------------------------------------------------------------------            |
*##查询类关键字##                                                                    |
*A1.获取大包的大包版本                -> Get BBU Pack Ver                            |
*A2.获取Running表的大包版本           -> Get BBU Running Pack Ver                    |
*A3.获取Plan表的大包版本              -> Get BBU Plan Pack Ver                       |
_____________________________________________________________________________________|

************************************************资源文件头结束**************************************************
'''
from pysnmp.smi.rfc1902 import ObjectIdentity

*** Settings ***
Library    SnmpLibrary
Library    ../../utils/CiUtils.py
Library    ../../utils/FileHandler.py
Library    ../../utils/OM_SFT_ApiFile.py

*** Variables ***
${Mib}    DTM-TD-LTE-ENODEB-ENBMIB

*** Keywords ***
#***********************************************************************************
#功能     ：A1.获取大包的大包版本                                                  *
#标签     ：                                                                       *
#索引     ：XXXXXXXX                                                               *
#入参     ：XXXXXXXX                                                               *
#返回值   ：大包版本号                                                             *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：SFT                                                                    *
#适用用例 ：                                                                       *
#负责人   ：wangruixuan                                                            *
#调用方法 ：调用关键字，输入Get BBU Pack Ver 加参数BBU包全路径                     *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Get BBU Pack Ver
    # 参数说明: FullPath:BBU包的全路径
    [Arguments]    ${FullPath}
    ${PackVer}    newGetVerNum    ${FullPath}
    Log    ${PackVer}
    [Return]    ${PackVer}

#***********************************************************************************
#功能     ：A2.获取Running表的大包版本                                             *
#标签     ：                                                                       *
#索引     ：XXXXXXXX                                                               *
#入参     ：XXXXXXXX                                                               *
#返回值   ：Running表大包版本号                                                    *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：SFT                                                                    *
#适用用例 ：                                                                       *
#负责人   ：wangruixuan                                                            *
#调用方法 ：调用关键字，输入Get BBU Running Pack Ver                               *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Get BBU Running Pack Ver
    ${PackRunningVer}    Get By Name    swPackRunningVersion    idx=${1}
    ${PackRunningVer1}    asciiCodeToWords    ${PackRunningVer}
    Log    ${PackRunningVer1}
    [Return]    ${PackRunningVer1}

#***********************************************************************************
#功能     ：A3.获取Plan表的大包版本                                                *
#标签     ：                                                                       *
#索引     ：XXXXXXXX                                                               *
#入参     ：XXXXXXXX                                                               *
#返回值   ：Plan表大包版本号                                                       *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：SFT                                                                    *
#适用用例 ：                                                                       *
#负责人   ：wangruixuan                                                            *
#调用方法 ：调用关键字，输入Get BBU Plan Pack Ver                                  *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Get BBU Plan Pack Ver
    ${PackPlanVer}    Get By Name    swPackPlanVersion    idx=${1}
    ${PackPlanVer1}    asciiCodeToWords    ${PackPlanVer}
    Log    ${PackPlanVer1}
    [Return]    ${PackPlanVer1}