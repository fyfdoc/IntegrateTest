# encoding utf-8
'''
*************************************************************
*** COPYRIGHT DaTang Mobile Communications Equipment CO.,LTD
*************************************************************
*文件名称：ddResources.robot
*功能描述：RRU DD相关资源文件：涉及关键字列表
*使用方法：

---------------------------------------------------------------------------------------
*修改日期     |     修改人     |     修改描述     |                                   |
*2018-11-01        wangyan11         创建文件                                         |
*2018-11-16        zhaobaoxin        修正关键字注释                                   |
*2018-11-22        zhaobaoxin        添加AAU时域抓数相关关键字                        |
--------------------------------------------------------------------------------------|
*************************************************************
______________________________________________________________________________________
*关键字目录：                                                                         |
--------------------------------------------------------------------------------------|
*##查询类关键字##                                                                     |
*A1-获取PGC参数值                     -> Cell Should be Enabled                       |
*A2-MP2953设备电压查询                -> RRU Should be Running status                 |
*A3-MP2953设备电流查询                -> RRU Should be Running status                 |
*A4-MP2953设备温度查询                -> RRU Should be Running status                 |
*A5-LM730设备温度查询                 -> RRU Should be Running status                 |
*A6-U9P设备温度查询                   -> RRU Should be Running status                 |
*A7-以太芯片链路状态                  -> Cell Should be Enabled                       |
*A8-电口204B误码率状态查询            -> Cell Should be Enabled                       |
*A9-链路连接查询                      -> Cell Should be Enabled                       |
*A10-链路连接查询2                    -> Cell Should be Enabled                       |
*A11-读取行状态获取可用的射频单元号   -> Cell Should be Enabled                       |
*A12-查询ORPD异常功率统计             -> AAU ORPD 功率异常统计                        |
*##动作类关键字##                                                                     |
*B1-AAU接口板发起重启流程             -> AAUReboot                                    |
*B2-Mount文件到ramDisk                -> Mount File To ramDisk                        |
*B3-时域打桩开始命令                  -> Time Piling Start                            |
*B4-时域打桩结束命令                  -> Time Piling Stop                             |
*B5-开天线并获取发送方输出功率        -> Open Ant and Get rruPathTxPower              |
*B6-整体恢复AAU环境                   -> Device Enviroment Recover                    |
*B7-根据目的IP设备恢复对应设备环境    -> Recover One Step                             |
______________________________________________________________________________________|

************************************************资源文件头结束**************************************************
'''

from pysnmp.smi.rfc1902 import ObjectIdentity

*** Settings ***
Library                            DateTime
Library                            SnmpLibrary
Library                            BuiltIn
Library                            Collections
Library                            ../../../utils/CiUtils.py
Resource                           ../OM/omResource.robot
Resource                           ../../../COMM/commResources/SnmpMibHelper.robot
Resource                           ../../../../resources/LogHelper.robot
Resource                           ../../../../resources/UAgentWrapper.robot
Resource                           ../../../../resources/UploadLogsAndRecoverGnb.robot


*** Variables ***
${IP}                              172.27.245.92
${Comitty}                         public
#${Comitty}                        dtm.1234
${Mib}                             DTM-TD-LTE-ENODEB-ENBMIB
${host_name}                       'SCTF'
${host_address}                    172.27.45.250
${pId}                             ${0}    #'Disconnect failed while pid value -1000'

#define OSP_RFM_GET_P              OSP_B_CMD(OSP_RFM_ID, 0x6009)    /* 获取PGC增益 */
${OSP_RFM_GET_PGC}                 ${0x66009}
${OSP_RFM_GET_PGC_UPLINK}          ${1}
${OSP_RFM_GET_PGC_DWLINK}          ${0}
${ANT_NO_MAX}                      ${64}


${MP2953_DEVICE_A}                 ${0}
${MP2953_DEVICE_B}                 ${1}
${MP2953_DEVICE_MAX}               ${2}
@{LM73_DEVICE_LIST}                @{2,3,4,5}

${AIU_address}                     172.27.45.250
${ARU_1_address}                   172.27.45.251
${ARU_2_address}                   172.27.45.252
${ARU_3_address}                   172.27.45.253
${ARU_4_address}                   172.27.45.254
@{i_tx0_rx_cgs_counter_list}       @{0xa0000874, 0xa0000878, 0xa000087C,0xa0000880}
${CRRU_FPGAREG_JESD_MODID}         ${84}
${CRRU_FPGAREG_ELC_MODID}          ${85}
${ELE_REG_ADDR}                    ${21}           #电口误码寄存器
${ELE_204B_ADDR}                   ${29}           #204b误码监测
${IS_0303VALUE_ADDR}               ${33}           #204b误码监测
${204bRightStatus}                 0x3030303       #204b建链状态成功时寄存器的值


${OM_SNMP_GET_NOT_EXIST}           ${342}
${OM_SNMP_SET_NOT_EXIST}           ${345}
${ConstSwitch_On}                  ${1}
${ConstSwitch_Off}                 ${0}
${ConstType_invaild}               ${-1}
${ConstType_irSource}              ${0}
${ConstType_dacSource}             ${1}
${ConstType_tdsPathSource}         ${2}
${ConstType_tdlPathSourch}         ${3}
${Mode_invalid}                    ${-1}
${Mode_uplink}                     ${0}
${Mode_downlink}                   ${1}
${ConstPower_uplink_TestData}      ${-60}
${ConstPower_downlink_TestData}    ${20}
@{retTxPower_Data_List}
${OID_Name_rruPathVSWR}            rruPathVSWR
${OID_Name_rruPathTxPower}         rruPathTxPower
${Get_List_None}                   [ ]


${LOG_Phase}                       '接入标志:'
${LOG_Oper}                        '操作状态:'


${Sleep_Time}                       10s


${AAU_AcessFinash}                  available       #6:AAU接入完成
${AAU_OperationalState}             enabled         #0:AAU可用
${AAU_AccessSlotNo}                 6
${AAU_ResetValue}                   0               #不影响下一级复位


${SLEEP_TIME}                       1min
${AAU_ResetValue_EffectNextRru}     1               #影响下一级复位


${ftp_dir}                          C:\\rru_log

${FILE_PRO2DDR0_BIN}                PRO2DDR0.bin
${CRRU_SPI_FPGA}                    ${8}
${TRXIQ}                            ${0}


*** Keywords ***
#***********************************************************************************
#功能     ：A1-获取PGC参数值                                                       *
#标签     ：mandatory                                                              *
#索引     ：天线编号  一维                                                         *
#入参     ：天线编号                                                               *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：0                                                                      *
#所属模块 ：CELL                                                                   *
#适用用例 ：                                                                       *
#负责人   ：zhaobaoxin                                                             *
#调用方法 ：调用天线编号，获取PGC参数值                                            *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
#Cell Should be Enabled
获取PGC参数值
    [Documentation]    获取PGC参数值
    [Tags]             mandatory
    [Arguments]
    [Teardown]         Log    Cell is enabled!
    [Timeout]          0

#2） PGC（AGC）等与增益设置相关参数的计算结果一致
#        /* 获取PGC */
#        case OSP_RFM_GET_PGC:
#        {
#            ret = rru_osp_getpgc(((OSP_STRU_PGC *)u32Arg)->u8AntNum,
#                                          ((OSP_STRU_PGC *)u32Arg)->u8UpDownLink,
#                                          &((OSP_STRU_PGC *)u32Arg)->u32PgcValue);
#        }
    @{pgc_result_list}    Create List
    Log To Console    \n获取上行PGC参数值:
    :FOR    ${AntNo}    IN RANGE    ${ANT_NO_MAX}
    \    ${execute_result}    ${reslut}=    Execute Command With Out Datas by UAgent    rru_osp_getpgc    ${AntNo}    ${OSP_RFM_GET_PGC_UPLINK}    <4>
#    \    Run Keyword If    ${execute_result} == ${0}
    \    ${result_cvt}    member_decode_to_integer_negative    ${reslut}
    \    Append to List    ${pgc_result_list}    ${result_cvt}
    Log To Console    \n@{pgc_result_list}


#***********************************************************************************
#功能     ：A2-MP2953设备电压查询                                                  *
#标签     ：mandatory                                                              *
#索引     ：MP2953设备索引  一维                                                   *
#入参     ：MP2953设备索引                                                         *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：0                                                                      *
#所属模块 ：RRU                                                                    *
#适用用例 ：                                                                       *
#负责人   ：zhaobaoxin                                                             *
#调用方法 ：输入设备索引，获取设备电压数值                                         *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
MP2953设备电压查询
    [Documentation]    MP2953设备电压查询
    [Tags]             mandatory
    [Arguments]
    [Teardown]         Log    Cell is enabled!
    [Timeout]          0

    #参考函数原型使用
    #/*******************************************************************************
    #* 函数名称: rru_mp2953_volt_read_dmbg
    #* 函数功能: 通过I2C接口读取电源模块电压
    #* 函数参数:
    #* 参数名称:        类型      输入/输出     描述
    #*            u8 u8Location     输入      用该位区分是MP2953A还是MP2953B
    #*            u8 u8Point        无效
    #*            u16 *pu16Data     输出      回读电压值
    #*
    #* 返回值:   NB_OK 表示成功；其它值表示失败。
    #* 函数类型:
    #* 函数说明:通过I2C接口读取电源模块电压
    #*
    #* 修改日期    版本号   修改人  修改内容（局限在本函数内的缺陷修改需要写在此处）
    #* -----------------------------------------------------------------
    #* 2018/06/13  liying5  xxxxxxxxxxxxx  创建函数
    #*******************************************************************************/
    #OSP_STATUS rru_mp2953_volt_read_dmbg(u8 u8Location,
    #                                u8 u8Point,
    #                                u16 *u16Data)
    :FOR    ${loop}    IN RANGE    ${MP2953_DEVICE_MAX}
    \    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    rru_mp2953_volt_read_dmbg
    \    ...    ${MP2953_DEVICE_A}
    \    ...    ${0}
    \    ...    <2>
    \    ${result_decode}    member_decode_to_integer_little    ${reslut_list}
    \    Run Key Word If    0 == ${loop}    Log To Console    \n ret= ${execute_result}, MP2953A: VOLT = ${result_decode}mv
    \    Run Key Word If    1 == ${loop}    Log To Console    \n ret= ${execute_result}, MP2953B: VOLT = ${result_decode}mv


#***********************************************************************************
#功能     ：A3-MP2953设备电流查询                                                  *
#标签     ：mandatory                                                              *
#索引     ：设备索引  一维                                                         *
#入参     ：设备索引                                                               *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：0                                                                      *
#所属模块 ：RRU                                                                    *
#适用用例 ：                                                                       *
#负责人   ：zhaobaoxin                                                             *
#调用方法 ：输入设备索引，获取设备电流数值                                         *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
MP2953设备电流查询
    [Documentation]    MP2953设备电流查询
    [Tags]             mandatory
    [Arguments]
    [Teardown]         Log    Cell is enabled!
    [Timeout]          0

    #rru_mp2953_current_read_dmbg
    :FOR    ${loop}    IN RANGE    ${MP2953_DEVICE_MAX}
    \    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    rru_mp2953_current_read_dmbg
    \    ...    ${loop}
    \    ...    ${0}
    \    ...    <2>
    \    ${result_decode}    member_decode_to_integer_little    ${reslut_list}
    \    Run Key Word If    0 == ${loop}    Log To Console    \n ret= ${execute_result}, MP2953A: CURRENT = ${result_decode}A
    \    Run Key Word If    1 == ${loop}    Log To Console    \n ret= ${execute_result}, MP2953B: CURRENT = ${result_decode}A


#***********************************************************************************
#功能     ：A4-MP2953设备温度查询                                                  *
#标签     ：mandatory                                                              *
#索引     ：设备索引  一维                                                         *
#入参     ：设备索引                                                               *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：0                                                                      *
#所属模块 ：RRU                                                                    *
#适用用例 ：                                                                       *
#负责人   ：zhaobaoxin                                                             *
#调用方法 ：输入设备索引，获取设备温度                                             *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
MP2953设备温度查询
    [Documentation]    MP2953设备温度查询
    [Tags]             mandatory
    [Arguments]
    [Teardown]         Log    Cell is enabled!
    [Timeout]          0

    #rru_mp2953_temp_read_dmbg
    :FOR    ${loop}    IN RANGE    ${MP2953_DEVICE_MAX}
    \    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    rru_mp2953_temp_read_dmbg
    \    ...    ${loop}
    \    ...    ${0}
    \    ...    <2>
    \    ${result_decode}    member_decode_to_integer_little    ${reslut_list}
    \    Run Key Word If    0 == ${loop}    Log To Console    \n ret= ${execute_result}, MP2953A: Temperature ${result_decode}
    \    Run Key Word If    1 == ${loop}    Log To Console    \n ret= ${execute_result}, MP2953B: Temperature ${result_decode}


#***********************************************************************************
#功能     ：A5-LM730设备温度查询                                                   *
#标签     ：mandatory                                                              *
#索引     ：设备索引  一维                                                         *
#入参     ：设备索引                                                               *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：0                                                                      *
#所属模块 ：RRU                                                                    *
#适用用例 ：                                                                       *
#负责人   ：zhaobaoxin                                                             *
#调用方法 ：输入设备索引，获取设备温度                                             *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
LM730设备温度查询
    [Documentation]    LM730设备温度查询
    [Tags]             mandatory
    [Arguments]
    [Teardown]         Log    Cell is enabled!
    [Timeout]          0

    #rru_dts_temp_read
    :FOR    ${Loop}    IN    @{LM73_DEVICE_LIST}
    \    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent
    \                                       ...    rru_dts_temp_read    ${Loop}    <2>
    #\    log to console    ${reslut_list}
    \    ${result_decode}    member_decode_to_integer_little    ${reslut_list}
    \    Log To Console    \n ret= ${execute_result} LM73${Loop-2}: Temperature ${result_decode}


#***********************************************************************************
#功能     ：A6-U9P设备温度查询                                                     *
#标签     ：mandatory                                                              *
#索引     ：                                                                       *
#入参     ：设备名称                                                               *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：0                                                                      *
#所属模块 ：RRU                                                                    *
#适用用例 ：                                                                       *
#负责人   ：zhaobaoxin                                                             *
#调用方法 ：输入设备索引，获取设备温度                                             *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
VU9P设备温度查询
    [Documentation]    VU9P设备温度查询
    [Tags]             mandatory
    [Arguments]
    [Teardown]         Log    Cell is enabled!
    [Timeout]          0

    #tst_get_vu9p_temp
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    tst_get_vu9p_temp
    Log To Console    \n ret= ${execute_result} VU9P: Temperature ${reslut_list}


#***********************************************************************************
#功能     ：A7-以太芯片链路状态                                                    *
#标签     ：mandatory                                                              *
#索引     ：链路索引  一维                                                         *
#入参     ：链路索引                                                               *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：0                                                                      *
#所属模块 ：RRU                                                                    *
#适用用例 ：                                                                       *
#负责人   ：zhaobaoxin                                                             *
#调用方法 ：输入链路索引，获取链路状态                                             *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
以太芯片链路状态
    [Documentation]    以太芯片链路状态
    [Tags]             mandatory
    [Arguments]
    [Teardown]         Log    Cell is enabled!
    [Timeout]          0

    #以太链路状态(0-15bit表示16路BASE-T Link状态，16bit表示GMII Link状态): 0x1205f
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    rru_bcm5396_get_link_sta    <4>
    ${result_decode}    member_decode_to_integer_little    ${reslut_list}
    Log To Console    \n 以太链路状态(0-15bit表示16路BASE-T Link状态，16bit表示GMII Link状态):${result_decode}
    #RRU_READ_FPGA_ZYNQ

#***********************************************************************************
#功能     ：A8-电口204B误码率状态查询                                              *
#标签     ：mandatory                                                              *
#索引     ：光口索引  一维                                                         *
#入参     ：光口索引                                                               *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：0                                                                      *
#所属模块 ：RRU                                                                    *
#适用用例 ：                                                                       *
#负责人   ：zhaobaoxin                                                             *
#调用方法 ：输入光口索引，获取光口误码率状态                                       *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
电口204B误码率状态查询
    [Documentation]    电口204B误码率状态查询
    [Tags]             mandatory
    [Arguments]
    [Teardown]         Log    Cell is enabled!
    [Timeout]          0

    #查询光口误码率原则上是从设备上电开始，应该一段时间内连续查询寄存器，且查出来的值不变或者减小。
    @{list_result_decode}    Create List
    :for    ${i}    in range    0    3
    \    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent   rru_fpgareg_zynqread
    ...  ${CRRU_FPGAREG_JESD_MODID}    ${ELE_204B_ADDR}    <4>
    \    ${result_decode}    member_decode_to_hex_little    ${reslut_list}
    \    Append to List    ${list_result_decode}    ${result_decode}
    Log To Console    \n @{list_result_decode}
    #Log To Console    \n ret =${execute_result} rru_fpgareg_zynqread(${CRRU_FPGAREG_JESD_MODID},${ELE_204B_ADDR}) Result= ${result_decode}
    :for    ${j}    in range    0     2
    \    Should be equal    ${list_result_decode[${j}]}    ${list_result_decode[${j+1}]}
    [Return]    @{list_result_decode}


#***********************************************************************************
#功能     ：A9-链路连接查询                                                        *
#标签     ：mandatory                                                              *
#索引     ：链路索引  一维                                                         *
#入参     ：链路索引                                                               *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：0                                                                      *
#所属模块 ：RRU                                                                    *
#适用用例 ：                                                                       *
#负责人   ：zhaobaoxin                                                             *
#调用方法 ：输入链路索引，获取链路连接状态                                         *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
链路连接查询
    [Documentation]    链路连接查询
    [Tags]             mandatory
    [Arguments]
    [Teardown]         Log    Cell is enabled!
    [Timeout]          0

    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent   rru_fpgareg_zynqread
    ...    ${CRRU_FPGAREG_JESD_MODID}    ${IS_0303VALUE_ADDR}    <4>
    ${result_decode}    member_decode_to_hex_little    ${reslut_list}
    Log To Console    \n ret =${execute_result} rru_fpgareg_zynqread(${CRRU_FPGAREG_JESD_MODID},${IS_0303VALUE_ADDR}) Result= ${result_decode}
    Should be equal    ${result_decode}    ${204bRightStatus}

#***********************************************************************************
#功能     ：A10-链路连接查询2                                                      *
#标签     ：mandatory                                                              *
#索引     ：链路索引  一维                                                         *
#入参     ：链路索引                                                               *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：0                                                                      *
#所属模块 ：RRU                                                                    *
#适用用例 ：                                                                       *
#负责人   ：zhaobaoxin                                                             *
#调用方法 ：                                                                       *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
链路连接查询2
    [Documentation]    链路连接查询
    [Tags]             mandatory
    [Arguments]
    [Teardown]         Log    Cell is enabled!
    [Timeout]          0

    linkStatusMonitor


#***********************************************************************************
#功能     ：A11-读取行状态获取可用的射频单元号                                     *
#标签     ：mandatory                                                              *
#索引     ：射频单元索引  一维                                                     *
#入参     ：                                                                       *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：0                                                                      *
#所属模块 ：RRU                                                                    *
#适用用例 ：                                                                       *
#负责人   ：zhaobaoxin                                                             *
#调用方法 ：                                                                       *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Get Useful rruPathRRUNo
    [Documentation]    读取行状态获取可用的射频单元号
    [Tags]             mandatory
    [Arguments]
    [Teardown]         Log    Cell is enabled!
    [Timeout]          0

    @{RruNo_List}    Get Useful RowStatus By Name    rruPathRowStatus
    # ${LoopTimesMax}    Set Variable    ${95*64}

    # ${oid}    Get Oid By Name    ${Mib}    rruPathRowStatus    #根据名称获取Oid
    # ${OIDBase}    Set Variable     ${oid}
    # @{rruPathRowStatus_List}    Create List
    # Log    ${LoopTimesMax}
    # :FOR    ${n}    IN RANGE    ${LoopTimesMax}
    # \    ${oidAndVal}    Get Next    ${oid}
    # \    Log    oidAndVal=${oidAndVal}
    # \    Run Keyword If    ${oidAndVal} == ()    Exit For Loop
    # \    Log Many    oid=${oidAndVal[0]}    value=${oidAndVal[1]}
    # \    Run Keyword If    '${oidAndVal[1]}' == 'createAndGo'
    #     ...    Append to List    ${rruPathRowStatus_List}     ${n}
    # \    ${oid}    Set Variable    ${oidAndVal[0]}

    # [Return]    @{rruPathRowStatus_List}

#***********************************************************************************
#功能     ：A13-Set Value For Is_RRU_Exist                                         *
#标签     ：mandatory                                                              *
#索引     ：参数值  一维                                                           *
#入参     ：参数值                                                                 *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：0                                                                      *
#所属模块 ：RRU                                                                    *
#适用用例 ：                                                                       *
#负责人   ：zhaobaoxin                                                             *
#调用方法 ：                                                                       *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Set Value For Is_RRU_Exist
    [Documentation]    获取可用的射频单元编号 列表
    [Tags]             mandatory
    [Arguments]        ${Value}
    [Teardown]         Log    Cell is enabled!
    [Timeout]          0

    ${Is_RRU_Exist}    ${Value}


#***********************************************************************************
#功能     ：B1-AAU接口板发起重启流程                                               *
#标签     ：mandatory                                                              *
#索引     ：                                                                       *
#入参     ：                                                                       *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：0                                                                      *
#所属模块 ：RRU                                                                    *
#适用用例 ：                                                                       *
#负责人   ：zhaobaoxin                                                             *
#调用方法 ：调用AAU重启函数                                                        *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
AAUReboot
    [Documentation]    AAU接口板发起重启流程
    [Tags]             mandatory
    [Arguments]
    [Teardown]         Disconnect UAgent Use Pid
    [Timeout]          0

    Connect Device By UAgent Use Pid    ${host_name}    ${host_address}    ${pId}
    ${execute_result}    ${execute_value}    execute_command_with_disconnect_after_command    rru_reboot
    Log To Console    \n rru_reboot:ret = ${execute_result} (ECMD_RSP2_TIMEOUT_ERROR = -6)
    :FOR    ${loop_time}    IN RANGE    ${10}
    \    Log To Console    \n 等待${loop_time+1}*${Sleep_Time}
    \    Sleep    ${Sleep_Time}

    AAU Status Check After Restart

#================================rruPathTxPower Start======================================
#***********************************************************************************
#功能     ：获取某一射频单元天线通道编号的发送方向输出功率                         *
#标签     ：TODO                                                                   *
#索引     ：                                                                       *
#入参     ：rruPathRRUNo 射频单元编号                                              *
#           rruPathNo射频单元天线通道编号                                          *
#返回值   ：发送方向输出功率                                                       *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：RRU                                                                    *
#适用用例 ：                                                                       *
#负责人   ：zhaobaoxin                                                             *
#调用方法 ：                                                                       *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Get rruPathTxPower Value Each
    [Arguments]    ${rruPathRRUNo}    ${rruPathNo}
    [Return]    ${ret}
    ${RruEntry}    Get Oid By Name    ${Mib}    rruPathTxPower
    ${ret}    Get_rruPathTable_Value_Each    ${RruEntry}    ${rruPathRRUNo}    ${rruPathNo}
Get rruPathTxPower Value
    [Documentation]    Get rruPathTxPower Value
    [Tags]
    [Arguments]    ${rruPathRRUNo}    ${rruPathNo}
    [Teardown]
    [Timeout]
    [Return]    ${ret_rruPathTxPower}
    ${ret_rruPathTxPower}    Get rruPathTxPower Value Each    ${rruPathRRUNo}    ${rruPathNo}

#***********************************************************************************
#功能     ：查询口空功率是否合理                                                   *
#标签     ：TODO                                                                   *
#索引     ：                                                                       *
#入参     ：ret_rruPathTxPower 查询口空功率                                        *
#返回值   ：True 合理 False 不合理                                                 *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：RRU                                                                    *
#适用用例 ：                                                                       *
#负责人   ：zhaobaoxin                                                             *
#调用方法 ：                                                                       *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Check rruPathTxPower Value
    [Arguments]    ${ret_rruPathTxPower}
    Return From Keyword If    ${ret_rruPathTxPower} < 33    ${False}
    Return From Keyword If    ${ret_rruPathTxPower} > 37    ${False}
    [Return]    ${True}
Is rruPathTxPower Over Range
    [Documentation]    Is rruPathTxPower Over Range
    [Tags]
    [Arguments]     ${ret_rruPathTxPower}
    [Teardown]
    [Timeout]
    [Return]    ${ret}
    ${ret}    Check rruPathTxPower Value    ${ret_rruPathTxPower}

#***********************************************************************************
#功能     ：获取某一射频单元天线通道编号的通道开关状态                             *
#标签     ：TODO                                                                   *
#索引     ：                                                                       *
#入参     ：rruPathRRUNo 射频单元编号                                              *
#           rruPathNo射频单元天线通道编号                                          *
#返回值   ：开关状态                                                               *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：RRU                                                                    *
#适用用例 ：                                                                       *
#负责人   ：zhaobaoxin                                                             *
#调用方法 ：                                                                       *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
 Get rruPathOpenState Value
    [Documentation]    Get rruPathOpenState Value
    [Tags]
    [Arguments]    ${rruPathRRUNo}    ${rruPathNo}
    [Teardown]
    [Timeout]
    [Return]    ${ret_rruPathTxPower}
    ${RruEntry}    Get Oid By Name    ${Mib}    rruPathOpenState
    ${ret_rruPathTxPower}    Get_rruPathTable_Value_Each    ${RruEntry}    ${rruPathRRUNo}    ${rruPathNo}

#***********************************************************************************
#功能     ：设置某一射频单元天线通道编号的通道开关状态                             *
#标签     ：TODO                                                                   *
#索引     ：                                                                       *
#入参     ：Value 开关状态                                                         *
#           rruPathRRUNo 射频单元编号                                              *
#           rruPathNo射频单元天线通道编号                                          *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：RRU                                                                    *
#适用用例 ：                                                                       *
#负责人   ：zhaobaoxin                                                             *
#调用方法 ：                                                                       *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Set rruPathOpenState Value Each
    [Documentation]    Get rruPathOpenState Value
    [Tags]
    [Arguments]    ${Value}    ${rruPathRRUNo}    ${rruPathNo}
    [Teardown]
    [Timeout]
    log    \n${Value},${rruPathRRUNo},${rruPathNo}
    ${RruEntry}    Get Oid By Name    ${Mib}    rruPathOpenState
    Set_rruPathTable_Value_Each    ${RruEntry}    ${Value}    ${rruPathRRUNo}    ${rruPathNo}

#Set rruPathOpenState On
#    [Arguments]    ${OpenState}    ${rruPathRRUNo}    ${rruPathNo}
#    log    \n${OpenState},${rruPathRRUNo},${rruPathNo}
#    #打开当前状态为'off'的射频单元
#    Run Keyword If    '${OpenState}' == 'off'
#    ...    Set rruPathOpenState Value Each    on    ${rruPathRRUNo}    ${rruPathNo}
#    Sleep    2s
#    #log to console    \n Loop For All rruPathTable ChildNode:${ret_rruPathTxPower}
#    ${ret}    Check rruPathTxPower Value    ${ret_rruPathTxPower}
#    #打开后需要再次关闭
#    Run Keyword If    '${OpenState}' == 'off'
#    ...    Set rruPathOpenState Value Each    off    ${rruPathRRUNo}    ${rruPathNo}
#    [Return]    ${ret}    ${ret_rruPathTxPower}

#***********************************************************************************
#功能     ：打桩应该保证所有通道开关状态为打开                                     *
#标签     ：TODO                                                                   *
#索引     ：                                                                       *
#入参     ：Value 开关状态                                                         *
#           rruPathRRUNo 射频单元编号                                              *
#           rruPathNo射频单元天线通道编号                                          *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：RRU                                                                    *
#适用用例 ：                                                                       *
#负责人   ：zhaobaoxin                                                             *
#调用方法 ：                                                                       *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Check rruPathOpenState Is On
    [Documentation]    Check rruPathOpenState Is On
    [Tags]
    [Arguments]    ${rruPathRRUNo}    ${rruPathNo}
    [Teardown]
    [Timeout]
    ${ret}    Get rruPathOpenState Value    ${rruPathRRUNo}    ${rruPathNo}
    Should be equal    '${ret}'    'on'

#***********************************************************************************
#功能     ：循环遍历rruPathTable节点下的子节点                                     *
#标签     ：TODO                                                                   *
#索引     ：                                                                       *
#入参     ：Value 开关状态                                                         *
#           rruPathRRUNo 射频单元编号                                              *
#           rruPathNo射频单元天线通道编号                                          *
#返回值   ：ret_Bool 查询的值是否合理                                              *
#           ret_rruPathTxPower 查询发送方向输出功率                                *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：RRU                                                                    *
#适用用例 ：                                                                       *
#负责人   ：zhaobaoxin                                                             *
#调用方法 ：                                                                       *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Loop For All rruPathTable ChildNode
    [Documentation]    Loop For All rruPathTable ChildNode
    [Tags]
    [Arguments]    ${rruPathRRUNo}    ${rruPathNo}
    [Teardown]
    [Timeout]
    [Return]    ${ret_Bool}    ${ret_rruPathTxPower}
    #Check rruPathOpenState Is On    ${rruPathRRUNo}    ${rruPathNo}
    ${ret_rruPathTxPower}    Get rruPathTxPower Value    ${rruPathRRUNo}    ${rruPathNo}
    ${ret_Bool}              Is rruPathTxPower Over Range    ${ret_rruPathTxPower}

#***********************************************************************************
#功能     ：循环遍历rruPathNo节点下的子节点                                        *
#标签     ：TODO                                                                   *
#索引     ：                                                                       *
#入参     ：Value 开关状态                                                         *
#           rruPathRRUNo 射频单元编号                                              *
#           rruPathNo射频单元天线通道编号                                          *
#返回值   ：ret_Bool 查询的值是否合理                                              *
#           ret_rruPathTxPower 查询发送方向输出功率                                *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：RRU                                                                    *
#适用用例 ：                                                                       *
#负责人   ：zhaobaoxin                                                             *
#调用方法 ：                                                                       *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Loop For All rruPathNo
    [Documentation]    Loop For All rruPathNo
    [Tags]
    [Arguments]    ${rruPathRRUNo}    ${rruPathNo}
    [Teardown]
    [Timeout]
    [Return]    ${ret_Bool}    &{rruPathTxPower_dic}
    ${ret_Bool}    Set Variable    ${True}
    &{rruPathTxPower_dic}    Create Dictionary

    :FOR    ${item}    in    @{rruPathNo}
    \    ${ret_error}    ${ret_value}    Loop For All rruPathTable ChildNode    ${rruPathRRUNo}    ${item}
    \    Continue For Loop If    ${ret_error} == ${True}
    \    ${ret_Bool}    Set Variable If    ${ret_error} == ${False}    ${False}
    \    Run Keyword If    ${ret_error} == ${False}    Set To Dictionary    ${rruPathTxPower_dic}    ${item}    ${ret_value}
    Log To Console    \n rruPathRRUNo:${rruPathRRUNo}: &{rruPathTxPower_dic}

Loop For All rruPathTable
    [Documentation]    Loop For All rruPathTable
    [Tags]
    [Arguments]    ${rruPathRRUNo}    @{rruPathNo}
    [Teardown]
    [Timeout]
    :FOR    ${item}    in    @{rruPathRRUNo}
    \    ${exect_result}    ${err_PathNo}    Loop For All rruPathNo    ${item}    @{rruPathNo}
    \    Continue For Loop If     ${exect_result} == ${True}
    \    Return From Keyword If     ${exect_result} == ${False}    ${False}
    [Return]    ${True}

#***********************************************************************************
#功能     ：B5.开天线并获取发送方功率                                                 *
#标签     ：TODO                                                                   *
#索引     ：                                                                       *
#入参     ：无                                                                     *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：RRU                                                                    *
#适用用例 ：                                                                       *
#负责人   ：zhaobaoxin                                                             *
#调用方法 ：                                                                       *
#                                                                                  *
#备注     ：调用get_rruPathRRUNo_Instence_En获取有效的‘射频单元编号’和‘射频单元天线*
#           通道编号’                                                              *
#                                                                                  *
#***********************************************************************************
Open Ant and Get rruPathTxPower
    [Documentation]    开天线并获取发送方功率
    [Tags]
    #[Arguments]
    [Teardown]
    [Timeout]
    ${RruEntry}    Get Oid By Name    ${Mib}    rruPathRowStatus
    @{rruPathRRUNo}    get_rruPathRRUNo_Instence_En    ${RruEntry}    ${95}    ${64}    rruPathRRUNo
    @{rruPathNo}    get_rruPathRRUNo_Instence_En    ${RruEntry}    ${95}    ${64}    rruPathNo

    :FOR    ${item}    in    ${rruPathRRUNo}
    \    ${ret}    Loop For All rruPathTable    ${item}    @{rruPathNo}
    \    Should be equal    ${ret}    ${True}

#================================rruPathTxPower End======================================

#***********************************************************************************
#功能     ：B3-时域打桩开始命令                                                       *
#标签     ：TODO                                                                   *
#索引     ：                                                                       *
#入参     ：无                                                                     *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：RRU                                                                    *
#适用用例 ：                                                                       *
#负责人   ：zhaobaoxin                                                             *
#调用方法 ：                                                                       *
#                                                                                  *
#备注     ：需要先mount打桩文件到AAU接口板，且调用的打桩命令为第九次升级增加接口   *
#                                                                                  *
#***********************************************************************************
Time Piling Start
    [Documentation]    时域打桩开始命令
    [Tags]
    #[Arguments]
    [Teardown]    Disconnect UAgent Use Pid
    [Timeout]
    Connect Device By UAgent Use Pid    ${host_name}    ${AIU_address}    ${pId}
    ${ret}    Execute Command by UAgent    RRU_TIME_PILING_START    \/ramDisk\/''${ifft_InData}''
    Should be equal    ${ret}    ${0}

#***********************************************************************************
#功能     ：B4-时域打桩结束命令                                                       *
#标签     ：TODO                                                                   *
#索引     ：                                                                       *
#入参     ：无                                                                     *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：RRU                                                                    *
#适用用例 ：                                                                       *
#负责人   ：zhaobaoxin                                                             *
#调用方法 ：                                                                       *
#                                                                                  *
#备注     ：需要先mount打桩文件到AAU接口板，且调用的打桩命令为第九次升级增加接口   *
#                                                                                  *
#***********************************************************************************
Time Piling Stop
    [Documentation]    时域打桩结束命令
    [Tags]
    #[Arguments]
    [Teardown]    Disconnect UAgent Use Pid
    [Timeout]
    Connect Device By UAgent Use Pid    ${host_name}    ${AIU_address}    ${pId}
    ${ret}    Execute Command by UAgent    RRU_TIME_PILING_STOP

#================================FILE DownLoad Start======================================
#***********************************************************************************
#功能     ：Mount文件到对应的设备                                                  *
#标签     ：TODO                                                                   *
#索引     ：                                                                       *
#入参     ：host_ip PC端IP                                                         *
#           Path PC端文件所在源路径                                                *
#返回值   ：0 mount成功 其他：mount失败                                           *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：RRU                                                                    *
#适用用例 ：                                                                       *
#负责人   ：zhaobaoxin                                                             *
#调用方法 ：                                                                       *
#                                                                                  *
#备注     ：需要在PC端开启NFS server服务                                           *
#                                                                                  *
#***********************************************************************************
File Mount Command
    [Documentation]    File Mount Command
    [Tags]
    [Arguments]    ${LocalHostIp}    ${TargetIp}
    [Teardown]    Disconnect UAgent Use Pid
    [Timeout]
    [Return]    ${ret}

    #Connect Device By UAgent Use Pid    ${host_name}    ${DeviceIp}    ${0}
    Connect Device By UAgent Use Pid    ${host_name}    ${TargetIp}    ${pId}

    ${Path}    File Mount Command By DeviceIp    ${TargetIp}
    ${ret}    Execute Command by UAgent    cmd    'mount -t nfs '${LocalHostIp}':'${Path}' /mnt -o nolock\n'    ''
    Log To Console    \n Mount return ${ret}.
    Run Keyword If    ${ret} == ${0xFF00}    Log To Console    \n Already mount,please Check.

#***********************************************************************************
#功能     ：通过目的IP，获取Mount文件的不同路径                                    *
#标签     ：TODO                                                                   *
#索引     ：                                                                       *
#入参     ：DeviceIp 目的设备调试IP                                                *
#返回值   ：Mount路径                                                              *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：RRU                                                                    *
#适用用例 ：                                                                       *
#负责人   ：zhaobaoxin                                                             *
#调用方法 ：                                                                       *
#                                                                                  *
#备注     ：目前还存在一个问题，umount动作会导致任务Busy的错误，所以需要接口板和四 *
#           个射频板分别mount不同文件夹，导致了如下的处理                          *
#***********************************************************************************
File Mount Command By DeviceIp
    [Documentation]    File Mount Command By DeviceIp
    [Tags]
    [Arguments]    ${DeviceIp}
    [Teardown]
    [Timeout]

    ${FilePath}    Set Variable If    '${DeviceIp}' == '${AIU_address}'
    ...    /d/nfsroot/AIU
    Return From Keyword If    '${DeviceIp}' == '${AIU_address}'    ${FilePath}

    ${FilePath}    Set Variable If    '${DeviceIp}' == '${ARU1_address}'
    ...    /d/nfsroot/ARU1
    Return From Keyword If    '${DeviceIp}' == '${ARU1_address}'    ${FilePath}

    ${FilePath}    Set Variable If    '${DeviceIp}' == '${ARU2_address}'
    ...    /d/nfsroot/ARU2
    Return From Keyword If    '${DeviceIp}' == '${ARU2_address}'    ${FilePath}

    ${FilePath}    Set Variable If    '${DeviceIp}' == '${ARU3_address}'
    ...    /d/nfsroot/ARU3
    Return From Keyword If    '${DeviceIp}' == '${ARU3_address}'    ${FilePath}

    ${FilePath}    Set Variable If    '${DeviceIp}' == '${ARU4_address}'
    ...    /d/nfsroot/ARU4
    Return From Keyword If    '${DeviceIp}' == '${ARU4_address}'    ${FilePath}

#***********************************************************************************
#功能     ：Umont文件命令                                                          *
#标签     ：TODO                                                                   *
#索引     ：                                                                       *
#入参     ：无                                                                     *
#返回值   ：0 mount成功 其他：mount失败                                            *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：RRU                                                                    *
#适用用例 ：                                                                       *
#负责人   ：zhaobaoxin                                                             *
#调用方法 ：                                                                       *
#                                                                                  *
#备注     ：还有问题，暂时规避                                                     *
#                                                                                  *
#***********************************************************************************
File Umount Command
    [Documentation]    File Umount Command
    [Tags]
    [Arguments]    ${TargetIp}
    [Teardown]    Disconnect UAgent Use Pid
    [Timeout]
    [Return]    ${ret}

    Connect Device By UAgent Use Pid    ${host_name}    ${TargetIp}    ${pId}
    ${ret}    Execute Command by UAgent    cmd    'umount /mnt\n'    ''
    Log To Console    \n Umount return ${ret}.
    Run Keyword If    ${ret} == ${0x100}    Log To Console    \n Already umount,please Check.

#***********************************************************************************
#功能     ：执行mount文件中的shell脚本命令                                         *
#标签     ：TODO                                                                   *
#索引     ：                                                                       *
#入参     ：AutoOrMan 手动恢复环境还是自动恢复 TargetIp 目标IP地址                 *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：RRU                                                                    *
#适用用例 ：                                                                       *
#负责人   ：zhaobaoxin                                                             *
#调用方法 ：                                                                       *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Execute Shell Command
    [Documentation]    Execute Shell Command
    [Tags]
    [Arguments]    ${AutoOrMan}    ${TargetIp}
    [Teardown]    Disconnect UAgent Use Pid
    [Timeout]

    Connect Device By UAgent Use Pid    ${host_name}    ${TargetIp}    ${pId}
    Log To Console    \n Input Para is ${AutoOrMan}.
    Run Keyword If    'Auto' == '${AutoOrMan}'
    ...    execute_command_with_disconnect_after_command    cmd     'sh /mnt/DTM.sh\n''
    Run Keyword If    'Man' == '${AutoOrMan}'
    ...    execute_command_with_disconnect_after_command    cmd     'sh /mnt/DTM_Mamual.sh\n''

#***********************************************************************************
#功能     ：拷贝文件到ramDisk中                                                    *
#标签     ：TODO                                                                   *
#索引     ：                                                                       *
#入参     ：待拷贝的文件名                                                         *
#返回值   ：0 拷贝成功 其他：拷贝失败                                              *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：RRU                                                                    *
#适用用例 ：                                                                       *
#负责人   ：zhaobaoxin                                                             *
#调用方法 ：                                                                       *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Copy File To ramDisk
    [Documentation]    Copy File To ramDisk
    [Tags]
    [Arguments]    ${File_Name}    ${TargetIp}
    [Teardown]    Disconnect UAgent Use Pid
    [Timeout]
    [Return]    ${ret}

    Connect Device By UAgent Use Pid    ${host_name}    ${TargetIp}    ${0}
    ${ret}    Execute Command by UAgent    cmd    'cp /mnt/"${File_Name}" /ramDisk\n'    ''
    Sleep    5s

#***********************************************************************************
#功能     ：检查文件是否存在                                                       *
#标签     ：TODO                                                                   *
#索引     ：                                                                       *
#入参     ：待拷贝的文件名                                                         *
#返回值   ：0 拷贝成功 其他：拷贝失败                                              *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：RRU                                                                    *
#适用用例 ：                                                                       *
#负责人   ：zhaobaoxin                                                             *
#调用方法 ：                                                                       *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Check File Is Exist
    [Documentation]    Check File Is Exist
    [Tags]
    [Arguments]    ${File_Path}    ${FileName}    ${TargetIp}
    [Teardown]    Disconnect UAgent Use Pid
    [Timeout]
    [Return]    ${ret}

    Connect Device By UAgent Use Pid    ${host_name}    ${TargetIp}    ${pId}
    ${ret}    Execute Command by UAgent    cmd    'ls -al "${File_Path}" |grep "${FileName}"\n'    ''
    Run Keyword If    ${ret} == ${0x100}    Log To Console    File:${FileName} is gone in ${File_Path} floder.\n

#***********************************************************************************
#功能     ：获取PC机IP地址                                                         *
#标签     ：TODO                                                                   *
#索引     ：                                                                       *
#入参     ：                                                                       *
#返回值   ：IP地址                                                                 *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：RRU                                                                    *
#适用用例 ：                                                                       *
#负责人   ：zhaobaoxin                                                             *
#调用方法 ：                                                                       *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Get Local Host Ip
    [Documentation]    Get Local Host Ip
    [Tags]
    #[Arguments]
    [Teardown]
    [Timeout]
    [Return]    ${host_ip}
    ${host_ip}    get_host_ip
    Log To Console    \n Get Host IP is ${host_ip}.
    Should not be equal    '${host_ip}'    '0.0.0.0'

#***********************************************************************************
#功能     ：B2-Mount文件到ramDisk                                                  *
#标签     ：TODO                                                                   *
#索引     ：                                                                       *
#入参     ：FileName 文件名 DeviceIp 设备IP                                        *
#返回值   ：IP地址                                                                 *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：RRU                                                                    *
#适用用例 ：                                                                       *
#负责人   ：zhaobaoxin                                                             *
#调用方法 ：                                                                       *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Mount File To ramDisk
    [Documentation]    Mount文件到ramDisk
    [Tags]
    [Arguments]    ${FileName}    ${TargetIp}
    [Teardown]    Disconnect UAgent Use Pid
    [Timeout]

    ${LocalHostIp}    Get Local Host Ip
    ${ret}    File Mount Command    ${LocalHostIp}    ${TargetIp}
    ${ret}    Check File Is Exist    /mnt    ${FileName}    ${TargetIp}
    Run Keyword If    ${ret} == ${0x100}    Log To Console     File is gone in '/mnt' floder.\n
    Run Keyword If    ${ret} == ${0}    Copy File To ramDisk    ${FileName}    ${TargetIp}

#***********************************************************************************
#功能     ：自动换AAU小包的命令行集合                                              *
#标签     ：TODO                                                                   *
#索引     ：                                                                       *
#入参     ：无                                                                     *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：RRU                                                                    *
#适用用例 ：                                                                       *
#负责人   ：zhaobaoxin                                                             *
#调用方法 ：                                                                       *
#                                                                                  *
#备注     ：暂时未用到                                                             *
#                                                                                  *
#***********************************************************************************
Small Packet Exchange Command Automatic
    [Documentation]    Small Packet Exchange Command Automatic
    [Tags]
    #[Arguments]
    [Teardown]
    [Timeout]
    ${ret1}    Execute Command by UAgent    cmd    'rm /flashDev/rru_si.out\n'    ''
    ${ret2}    Execute Command by UAgent    cmd    'rm /flashDev/running/rrusw.dtz\n'    ''
    ${ret3}    Execute Command by UAgent    cmd    'rm /flashDev/running/rru_si.out\n'    ''
    ${ret4}    Execute Command by UAgent    cmd    'cp /mnt/rru_si.out /flashDev'    ''
    ${ret5}    Execute Command by UAgent    cmd    'cp /mnt/rrusw.dtz /flashDev/running'    ''
    ${ret6}    Execute Command by UAgent    cmd    'cp /mnt/rru_si.out /flashDev/running'    ''
    Log To Console    \nSmall Packet Exchange Command Automatic ret:${ret1}${ret2}${ret3}${ret4}${ret5}${ret6}

#***********************************************************************************
#功能     ：手动换AAU小包的命令行集合                                              *
#标签     ：TODO                                                                   *
#索引     ：                                                                       *
#入参     ：无                                                                     *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：RRU                                                                    *
#适用用例 ：                                                                       *
#负责人   ：zhaobaoxin                                                             *
#调用方法 ：                                                                       *
#                                                                                  *
#备注     ：暂时未用到                                                             *
#                                                                                  *
#***********************************************************************************
Small Packet Exchange Command Manual
    [Documentation]    Small Packet Exchange Command Automatic
    [Tags]
    #[Arguments]
    [Teardown]
    [Timeout]
    ${ret}    Execute Command by UAgent    cmd    'mv /flashDev/rru_si.out /flashDev/rru_si\n'    ''
    Log To Console    \n Small Packet Exchange Command Manual ret = ${ret}
#================================FILE DownLoad End======================================

#================================Device Enviroment Recover==============================

#***********************************************************************************
#功能     ：B7-根据目的IP设备恢复对应设备环境                                         *
#标签     ：TODO                                                                   *
#索引     ：                                                                       *
#入参     ：DeviceIp 设备IP  AutoOrMan 自动或者手动恢复                            *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：RRU                                                                    *
#适用用例 ：                                                                       *
#负责人   ：zhaobaoxin                                                             *
#调用方法 ：                                                                       *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Recover One Step
    [Documentation]    Recover One Step
    [Tags]
    [Arguments]    ${TargetIp}    ${AutoOrMan}
    [Teardown]    Disconnect UAgent Use Pid
    [Timeout]

    #连接250 251 252 253 254
    Log To Console    \n AAU Device Ip Is ${TargetIp} .

    #Connect Device By UAgent Use Pid    ${host_name}    ${DeviceIp}    ${0}

    #Mount PC
    #Log To Console    \n File Mount Process.
    ${LocalHostIp}    Get Local Host Ip
    File Mount Command    ${LocalHostIp}    ${TargetIp}

    #运行脚本.Sh
    Execute Shell Command    ${AutoOrMan}    ${TargetIp}

    #File Umount Command
    #断开 250 251 252 253 254

#***********************************************************************************
#功能     ：B6-整体恢复AAU环境                                                        *
#标签     ：TODO                                                                   *
#索引     ：                                                                       *
#入参     ：AutoOrMan 手动复位或者自动恢复                                         *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：RRU                                                                    *
#适用用例 ：                                                                       *
#负责人   ：zhaobaoxin                                                             *
#调用方法 ：                                                                       *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Device Enviroment Recover
    [Documentation]    Recover One Step
    [Tags]
    [Arguments]    ${AutoOrMan}
    [Teardown]
    [Timeout]

    Recover One Step   ${AIU_address}     ${AutoOrMan}
    Recover One Step   ${ARU1_address}     ${AutoOrMan}
    Recover One Step    ${ARU2_address}     ${AutoOrMan}
    Recover One Step    ${ARU3_address}     ${AutoOrMan}
    Recover One Step    ${ARU4_address}     ${AutoOrMan}

#***********************************************************************************
#功能     ：A12-查询ORPD异常功率统计                                              *
#标签     ：mandatory                                                              *
#索引     ：                                                                       *
#入参     ：                                                                       *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：0                                                                      *
#所属模块 ：RRU                                                                    *
#适用用例 ：                                                                       *
#负责人   ：zhaobaoxin                                                             *
#调用方法 ：                                                                       *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
AAU ORPD 功率异常统计
    [Documentation]     查询ORPD异常功率统计
    [Tags]              AAU ORPD Power Test

    #0:off|关闭/1:on|打开
    #0..3
    #-1:invalid|无效/0:irSource|IR数据源/1:dacSource|DAC源/2:tdsPathSource|TDS通路源/3:tdlPathSourch|TDL通路源
    #-1:invalid|无效/0:uplink|上行/1:downlink|下行
    # -2147483648..2147483647   上行功率：（-81..-51）  下行功率（0..46）

#    Set SetTopoRRUTRxConst Value    ${1}    ${0}    ${0}    ${-60}

#    Sleep    2min

#\    ${noMatchCount}    Set Variable If    '${ofpPortStatus.ofpPortModuleLossStatus}' != 'noLosss'    ${noMatchCount+1}    ${noMatchCount}

    @{RruNo_List}    Get Useful RowStatus By Name    rruPathRowStatus
    #Log    @{RRUNo_List}
    ${Is_RRU_Exist}    Set Variable If    @{RRUNo_List} == ${Get_List_None}    ${False}    ${True}

    :FOR    ${RruNo}    in    @{RRUNo_List}
    \    Log    ${RruNo}
    #查询天线通道收发方向信息
    \    ${RruEntry}    Get Oid By Name    ${Mib}    rruPathTxStatus
    \    ${retInfoTx}    get rruPathStatusByThreshold     rruPathTxStatus    ${RruEntry}    ${RruNo}    ${64}    ${0}    ${0}
    \    Log To Console    \n 查询天线通道收方向信息:\n${retInfoTx}

    \    ${RruEntry}    Get Oid By Name    ${Mib}    rruPathRxStatus
    \    ${retInfoRx}    get rruPathStatusByThreshold     rruPathRxStatus    ${RruEntry}    ${RruNo}    ${64}    ${0}    ${0}
    \    Log To Console    \n 查询天线通道发方向信息:\n${retInfoRx}

    ##rruPathVSWR、rruPathVSWRThreshold、rruPathVSWRThreshold2nd
    \    ${RruEntry}    Get Oid By Name    ${Mib}    ${OID_Name_rruPathVSWR}
    \    ${retInfoTemp}    get rruPathStatusByThreshold     ${OID_Name_rruPathVSWR}    ${RruEntry}    ${RruNo}    ${64}    ${10}    ${13}
    \    Log To Console    \n 查询天线电压驻波比:\n${retInfoTemp}

    #定标值为35db,则门限值为+-7
    \    ${RruEntry}    Get Oid By Name    ${Mib}    ${OID_Name_rruPathTxPower}
    \    ${retInfoTemp}    get rruPathStatusByThreshold     ${OID_Name_rruPathTxPower}    ${RruEntry}    ${RruNo}    ${64}    ${28}    ${42}
    \    Log To Console    \n 发送方向输出功率:\n${retInfoTemp}

    #查询天线通道温度
    \    ${RruEntry}    Get Oid By Name    ${Mib}    rruPathTemperature
    \    ${retInfoTemp}    get rruPathStatusByThreshold     rruPathTemperature    ${RruEntry}    ${RruNo}    ${64}    ${0}    ${100}
    \    Log To Console    \n 查询天线通道温度:\n${retInfoTemp}

#    Set SetTopoRRUTRxConst Value    ${0}    ${0}    ${0}    ${-60}

    Should be equal    ${Is_RRU_Exist}    ${True}

#***********************************************************************************
#功能     ：A13-AAU时域抓数                                                        *
#标签     ：mandatory                                                              *
#索引     ：                                                                       *
#入参     ：时域方向指示：上行或者下行                                             *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：0                                                                      *
#所属模块 ：RRU                                                                    *
#适用用例 ：                                                                       *
#负责人   ：zhaobaoxin                                                             *
#调用方法 ：                                                                       *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Data Collect In Time Piling
    [Documentation]     AAU时域抓数
    [Tags]              Data Collect In Time Uplink
    [Arguments]         ${link_direction}
    [Teardown]    Disconnect UAgent Use Pid

    #Connect Device By UAgent Use Pid    ${host_name}    ${AIU_address}    ${0}

    #2.1.1   上行时域抓数：
    ${ret}    AIU WRITE FPGA Command Process     ${0}    ${0X3100}    ${link_direction}
    ${ret}    AIU WRITE FPGA Command Process     ${0}    ${0X3100}    ${0x00000000}

    #//上行时域抓数天线1-4
    #//切换PCIE对应片间DDR号
    ${ret}    AIU WRITE FPGA Command Process     ${0}    ${0X3082}    ${0x000}
    #//切换PCIE对应片内DDR号
    ${ret}    AIU WRITE FPGA Command Process     ${0}    ${0X3085}    ${0x00000000}
    #//提取时域测试结果
    Check File Is Exist    '/ramDisk'     '${FILE_PRO2DDR0_BIN}'    ${AIU_address}
    # ${ret}    Execute Command by UAgent    cmd    'fdd_pcie_fpga_tool
    # ...    '/ramDisk/${FILE_PRO2DDR0_BIN}'    ${0x0080000}    ${0x4b0000}    ${1}

    #//上行时域抓数天线5-8
    # //切换PCIE对应片间DDR号
    # AIU_WRITE_FPGA 0,0X3082,0x000
    # //切换PCIE对应片内DDR号
    # AIU_WRITE_FPGA 0,0X3085,0x00000000
    # //提取时域测试结果
    # fdd_pcie_fpga_tool "/ramDisk/PRO2DDR0.bin",0x02080000,0x4b0000,1
    ${ret}    AIU WRITE FPGA Command Process     ${0}    ${0X3082}    ${0x000}
    ${ret}    AIU WRITE FPGA Command Process     ${0}    ${0X3085}    ${0x00000000}
    Check File Is Exist    '/ramDisk'     '${FILE_PRO2DDR0_BIN}'    ${AIU_address}
    # ${ret}    Execute Command by UAgent    cmd    'fdd_pcie_fpga_tool
    # ...    '/ramDisk/${FILE_PRO2DDR0_BIN}'    ${0x02080000}    ${0x4b0000}    ${1}

    # //上行时域抓数天线9-12
    # //切换PCIE对应片间DDR号
    # AIU_WRITE_FPGA 0,0X3082,0x000
    # //切换PCIE对应片内DDR号
    # AIU_WRITE_FPGA 0,0X3085,0x04000000
    # //提取时域测试结果
    # fdd_pcie_fpga_tool "/ramDisk/PRO2DDR0.bin",0x0080000,0x4b0000,1
    ${ret}    AIU WRITE FPGA Command Process     ${0}    ${0X3082}    ${0x000}
    ${ret}    AIU WRITE FPGA Command Process     ${0}    ${0X3085}    ${0x04000000}
    Check File Is Exist    '/ramDisk'     '${FILE_PRO2DDR0_BIN}'    ${AIU_address}
    # ${ret}    Execute Command by UAgent    cmd    'fdd_pcie_fpga_tool
    # ...    '/ramDisk/${FILE_PRO2DDR0_BIN}'    ${0x0080000}    ${0x4b0000}    ${1}

    # //上行时域抓数天线13-16
    # //切换PCIE对应片间DDR号
    # AIU_WRITE_FPGA 0,0X3082,0x000
    # //切换PCIE对应片内DDR号
    # AIU_WRITE_FPGA 0,0X3085,0x04000000
    # //提取时域测试结果
    # fdd_pcie_fpga_tool "/ramDisk/PRO2DDR0.bin",0x02080000,0x4b0000,1
    #TODO:

#***********************************************************************************
#功能     ：A14-仿照AIU WRITE FPGA函数实现内部流程                                 *
#标签     ：                                                                       *
#索引     ：                                                                       *
#入参     ：                                                                       *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：0                                                                      *
#所属模块 ：RRU                                                                    *
#适用用例 ：                                                                       *
#负责人   ：zhaobaoxin                                                             *
#调用方法 ：                                                                       *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
AIU WRITE FPGA Command Process
    [Arguments]    ${chipid}    ${u16Addr}    ${u32RegVal}
    [Teardown]    Disconnect UAgent Use Pid

    Connect Device By UAgent Use Pid    ${host_name}    ${AIU_address}    ${0}

    #/* 获取互斥锁,占用硬件资源 */
    ${baseaddr_cfg}    Execute Command by UAgent    rru_dev_cpubaseaddr_cfg    ${CRRU_SPI_FPGA}    ${0}    ${0}
     Log To Console    \n 调用申请互斥锁函数返回值为:${baseaddr_cfg}
     Sleep    1s
    # /* init spi ctrl */
    Execute Command by UAgent    rru_qoriqspi_set_sampleedge    ${0}
    Sleep    1s
    @{Buff}     fpga addregval to buff    ${u16Addr}    ${u32RegVal}

    Log To Console    RegAddr = ${u16Addr} And RegVal = ${u32RegVal}.
    Execute Command by UAgent    rru_qoriqspi_16bit_write    ${TRXIQ}    ${3}
        ...    <48, [N;4;0;@{Buff}[${0}]], [N;4;4;@{Buff}[${1}]], [N;4;8;@{Buff}[${2}]]>
    Sleep    1s
    #/* 释放互斥锁 */
    ${baseaddr_free}    Execute Command by UAgent    rru_dev_cpubaseaddr_free    ${CRRU_SPI_FPGA}    ${0}    ${0}
    Log To Console    调用释放互斥锁函数返回值为:${baseaddr_free}\n
    Sleep    1s
