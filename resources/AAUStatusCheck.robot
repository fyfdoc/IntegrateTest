# encoding utf-8
'''
RRU状态检查资源文件
'''
from pysnmp.smi.rfc1902 import ObjectIdentity

*** Settings ***
Library    SnmpLibrary
Library    BuiltIn
Library    ../utils/CiUtils.py

*** Variables ***
${OM_SNMP_GET_NOT_EXIST}    ${342}
${OM_SNMP_SET_NOT_EXIST}    ${345}

${topoRRUNo_Max}    ${95}


${ConstSwitch_On}    {1}
${ConstSwitch_Off}    {0}
${ConstType_invaild}    {-1}
${ConstType_irSource}    {0}
${ConstType_dacSource}    {1}
${ConstType_tdsPathSource}    {2}
${ConstType_tdlPathSourch}    {3}
${Mode_invalid}    {-1}
${Mode_uplink}    {0}
${Mode_downlink}    {1}
${ConstPower_uplink_TestData}    {-60}
${ConstPower_downlink_TestData}    {20}

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

${Print_Before_PowerDown}    'The Power would be shutdown in 100ms!'

#射频单元端口编号
${pathNo_Max}    ${64}
#天线阵编号最大定义值
${topoRRUNo_Max}    ${95}

*** Keywords ***
# Get Useful RowStatus By Name
#     [Arguments]    ${RowStatusName}
#     ${RruEntry}    Get Oid By Name    ${Mib}    ${RowStatusName}
#     @{RruNo_List}    get topoRRUNo Instance    ${RruEntry}    ${topoRRUNo_Max}

#     Run Keyword If    @{RruNo_List} == [ ]    Log To Console    \n 无可用的射频单元！
#     Return From Keyword If    @{RruNo_List} == [ ]    ${False}
#     Log    @{RruNo_List}
#     [Return]    @{RruNo_List}

# Display AAU Access Phase
#     [Arguments]    ${RRUNo}
#     Log To Console    \n射频单元接入状态:
#     :FOR    ${Loop_time}    IN RANGE    ${50}
#     \    ${ret}    Get By Name    topoRRUAccessPhase    idx=${RRUNo}
#     \    Run Keyword If    '${ret}' == ${RRUAccessPhase_0}    Log To Console    未知 \n
#     \    Run Keyword If    '${ret}' == ${RRUAccessPhase_1}    Log To Console    广播接入完成,通道建立阶段 \n
#     \    Run Keyword If    '${ret}' == ${RRUAccessPhase_2}    Log To Console    通道建立完成,版本更新阶段 \n
#     \    Run Keyword If    '${ret}' == ${RRUAccessPhase_3}    Log To Console    版本更新完成,时延测量阶段 \n
#     \    Run Keyword If    '${ret}' == ${RRUAccessPhase_4}    Log To Console    时延测量完成,天线参数配置阶段 \n
#     \    Run Keyword If    '${ret}' == ${RRUAccessPhase_5}    Log To Console    天线参数配置完成,初始化校准结果上报阶段 \n
#     \    Run Keyword If    '${ret}' == ${RRUAccessPhase_6}    Log To Console    RRU接入完成 \n
#     \    Continue For Loop If    '${ret}' != ${RRUAccessPhase_6}
#     \    Sleep    4s
#     \    Return From Keyword If    '${ret}' == ${RRUAccessPhase_6}    ${True}
#     [Return]    ${False}

# Display AAU Operational State
#     [Arguments]    ${RRUNo}
#     :FOR    ${Loop_time}    IN RANGE    ${10}
#     \    ${ret}    Get By Name    topoRRUOperationalState    idx=${RRUNo}
#     \    Continue For Loop If    '${ret}' != ${RRUOperationalState_0}
#     \    Sleep    1s
#     \    Return From Keyword If    '${ret}' == ${RRUOperationalState_0}    ${True}
#     [Return]    ${False}

# #RRU接入状态
# Get AAU Access Phase
#     @{RRUNo_list}    Get Useful RowStatus By Name    topoRRURowStatus
#     Return From Keyword If    @{RRUNo_list} == ${False}    ${False}
#     :FOR    ${RRUNo}    in     @{RRUNo_list}
#     \    log    ${RRUNo}
#     \    ${ret}    Display AAU Access Phase    ${RRUNo}
#     \    Return From Keyword If    '${ret}' == ${False}    ${False}
#     [Return]    ${True}

# Get RRU Access Phase
#     :FOR    ${RRUNo}    IN RANGE    0    95     #RRUNo 0..95
#     \    ${ret}    ${error}   Get With Error By Name    topoRRUAccessPhase    idx=${RRUNo}
#     \    Continue For Loop If    ${error} > ${0}
#     \    Return From Keyword If    '${ret}' == 'available'     ${True}
#     [Return]    ${False}

# #获取行状态信息：2:notInService|退服/4:createAndGo|行有效/6:destroy|行无效
# Get RRU Row Status
#     :FOR    ${RRUNo}    IN RANGE    0    95     #RRUNo 0..95
#     \    ${ret}    ${error}    Get With Error By Name    topoRRURowStatus    idx=${RRUNo}
#     \    Continue For Loop If    ${error} == ${OM_SNMP_GET_NOT_EXIST}
#     \    Return From Keyword If    '${ret}' == 'destroy'    ${True}
#     \    Return From Keyword If    '${ret}' == 'notInService'    ${True}
#     \    Return From Keyword If    '${ret}' == 'createAndGo'    ${True}
#     Return From Keyword If   ${RRUNo} == ${94}    ${False}
#     [Return]    ${False}

# #向对应的OID topoRRUResetTrigger设置Value
# AAU Set Oid topoRRUResetTrigger Value
#     # 要设置的值
#     [Arguments]    ${SetValue}    ${index}
#     Set Many By Name    topoRRUResetTrigger    ${SetValue}    idx=${index}

# #在使用remoteRadioUnit的子节点时，先判断对应的rru是否可用
# Set RRUResetTrigger Value
#      参数说明: SetValue:需要重启的方式
#     [Arguments]    ${SetValue}
#     :FOR    ${RRUNo}    IN RANGE    0    95     #RRUNo 0..95
#     \    ${ret}    ${error}    Get With Error By Name    topoRRURowStatus    idx=${RRUNo}
#     \    Continue For Loop If    ${error} == ${OM_SNMP_GET_NOT_EXIST}
#     \    Run Keyword If    '${ret}' == 'createAndGo'    AAU Set Oid topoRRUResetTrigger Value    ${SetValue}    ${RRUNo}
#     Run Keyword If    ${94} == ${RRUNo}    Log    There is not a useful RRU to Operate.


# #topoRRUTRxConstSwitch、topoRRUTRxConstMode、topoRRUTRxConstType、topoRRUSetTRxMode、topoRRUTRxConstPower
# AAU Set Oid SetTopoRRUTRxConst Value
#     # 参数说明:ConstSwitch 射频单元上下行发单音开关
# #    # 参数说明:ConstMode 射频单元上下行发单音模式
#     # 参数说明:ConstType 射频单元上下行发单音类型
#     # 参数说明:Mode 射频单元上下行发单音工作模式
#     # 参数说明:ConstPower 射频单元上下行发单音功率
#     [Arguments]    ${ConstSwitch}    ${ConstType}    ${Mode}    ${ConstPower}    ${index}

#     Set Many By Name    topoRRUTRxConstSwitch    ${ConstSwitch}    idx=${index}
# #    ...                   topoRRUTRxConstMode    ${ConstMode}    idx=${index}
#     ...                   topoRRUTRxConstType    ${ConstType}    idx=${index}
#     ...                   topoRRUSetTRxMode    ${Mode}    idx=${index}
#     ...                   topoRRUTRxConstPower    ${ConstPower}    idx=${index}


# #在使用remoteRadioUnit的子节点时，先判断对应的rru是否可用
# Set SetTopoRRUTRxConst Value
#     # 参数说明: SetValue:需要重启的方式
#    [Arguments]    ${ConstSwitch}    ${ConstType}    ${Mode}    ${ConstPower}

#     ${RruEntry}    Get Oid By Name    ${Mib}    rruPathRowStatus
#     @{RruNo_List}    get topoRRUNo createAndGo    ${RruEntry}    ${topoRRUNo_Max}
#     :FOR    ${RRUNo}    in    @{RruNo_List}
#     \    AAU Set Oid SetTopoRRUTRxConst Value    ${ConstSwitch}    ${ConstType}    ${Mode}    ${ConstPower}    ${RRUNo}


# #射频单元拓扑RRU实例是否存在
# Is RRU Instence Exist
#     ${ret}    Get RRU Row Status
#     [Return]    ${ret}

# #获取小区可操作状态
# Get Cell Operational State
#     :FOR    ${CellLcId}    IN RANGE    0    35     #CellId 0..35
#     \    ${ret}    ${error}   Get With Error By Name    nrCellOperationalState    idx=${CellLcId}
#     \    Continue For Loop If    ${error} > ${0}
#     \    Return From Keyword If    '${ret}' == 'enabled'     ${True}
#     [Return]    ${False}

# #激活已存在的实例小区
# Set Cell Active Trigger
#     :FOR    ${CellLcId}    IN RANGE    0    35     #CellId 0..35
#     \    ${ret}    ${error}   Get With Error By Name    nrCellActiveTrigger    idx=${CellLcId}
#     \    Continue For Loop If    ${error} > ${0}
#     \    Run Keyword If    '${ret}' == 'deactive'    Set By Name    nrCellActiveTrigger    active    idx=${CellLcId}

# #激活小区后判断是否可用
# NRCell Active Operate
#     Set Cell Active Trigger
#     Sleep    10s
#     ${ret}    Get Cell Operational State
#     [Return]    ${ret}

# #AAU重启后的状态检查
# AAU Status Check After Restart
#     ${retAccessPhase}    Get AAU Access Phase
#     Run Keyword If    ${retAccessPhase} == ${False}    Log To Console    'RRU接入状态错误'
#     #Should be equal    ${retAccessPhase}    ${True}
#     ${retCellActive}    NRCell Active Operate
#     Run Keyword If    ${retCellActive} == ${False}    Log To Console    'NRCell小区激活后不可用'
#     #Should be equal    ${retCellActive}    ${True}