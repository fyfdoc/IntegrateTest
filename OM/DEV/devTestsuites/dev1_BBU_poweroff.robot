from pysnmp.smi.rfc1902 import ObjectIdentity

*** Settings ***
Library    SnmpLibrary
Library    BuiltIn
Library    ../../utils/CiUtils.py
Resource    ../../../resources/SnmpMibHelper.robot
Resource    ../../../resources/LogHelper.robot
Resource    ../../../resources/UploadLogsAndRecoverGnb.robot
Resource    ../devResources/devResource.robot
Suite Setup           Open Snmp Connection And Load Private MIB          ${IP}         ${Comitty}       ${Mib}


*** Variables ***
${IP}             172.27.245.92
${Comitty}        public
#${Comitty}       dtm.1234
${Mib}            DTM-TD-LTE-ENODEB-ENBMIB

*** test case ***
BBU PowerOff
		Bbu All Baseband Board PowerOff    100
  
#Run Keyword If Any Tests Failed    Upload Logs And Recover Gnb

