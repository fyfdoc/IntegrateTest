from pysnmp.smi.rfc1902 import ObjectIdentity


*** Keywords ***
Open Snmp Connection And Load Private MIB
   [Arguments]   ${dstIp}       ${Comitty}      ${mib}  
   Open Snmp Connection       ${dstIp}          ${Comitty} 
   Load Mib      DTM-TD-LTE-ENODEB-ENBMIB

*** Settings ***
Library    SnmpLibrary
Library    BuiltIn
Library    ../utils/CiUtils.py
Resource    ../resources/UploadLogsAndRecoverGnb.robot
Suite Setup           Open Snmp Connection And Load Private MIB          ${IP}         ${Comitty}       ${Mib}
Suite Teardown    Run Keyword If Any Tests Failed    Upload Logs And Recover Gnb 
 
*** Variables ***
${IP}             172.27.245.92 
${Comitty}        public
#${Comitty}       dtm.1234
${Mib}            DTM-TD-LTE-ENODEB-ENBMIB

${ff}              cellActiveTrigger
${Oid_ActiveState}      .1.3.6.1.4.1.5105.100.2.4.4.3.1.6
${ActiveStateVal}        0
${DeActiveStateVal}      1
${Oid_ActiveDelayInterval}         .1.3.6.1.4.1.5105.100.2.4.4.3.1.14.2
${ActiveDelayInterVal}             60

${Cell_enabled}    enabled    
${Cell_disabled}    disabled
${LcCell_enabled}    enabled    
${LcCell_disabled}    disabled
${Trigger_is_active}    active
${Trigger_is_deactive}    deactive
${LcTrigger_is_add}    add
${LcTrigger_is_delete}    delete


*** test case ***
Active Cell Test 
  [Documentation]     Multiple times setup&deactive cell               
  [Tags]              Cell Setup&deactive Test
  
  :FOR    ${loop}    IN RANGE    80
  \   ${curTrigger}       Get Oid By Name    ${Mib}    nrCellActiveTrigger
  \   ${Trigger_Value}    Get    ${curTrigger}
  \   Log        ${Trigger_Value}
  \   Should be equal    ${Trigger_Value}    ${Trigger_is_active}
  
  \   ${curCellStatus}    Get Oid By Name    ${Mib}    nrCellOperationalState
  \   ${curCellStatus_Value}    Get    ${curCellStatus}
  \   Log        ${curCellStatus_Value}
  \   Should be equal    ${curCellStatus_Value}    ${Cell_enabled}

  \   Set           ${curTrigger}               ${DeActiveStateVal}  
  \   Sleep   30
  
  \   ${Trigger_Value}    Get    ${curTrigger}
  \   Log        ${Trigger_Value}
  \   Should be equal    ${Trigger_Value}    ${Trigger_is_deactive}
    
  \   ${curCellStatus_Value}    Get    ${curCellStatus}
  \   Log        ${curCellStatus_Value}
  \   Should be equal    ${curCellStatus_Value}    ${Cell_disabled}
    
    
  \   ${curLcTrigger}      Get Oid By Name      ${Mib}   nrLocalCellConfigTrigger
  \   ${LcTrigger_Value}    Get    ${curLcTrigger}
  \   Log        ${LcTrigger_Value}
  \   Should be equal    ${LcTrigger_Value}    ${LcTrigger_is_add}  
  
  \   ${curLcCellStatus}    Get Oid By Name    ${Mib}    nrLocalCellOperationalState   
  \   ${curLcCellStatus_Value}        Get        ${curLcCellStatus}
  \   Log        ${curLcCellStatus_Value}
  \   Should be equal    ${curLcCellStatus_Value}    ${LcCell_enabled}

  \   Set           ${curLcTrigger}               ${DeActiveStateVal} 
  \   Sleep   30
  


  
  \   Set           ${curLcTrigger}               ${ActiveStateVal} 
  \   Sleep   30

  \   ${curLcCellStatus}    Get Oid By Name    ${Mib}    nrLocalCellOperationalState
  \   ${curLcCellStatus_Value}        Get        ${curLcCellStatus} 
  \   Log        ${curLcCellStatus_Value}
  \   Should be equal    ${curLcCellStatus_Value}    ${LcCell_enabled}
  
  \   Set           ${curTrigger}               ${ActiveStateVal}  
  \   Sleep   30

  \   ${curCellStatus}    Get Oid By Name    ${Mib}    nrCellOperationalState
  \   ${curCellStatus_Value}    Get    ${curCellStatus}  
  \   Log        ${curCellStatus}
  \   Should be equal    ${curCellStatus_Value}    ${Cell_enabled}        

              