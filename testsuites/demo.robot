# encoding utf-8
'''
SnmpLibrary使用例子
'''
from pysnmp.smi.rfc1902 import ObjectIdentity

*** Settings ***
Library    SnmpLibrary
Library    BuiltIn
Library    ../utils/CiUtils.py
Resource    ../resources/SnmpMibHelper.robot
Suite Setup    Open Snmp Connection And Load Private MIB    ${DeviceIp}    ${Community}    ${MibName}

*** Variables ***
${DeviceIp}    172.27.245.92
${Community}    public
#${Community}    dtm.1234
${MibName}    DTM-TD-LTE-ENODEB-ENBMIB

*** Keywords ***

*** test case ***
#~ #----------------------------------------------------------------------
# 根据MIB节点Oid获取其值
Get Test
    Get    .1.3.6.1.4.1.5105.100.1.2.2.1.1    idx=${199}          # OMC文件传输表可用编号
    ${fileTransId}    Get    .1.3.6.1.4.1.5105.100.1.2.2.1.2      # 其他文件传输表可用编号
    Log    ${fileTransId}

#~ #----------------------------------------------------------------------
# 根据MIB节点名称获取其值
Get By Name Test
    Get By Name    fileTransNextAvailableIDForOMC                                  # OMC文件传输表可用编号
    ${fileTransId}    Get By Name    fileTransNextAvailableIDForOthers    idx=0    # 其他文件传输表可用编号
    Log    ${fileTransId}


#~ #----------------------------------------------------------------------
# 获取节点的值及其错误状态编号
Get With Error By Name Test
    ${rs}    ${error}    Get With Error By Name    ftpServerInetAddr    idx=${2}

#~ #----------------------------------------------------------------------
# Set单个参数用例(Oid)
Set Test
     [Tags]    Cell Setup Test
    Set    .1.3.6.1.4.1.5105.100.2.4.2.4.1.1    0    idx=0

#~ #----------------------------------------------------------------------
# Set单个参数用例(节点名称)
Set By Name Test
     [Tags]    Set By Name
    Set By Name    coolingPolicy    0    idx=0


#~ #----------------------------------------------------------------------
# Set多个参数用例(Oid)
Set Many Test
    [Documentation]    Set Many Test    #sssss
    [Tags]    Set Many Test
    Set Many    .1.3.6.1.4.1.5105.100.2.4.2.4.1.3    ${63}    idx=0
    ...                 .1.3.6.1.4.1.5105.100.2.4.2.4.1.4    ${20}    idx=0
    ...                 .1.3.6.1.4.1.5105.100.2.4.2.4.1.5    ${50}    idx=0

#~ #----------------------------------------------------------------------
# Set多个参数用例(节点名称)
Set Many By Name Test
    Set Many By Name    fileTransRowStatus    ${4}    idx=${20}                               # 行状态
    ...                                 fileTransType    ${5}    idx=${20}                    # 传输文件类型
    ...                                 fileTransIndicator    ${1}    idx=${20}               # 上下载指示 1:upload|上传/2:download|下载
    ...                                 fileTransNEDirectory    null    idx=${20}             # 网元上的文件路径
    ...                                 fileTransFTPDirectory    C:\\enb_log    idx=${20}     # FTP服务器上的文件路径
    ...                                 fileTransFileName    null    idx=${20}                # 文件名称


