from pysnmp.smi.rfc1902 import ObjectIdentity


*** Keywords ***
Open Snmp Connection And Load Private MIB
   [Arguments]   ${dstIp}       ${Comitty}      ${mib}
   Open Snmp Connection       ${dstIp}          ${Comitty}
   Load Mib      DTM-TD-LTE-ENODEB-ENBMIB

#Test
Get Device Status
   [Arguments]    ${arm_idx}    ${rangeno}
   :FOR    ${loop}    IN RANGE    ${rangeno}
   \   ${curCellStatus}    Get Oid By Name    ${Mib}    nrCellOperationalState
   \   ${curCellStatus_Value}    Get    ${curCellStatus}
   \   ${ProceduralStatus_Value}    Get By Name    boardProceduralStatus    idx=${arm_idx}
   \   ${OperationalStatus_Value}    Get By Name    boardOperationalState    idx=${arm_idx}
   \   Log    ${curCellStatus_Value}
   \   Log    ${ProceduralStatus_Value}
   \   Log    ${OperationalStatus_Value}
   \   Should be equal    ${curCellStatus_Value}    ${Cell_enabled}
   \   Should be equal    ${ProceduralStatus_Value}    ${ProceduralStatus}
   \   Should be equal    ${OperationalStatus_Value}    ${OperationalStatus}

   \   ${boardPowerOff}    Get Oid By Name    ${Mib}    boardPowerState
   \   Set    ${boardPowerOff}    ${Power_Off}    idx=${arm_idx}
   \   log    ${boardPowerOff}
   \   Sleep    30

   \   ${boardPowerOn}    Get Oid By Name    ${Mib}    boardPowerState
   \   Set    ${boardPowerOn}    ${Power_On}    idx=${arm_idx}
   \   Sleep    420

   \   ${curCellStatus}    Get Oid By Name    ${Mib}    nrCellOperationalState
   \   ${curCellStatus_Value}    Get    ${curCellStatus}
   \   ${ProceduralStatus_Value}    Get By Name    boardProceduralStatus    idx=${arm_idx}
   \   ${OperationalStatus_Value}    Get By Name    boardOperationalState    idx=${arm_idx}
   \   Log    ${curCellStatus_Value}
   \   Log    ${ProceduralStatus_Value}
   \   Log    ${OperationalStatus_Value}
   \   Should be equal    ${ProceduralStatus_Value}    ${ProceduralStatus}
   \   Should be equal    ${OperationalStatus_Value}    ${OperationalStatus}
   \   Should be equal    ${curCellStatus_Value}    ${Cell_enabled}



*** Settings ***
Library    SnmpLibrary
Library    BuiltIn
Library    ../utils/CiUtils.py
Resource    ../resources/SnmpMibHelper.robot
Resource    ../resources/LogHelper.robot
Resource    ../resources/UploadLogsAndRecoverGnb.robot
Suite Setup           Open Snmp Connection And Load Private MIB          ${IP}         ${Comitty}       ${Mib}




*** Variables ***
${IP}             172.27.245.92
${Comitty}        public
#${Comitty}       dtm.1234
${Mib}            DTM-TD-LTE-ENODEB-ENBMIB


${Cell_enabled}    enabled
${Power_Off}    powerOff
${Power_On}    normal
${ProceduralStatus}    terminating
${OperationalStatus}    enabled
${MibName}    DTM-TD-LTE-ENODEB-ENBMIB
${aom}    aom
${som}    som

*** test case ***
BBU PowerOff

  ${boardEntry}    Get Oid By Name    ${MibName}    boardRowStatus
  Log    ${boardEntry}
  @{som_slotNo_list}    Get board of aom or som    ${som}    ${boardEntry}    ${16}

  :FOR    ${loop_slotNo}    in    @{som_slotNo_list}
  \    ${arm_idx}    Get Index By SlotNo Two    ${loop_slotNo}
  \    Log    ${loop_slotNo}'s board log upload is complete!
  \    Get Device Status    ${arm_idx}    100
  
Run Keyword If Any Tests Failed    Upload Logs And Recover Gnb

#  :FOR    ${loop}    IN RANGE    10
#  \   ${curCellStatus}    Get Oid By Name    ${Mib}    nrCellOperationalState
#  \   ${curCellStatus_Value}    Get    ${curCellStatus}
#  \   ${ProceduralStatus_Value}    Get By Name    boardProceduralStatus    idx=${arm_idx}
#  \   ${OperationalStatus_Value}    Get By Name    boardOperationalState    idx=${arm_idx}
#  \   Log    ${curCellStatus_Value}
#  \   Log    ${ProceduralStatus_Value}
#  \   Log    ${OperationalStatus_Value}
#  \   Should be equal    ${curCellStatus_Value}    ${Cell_enabled}
#  \   Should be equal    ${ProceduralStatus_Value}    ${ProceduralStatus}
#  \   Should be equal    ${OperationalStatus_Value}    ${OperationalStatus}
#
#  \   ${boardPowerOff}    Get Oid By Name    ${Mib}    boardPowerState
#  \   Set    ${boardPowerOff}    ${Power_Off}    idx=${arm_idx}
#  \   Sleep    30
#
#  \   ${boardPowerOn}    Get Oid By Name    ${Mib}    boardPowerState
#  \   Set    ${boardPowerOn}    ${Power_On}    idx=${arm_idx}
#  \   Sleep    360
#
#  \   ${curCellStatus}    Get Oid By Name    ${Mib}    nrCellOperationalState
#  \   ${curCellStatus_Value}    Get    ${curCellStatus}
#  \   ${ProceduralStatus_Value}    Get By Name    boardProceduralStatus    idx=${arm_idx}
#  \   ${OperationalStatus_Value}    Get By Name    boardOperationalState    idx=${arm_idx}
#  \   Log    ${curCellStatus_Value}
#  \   Log    ${ProceduralStatus_Value}
#  \   Log    ${OperationalStatus_Value}
#  \   Should be equal    ${ProceduralStatus_Value}    ${ProceduralStatus}
#  \   Should be equal    ${OperationalStatus_Value}    ${OperationalStatus}
#  \   Should be equal    ${curCellStatus_Value}    ${Cell_enabled}