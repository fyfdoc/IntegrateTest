from pysnmp.smi.rfc1902 import ObjectIdentity


*** Keywords ***

*** Settings ***
Resource        ../../rruResources/DD/ddResources.robot
Suite Setup     Open Snmp Connection And Load Private MIB

*** Variables ***
${Sleep_Time}    10s

*** test case ***
AAU接口板反复重启压力(DD:rru_reboot)
    :FOR    ${Loop}    IN RANGE    ${2}
    \    Log To Console    \n这是AAU接口板第${Loop+1}次Reboot,Reboot需要${Sleep_Time}
    \    AAUReboot
