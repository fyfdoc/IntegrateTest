from pysnmp.smi.rfc1902 import ObjectIdentity

*** Keywords ***

*** Settings ***
Resource        ../../rruResources/DD/ddResources.robot
Suite Setup     Open Snmp Connection And Load Private MIB

*** Variables ***


*** test case ***
AAU ORPD 功率异常统计测试
    AAU ORPD 功率异常统计