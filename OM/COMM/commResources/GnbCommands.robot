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
*****通用命令类*****                                                                 |
**A1.无AAU模式                    -> Set No AAU Mode                                 |
**A2.带检查的无AAU模式            -> Set No AAU Mode With Check                      |
**A3.无核心网模式                 -> Set No AMF Mode                                 |
**A4.设置无时钟源模式             -> Set No Clk Mode                                 |
**A5.获取测试流程时间信息         -> Get Date Info                                   |
*****设置全局变量类*****                                                             |
**B1.设置高层无核心网全局变量     -> Is Exist Clock Src                              |
*****查寻类*****                                                                     |
**C1.查寻时钟源是否存在           -> Set g_u8AP_NgSetupDummyAmfFlag                  |
_____________________________________________________________________________________|

************************************************资源文件头结束**************************************************
'''
*** Settings ***
Library    SnmpLibrary
Library    ../../utils/CiUtils.py
Library    ../../../device_agent/TestCaseClient.py
Resource    UAgentWrapper.robot

*** Variables ***
${IP0}             172.27.245.91
${IP1}             172.27.245.92
${hsctd_address_base}    172.27.245
${hbpod_address_base}    172.27.246
${FtpServerx86Ip}    172.27.245.100
${FtpServerarmIp}    172.27.246.100
${som}    som
@{hbpod_slots}
@{hsctd_slots}

${Mib}    DTM-TD-LTE-ENODEB-ENBMIB
${No_AAU_Command}    OM_MCELL_SIM_CELLSETUP_NOAAU  1
${OM_MIB_HELP}    OM_MIB_HELP
${NetPlan_By_LcId}    OM_HELP_TOPORRU_NETPLAN_LCID 1
${NetPlan_By_RruNo}    OM_HELP_TOPORRU_NETPLAN_RRUNO 1

${HL_NO_AMF_Global_Var}    OSP_SET_VALUE_BYNAME "g_u8AP_NgSetupDummyAmfFlag", 1, 1

${enabled}    enabled

${OM_SNMP_GET_NOT_EXIST}    ${342}
${OM_SNMP_SET_NOT_EXIST}    ${345}

*** Keywords ***
#***********************************************************************************
#功能     ：A1.Set No AAU Mode                                                        *
#标签     ：                                                                       *
#索引     ：XXXXXXXX                                                               *
#入参     ：XXXXXXXX                                                               *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：CELL                                                                   *
#适用用例 ：                                                                       *
#负责人   ：majingwei                                                              *
#调用方法 ：调用关键字，输入XXXXXXXX                                               *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Get Hbpod Slot List
    ${boardEntry}    Get Oid By Name    ${Mib}    boardRowStatus
    Log    ${boardEntry}
    @{aom_slotNo_list}    Get board of aom or som    aom    ${boardEntry}    ${16}
    [Return]    @{aom_slotNo_list}

Connect Hsctd Pid2
    @{hsctd_slots}    Get Hbpod Slot List
    ${slot1}    Evaluate    int(@{hsctd_slots}[0])
    Set Suite Variable    ${hsctd_slot}    ${slot1}
    ${ip_address}    Catenate    SEPARATOR=.    ${hsctd_address_base}    ${hsctd_slot + 91}
    ${pid}    Set Variable    ${2}
    Connect Device By UAgent Use Pid    hsctd scp 2    ${ip_address}    ${pid}

#***********************************************************************************
#功能     ：A1.Set No AAU Mode                                                        *
#标签     ：                                                                       *
#索引     ：XXXXXXXX                                                               *
#入参     ：XXXXXXXX                                                               *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：CELL                                                                   *
#适用用例 ：                                                                       *
#负责人   ：majingwei                                                              *
#调用方法 ：调用关键字，输入XXXXXXXX                                               *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Set No AAU Mode
    [Documentation]    下发无AAU
    [Tags]
    [Arguments]
    [Teardown]
    [Timeout]
    ${Ret}    Execute Command by UAgent    ${No_AAU_Command}
    [Return]    ${Ret}

#***********************************************************************************
#功能     ：B1.设置高层无核心网全局变量                                            *
#标签     ：                                                                       *
#索引     ：XXXXXXXX                                                               *
#入参     ：XXXXXXXX                                                               *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：CELL                                                                   *
#适用用例 ：                                                                       *
#负责人   ：majingwei                                                              *
#调用方法 ：调用关键字，输入XXXXXXXX                                               *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Set g_u8AP_NgSetupDummyAmfFlag
    [Documentation]    设置高层无核心网全局变量g_u8AP_NgSetupDummyAmfFlag为1
    [Tags]
    [Arguments]
    [Teardown]
    [Timeout]
    ${Ret}    Execute Command by UAgent    ${HL_NO_AMF_Global_Var}
    [Return]    ${Ret}
#***********************************************************************************
#功能     ：B1.设置高层无核心网全局变量                                            *
#标签     ：                                                                       *
#索引     ：XXXXXXXX                                                               *
#入参     ：XXXXXXXX                                                               *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：                                                                       *
#适用用例 ：                                                                       *
#负责人   ：yuhuimin                                                               *
#调用方法 ：调用关键字，输入XXXXXXXX                                               *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Set No AMF Mode
        Set By Name    sysS1CreateMode    noPeerMme
        Sleep    5s
        ${s1Status}    Get By Name    linkCommonOperationStatus
        Should be equal    ${s1Status}    ${enabled}

#***********************************************************************************
#功能     ：C1.查寻时钟源是否存在                                                  *
#标签     ：                                                                       *
#索引     ：XXXXXXXX                                                               *
#入参     ：XXXXXXXX                                                               *
#返回值   ：0 不存在 / 1 存在                                                      *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：                                                                       *
#适用用例 ：                                                                       *
#负责人   ：wangruixuan                                                            *
#调用方法 ：调用关键字，输入XXXXXXXX                                               *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Is Exist Clock Src
    :FOR    ${index}    IN RANGE    1    10
    \    ${ret}    ${error}   Get With Error By Name    clkSrcStatus    ${index}
    \    Run Keyword If    ${error} == ${0}    Run Keyword If    '${ret}' == 'active'    Exit For Loop
    \    Return From Keyword If    ${index} == ${9}    ${0}
    [Return]    ${1}

#***********************************************************************************
#功能     ：A4.设置无时钟源模式                                                    *
#标签     ：                                                                       *
#索引     ：XXXXXXXX                                                               *
#入参     ：XXXXXXXX                                                               *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：                                                                       *
#适用用例 ：                                                                       *
#负责人   ：wangruixuan                                                            *
#调用方法 ：调用关键字，输入XXXXXXXX                                               *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Set No Clk Mode
    # 判断时钟模式
    :FOR    ${n}    IN RANGE    ${600}
    \    ${ClkSrcMode}    ${error}    Get With Error By Name    sysStartIsNoClkSrcMode
    \    Run Keyword If    ${OM_SNMP_GET_NOT_EXIST} != ${error}    Exit For Loop
    \    Sleep    1
    Log    ${ClkSrcMode}
    # 判断时钟源是否存在
    ${isExistClkSrc}    Is Exist Clock Src
    Log    ${isExistClkSrc}
    Run Keyword If    ${isExistClkSrc} == ${0}
    ...    Run Keyword If    '${ClkSrcMode}' == 'normal'
    ...    Set By Name    sysStartIsNoClkSrcMode    noClkSrc
    Sleep    5s

#***********************************************************************************
#功能     ：A5.获取测试流程时间信息                                                *
#标签     ：                                                                       *
#索引     ：XXXXXXXX                                                               *
#入参     ：XXXXXXXX                                                               *
#返回值   ：&{Time_Info_Dict}                                                      *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：                                                                       *
#适用用例 ：                                                                       *
#负责人   ：morunzhang                                                             *
#调用方法 ：调用关键字，输入XXXXXXXX                                               *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Get Date Info
    [Arguments]    ${description}    ${begintime}    ${testnum}       
    &{Time_Info_Dict}    Create Dictionary
    ${endtime}    get current date
    ${time}    subtract date from date    ${endtime}    ${begintime}
    ${avgtime}    evaluate    ${time}/${testnum}
    Set To Dictionary    ${Time_Info_Dict}    ${description}开始时间:    ${begintime}
    Set To Dictionary    ${Time_Info_Dict}    ${description}结束时间:    ${endtime}
    Set To Dictionary    ${Time_Info_Dict}    ${description}间隔时间:    ${time}
    Set To Dictionary    ${Time_Info_Dict}    ${description}平均时间:    ${avgtime}
    [Return]    &{Time_Info_Dict}