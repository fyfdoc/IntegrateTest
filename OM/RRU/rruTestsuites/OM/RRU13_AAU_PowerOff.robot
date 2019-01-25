from pysnmp.smi.rfc1902 import ObjectIdentity

*** Settings ***
Resource        ../../rruResources/OM/omResource.robot
Resource        ../../../COMM/commResources/SnmpMibHelper.robot
Suite Setup     Open Snmp Connection And Load Private MIB

*** Variables ***
${IP}             172.27.245.92
${Comitty}        public
#${Comitty}       dtm.1234
${Mib}            DTM-TD-LTE-ENODEB-ENBMIB

${LOG_Phase}    '接入标志:'
${LOG_Oper}    '操作状态:'

*** test case ***
Power Off AAU Test
  [Documentation]     Multiple times poweroff AAU
  [Tags]              poweroff AAU

    Power Off AAU    100

