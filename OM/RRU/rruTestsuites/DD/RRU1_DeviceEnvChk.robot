from pysnmp.smi.rfc1902 import ObjectIdentity

*** Keywords ***

*** Settings ***
Resource        ../../rruResources/DD/ddResources.robot
Suite Setup     Open Snmp Connection And Load Private MIB

*** Variables ***
${host_name}    'SCTF'
${AIU_address}    172.27.45.250
${ARU_1_address}    172.27.45.251
${ARU_2_address}    172.27.45.252
${ARU_3_address}    172.27.45.253
${ARU_4_address}    172.27.45.254
${pId}    ${0}

*** test case ***
# 连接设备
Connect Device Use Pid
    Connect Device By UAgent Use Pid    ${host_name}    ${host_address}    ${pId}

查询AAU设备环境
    Log To Console    \n参考函数：tst_dts_dmbg_all

    MP2953设备温度查询

    LM730设备温度查询

    VU9P设备温度查询

    MP2953设备电压查询

    MP2953设备电流查询

Disconnect Device
    Disconnect UAgent Use Pid