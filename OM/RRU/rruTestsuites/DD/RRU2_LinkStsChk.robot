from pysnmp.smi.rfc1902 import ObjectIdentity


*** Settings ***
Resource        ../../rruResources/DD/ddResources.robot
Suite Setup     Open Snmp Connection And Load Private MIB

*** Variables ***
${IP}             172.27.245.92
${Comitty}        public
#${Comitty}       dtm.1234
${Mib}            DTM-TD-LTE-ENODEB-ENBMIB

*** Keywords ***

*** test case ***
# 初始化校准
DD_INIT_CAL
    Connect Device By UAgent Use Pid    ${host_name}    ${ARU_1_address}    ${pId}
#电口204B误码状态查询
    电口204B误码率状态查询
#链路连接查询
    链路连接查询
#Disconnect Device
    Disconnect UAgent Use Pid