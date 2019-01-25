# encoding utf-8
# *************************************************************
# *** COPYRIGHT DaTang Mobile Communications Equipment CO.,LTD
# *************************************************************
# *文件名称：LogInHelper.robot
# *功能描述：处理器链接相关资源文件：处理器链接涉及关键字列表
# *使用方法：

# -----------------------------------------------------------------------------------
# *修改记录：                                                                       |
# *##修改日期    |    修改人    |    修改描述    |                                  |
# *2018-11-01        sunshixu       创建文件                                        |
# ----------------------------------------------------------------------------------|
# **************************************************************************************
# ______________________________________________________________________________________
# *关键字目录：                                                                        |
# -------------------------------------------------------------------------            |
# *1.近端链接主控各处理器              -> Local Login HSCTD Process                    |
# *2.近端链接主控各处理器              -> Local Login HBPOD Process                    |
# *3.近端链接主控各处理器              -> Remote Login HSCTD Process                   |
# *4.近端链接主控各处理器              -> Remote Login HBPOD Process                   |
# _____________________________________________________________________________________|

# **************************************************************************************
*** Settings ***
Library     DateTime
Library    SnmpLibrary
Library    BuiltIn
Library    ../../utils/CiUtils.py
Resource    ../_COMM_/LogHelper.robot
Resource    ../_COMM_/UAgentWrapper.robot



*** Variables ***
${Ip1}    172.27.245.91
${Ip2}    172.27.245.92
${host_address}    192.168.1.5    # 手动
${Community}    public
${MibName}    DTM-TD-LTE-ENODEB-ENBMIB

${hbpod_address_base}    172.27.246

*** Keywords ***
#***********************************************************************************
#功能     ：近端链接主控各处理器                                                   *
#标签     ：                                                                       *
#索引     ：                                                                       *
#入参     ：入参pid                                                                *
#返回值   ：                                                                       *
#后处理   ：                                                                       *
#超时     ：                                                                       *
#所属模块 ：TSP                                                                    *
#适用用例 ：                                                                       *
#负责人   ：sunshixu                                                               *
#调用方法 ：调用关键字，入参pid                                                    *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Local Login HSCTD Process
    [documentation]    链接主控板个处理器进程 pid : x86-> 2-5
    [arguments]    ${pid}
    # connect
    ${ret1}=    Connect Device By UAgent Use Pid    hsctd scp ${pid}    ${Ip2}    ${pid}
    ${ret2}=    Run Keyword If    ${ret1} < 0    Connect Device By UAgent Use Pid    hsctd scp ${pid}    ${Ip1}    ${pid}
    Should Be True    ${ret1} == ${0} or ${ret2} == ${0}


#***********************************************************************************
#功能     ：近端链接基带各处理器                                                   *
#标签     ：                                                                       *
#索引     ：                                                                       *
#入参     ：入参pid, 基带板索引(多基带板时)                                        *
#返回值   ：                                                                       *
#后处理   ：                                                                       *
#超时     ：                                                                       *
#所属模块 ：TSP                                                                    *
#适用用例 ：                                                                       *
#负责人   ：sunshixu                                                               *
#调用方法 ：调用关键字，入参pid                                                    *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Local Login HBPOD Process
    [documentation]    链接基带板个处理器进程 pid : x86-> 2-8  plp1-> 11  plp2-> 21
    ...    board_num: 基带板序号  多基带板时使用
    [arguments]    ${pid}    ${board_num}=${0}
    # 获取基带槽位号
    ${boardEntry}    Get Oid By Name    ${MibName}    boardRowStatus
    Log    ${boardEntry}
    @{hbpod_slots}    Get board of aom or som    som    ${boardEntry}    ${16}
    ${hbpod_slot}    Set Variable    @{hbpod_slots}[${board_num}]
    # 配置connect 参数
    ${host}    Run Keyword If    ${pid}==${11}    Evaluate    ${hbpod_slot} + ${pid}
    ...    ELSE IF    ${pid}==${21}    Evaluate    ${hbpod_slot} + ${pid}
    ...    ELSE    Evaluate    ${hbpod_slot} + ${1}
    ${ip_address}    Catenate    SEPARATOR=.    ${hbpod_address_base}    ${host}
    ${pid}    Set Variable    ${pid}
    # connect
    ${ret}    Run Keyword If    ${pid}==${11}    Connect Device By UAgent Use Pid    hbpod ${pid}    ${ip_address}    ${0}
    ...    ELSE IF    ${pid}==${21}    Connect Device By UAgent Use Pid    hbpod ${pid}    ${ip_address}    ${0}
    ...    ELSE    Connect Device By UAgent Use Pid    hbpod bcp ${pid}    ${ip_address}    ${pid}
    Should be equal    ${ret}    ${0}

#***********************************************************************************
#功能     ：远端链接主控各处理器                                                   *
#标签     ：                                                                       *
#索引     ：                                                                       *
#入参     ：入参pid                                                                *
#返回值   ：                                                                       *
#后处理   ：                                                                       *
#超时     ：                                                                       *
#所属模块 ：TSP                                                                    *
#适用用例 ：                                                                       *
#负责人   ：sunshixu                                                               *
#调用方法 ：调用关键字，入参pid                                                    *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Remote Login HSCTD Process
    [documentation]    链接主控板个处理器进程 pid : x86-> 2-5
    [arguments]    ${pid}
    # 获取主控槽位号
    # ${boardEntry}    Get Oid By Name    ${MibName}    boardRowStatus
    # Log    ${boardEntry}
    # @{aom_slotNo_list}    Get board of aom or som    aom    ${boardEntry}    ${16}
    # ${hsctd_slot}   Set Variable    @{aom_slotNo_list}[0]
    # ${hsctd_slot}    Evaluate    int(${hsctd_slot})

    ${hsctd_slot}    Set Variable    ${1}
    # connect
    ${ret}=    Connect Device By UAgent Use Pid    scp ${pid}
    ...    ${host_address}    ${pid}    ${hsctd_slot}    ${0}
    Should be equal    ${ret}    ${0}


#***********************************************************************************
#功能     ：远端链接基带各处理器                                                   *
#标签     ：                                                                       *
#索引     ：                                                                       *
#入参     ：入参pid ,基带板索引(多基带板时)                                        *
#返回值   ：                                                                       *
#后处理   ：                                                                       *
#超时     ：                                                                       *
#所属模块 ：TSP                                                                    *
#适用用例 ：                                                                       *
#负责人   ：sunshixu                                                               *
#调用方法 ：调用关键字，入参pid                                                    *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Remote Login HBPOD Process
    [documentation]    链接基带板个处理器进程 pid : x86-> 2-8  plp1-> 11  plp2-> 21
    ...    board_num: 基带板序号  多基带板时使用
    [arguments]    ${pid}    ${board_num}=${0}
    # 获取基带槽位号
    # ${boardEntry}    Get Oid By Name    ${MibName}    boardRowStatus
    # Log    ${boardEntry}
    # @{hbpod_slots}    Get board of aom or som    som    ${boardEntry}    ${16}
    # ${hbpod_slot}    Set Variable    @{hbpod_slots}[${board_num}]
    # ${hbpod_slot}    Evaluate    int(${hbpod_slot})

    ${hbpod_slot}    Set Variable    ${6}
    log    ${hbpod_slot}
    # connect
    ${ret}    Run Keyword If    ${pid}==${11}        Connect Device By UAgent Use Pid    hbpod ${pid}
    ...    ${host_address}    ${0}    ${hbpod_slot}    ${8}
    ...    ELSE IF    ${pid}==${21}        Connect Device By UAgent Use Pid    hbpod ${pid}
    ...    ${host_address}    ${0}    ${hbpod_slot}    ${10}
    ...    ELSE        Connect Device By UAgent Use Pid    hbpod ${pid}
    ...    ${host_address}    ${pid}    ${hbpod_slot}    ${0}
    Should be equal    ${ret}    ${0}