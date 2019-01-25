from pysnmp.smi.rfc1902 import ObjectIdentity


*** Keywords ***
Open Snmp Connection And Load Private MIB
   [Arguments]   ${dstIp}       ${Comitty}      ${mib}  
   Open Snmp Connection       ${dstIp}          ${Comitty} 
   Load Mib      DTM-TD-LTE-ENODEB-ENBMIB





*** Settings ***
Library    SnmpLibrary
Library    BuiltIn
Suite Setup           Open Snmp Connection And Load Private MIB          ${IP}         ${Comitty}       ${Mib} 
 
 
 
 
*** Variables ***
${IP}             172.27.245.92 
#${Comitty}        public
${Comitty}       dtm.1234
${Mib}            DTM-TD-LTE-ENODEB-ENBMIB

${ff}              cellActiveTrigger
${Oid_ActiveState}      .1.3.6.1.4.1.5105.100.2.4.4.3.1.6
${ActiveStateVal}        0
${DeActiveStateVal}      1
${Oid_Test}      .1.3.6.1.4.1.5105.100.2.4.2.4.1.1

${Oid_ActiveDelayInterval}         .1.3.6.1.4.1.5105.100.2.4.4.3.1.14.2
${ActiveDelayInterVal}             60

#   Set           ObjectIdentity('DTM-TD-LTE-ENODEB-ENBMIB', 'cellActiveTrigger')              ${ActiveStateVal}              2

*** test case ***
Active Cell Test 
  [Documentation]     5times setup&deactive cell                #sssss
  [Tags]              Cell Setup Test
  
  :FOR    ${aa}     IN       @{1,2}
  \   ${test}       Get Oid By Name        ${Mib}         cellActiveTrigger      
  \   Log           ${test}     
  \   Sleep         3s
  \   Set           ${Oid_Test}               ${ActiveStateVal}              idx=0
  
              