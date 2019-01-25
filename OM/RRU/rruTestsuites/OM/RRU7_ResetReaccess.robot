from pysnmp.smi.rfc1902 import ObjectIdentity

*** Settings ***
Resource        ../../rruResources/OM/omResource.robot
Resource        ../../../COMM/commResources/SnmpMibHelper.robot
Suite Setup     Open Snmp Connection And Load Private MIB

*** Variables ***
${AAU_ResetValue_EffectNextRru}     1               #影响下一级复位

*** test case ***
AAU影响下一级复位
    [Documentation]     Multiple times AAU Reset Effect Next Rru
    [Tags]              AAU Reset Effect Next Rru

    :FOR    ${loop}    IN RANGE   2
    \    Set RRUResetTrigger Value    ${AAU_ResetValue_EffectNextRru}
    \    Log To Console    \n正在进行第${loop+1}次AAU影响下一级复位，请等待${SLEEP_TIME} ...     #20180912:109测试时间大概1分46秒小区可以重新建立
    \    Sleep   ${SLEEP_TIME}
    \    #AAU重启后的状态检查
    \    AAU Status Check After Restart
