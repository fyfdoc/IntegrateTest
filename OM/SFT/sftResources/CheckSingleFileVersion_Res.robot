# encoding utf-8
'''
*************************************************************
*** COPYRIGHT DaTang Mobile Communications Equipment CO.,LTD
*************************************************************
*文件名称：CheckSingleFileVersion_Res.robot
*功能描述：主备升级资源文件
*使用方法：

-----------------------------------------------------------------------------------
*修改记录：                                                                       |
*##修改日期    |    修改人    |    修改描述    |                                  |
*2018-11-21      wangruixuan       创建文件                                       |
----------------------------------------------------------------------------------|
*************************************************************
______________________________________________________________________________________
*关键字目录：                                                                        |
-------------------------------------------------------------------------            |
*##功能类关键字##                                                                    |
*A1.查寻文件信息表中的文件版本        -> Get File Version From List                  |
_____________________________________________________________________________________|

************************************************资源文件头结束**************************************************
'''
from pysnmp.smi.rfc1902 import ObjectIdentity

*** Settings ***
Library    SnmpLibrary
Library    ../../utils/CiUtils.py
Library    ../../utils/OM_SFT_ApiFile.py

*** Variables ***
${OM_SNMP_GET_NOT_EXIST}    ${342}
${OM_SNMP_SET_NOT_EXIST}    ${345}

${Mib}    DTM-TD-LTE-ENODEB-ENBMIB

*** Keywords ***
#***********************************************************************************
#功能     ：A1.查寻文件信息表中的文件版本                                          *
#标签     ：                                                                       *
#索引     ：XXXXXXXX                                                               *
#入参     ：FileFullPath:文件全路径                                                *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：SFT                                                                    *
#适用用例 ：文件版本号对比用例                                                     *
#负责人   ：wangruixuan                                                            *
#调用方法 ：调用关键字，输入Get File Version From List 加文件全路径                *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Get File Version From List
    [Arguments]    ${FileFullPath}
    :FOR    ${loop}    IN RANGE    50
    \    ${FileName_ascii}    ${error}    Get With Error By Name    swFileName    idx=@{1,1,${loop+1}}
    \    Exit For Loop If    ${error} == ${OM_SNMP_GET_NOT_EXIST}
    \    ${FileVer_ascii}    Get By Name    swFileVersion    idx=@{1,1,${loop+1}}
    \    ${FileName_Str}    asciiCodeToWords    ${FileName_ascii}
    \    ${FileVer_Str}    asciiCodeToWords    ${FileVer_ascii}
    \    ${Result}    Should Be Equal For Str    ${FileFullPath}    ${FileName_Str}
    \    Run Keyword If    ${Result} == ${True}    Exit For Loop
    [Return]    ${FileVer_Str}
