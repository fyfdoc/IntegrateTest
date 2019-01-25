from pysnmp.smi.rfc1902 import ObjectIdentity

*** Settings ***
Resource        ../../rruResources/OM/omResource.robot
Resource        ../../../COMM/commResources/SnmpMibHelper.robot
Suite Setup     Open Snmp Connection And Load Private MIB

*** Variables ***

*** test case ***
Reset AAU Test
    AAUReset    ${10}
