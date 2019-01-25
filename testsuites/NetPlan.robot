'''
网络规划测试用例
'''


from pysnmp.smi.rfc1902 import ObjectIdentity

*** Settings ***
Library    SnmpLibrary
Library    BuiltIn
Library    Collections
Library    ../utils/CiUtils.py
Resource    ../resources/SnmpMibHelper.robot
Suite Setup    Open Snmp Connection And Load Private MIB    ${DeviceIp}    ${Community}    ${MibName}

*** Variables ***
${DeviceIp}    172.27.245.92
${Community}    public
#${Community}    dtm.1234
${MibName}    DTM-TD-LTE-ENODEB-ENBMIB
${aom}    aom
${som}    som


*** Keywords ***


*** test case ***
#~ #----------------------------------------------------------------------
初始化
    ${returnval}    ${error}    Get With Error By Name    nrNetLocalCellRowStatus    idx=0
    Run Keyword If    '${returnval}' == 'createAndGo'    Set By Name    nrNetLocalCellRowStatus    ${6}    idx=0

    ${returnval}    ${error}    Get With Error By Name    netRRURowStatus    idx=0
    Run Keyword If    '${returnval}' == 'createAndGo'    Set By Name    netRRURowStatus    ${6}    idx=0

    ${returnval}    ${error}    Get With Error By Name    netAntArrayRowStatus    idx=0
    Run Keyword If    '${returnval}' == 'createAndGo'    Set By Name    netAntArrayRowStatus    ${6}    idx=0

    :FOR    ${loop_num}    IN RANGE    13
    \    ${returnval}    ${error}    Get With Error By Name    netBoardRowStatus    idx=0.0.${loop_num}
    \    Continue For Loop If    ${error} != 0
    \    Run Keyword If    '${returnval}' == 'createAndGo'    Set By Name    netBoardRowStatus    ${6}    idx=0.0.${loop_num}


#~ #----------------------------------------------------------------------
板卡规划
    Set Many By Name    netBoardRowStatus   ${4}    idx=0.0.1
    ...                 netBoardType    ${23}    idx=0.0.1

    Set Many By Name    netBoardRowStatus   ${4}    idx=0.0.4
    ...                 netBoardType    ${106}    idx=0.0.4

    Set Many By Name    netBoardRowStatus   ${4}    idx=0.0.5
    ...                 netBoardType    ${103}    idx=0.0.5

    Set Many By Name    netBoardRowStatus   ${4}    idx=0.0.6
    ...                 netBoardType    ${22}    idx=0.0.6

    Set Many By Name    netBoardRowStatus   ${4}    idx=0.0.12
    ...                 netBoardType     ${107}    idx=0.0.12


#~ #----------------------------------------------------------------------
打开布配开关
    Set Many By Name    nrNetLocalCellCtrlConfigSwitch    ${1}    idx=0

#~ #----------------------------------------------------------------------
NR本地小区属性配置
    Set Many By Name    nrNetLocalCellRowStatus    ${4}    idx=0
    ...                 nrNetLocalCellFreqBandWidth    ${4}    idx=0
    ...                 nrNetLocalCellAppScene    ${1}    idx=0
    ...                 nrNetLocalCellAntArrayMode     ${1}    idx=0
    ...                 nrNetLocalCellAntPortNum    ${0}    idx=0

#~ #----------------------------------------------------------------------
天线阵规划
    Set Many By Name    netAntArrayRowStatus    ${4}    idx=0
    ...                 netAntArrayVendorIndex    ${13}    idx=0
    ...                 netAntArrayTypeIndex    ${9}    idx=0
    ...                 netAntArrayHalfPowerBeamWidth    ${65}    idx=0

#~ #----------------------------------------------------------------------
 射频单元规划
    Set Many By Name    netRRURowStatus    ${4}    idx=0
    ...                 netRRUTypeIndex    ${143}    idx=0
    ...                 netRRUOfpWorkMode    ${1}    idx=0
    ...                 netRRUAccessRackNo    ${0}    idx=0
    ...                 netRRUAccessShelfNo    ${0}    idx=0
    ...                 netRRUAccessSlotNo    ${6}    idx=0
    ...                 netRRUAccessBoardType    ${22}    idx=0
    ...                 netRRUOfp1AccessOfpPortNo    ${1}    idx=0
    ...                 netRRUOfp1AccessLinePosition    ${1}    idx=0

#~ #----------------------------------------------------------------------
天线安装规划
   :FOR    ${loop_num}    IN RANGE    1    65
   \    Set Many By Name    netSetRRUPortWithAntennaRowStatus    ${4}    idx=0.${loop_num}
   \    ...                 netSetRRUPortAntArrayNo    ${0}    idx=0.${loop_num}
   \    ...                 netSetRRUPortAntArrayPathNo    ${loop_num}    idx=0.${loop_num}
   \    ...                 netSetRRUPortRETAntSupport     ${0}     idx=0.${loop_num}
   \    ...                 netSetRRUPortRETAntRCUNo    ${-1}    idx=0.${loop_num}
   \    ...                 netSetRRUPortManualConfigPortNo    ${0}    idx=0.${loop_num}

   :FOR    ${loop_num}    IN RANGE    1    65
   \    Set Many By Name    netSetRRUPortSubtoLocalCellId    ${0}    idx=0.${loop_num}
   \    ...                 netSetRRUPortTxRxStatus    ${3}    idx=0.${loop_num}
   \    ...                 netSetRRUPortGroupNo    ${-1}    idx=0.${loop_num}



#~ #----------------------------------------------------------------------
关闭布配开关
    Set Many By Name    nrNetLocalCellCtrlConfigSwitch    ${0}    idx=0


