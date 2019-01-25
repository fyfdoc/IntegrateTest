# encoding utf-8
'''
*************************************************************
*** COPYRIGHT DaTang Mobile Communications Equipment CO.,LTD
*************************************************************
*文件名称：MainAndBackUpgrade_Res.robot
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
*A1.连接PLP设备                       -> Connect Device by UAgent Use Pid For PLP    |
*##查寻类关键字##                                                                    |
*B1.查寻CORE的主备运行状态            -> CheckMainBackStatus_CORE                    |
*B2.查寻BOOT的主备运行状态            -> CheckMainBackStatus_BOOT                    |
*B3.查寻当前运行的文件版本            -> GetBoardVersion                             |
*B4.查寻ATA2路径下的文件版本          -> GetATA2Version                              |
_____________________________________________________________________________________|

************************************************资源文件头结束**************************************************
'''
from pysnmp.smi.rfc1902 import ObjectIdentity

*** Settings ***
Library    SnmpLibrary
Library    ../../utils/CiUtils.py
Resource    ../../COMM/commResources/UAgentWrapper.robot

*** Variables ***
${PLP1_hostname}    'PLP1'
${PLP2_hostname}    'PLP2'
${PLP1_hostaddress}    172.27.246.17
${PLP2_hostaddress}    172.27.246.27
${PLP_pId}    ${0}

${Mib}    DTM-TD-LTE-ENODEB-ENBMIB

*** Keywords ***
#***********************************************************************************
#功能     ：A1.连接PLP设备                                                         *
#标签     ：                                                                       *
#索引     ：XXXXXXXX                                                               *
#入参     ：ProcID:处理器编号 | PLP1:8   PLP2:10                                   *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：SFT                                                                    *
#适用用例 ：                                                                       *
#负责人   ：wangruixuan                                                            *
#调用方法 ：调用关键字，输入Connect Device by UAgent Use Pid For PLP 加处理器编号  *
#                                                                                  *
#备注     ：使用完成后需断开                                                       *
#                                                                                  *
#***********************************************************************************
Connect Device by UAgent Use Pid For PLP
    [Arguments]    ${ProcID}
    Run Keyword If    ${ProcID} == ${8}    Connect Device by UAgent Use Pid    ${PLP1_hostname}    ${PLP1_hostaddress}    ${PLP_pId}
    Run Keyword If    ${ProcID} == ${10}    Connect Device by UAgent Use Pid    ${PLP2_hostname}    ${PLP2_hostaddress}    ${PLP_pId}

#***********************************************************************************
#功能     ：B1.查寻CORE的主备运行状态                                              *
#标签     ：                                                                       *
#索引     ：XXXXXXXX                                                               *
#入参     ：MainOrBack:主备编号 | 0:主区  1:备区                                   *
#返回值   ：execute_result:查寻结果 | 0:可用  1:不可用                             *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：SFT                                                                    *
#适用用例 ：主备升级测试用例                                                       *
#负责人   ：wangruixuan                                                            *
#调用方法 ：调用关键字，输入CheckMainBackStatus_CORE加参数                         *
#                                                                                  *
#备注     ：调用前 需连接PLP设备                                                   *
#                                                                                  *
#***********************************************************************************
CheckMainBackStatus_CORE
    [Arguments]    ${MainOrBack}
    ${execute_result}=    Execute Command by UAgent    bsp_verify_core    ${MainOrBack}
    [Return]    ${execute_result}

#***********************************************************************************
#功能     ：B2.查寻BOOT的主备运行状态                                              *
#标签     ：                                                                       *
#索引     ：XXXXXXXX                                                               *
#入参     ：MainOrBack:主备编号 | 0:主区  1:备区                                   *
#返回值   ：execute_result:查寻结果 | 0:可用  1:不可用                             *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：SFT                                                                    *
#适用用例 ：主备升级测试用例                                                       *
#负责人   ：wangruixuan                                                            *
#调用方法 ：调用关键字，输入CheckMainBackStatus_BOOT加参数                         *
#                                                                                  *
#备注     ：调用前 需连接PLP设备                                                   *
#                                                                                  *
#***********************************************************************************
CheckMainBackStatus_BOOT
    [Arguments]    ${MainOrBack}
    ${execute_result}=    Execute Command by UAgent    bsp_verify_boot    ${MainOrBack}
    [Return]    ${execute_result}

#***********************************************************************************
#功能     ：B3.查寻当前运行的文件版本                                              *
#标签     ：                                                                       *
#索引     ：XXXXXXXX                                                               *
#入参     ：singleFileType:文件类型 | boot:203  core:204                           *
#           ProcID:处理器编号 | PLP1:8   PLP2:10                                   *
#返回值   ：result_list:查寻结果                                                   *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：SFT                                                                    *
#适用用例 ：主备升级测试用例                                                       *
#负责人   ：wangruixuan                                                            *
#调用方法 ：调用关键字，输入GetBoardVersion加参数                                  *
#                                                                                  *
#备注     ：调用前 需连接基带设备  som_sft_main.c文件应有对应测试函数              *
#                                                                                  *
#***********************************************************************************
GetBoardVersion
    [Arguments]    ${singleFileType}    ${ProcID}
    ${execute_result}    ${result_list}=    Execute Command With Out Datas by UAgent    OM_SSFT_GetFileVersionInBoard    ${singleFileType}    ${ProcID}    <60,[S;0;0;0]>
    Log    "Board Version:${result_list}"
    [Return]    ${result_list}

#***********************************************************************************
#功能     ：B4.查寻ATA2路径下的文件版本                                            *
#标签     ：                                                                       *
#索引     ：XXXXXXXX                                                               *
#入参     ：FilePath:文件路径                                                      *
#返回值   ：result_list:查寻结果                                                   *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：SFT                                                                    *
#适用用例 ：主备升级测试用例                                                       *
#负责人   ：wangruixuan                                                            *
#调用方法 ：调用关键字，输入GetATA2Version加参数                                   *
#                                                                                  *
#备注     ：调用前 需连接主控设备                                                  *
#                                                                                  *
#***********************************************************************************
GetATA2Version
    [Arguments]    ${FilePath}
    ${execute_result}    ${result_list}=    Execute Command With Out Datas by UAgent    OM_SFT_GetMicroVer    <60,[S;0;0;${FilePath}]>    <60,[S;0;0;0]>
    Log    "FileInfo:${result_list}"
    Return From Keyword If    ${execute_result} == ${-1}    ${execute_result}
    [Return]    ${result_list}