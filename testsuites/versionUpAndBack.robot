 #encoding utf-8

'''
create by zhuqingshuang
版本升级回退测试用例集
'''

from pysnmp.smi.rfc1902 import ObjectIdentity

*** Settings ***
Library    SnmpLibrary
Library    BuiltIn
Library    ../utils/CiUtils.py
Library    ../utils/FileHandler.py
Resource    ../resources/SnmpMibHelper.robot
Resource    ../resources/AAUStatusCheck.robot
Resource    ../resources/BBUStatusCheck.robot
Suite Setup    Open Snmp Connection and Load Private MIB    ${dstIP}    ${community}    ${MIB}

*** Variables ***
${dstIp}    172.27.245.92
${community}    public
${MIB}    DTM-TD-LTE-ENODEB-ENBMIB

${DownloadIndicator}   forcedDownload
${ActivateIndicator}    instantActivate
${OM_SNMP_GET_NOT_EXIST}    ${342}
${OM_SNMP_SET_NOT_EXIST}    ${345}

*** KeyWords ***
#--------------------------------------------------------------------------
BBU VerUpAndBack
    # 参数说明: PackName:文件名    xxx_base:用于版本回退 xxx_new:用于版本升级
    [Arguments]    ${PackName}
    ${subpackageNum}    splitPackage    ${PackName}
    ${splitBBUPath}    get_splitBBUPath
    ${Version}    getVerNum    ${PackName}

    Set Many By Name
    ...                                 swPackPlanPackName    5GIIIBBU.dtz   idx=${1}    # 软件包名称
    ...                                 swPackPlanVendor    null    idx=${1}            # 厂家信息
    ...                                 swPackPlanVersion    ${Version}    idx=${1}     # 软件包版本
    ...                                 swPackPlanDownloadIndicator    ${DownloadIndicator}    idx=${1}        # 软件包自动下载标志
#    ...                                 swPackPlanScheduleDownloadTime    1900-01-01    idx=${1}              #  软件包下载时间
    ...                                 swPackPlanDownloadDirectory    ${splitBBUPath}    idx=${1}        # 软件包自动下载路径
    ...                                 swPackPlanActivateIndicator    ${ActivateIndicator}    idx=${1}    # 激活标志
#    ...                                 swPackPlanScheduleActivateTime    1900-01-01    idx=${1}              # 软件包定时激活或去激活时间
    ...                                 swPackPlanRelyVesion    null    idx=${1}             # 补丁包依赖版本
    ...                                 swPackPlanFwActiveIndicator    active    idx=${1}    # 固件激活标志
    ...                                 swPackPlanSubPackNumber    ${subpackageNum}    idx=${1}          # 外设软件拆包个数
    Log To Console    \nBBU正在进行版本下载，请等待30分钟
    Sleep    30min
    BBU Status Check After Restart

# 如果获取的实例不存在则创建
Create Instance If Not Exist
    [Arguments]    ${PackName}    ${subpackageNum}    ${splitAAUPath}    ${Version}    #${GetTime}

    ${ret}    ${error}    Get With Error By Name    peripheralPackPlanRowStatus    idx=${1}
    Log    ${error}
    Run Keyword If    ${error} == ${OM_SNMP_GET_NOT_EXIST}
    ...    Set Many By Name    peripheralPackPlanRowStatus    createAndGo    idx=${1}
    ...                                 peripheralPackPlanPackName    ${PackName}    idx=${1}    # 软件包名称
    ...                                 peripheralPackPlanVendor    null    idx=${1}    # 厂家信息
    ...                                 peripheralPackPlanVersion    ${Version}    idx=${1}    # 软件包版本
    ...                                 peripheralPackPlanDownloadIndicator    ${DownloadIndicator}    idx=${1}    # 软件包自动下载标志
#    ...                                 peripheralPackPlanScheduleDownloadTime    ${GetTime}    idx=${1}    # 软件包下载时间
    ...                                 peripheralPackPlanDownloadDirectory    ${splitAAUPath}    idx=${1}    # 软件包自动下载路径
    ...                                 peripheralPackPlanActivateIndicator    ${ActivateIndicator}    idx=${1}    # 激活标志
#    ...                                 peripheralPackPlanScheduleActivateTime    1900-01-01    idx=${1}    # 软件包定时激活或去激活时间
    ...                                 peripheralPackPlanRelyVesion    null    idx=${1}    # 补丁包依赖版本
    ...                                 peripheralPackPlanSubPackNumber    ${subpackageNum}    idx=${1}    # 外设软件拆包个数

# 如果获取的实例存在则直接修改
Modify Instance If Exist
    [Arguments]    ${PackName}    ${subpackageNum}    ${splitAAUPath}    ${Version}    #${GetTime}

    ${ret}    ${error}   Get With Error By Name    peripheralPackPlanRowStatus    idx=${1}
    Log    ${ret}
    Run Keyword If    ${error} == ${0}    Set By Name    peripheralPackPlanRowStatus    ${6}    idx=${1}

    Set Many By Name    peripheralPackPlanRowStatus    createAndGo    idx=${1}
    ...                                 peripheralPackPlanPackName    ${PackName}    idx=${1}    # 软件包名称
    ...                                 peripheralPackPlanVendor    null    idx=${1}    # 厂家信息
    ...                                 peripheralPackPlanVersion    ${Version}    idx=${1}    # 软件包版本
    ...                                 peripheralPackPlanDownloadIndicator    ${DownloadIndicator}    idx=${1}   # 软件包自动下载标志
#    ...                                 peripheralPackPlanScheduleDownloadTime    ${GetTime}    idx=${1}     # 软件包下载时间
    ...                                 peripheralPackPlanDownloadDirectory    ${splitAAUPath}    idx=${1}    # 软件包自动下载路径
    ...                                 peripheralPackPlanActivateIndicator    ${ActivateIndicator}    idx=${1}    # 激活标志
#    ...                                 peripheralPackPlanScheduleActivateTime    1900-01-01    idx=${1}    # 软件包定时激活或去激活时间
    ...                                 peripheralPackPlanRelyVesion    null    idx=${1}    # 补丁包依赖版本
    ...                                 peripheralPackPlanSubPackNumber    ${subpackageNum}    idx=${1}    # 外设软件拆包个数

# 入参合法性检查
Input Para Check
    [Arguments]    ${InputPara}
    Return From Keyword If    ${InputPara} == None    ${False}
    [Return]    ${True}

AAU VerUpAndBack
    # 参数说明: PackName:文件名    xxx_base:用于版本回退 xxx_new:用于版本升级
    [Arguments]    ${PackName}
    ${subpackageNum}    splitPackage    ${PackName}
    ${splitAAUPath}    get_splitAAUPath
    ${Version}    getVerNum    ${PackName}
    #${GetFullTime}    Get Current Date
    #${DownloadTime}    set DownloadTime
    Log to Console    \n 软件包名称：${PackName}
    Log to Console    \n 软件版本：${Version} 分包个数：${subpackageNum}
    Log to Console    \n 软件路径：${splitAAUPath}
    #Log to Console    \n 软件包下载时间：${DownloadTime}

    Create Instance If Not Exist    ${PackName}    ${subpackageNum}    ${splitAAUPath}    ${Version}     #${DownloadTime}

    Modify Instance If Exist    ${PackName}    ${subpackageNum}    ${splitAAUPath}    ${Version}    #${DownloadTime}

    Log To Console    \nAAU正在进行版本下载，请等待10分钟
    Sleep    10min
    ${ret}    AAU Status Check After Restart
    [Return]    ${ret}

*** Test Cases ***
AAU版本升级回退测试用例
    :FOR    ${loop}    IN RANGE    200
    \    Log To Console    \n正在执行第${loop+1}次升级回退
    \    ${ret}    AAU VerUpAndBack    5GIIIAAU_new.dtz
    \    ${ret}    AAU VerUpAndBack    5GIIIAAU_base.dtz

BBU版本升级回退测试用例
    :FOR    ${loop}    IN RANGE    10
    \    BBU VerUpAndBack    5GIIIBBU_base.dtz
    \    BBU VerUpAndBack    5GIIIBBU_new.dtz
