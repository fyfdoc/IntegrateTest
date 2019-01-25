# encoding utf-8
'''
*************************************************************
*** COPYRIGHT DaTang Mobile Communications Equipment CO.,LTD
*************************************************************
*文件名称：tranResource.robot
*功能描述：传输模块相关资源文件
*使用方法：传输用例使用时需要配置*** Variables ***表中的各项数据严格区分IPV4与IPV6

-----------------------------------------------------------------------------------
*修改记录：                                                                       |
*##修改日期    |    修改人    |    修改描述    |                                  |
*2018-11-08    |   caoweidong |    创建文件    |                                  |
----------------------------------------------------------------------------------|
*************************************************************
______________________________________________________________________________________
*关键字目录：                                                                        |
-------------------------------------------------------------------------            |
*##查询类关键字##                                                                    |
*A1.查询指定告警是否发生              -> Alarm Should be Occured                     |
*##动作类关键字##                                                                    |
*B1.清除指定告警                      -> Clean Alarm                                 |
-------------------------------------------------------------------------            | 
*A-hsctd idxaddr                      -> 查询主控板卡的索引                          |
*A-hbpod idxaddr                      -> 查询基带板卡的索引                          |
*A-Get idxaddr                        -> 获取主控与基带的信息进行连接OSP准备         |
*A-OSP Connect                        -> 连接OSP设备                                 |
*A-Cfgipv4Data                        -> 从链表中获取ipv4数据写入MIB                 |
*A-Cfgipv6Data                        -> 从链表中提取ipv6数据写入MIB                 |
*A-cfgdata                            -> 从链表中获取非IP类数据写入MIB               |
*A-Cfg dst ipv4                       -> 配置IP 将所有IP参量设置到mib中              |
*A-Cfg dst ipv6                       -> 配置IPv6 将所有IP参量设置到mib中            |
*A-Cfg dst ippath                     -> 配置IP 将所有IP参量设置到mib中              |
*A-Cfg dst ipv4route                  -> 配置IPv4route 将所有IPv4route参量设置到mib中|
*A-Cfg dst ipv6route                  -> 配置IPv4route 将所有IPv4route参量设置到mib中|
*A-Send cutovertrigger                -> 发送割接命令                                |
*B-Mib ipstatus Should be enabled     ->获取配置IP的状态                             |
*B-Mib ippathstatus Should be enabled  -> 获取配置IPpath的状态                       |
*B-Cfgip DD Should be enabled          -> 查询驱动配置IP的返回值                     |
*B-Cfgiptoute DD Should be enabled     -> 查询驱动配置IProute的返回值                |
*A-割接                                -> 传输割接                                   |
*B-s1Status should be enable           -> s1可用状态检查                             |
*A-压力割接                            -> 反复割接测试                               |
_____________________________________________________________________________________|

************************************************资源文件头结束**************************************************
'''
from pysnmp.smi.rfc1902 import ObjectIdentity

*** Settings ***
Library    SnmpLibrary
Library    ../../../utils/CiUtils.py
Library    BuiltIn
Library    Collections
Resource    ../../COMM/commResources/SnmpMibHelper.robot
Resource    ../../../resources/UAgentWrapper.robot
Resource    ../../COMM/commResources/GnbCommands.robot




*** Variables ***

${Mib}    DTM-TD-LTE-ENODEB-ENBMIB
${OM_SNMP_GET_NOT_EXIST}    ${342}
${hsctd_address_base}    172.27.245
${peerip0}    192.168.1.20
${peerip1}    127.0.0.1

#***********************************************************************************
#功能     ：配置IPv4使用的数据链表                                                 *
#标签     ：                                                                       *
#所属模块 ：TRAN                                                                   *
#适用用例 ：                                                                       *
#负责人   ：caoweidong                                                             *
#调用方法 ：调用链表使用                                                           *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
${ipAddrLocalIpAddressType_ipv4}    1    #IP地址类型
${ipAddrLocalIpAddress_ipv4}    192.168.1.25    #IP地址
${ipAddrLocalIpMask_ipv4}    255.255.255.0      #子网掩码
${ipAddrPhyType_ipv4}    0   #物理端口类型
${ipAddrRackNo_ipv4}    0    #机架号
${ipAddrShelfNo_ipv4}    0    #机框号
${ipAddrSlotNo_ipv4}    1    #插槽号
${ipAddrPhyPortId_ipv4}    0    #物理端口号

${ipAddrLocalIpAddressType_ipv6}    1    #IP地址类型
${ipAddrLocalIpAddress_ipv6}    2222:1234:2234::0023    #IP地址
${ipAddrLocalIpMask_ipv6}    ffff:ffff:ffff:ffff::0      #子网掩码
${ipAddrPhyType_ipv6}    0   #物理端口类型
${ipAddrRackNo_ipv6}    0    #机架号
${ipAddrShelfNo_ipv6}    0    #机框号
${ipAddrSlotNo_ipv6}    1    #插槽号
${ipAddrPhyPortId_ipv6}    0    #物理端口号


#***********************************************************************************
#功能     ：配置IPv6使用的数据链表                                                 *
#标签     ：                                                                       *
#所属模块 ：TRAN                                                                   *
#适用用例 ：                                                                       *
#负责人   ：caoweidong                                                             *
#调用方法 ：调用链表使用                                                           *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
@{cfgvalue_ipv6}
#...    0    #本地ip 地址编号
...    2    #IP地址类型 ipv6
...    2222:1234:2234:0000:0000:0000:0000:0015    #IP地址
...    ffff:ffff:ffff:ffff:0000:0000:0000:0000     #子网掩码
...    0    #物理端口类型 eth
...    0    #机架号
...    0    #机框号
...    1    #插槽号
...    0    #物理端口号

#***********************************************************************************
#功能     ：配置ippath参量数据                                                     *
#标签     ：                                                                       *
#所属模块 ：TRAN                                                                   *
#适用用例 ：                                                                       *
#负责人   ：caoweidong                                                             *
#调用方法 ：                                                                       *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
${ipPathMaxTxBandwidth_value}    4000    
${ipPathMaxRxBandwidth_value}    8000 

#***********************************************************************************
#功能     ：配置ipv4 route参量数据链表                                             *
#标签     ：                                                                       *
#所属模块 ：TRAN                                                                   *
#适用用例 ：                                                                       *
#负责人   ：caoweidong                                                             *
#调用方法 ：调用链表使用                                                           *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
@{cfgvalue_ipv4route}
...    1    #对端IP地址类型
...    172.18.66.121    #对端IP网段地址
...    255.255.255.0    #对端IP掩码
...    192.168.1.1      #网关ip地址

@{objNames_iproute}
...    rtRelatPeerIpType    #对端IP地址类型
...    rtRelatPeerIp        #对端IP网段地址
...    rtRelatPeerIpMask    #对端IP掩码
...    rtRelatGatewayIpAddress    #网关ip地址

@{cfgvalue_ipv6route}
...    2    #对端IP地址类型
...    2222:2234:1111:0000:0000:0000:0000:0023    #对端IP网段地址
...    ffff:ffff:ffff:ffff:0000:0000:0000:0000    #对端IP掩码
...    2222:1234:2234:0000:0000:0000:0000:0001    #网关ip地址

#***********************************************************************************
#功能     ：OM链路配置参量数据链表                                                 *
#标签     ：                                                                       *
#所属模块 ：TRAN                                                                   *
#适用用例 ：                                                                       *
#负责人   ：caoweidong                                                             *
#调用方法 ：调用链表使用                                                           *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
${omLinkLocalIPAddressType_ipv4}    1    #OM的IP地址类型  
${omLinkLocalIPAddress_ipv4}       192.168.1.89   #OM的IP地址
${omLinkLocalIpMask_ipv4}           255.255.255.0    #子网掩码
${omLinkDefaultGWIpAddr_ipv4}       192.168.1.1    #默认网关
${omLinkPeerIpAddrType_ipv4}        1    #对端OM的IP地址类型
${omLinkPeerIpAddr_ipv4}            192.168.1.20    #对端OMIP地址
${omLinkMaxTxBandwidth_ipv4}        5000    #为OM通道分配的发送带宽
${omLinkMaxRxBandwidth_ipv4}        5000    #为OM通道分配的接收带宽
${omLinkDSCP_ipv4}             48     #DSCP优先级
${omLinkEnableMacQos_ipv4}     0     #是否启用MacQos
${omLinkMacPri_ipv4}           6    #mac优先级
${omLinkVlanId_ipv4}           0    #VLANID 
${omLinkPhyType_ipv4}          0    #端口类型
${omLinkRackNo_ipv4}      0    #机架号
${omLinkShelfNo_ipv4}    0    #机框号
${omLinkSlotNo_ipv4}    1    #插槽号
${omLinkPhyPortId_ipv4}  0    #以太网物理端口号 
${omLinkRecoverTimer_ipv4}       1800    #OM链路故障后启动定时器
${omLinkIsRealTimeValid_ipv4}    1    #是否即时生效
${omLinkNetworkAttribute_ipv4}    2      #OM多链路属性  取值

${omLinkLocalIPAddressType_ipv6}    2    #OM的IP地址类型  
${omLinkLocalIPAddress_ipv6}       2222::0010   #OM的IP地址
${omLinkLocalIpMask_ipv6}           ffff:ffff:ffff:ffff::0    #子网掩码
${omLinkDefaultGWIpAddr_ipv6}       2222::0001    #默认网关
${omLinkPeerIpAddrType_ipv6}        2    #对端OM的IP地址类型
${omLinkPeerIpAddr_ipv6}            2222::0012     #对端OMIP地址
${omLinkMaxTxBandwidth_ipv6}        5000    #为OM通道分配的发送带宽
${omLinkMaxRxBandwidth_ipv6}        5000    #为OM通道分配的接收带宽
${omLinkDSCP_ipv6}             48     #DSCP优先级
${omLinkEnableMacQos_ipv6}     0     #是否启用MacQos
${omLinkMacPri_ipv6}           6    #mac优先级
${omLinkVlanId_ipv6}           0    #VLANID 
${omLinkPhyType_ipv6}          0    #端口类型
${omLinkRackNo_ipv6}      0    #机架号
${omLinkShelfNo_ipv6}    0    #机框号
${omLinkSlotNo_ipv6}    1    #插槽号
${omLinkPhyPortId_ipv6}  0    #以太网物理端口号 
${omLinkRecoverTimer_ipv6}       1800    #OM链路故障后启动定时器
${omLinkIsRealTimeValid_ipv6}    1    #是否即时生效
${omLinkNetworkAttribute_ipv6}    2      #OM多链路属性  取值

#***********************************************************************************
#功能     ：sctp  ng链路配置参量数据链表                                           *
#标签     ：                                                                       *
#所属模块 ：TRAN                                                                   *
#适用用例 ：                                                                       *
#负责人   ：caoweidong                                                             *
#调用方法 ：调用链表使用                                                           *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
${sctpServerNo_ipv4}    0                         #对端服务器索引
${sctpWorkingMode_ipv4}    1                      #SCTP链路工作模式
${sctpLocalIpAddrIndex1_ipv4}    0                #本地IP Addr索引1
${sctpLocalIpAddrIndex2_ipv4}    -1               #本地IP Addr索引1
${sctpLocalIpAddrIndex3_ipv4}    -1               #本地IP Addr索引1
${sctpLocalIpAddrIndex4_ipv4}    -1               #本地IP Addr索引1
${sctpPeerIpAddressType_ipv4}    1                #对端IP地址类型
${sctpPeerIpAddr1_ipv4}          192.168.1.56     #对端IP地址1
${sctpPeerIpAddr2_ipv4}          127.0.0.1        #对端IP地址1
${sctpPeerIpAddr3_ipv4}          127.0.0.1        #对端IP地址1
${sctpPeerIpAddr4_ipv4}          127.0.0.1        #对端IP地址1
${sctpPeerType_ipv4}             6                #链路协议类型
${sctpPeerPortNumber_ipv4}       0                #对端SCTP端口号[TD-SCDMA专用]

${sctpServerNo_ipv6}    0                         #对端服务器索引
${sctpWorkingMode_ipv6}    1                      #SCTP链路工作模式
${sctpLocalIpAddrIndex1_ipv6}    0                #本地IP Addr索引1
${sctpLocalIpAddrIndex2_ipv6}    -1               #本地IP Addr索引1
${sctpLocalIpAddrIndex3_ipv6}    -1               #本地IP Addr索引1
${sctpLocalIpAddrIndex4_ipv6}    -1               #本地IP Addr索引1
${sctpPeerIpAddressType_ipv6}    2                #对端IP地址类型
${sctpPeerIpAddr1_ipv6}          1111:1234::15     #对端IP地址1
${sctpPeerIpAddr2_ipv6}          ac1b:0cbc::0        #对端IP地址1
${sctpPeerIpAddr3_ipv6}          ac1b:0cbc::1      #对端IP地址1
${sctpPeerIpAddr4_ipv6}          ac1b:0cbc::2       #对端IP地址1
${sctpPeerType_ipv6}             6                #链路协议类型
${sctpPeerPortNumber_ipv6}       0                #对端SCTP端口号[TD-SCDMA专用]



*** Keywords ***

#***********************************************************************************
#功能     ：查询主控板卡的索引                                                     *
#标签     ：                                                                       *
#索引     ：XXXXXXXX                                                               *
#入参     ：XXXXXXXX                                                               *
#返回值   ：返回主控板卡的索引                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：TRAN                                                                   *
#适用用例 ：                                                                       *
#负责人   ：caoweidong                                                             *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
hsctd idxaddr
    [Documentation]    查询主控板卡的索引
    [Tags]
    [Arguments]    
    [Teardown]
    [Timeout]

    ${boardEntry}    Get Oid By Name    ${Mib}    boardRowStatus
    Log    ${boardEntry}
    @{aom_slotNo_list}    Get board of aom or som    aom    ${boardEntry}    ${16}
    [Return]    @{aom_slotNo_list}

#***********************************************************************************
#功能     ：查询基带板卡的索引                                                     *
#标签     ：                                                                       *
#索引     ：                                                                       *
#入参     ：                                                                       *
#返回值   ：返回基带板卡的索引                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：TRAN                                                                   *
#适用用例 ：                                                                       *
#负责人   ：caoweidong                                                             *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
hbpod idxaddr
    [Documentation]    查询基带板卡的索引
    [Tags]
    [Arguments]    
    [Teardown]
    [Timeout]

    ${boardEntry}    Get Oid By Name    ${Mib}    boardRowStatus
    Log    ${boardEntry}
    @{som_slotNo_list}    Get board of aom or som    som    ${boardEntry}    ${16}
    [Return]    @{som_slotNo_list}

#***********************************************************************************
#功能     ：获取主控与基带的信息进行连接OSP准备                                    *
#标签     ：                                                                       *
#索引     ：XXXXXXXX                                                               *
#入参     ：XXXXXXXX                                                               *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：TRAN                                                                   *
#适用用例 ：                                                                       *
#负责人   ：caoweidong                                                             *
#调用方法 ：调用关键字，输入XXXXXXXX                                               *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************    
Get idxaddr
    [Documentation]    获取主控与基带的信息进行连接OSP准备
    [Tags]
    [Arguments]    
    [Teardown]
    [Timeout]

    @{hsctd_slots}    hsctd idxaddr
    @{hbpod_slots}    hbpod idxaddr
    ${slot1}    Evaluate    int(@{hsctd_slots}[0])
    Set Suite Variable    ${hsctd_slot}    ${slot1}
    # log to console    ${hsctd_slot}
    ${slot2}    Evaluate    int(@{hbpod_slots}[0])
    Set Suite Variable    ${hbpod_slot}    ${slot2}
    # log to console    ${hbpod0_slot}

#***********************************************************************************
#功能     ：连接OSP设备                                                            *
#标签     ：                                                                       *
#索引     ：无                                                                     *
#入参     ：无                                                                     *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：TRAN                                                                   *
#适用用例 ：                                                                       *
#负责人   ：caoweidong                                                             *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************    
OSP Connect
    [Documentation]    连接OSP设备 
    [Tags]
    [Arguments]    
    [Teardown]
    [Timeout]

    ${ip_address}    Catenate    SEPARATOR=.    ${hsctd_address_base}    ${hsctd_slot + 91}
    ${pid}    Set Variable    ${2}
    Connect Device By UAgent Use Pid    hsctd scp 2    ${ip_address}    ${pid}

#***********************************************************************************
#功能     ：从链表中获取ipv4数据写入MIB                                            *
#标签     ：                                                                       *
#索引     ：                                                                       *
#入参     ：名称链表  值链表  索引                                                 *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：TRAN                                                                   *
#适用用例 ：                                                                       *
#负责人   ：caoweidong                                                             *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************    
Cfgipv4Data
    [Documentation]    从链表中获取ipv4数据写入MIB
    [Tags]
    [Arguments]    ${objNames}    ${cfgvalue}    ${index}
    [Teardown]
    [Timeout]

    ${name}    get from list    ${objNames}    ${index}
    ${value}    get from list    ${cfgvalue}    ${index}
    ${curTrigger}       Get Oid By Name    ${Mib}    ${name}
    set ip address    ${curTrigger}    ${value}

#***********************************************************************************
#功能     ：从链表中提取ipv6数据写入MIB                                            *
#标签     ：                                                                       *
#索引     ：无                                                                     *
#入参     ：名称链表  值链表  索引                                                 *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：TRAN                                                                   *
#适用用例 ：                                                                       *
#负责人   ：caoweidong                                                             *
#调用方法 ：调用关键字，输入XXXXXXXX                                               *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************    
Cfgipv6Data
    [Documentation]    从链表中提取ipv6数据写入MIB
    [Tags]
    [Arguments]    ${objNames}    ${cfgvalue}    ${index}
    [Teardown]
    [Timeout]

    ${name}    get from list    ${objNames}    ${index}
    ${value}    get from list    ${cfgvalue}    ${index}
    ${ipv6_val}    ci_inet_pton_ipv6    ${value}
    Set By Name    ${name}    ${ipv6_val}

#***********************************************************************************
#功能     ：从链表中获取非IP类数据写入MIB                                          *
#标签     ：                                                                       *
#索引     ：无                                                                     *
#入参     ：名称链表  值链表  索引                                                 *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：TRAN                                                                   *
#适用用例 ：                                                                       *
#负责人   ：caoweidong                                                             *
#调用方法 ：调用关键字，输入XXXXXXXX                                               *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************    
cfgdata
    [Documentation]    从链表中获取非IP类数据写入MIB
    [Tags]
    [Arguments]    ${objNames}    ${cfgvalue}    ${index}
    [Teardown]
    [Timeout]
    
    ${name}    get from list    ${objNames}    ${index}
    ${value}    get from list    ${cfgvalue}    ${index}
    Set By Name    ${name}    ${value}

#***********************************************************************************
#功能     ：配置IP 将所有IP参量设置到mib中                                         *
#标签     ：                                                                       *
#索引     ：无                                                                     *
#入参     ：名称链表  值链表                                                       *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：TRAN                                                                   *
#适用用例 ：                                                                       *
#负责人   ：caoweidong                                                             *
#调用方法 ：调用关键字，输入XXXXXXXX                                               *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************    
Cfg dst ipv4
    [Documentation]    配置IP 将所有IP参量设置到mib中
    [Tags]
    [Arguments]    
    [Teardown]
    [Timeout]

    ${value}    ${error}    Get With Error By Name    ipAddrRowStatus    idx=0
    log    ${error}    
    Run Keyword If    '${value}' == 'createAndGo'    set many by name    ipAddrRowStatus    ${6}    idx=${0}

    ${PeerIpAddr1}    convert_to_ip_address    ${ipAddrLocalIpAddress_ipv4}
    #log    ${PeerIpAddr1}
    ${PeerIpAddr2}    convert_to_ip_address    ${ipAddrLocalIpMask_ipv4}
    #log    ${PeerIpAddr2}

    ${value}    ${error}    Get With Error By Name    ipAddrRowStatus    idx=0
    log    ${error}    
    Run Keyword If    '${value}' == ''    set many by name    ipAddrRowStatus    ${4}    idx=${0}                              
    ...                 ipAddrLocalIpAddressType    ${ipAddrLocalIpAddressType_ipv4}    idx=${0}                   
    ...                 ipAddrLocalIpAddress    ${PeerIpAddr1}    idx=${0}                   
    ...                 ipAddrLocalIpMask    ${PeerIpAddr2}    idx=${0}                
    ...                 ipAddrPhyType    ${ipAddrPhyType_ipv4}    idx=${0}
    ...                 ipAddrRackNo    ${ipAddrRackNo_ipv4}    idx=${0} 
    ...                 ipAddrShelfNo    ${ipAddrShelfNo_ipv4}    idx=${0} 
    ...                 ipAddrSlotNo    ${ipAddrSlotNo_ipv4}    idx=${0} 
    ...                 ipAddrPhyPortId    ${ipAddrPhyPortId_ipv4}    idx=${0} 


#***********************************************************************************
#功能     ：配置IPv6 将所有IP参量设置到mib中                                       *
#标签     ：                                                                       *
#索引     ：XXXXXXXX                                                               *
#入参     ：名称链表  值链表                                                       *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：TRAN                                                                   *
#适用用例 ：                                                                       *
#负责人   ：caoweidong                                                             *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************    
Cfg dst ipv6
    [Documentation]    配置IPv6 将所有IP参量设置到mib中
    [Tags]
    [Arguments]    
    [Teardown]
    [Timeout]
    
    ${value}    ${error}    Get With Error By Name    ipAddrRowStatus    idx=0
    log    ${error}    
    Run Keyword If    '${value}' == 'createAndGo'    set many by name    ipAddrRowStatus    ${6}    idx=${0}

    ${PeerIpAddr1}    ci_inet_pton_ipv6    ${ipAddrLocalIpAddress_ipv6}
    #log    ${PeerIpAddr1}
    ${PeerIpAddr2}    ci_inet_pton_ipv6    ${ipAddrLocalIpMask_ipv6}
    #log    ${PeerIpAddr2}

    ${value}    ${error}    Get With Error By Name    ipAddrRowStatus    idx=0
    log    ${error}    
    Run Keyword If    '${value}' == ''    set many by name    ipAddrRowStatus    ${4}    idx=${0}                              
    ...                 ipAddrLocalIpAddressType    ${ipAddrLocalIpAddressType_ipv6}    idx=${0}                   
    ...                 ipAddrLocalIpAddress    ${PeerIpAddr1}    idx=${0}                   
    ...                 ipAddrLocalIpMask    ${PeerIpAddr2}    idx=${0}                
    ...                 ipAddrPhyType    ${ipAddrPhyType_ipv6}    idx=${0}
    ...                 ipAddrRackNo    ${ipAddrRackNo_ipv6}    idx=${0} 
    ...                 ipAddrShelfNo    ${ipAddrShelfNo_ipv6}    idx=${0} 
    ...                 ipAddrSlotNo    ${ipAddrSlotNo_ipv6}    idx=${0} 
    ...                 ipAddrPhyPortId    ${ipAddrPhyPortId_ipv6}    idx=${0} 

#***********************************************************************************
#功能     ：配置IPPath 将所有IPPath参量设置到mib中                                 *
#标签     ：                                                                       *
#索引     ：XXXXXXXX                                                               *
#入参     ：名称链表  值链表  索引                                                 *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：TRAN                                                                   *
#适用用例 ：                                                                       *
#负责人   ：caoweidong                                                             *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#*********************************************************************************** 
Cfg dst ippath
    [Documentation]    配置IP 将所有IP参量设置到mib中
    [Tags]
    [Arguments]     
    [Teardown]
    [Timeout]

    ${value}    ${error}    Get With Error By Name    ipPathRowStatus    idx=@{0,0}
    log    ${error}
    Run Keyword If    '${value}' == ''    Set By Name    ipPathRowStatus    4
    Set By Name    ipPathType    1    idx=@{0,0}
    Set By Name    ipPathMaxTxBandwidth    ${ipPathMaxTxBandwidth_value}    idx=@{0,0}
    Set By Name    ipPathMaxRxBandwidth    ${ipPathMaxRxBandwidth_value}    idx=@{0,0}
    Sleep   1
    ${value}    ${error}    Get With Error By Name    ipPathRowStatus    idx=@{0,1}
    log    ${error}
    Run Keyword If    '${value}' == ''    Set By Name    ipPathRowStatus    4
    Set By Name    ipPathType    2    idx=@{0,1} 
    Set By Name    ipPathMaxTxBandwidth    ${ipPathMaxTxBandwidth_value}    idx=@{0,1}
    Set By Name    ipPathMaxRxBandwidth    ${ipPathMaxRxBandwidth_value}    idx=@{0,1} 
    Sleep   1

#***********************************************************************************
#功能     ：配置IPv4route 将所有IPv4route参量设置到mib中                           *
#标签     ：                                                                       *
#索引     ：XXXXXXXX                                                               *
#入参     ：XXXXXXXX                                                               *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：TRAN                                                                   *
#适用用例 ：                                                                       *
#负责人   ：caoweidong                                                             *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Cfg dst ipv4route
    [Documentation]    配置IPv4route 将所有IPv4route参量设置到mib中
    [Tags]
    [Arguments]          
    [Teardown]
    [Timeout]
    
    ${value}    ${error}    Get With Error By Name    rtRelatRowStatus    idx=0
    log    ${error}    
    Run Keyword If    '${value}' == 'createAndGo'    set many by name    rtRelatRowStatus    ${6}    idx=${0}

    ${value}    ${error}    Get With Error By Name    rtRelatRowStatus    idx=0
    log    ${error}
    Run Keyword If    '${value}' == ''    Set By Name    rtRelatRowStatus    4
    :FOR    ${index}    IN RANGE    0    3
    \    Run Keyword If    '${index}' == '0'    cfgdata    ${objNames_iproute}    ${cfgvalue_ipv4route}    ${index}
    \    Run Keyword If    '${index}' == '1'    Cfgipv4Data    ${objNames_iproute}    ${cfgvalue_ipv4route}    ${index}
    \    Run Keyword If    '${index}' == '2'    Cfgipv4Data    ${objNames_iproute}    ${cfgvalue_ipv4route}    ${index}
    \    Run Keyword If    '${index}' == '3'    Cfgipv4Data    ${objNames_iproute}    ${cfgvalue_ipv4route}    ${index}
    \    Sleep   1 

#***********************************************************************************
#功能     ：配置IPv6route 将所有IPv6route参量设置到mib中                           *
#标签     ：                                                                       *
#索引     ：XXXXXXXX                                                               *
#入参     ：XXXXXXXX                                                               *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：TRAN                                                                   *
#适用用例 ：                                                                       *
#负责人   ：caoweidong                                                             *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Cfg dst ipv6route
    [Documentation]    配置IPv4route 将所有IPv4route参量设置到mib中
    [Tags]
    [Arguments]          
    [Teardown]
    [Timeout]
    
    ${value}    ${error}    Get With Error By Name    rtRelatRowStatus    idx=0
    log    ${error}    
    Run Keyword If    '${value}' == 'createAndGo'    set many by name    rtRelatRowStatus    ${6}    idx=${0}

    ${value}    ${error}    Get With Error By Name    rtRelatRowStatus    idx=0
    log    ${error}
    Run Keyword If    '${value}' == ''    Set By Name    ipPathRowStatus    4

    :FOR    ${index}    IN RANGE    0    3
    \    Run Keyword If    '${index}' == '0'    cfgdata    ${objNames_iproute}    ${cfgvalue_ipv6route}    ${index}
    \    Run Keyword If    '${index}' == '1'    Cfgipv6Data    ${objNames_iproute}    ${cfgvalue_ipv6route}    ${index}
    \    Run Keyword If    '${index}' == '2'    Cfgipv6Data    ${objNames_iproute}    ${cfgvalue_ipv6route}    ${index}
    \    Run Keyword If    '${index}' == '3'    Cfgipv6Data    ${objNames_iproute}    ${cfgvalue_ipv6route}    ${index}
    \    Sleep   1 

#***********************************************************************************
#功能     ：发送割接命令                                                           *
#标签     ：                                                                       *
#索引     ：XXXXXXXX                                                               *
#入参     ：XXXXXXXX                                                               *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：TRAN                                                                   *
#适用用例 ：                                                                       *
#负责人   ：caoweidong                                                             *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Send cutovertrigger
    [Documentation]    发送割接命令
    [Tags]
    [Arguments]    
    [Teardown]
    [Timeout]

    ${selfStartupAlgorithmSwitchSts}    Get By Name     selfStartupAlgorithmSwitch   idx=0
    Run Keyword If    '${selfStartupAlgorithmSwitchSts}' == 'on'    Set By Name    selfStartupAlgorithmSwitch    0   
    Set By Name    transCutOverTrigger    1
    Sleep    8

#***********************************************************************************
#功能     ：获取配置IP的状态                                                       *
#标签     ：                                                                       *
#索引     ：XXXXXXXX                                                               *
#入参     ：XXXXXXXX                                                               *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：TRAN                                                                   *
#适用用例 ：                                                                       *
#负责人   ：caoweidong                                                             *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Mib ipstatus Should be enabled
    [Documentation]    获取配置IP的状态
    [Tags]
    [Arguments]   
    [Teardown]
    [Timeout]

    ${result}    Get By Name    ipAddrCfgStatus    0
    Log    ${result}  
    Should Be Equal    ${result}    ok

#***********************************************************************************
#功能     ：获取配置IPpath的状态                                                   *
#标签     ：                                                                       *
#索引     ：XXXXXXXX                                                               *
#入参     ：XXXXXXXX                                                               *
#返回值   ：返回IP的配置装态                                                       *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：TRAN                                                                   *
#适用用例 ：                                                                       *
#负责人   ：caoweidong                                                             *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Mib ippathstatus Should be enabled
    :FOR    ${index}    IN    0    1
    \    ${result}    Get By Name    ipPathSetupStatus    idx=@{0,${index}}
    \    Log    ${result}  
    \    Should Be Equal    ${result}    ok

#***********************************************************************************
#功能     ：查询驱动配置IP的返回值                                                 *
#标签     ：                                                                       *
#索引     ：XXXXXXXX                                                               *
#入参     ：XXXXXXXX                                                               *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：TRAN                                                                   *
#适用用例 ：                                                                       *
#负责人   ：caoweidong                                                             *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Cfgip DD Should be enabled
    [Documentation]    查询驱动配置IP的返回值
    [Tags]
    [Arguments]    
    [Teardown]
    [Timeout]

    ${mkdir}=    Execute Command by UAgent    OM_MTRAN_IPDEL    
    log    ${mkdir}
    Sleep    3
    ${cfgresult}=    Execute Command by UAgent    OM_MTRAN_IPCONFIG   
    log    ${cfgresult}       
    ${dstvalue}    convert_to_integer32    0
    log   ${dstvalue} 
    Should Be Equal    ${cfgresult}    ${dstvalue} 

#***********************************************************************************
#功能     ：查询驱动配置IProute的返回值                                            *
#标签     ：                                                                       *
#索引     ：XXXXXXXX                                                               *
#入参     ：XXXXXXXX                                                               *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：TRAN                                                                   *
#适用用例 ：                                                                       *
#负责人   ：caoweidong                                                             *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Cfgiptoute DD Should be enabled
    [Documentation]    查询驱动配置IProute的返回值
    [Tags]
    [Arguments]    
    [Teardown]
    [Timeout]

    ${mkdir}=    Execute Command by UAgent    OM_STRAN_ROUTEDEL    0    
    log    ${mkdir}
    Sleep    3
    ${cfgresult}=    Execute Command by UAgent    OM_MTRAN_ROUTEINIT    0   
    log    ${cfgresult}       
    ${dstvalue}    convert_to_integer32    0
    log   ${dstvalue} 
    Should Be Equal    ${cfgresult}    ${dstvalue} 

#***********************************************************************************
#功能     ：传输割接                                                               *
#标签     ：                                                                       *
#索引     ：                                                                       *
#入参     ：                                                                       *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：TRAN                                                                   *
#适用用例 ：                                                                       *
#负责人   ：                                                                       *
#调用方法 ：调用关键字，割接                                                       *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
割接
    [Documentation]    传输割接    
    [Tags]    
    [Arguments]    
    [Teardown]
    [Timeout]
        
    Set By Name    transCutOverTrigger    ${1}
    Sleep    6

#***********************************************************************************
#功能     ：s1可用状态检查                                                         *
#标签     ：                                                                       *
#索引     ：                                                                       *
#入参     ：                                                                       *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：TRAN                                                                   *
#适用用例 ：                                                                       *
#负责人   ：                                                                       *
#调用方法 ：调用关键字，割接                                                       *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************    
s1Status should be enable    
    [Documentation]   check s1 status    
    [Tags]     
    [Arguments]    
    [Teardown]
    [Timeout]
    
	  ${s1Status}    Get By Name    linkCommonOperationStatus 	     
	  Should be equal    ${s1Status}    enabled    

#***********************************************************************************
#功能     ：压力割接                                                               *
#标签     ：                                                                       *
#索引     ：                                                                       *
#入参     ：${rangeno}                                                             *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：TRAN                                                                   *
#适用用例 ：                                                                       *
#负责人   ：                                                                       *
#调用方法 ：调用关键字，割接                                                       *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************	  
压力割接
    [Documentation]    反复割接测试   
    [Tags]     
    [Arguments]    ${rangeno}
    [Teardown]
    [Timeout]
    
	  :FOR    ${i}    in range    ${rangeno}
    \    割接	  
    \    s1Status should be enable

#***********************************************************************************
#功能     ：配置OM参量设置到mib中 ipv4                                             *
#标签     ：                                                                       *
#索引     ：XXXXXXXX                                                               *
#入参     ：XXXXXXXX                                                               *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：TRAN                                                                   *
#适用用例 ：                                                                       *
#负责人   ：caoweidong                                                             *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Cfg dst ipv4omlink
    [Documentation]    配置OM参量设置到mib中
    [Tags]
    [Arguments]          
    [Teardown]
    [Timeout]

    ${value}    ${error}    Get With Error By Name    omLinkRowStatus    idx=0
    log    ${error}    
    Run Keyword If    '${value}' == 'createAndGo'    set many by name    omLinkRowStatus    ${6}    idx=${0}

    ${PeerIpAddr1}    convert_to_ip_address    ${omLinkLocalIPAddress_ipv4}
    #log    ${PeerIpAddr1}
    ${PeerIpAddr2}    convert_to_ip_address    ${omLinkLocalIpMask_ipv4}
    #log    ${PeerIpAddr2}
    ${PeerIpAddr3}    convert_to_ip_address    ${omLinkDefaultGWIpAddr_ipv4}
    #log    ${PeerIpAddr3}
    ${PeerIpAddr4}    convert_to_ip_address    ${omLinkPeerIpAddr_ipv4}
    #log    ${PeerIpAddr4}

    ${value}    ${error}    Get With Error By Name    omLinkRowStatus    idx=0
    log    ${error}    
    Run Keyword If    '${value}' == ''    set many by name    omLinkRowStatus    ${4}    idx=${0}                              
    ...                 omLinkLocalIPAddressType    ${omLinkLocalIPAddressType_ipv4}    idx=${0}                   
    ...                 omLinkLocalIPAddress    ${PeerIpAddr1}    idx=${0}                   
    ...                 omLinkLocalIpMask    ${PeerIpAddr2}    idx=${0}
    ...                 omLinkDefaultGWIpAddr    ${PeerIpAddr3}    idx=${0}                   
    ...                 omLinkPeerIpAddrType    ${omLinkPeerIpAddrType_ipv4}    idx=${0}
    ...                 omLinkPeerIpAddr    ${PeerIpAddr4}    idx=${0}                   
    ...                 omLinkMaxTxBandwidth    ${omLinkMaxTxBandwidth_ipv4}    idx=${0}
    ...                 omLinkMaxRxBandwidth    ${omLinkMaxRxBandwidth_ipv4}    idx=${0}                   
    ...                 omLinkDSCP    ${omLinkDSCP_ipv4}    idx=${0}
    ...                 omLinkEnableMacQos    ${omLinkEnableMacQos_ipv4}    idx=${0}                   
    ...                 omLinkMacPri    ${omLinkMacPri_ipv4}    idx=${0}
    ...                 omLinkVlanId    ${omLinkVlanId_ipv4}    idx=${0}
    ...                 omLinkPhyType    ${omLinkPhyType_ipv4}    idx=${0}     
    ...                 omLinkRackNo    ${omLinkRackNo_ipv4}    idx=${0}  
    ...                 omLinkShelfNo    ${omLinkShelfNo_ipv4}    idx=${0}
    ...                 omLinkSlotNo    ${omLinkSlotNo_ipv4}    idx=${0}  
    ...                 omLinkPhyPortId    ${omLinkPhyPortId_ipv4}    idx=${0}   
    ...                 omLinkRecoverTimer    ${omLinkRecoverTimer_ipv4}    idx=${0}  
    ...                 omLinkIsRealTimeValid    ${omLinkIsRealTimeValid_ipv4}    idx=${0}  
    ...                 omLinkNetworkAttribute    ${omLinkNetworkAttribute_ipv4}    idx=${0}   


#***********************************************************************************
#功能     ：配置OM参量设置到mib中      ipv6                                        *
#标签     ：                                                                       *
#索引     ：XXXXXXXX                                                               *
#入参     ：XXXXXXXX                                                               *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：TRAN                                                                   *
#适用用例 ：                                                                       *
#负责人   ：caoweidong                                                             *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Cfg dst ipv6omlink
    [Documentation]    配置OM参量设置到mib中
    [Tags]
    [Arguments]          
    [Teardown]
    [Timeout]
    
    ${value}    ${error}    Get With Error By Name    omLinkRowStatus    idx=0
    log    ${error}    
    Run Keyword If    '${value}' == 'createAndGo'    set many by name    omLinkRowStatus    ${6}    idx=${0}

    ${PeerIpAddr1}    ci_inet_pton_ipv6    ${omLinkLocalIPAddress_ipv6}
    #log    ${PeerIpAddr1}
    ${PeerIpAddr2}    ci_inet_pton_ipv6    ${omLinkLocalIpMask_ipv6}
    #log    ${PeerIpAddr2}
    ${PeerIpAddr3}    ci_inet_pton_ipv6    ${omLinkDefaultGWIpAddr_ipv6}
    #log    ${PeerIpAddr3}
    ${PeerIpAddr4}    ci_inet_pton_ipv6    ${omLinkPeerIpAddr_ipv6}
    #log    ${PeerIpAddr4}

    ${value}    ${error}    Get With Error By Name    omLinkRowStatus    idx=0
    log    ${error}    
    Run Keyword If    '${value}' == ''    set many by name    omLinkRowStatus    ${4}    idx=${0}                              
    ...                 omLinkLocalIPAddressType    ${omLinkLocalIPAddressType_ipv6}    idx=${0}                   
    ...                 omLinkLocalIPAddress    ${PeerIpAddr1}    idx=${0}                   
    ...                 omLinkLocalIpMask    ${PeerIpAddr2}    idx=${0}
    ...                 omLinkDefaultGWIpAddr    ${PeerIpAddr3}    idx=${0}                   
    ...                 omLinkPeerIpAddrType    ${omLinkPeerIpAddrType_ipv6}    idx=${0}
    ...                 omLinkPeerIpAddr    ${PeerIpAddr4}    idx=${0}                   
    ...                 omLinkMaxTxBandwidth    ${omLinkMaxTxBandwidth_ipv6}    idx=${0}
    ...                 omLinkMaxRxBandwidth    ${omLinkMaxRxBandwidth_ipv6}    idx=${0}                   
    ...                 omLinkDSCP    ${omLinkDSCP_ipv6}    idx=${0}
    ...                 omLinkEnableMacQos    ${omLinkEnableMacQos_ipv6}    idx=${0}                   
    ...                 omLinkMacPri    ${omLinkMacPri_ipv6}    idx=${0}
    ...                 omLinkVlanId    ${omLinkVlanId_ipv6}    idx=${0}
    ...                 omLinkPhyType    ${omLinkPhyType_ipv6}    idx=${0}     
    ...                 omLinkRackNo    ${omLinkRackNo_ipv6}    idx=${0}  
    ...                 omLinkShelfNo    ${omLinkShelfNo_ipv6}    idx=${0}
    ...                 omLinkSlotNo    ${omLinkSlotNo_ipv6}    idx=${0}  
    ...                 omLinkPhyPortId    ${omLinkPhyPortId_ipv6}    idx=${0}   
    ...                 omLinkRecoverTimer    ${omLinkRecoverTimer_ipv6}    idx=${0}  
    ...                 omLinkIsRealTimeValid    ${omLinkIsRealTimeValid_ipv6}    idx=${0}  
    ...                 omLinkNetworkAttribute    ${omLinkNetworkAttribute_ipv6}    idx=${0}   


#***********************************************************************************
#功能     ：配置NG参量设置到mib中 ipv4                                             *
#标签     ：                                                                       *
#索引     ：XXXXXXXX                                                               *
#入参     ：XXXXXXXX                                                               *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：TRAN                                                                   *
#适用用例 ：                                                                       *
#负责人   ：caoweidong                                                             *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Cfg dst ipv4nglink
    [Documentation]    配置ng参量设置到mib中
    [Tags]
    [Arguments]          
    [Teardown]
    [Timeout]
    
    ${PeerIpAddr1}    convert_to_ip_address    ${sctpPeerIpAddr1_ipv4}
    #log    ${PeerIpAddr1}
    ${PeerIpAddr2}    convert_to_ip_address    ${sctpPeerIpAddr2_ipv4}
    #log    ${PeerIpAddr2}
    ${PeerIpAddr3}    convert_to_ip_address    ${sctpPeerIpAddr3_ipv4}
    #log    ${PeerIpAddr3}
    ${PeerIpAddr4}    convert_to_ip_address    ${sctpPeerIpAddr4_ipv4}
    #log    ${PeerIpAddr4}

    ${value}    ${error}    Get With Error By Name    sctpRowStatus    idx=0
    log    ${error}
    #Run Keyword If    '${value}' == ''    Set By Name    sctpRowStatus    4
    
    Run Keyword If    '${value}' == ''    set many by name    sctpRowStatus    ${4}    idx=${0}                              
    ...                 sctpServerNo    ${sctpServerNo_ipv4}    idx=${0}                   
    ...                 sctpWorkingMode    ${sctpWorkingMode_ipv4}    idx=${0}
    ...                 sctpLocalIpAddrIndex1    ${sctpLocalIpAddrIndex1_ipv4}    idx=${0}                   
    ...                 sctpLocalIpAddrIndex2    ${sctpLocalIpAddrIndex2_ipv4}    idx=${0}
    ...                 sctpLocalIpAddrIndex3    ${sctpLocalIpAddrIndex3_ipv4}    idx=${0}                   
    ...                 sctpLocalIpAddrIndex4    ${sctpLocalIpAddrIndex4_ipv4}    idx=${0}
    ...                 sctpPeerIpAddressType    ${sctpPeerIpAddressType_ipv4}    idx=${0}                   
    ...                 sctpPeerIpAddr1    ${PeerIpAddr1}    idx=${0}
    ...                 sctpPeerIpAddr2    ${PeerIpAddr2}    idx=${0}                   
    ...                 sctpPeerIpAddr3    ${PeerIpAddr3}    idx=${0}
    ...                 sctpPeerIpAddr4    ${PeerIpAddr4}    idx=${0}                   
    ...                 sctpPeerType    ${sctpPeerType_ipv4}    idx=${0}
    ...                 sctpPeerPortNumber    ${sctpPeerPortNumber_ipv4}    idx=${0}                   

#***********************************************************************************
#功能     ：配置NG参量设置到mib中 ipv6                                             *
#标签     ：                                                                       *
#索引     ：XXXXXXXX                                                               *
#入参     ：XXXXXXXX                                                               *
#返回值   ：无                                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：TRAN                                                                   *
#适用用例 ：                                                                       *
#负责人   ：caoweidong                                                             *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Cfg dst ipv6nglink
    [Documentation]    配置ng参量设置到mib中
    [Tags]
    [Arguments]          
    [Teardown]
    [Timeout]
    
    ${PeerIpAddr1}    ci_inet_pton_ipv6    ${sctpPeerIpAddr1_ipv6}
    #log    ${PeerIpAddr1}
    ${PeerIpAddr2}    ci_inet_pton_ipv6    ${sctpPeerIpAddr2_ipv6}
    #log    ${PeerIpAddr2}
    ${PeerIpAddr3}    ci_inet_pton_ipv6    ${sctpPeerIpAddr3_ipv6}
    #log    ${PeerIpAddr3}
    ${PeerIpAddr4}    ci_inet_pton_ipv6    ${sctpPeerIpAddr4_ipv6}
    #log    ${PeerIpAddr4}

    ${value}    ${error}    Get With Error By Name    sctpRowStatus    idx=0
    log    ${error}
    #Run Keyword If    '${value}' == ''    Set By Name    sctpRowStatus    4
    
    Run Keyword If    '${value}' == ''    set many by name    sctpRowStatus    ${4}    idx=${0}                              
    ...                 sctpServerNo    ${sctpServerNo_ipv6}    idx=${0}                   
    ...                 sctpWorkingMode    ${sctpWorkingMode_ipv6}    idx=${0}
    ...                 sctpLocalIpAddrIndex1    ${sctpLocalIpAddrIndex1_ipv6}    idx=${0}                   
    ...                 sctpLocalIpAddrIndex2    ${sctpLocalIpAddrIndex2_ipv6}    idx=${0}
    ...                 sctpLocalIpAddrIndex3    ${sctpLocalIpAddrIndex3_ipv6}    idx=${0}                   
    ...                 sctpLocalIpAddrIndex4    ${sctpLocalIpAddrIndex4_ipv6}    idx=${0}
    ...                 sctpPeerIpAddressType    ${sctpPeerIpAddressType_ipv6}    idx=${0}                   
    ...                 sctpPeerIpAddr1    ${PeerIpAddr1}    idx=${0}
    ...                 sctpPeerIpAddr2    ${PeerIpAddr2}    idx=${0}                   
    ...                 sctpPeerIpAddr3    ${PeerIpAddr3}    idx=${0}
    ...                 sctpPeerIpAddr4    ${PeerIpAddr4}    idx=${0}                   
    ...                 sctpPeerType    ${sctpPeerType_ipv6}    idx=${0}
    ...                 sctpPeerPortNumber    ${sctpPeerPortNumber_ipv6}    idx=${0}

#***********************************************************************************
#功能     ：获取配置OM的配置的状态                                                 *
#标签     ：                                                                       *
#索引     ：XXXXXXXX                                                               *
#入参     ：XXXXXXXX                                                               *
#返回值   ：返回OM的配置的状态                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：TRAN                                                                   *
#适用用例 ：                                                                       *
#负责人   ：caoweidong                                                             *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Mib omlinkstatus Should be enabled
    [Documentation]    获取OM的配置的状态
    [Tags]
    [Arguments]   
    [Teardown]
    [Timeout]

    ${result}    Get By Name    omLinkSetupStatus    0
    Log    ${result}  
    Should Be Equal    ${result}    ok

#***********************************************************************************
#功能     ：获取配置OM的配置的状态                                                 *
#标签     ：                                                                       *
#索引     ：XXXXXXXX                                                               *
#入参     ：XXXXXXXX                                                               *
#返回值   ：返回OM的配置的状态                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：TRAN                                                                   *
#适用用例 ：                                                                       *
#负责人   ：caoweidong                                                             *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Mib nglinkstatus Should be enabled
    [Documentation]    获取OM的配置的状态
    [Tags]
    [Arguments]   
    [Teardown]
    [Timeout]

    ${result}    Get By Name    sctpStatus    0
    Log    ${result}  
    Should Be Equal    ${result}    ok


#***********************************************************************************
#功能     ：用例环境检测       配置传输用例需要的环境                              *
#标签     ：                                                                       *
#索引     ：XXXXXXXX                                                               *
#入参     ：XXXXXXXX                                                               *
#返回值   ：返回OM的配置的状态                                                     *
#后处理   ：无                                                                     *
#超时     ：无                                                                     *
#所属模块 ：TRAN                                                                   *
#适用用例 ：                                                                       *
#负责人   ：caoweidong                                                             *
#调用方法 ：调用关键字                                                             *
#                                                                                  *
#备注     ：                                                                       *
#                                                                                  *
#***********************************************************************************
Tran_env_check 
    [Documentation]    配置传输用例需要的环境 对已经存在的配置信息进行删除
    [Tags]
    [Arguments]   
    [Teardown]
    [Timeout]

    #清除sctp链路
    ${value}    ${error}    Get With Error By Name    sctpRowStatus    idx=0
    log    ${error}    
    Run Keyword If    '${value}' == 'createAndGo'    set many by name    sctpDeleteFlag    ${1}    idx=${0}
    ...                 sctpRowStatus    ${6}    idx=${0}
    
    #清除ippath
    ${value}    ${error}    Get With Error By Name    ipPathRowStatus    idx=${0,0}
    log    ${error}    
    Run Keyword If    '${value}' == 'createAndGo'    set many by name    ipPathRowStatus    ${6}    idx=${0,0}

    ${value}    ${error}    Get With Error By Name    ipPathRowStatus    idx=${0,1}
    log    ${error}    
    Run Keyword If    '${value}' == 'createAndGo'    set many by name    ipPathRowStatus    ${6}    idx=${0,1}
    
    #清除ip
    ${value}    ${error}    Get With Error By Name    ipAddrRowStatus    idx=0
    log    ${error}    
    Run Keyword If    '${value}' == 'createAndGo'    set many by name    ipAddrRowStatus    ${6}    idx=${0}
    
    #清除路由
    ${value}    ${error}    Get With Error By Name    rtRelatRowStatus    idx=0
    log    ${error}    
    Run Keyword If    '${value}' == 'createAndGo'    set many by name    rtRelatRowStatus    ${6}    idx=${0}




