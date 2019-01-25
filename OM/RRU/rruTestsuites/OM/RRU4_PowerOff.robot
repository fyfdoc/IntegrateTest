from pysnmp.smi.rfc1902 import ObjectIdentity

*** Settings ***
Resource        ../../rruResources/OM/omResource.robot
Resource        ../../../COMM/commResources/SnmpMibHelper.robot
Suite Setup     Open Snmp Connection And Load Private MIB

*** Variables ***

*** test case ***
Power Off AAU Test
    [Documentation]     Multiple times poweroff AAU
    [Tags]              poweroff AAU

    :FOR    ${loop}    IN RANGE    1
    #\   Set Many By Name    topoRRUResetTrigger    ${11}
    #\   Sleep   180

    \   ${curLocalCellConfigState}    Get By Name    nrLocalCellConfigTrigger
    \   Should be equal    ${curLocalCellConfigState}    add

    \   ${curCellActiveState}    Get By Name    nrCellActiveTrigger
    \   Should be equal    ${curCellActiveState}    active

    \   ${curCellOperationalState}    Get By Name    nrCellOperationalState
    \   Should be equal    ${curCellOperationalState}    enabled

