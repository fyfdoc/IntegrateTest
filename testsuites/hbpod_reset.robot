from pysnmp.smi.rfc1902 import ObjectIdentity


*** Keywords ***
Open Snmp Connection And Load Private MIB
   [Arguments]   ${dstIp}       ${Comitty}      ${mib}
   Open Snmp Connection       ${dstIp}          ${Comitty}
   Load Mib      DTM-TD-LTE-ENODEB-ENBMIB

#Test
HBPOD REBOOT
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

   \   ${curCellResetTrigger}    Get Oid By Name    ${Mib}    boardResetTrigger
   \   Set    ${curCellResetTrigger}    ${board_ResetValue}    idx=${arm_idx}
   \   Sleep    360

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
Suite Teardown    Run Keyword If Any Tests Failed    Upload Logs And Recover Gnb 




*** Variables ***
${IP}             172.27.245.92
${Comitty}        public
#${Comitty}       dtm.1234
${Mib}            DTM-TD-LTE-ENODEB-ENBMIB


${Cell_enabled}    enabled
${board_ResetValue}    on
${ProceduralStatus}    terminating
${OperationalStatus}    enabled
${MibName}    DTM-TD-LTE-ENODEB-ENBMIB
${aom}    aom
${som}    som

*** test case ***
HBPOD RESET

  ${boardEntry}    Get Oid By Name    ${MibName}    boardRowStatus
  Log    ${boardEntry}
  @{som_slotNo_list}    Get board of aom or som    ${som}    ${boardEntry}    ${16}

  :FOR    ${loop_slotNo}    in    @{som_slotNo_list}
  \    ${arm_idx}    Get Index By SlotNo Two    ${loop_slotNo}
  \    Log    ${loop_slotNo}'s board log upload is complete!
  \    HBPOD REBOOT    ${arm_idx}    10
  






  #:FOR    ${loop}    IN RANGE    1
  #\   ${curCellStatus}    Get Oid By Name    ${Mib}    nrCellOperationalState
  #\   ${curCellStatus_Value}    Get    ${curCellStatus}
  #\   ${ProceduralStatus_Value}    Get By Name    boardProceduralStatus    idx=0.0.6
  #\   ${OperationalStatus_Value}    Get By Name    boardOperationalState    idx=0.0.6
  #\   Log    ${curCellStatus_Value}
  #\   Log    ${ProceduralStatus_Value}
  #\   Log    ${OperationalStatus_Value}
  #\   Should be equal    ${curCellStatus_Value}    ${Cell_enabled}
  #\   Should be equal    ${ProceduralStatus_Value}    ${ProceduralStatus}
  #\   Should be equal    ${OperationalStatus_Value}    ${OperationalStatus}
  #
  #\   ${curCellResetTrigger}    Get Oid By Name    ${Mib}    boardResetTrigger
  #\   Set    ${curCellResetTrigger}    ${board_ResetValue}    idx=0.0.6
  #\   Sleep    360
  #
  #\   ${curCellStatus}    Get Oid By Name    ${Mib}    nrCellOperationalState
  #\   ${curCellStatus_Value}    Get    ${curCellStatus}
  #\   ${ProceduralStatus_Value}    Get By Name    boardProceduralStatus    idx=0.0.6
  #\   ${OperationalStatus_Value}    Get By Name    boardOperationalState    idx=0.0.6
  #\   Log    ${curCellStatus_Value}
  #\   Log    ${ProceduralStatus_Value}
  #\   Log    ${OperationalStatus_Value}
  #\   Should be equal    ${ProceduralStatus_Value}    ${ProceduralStatus}
  #\   Should be equal    ${OperationalStatus_Value}    ${OperationalStatus}
  #\   Should be equal    ${curCellStatus_Value}    ${Cell_enabled}