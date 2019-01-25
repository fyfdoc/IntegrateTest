*** Settings ***
Resource    ../resources/UAgentWrapper.robot


*** Variables ***
${host_name}	'SCTF'
${host_address}	172.27.245.92
${pId}	${-1}
@{pars}	${1}
@{pars2}	${1}	${1}

*** Test Cases ***
# 连接设备
Connect Device Use Pid
    Connect Device By UAgent Use Pid    ${host_name}    ${host_address}    ${pId}

# 调用OM_MIB_CheckInitInfo方法，不带参数
Test Fun OM_MIB_CheckInitInfo
    ${execute_result}=    Execute Command by UAgent    OM_MIB_CheckInitInfo
    Should be equal    ${execute_result}    ${0}

# 参数类型为数组和字符串
Test Fun OM_MCELL_MacParaSend
    ${execute_result}=    Execute Command by UAgent    OM_MCELL_MacParaSend    ${0}    'hello'
    Should be equal    ${execute_result}    ${0}

Test Fun OM_SSFT_GetZu15egOspCmdNameTest
    ${execute_result}=    Execute Command by UAgent    OM_SSFT_GetZu15egOspCmdNameTest    ${1}
    Should be equal    ${execute_result}    ${6}

Test Fun OM_MIB_ShowRecByNo
    ${execute_result}=    Execute Command by UAgent    OM_MIB_ShowRecByNo    ${1}    ${1}
    Should be equal    ${execute_result}    ${0}

# 自定义参数结构例子
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 自定义参数结构说明
# 结构定义: <buffer_size,[par_type;par_size,buffer_index,par_value],...>
# 例子: 1) <200,[S;0;0;ABC]>    2) <200,[S;0;0;ABC],[N,4,20,123]>    2) <200>
# 说明: buffer_size: 参数缓存大小
#       [par_type;par_size,buffer_index,par_value]: 给缓存设置值的结构，可以有0到多个
#       par_type: 参数类型: 只有两种 S:字符串; N:数值
#       par_size: 参数所占用的字节大小，当参数为S字符串类型时可填写任意数值；当参数为N数字类型时必须准确填写
#       bffer_index: 值在缓存数组中的开始索引
#       par_value: 参数的值
# 参数的返回结果会依次放入${reslut_list}中
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Test Fun OM_MCELL_LcSetupCheck
    ${execute_result}    ${reslut_list}=    Execute Command With Out Datas by UAgent    OM_MCELL_LcSetupCheck    ${9}    <200,[S;0;0;ABC]>    <4,[N;4;0;3]>
    Log    ${execute_result} ${reslut_list}
    Should be equal    ${execute_result}    ${0}

# 断开连接
Disconnect Device
    Disconnect UAgent

*** Keywords ***

