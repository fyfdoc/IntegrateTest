# -*- coding: utf-8 -*-
#~ #----------------------------------------------------------------------

import os, shutil, time
import xml.dom.minidom
#LMT path
LMT_PATH = 'C:\\Users\\admin\\Downloads\\LMT_LTE'
#OSP path
OSP_PATH = 'C:\\Users\\admin\\Downloads\\OSP_STUDIO_X64\\OSP_STUDIO_X64\\log'
# 文件传输类型字典
FILE_TRANS_TYPE_DIC = {
    'operationLog':1 # 操作日志
    ,'alterLog':2 # 变更日志
    ,'omSecurityLog':3 # 安全日志
    ,'alarmLog':4 # 告警日志文件
    ,'omKeyLog':5 # 重要过程日志
    ,'updateLog':6 # 升级日志
    ,'debugLog':7 # 黑匣子日志
    ,'statelessAlarmLog':8 # 异常日志
    ,'eventLog':9 # 事件日志
    ,'userLog':10 # 用户日志
    ,'cfgDataConsistency':11 # 配置数据一致性文件
    ,'stateDataConsistency':12 # 状态数据一致性文件
    ,'dataConsistency':13 # 数据一致性文件
    ,'curConfig':14 # 当前运行配置文件
    ,'planConfig':15 # 期望配置文件
    ,'equipSoftwarePack':16 # 主设备软件包
    ,'coldPatchPack':17 # 主设备冷补丁包
    ,'hotPatchPack':18 # 主设备热补丁包
    ,'rruEquipSoftwarePack':19 # RRU软件包
    ,'relantEquipSoftwarePack':20 # 电调天线软件包
    ,'enviromentEquipSoftwarePackPack':21 # 环境监控软件包
    ,'gpsEquipSoftwarePack':22 # GPS软件包
    ,'equip1588SoftwarePack':23 # 1588软件包
    ,'cnssEquipSoftwarePackPack':24 # 北斗软件包
    ,'generalFile':25 # 普通文件
    ,'lmtMDBFile':26 # 数据库文件
    ,'activeAlarmFile':27 # 活跃告警文件
    ,'performanceFile':28 # 性能文件
    ,'cfgPatchFile':29 # 数据补丁文件
    ,'snapshotFile':30 # 快照配置文件
    ,'cdlFile':31 # CDL文件
    ,'sctpLogFile':32 # sctp快照日志文件
    ,'dumpLogFile':33 # dump快照日志文件
    ,'ocuEquipSoftwarePack':34 # ocu软件包
    ,'servicecdlFile':35 # 业务CDL文件
    ,'mroFile':36 # MRO文件
    ,'mrsFile':37 # MRS文件
    ,'mreFile':38 # MRE文件
    ,'mmlOpLog':39 # 直连接口操作日志
    ,'mmlPmFile':40 # 直连接口性能文件
    ,'gtsaLog':41 # GTSA远程日志
    ,'iotLog':42 # IOT测量日志
    ,'traceUserLog':43 # 跟踪用户日志
    ,'pcapLog':44 # PCAP日志
    ,'immediatMdt':45 # ImmediatMdt文件
    ,'loggedMdt':46 # LoggedMdt文件
    ,'rlf':47 # RlfMdt文件
    ,'ripLog':48 # RIP测量日志
    ,'rncDisa':49 # RNC容灾配置数据文件
    ,'raeFile':50 # RAE相关文件
    ,'riaLog':51 # RIA检测日志
    ,'slotRipFile':52 # 时隙级干扰统计文件
    ,'symbolRipFile':53 # 符号级干扰统计文件
#添加RRU日志内容
    ,'rrualarm':0 #告警日志
    ,'rruuser':1 #用户日志
    ,'rrusys':2 #系统日志
    #,'all':3 #全部rru日志
    }

# 日志文件类型与文件名称关系，用于检查日志文件是否上传成功(目前只添加了公共日志部分，其他日志后续实现时需添加)
LOG_FILE_TYPE_AND_NAME_DIC = {
    'operationLog':'_operatelog.lgz' # 操作日志
    ,'alterLog':2 # 变更日志
    ,'omSecurityLog':3 # 安全日志
    ,'alarmLog':'_alarmlog.lgz' # 告警日志文件
    ,'omKeyLog':'_omkeylog.lgz' # 重要过程日志
    ,'updateLog':6 # 升级日志
    ,'debugLog':'_debuglog.lgz' # 黑匣子日志
    ,'statelessAlarmLog':'_exceptionlog.lgz' # 异常日志
    ,'eventLog':'eventlog.lgz' # 事件日志
    ,'userLog':10 # 用户日志
    ,'cfgDataConsistency':'_configconsistency.dcb' # 配置数据一致性文件
    ,'stateDataConsistency':'_stateconsistency.dcb' # 状态数据一致性文件
    ,'dataConsistency':'_dataconsistency.dcb' # 数据一致性文件
    ,'curConfig':'_cur.cfg' # 当前运行配置文件
    ,'planConfig':15 # 期望配置文件
    ,'equipSoftwarePack':16 # 主设备软件包
    ,'coldPatchPack':17 # 主设备冷补丁包
    ,'hotPatchPack':18 # 主设备热补丁包
    ,'rruEquipSoftwarePack':19 # RRU软件包
    ,'relantEquipSoftwarePack':20 # 电调天线软件包
    ,'enviromentEquipSoftwarePackPack':21 # 环境监控软件包
    ,'gpsEquipSoftwarePack':22 # GPS软件包
    ,'equip1588SoftwarePack':23 # 1588软件包
    ,'cnssEquipSoftwarePackPack':24 # 北斗软件包
    ,'generalFile':25 # 普通文件
    ,'lmtMDBFile':'lm.dtz' # 数据库文件
    ,'activeAlarmFile':'_activealarm.lgz' # 活跃告警文件
    ,'performanceFile':28 # 性能文件
    ,'cfgPatchFile':29 # 数据补丁文件
    ,'snapshotFile':30 # 快照配置文件
    ,'cdlFile':31 # CDL文件
    ,'sctpLogFile':32 # sctp快照日志文件
    ,'dumpLogFile':'XXXXX' # dump快照日志文件
    ,'ocuEquipSoftwarePack':34 # ocu软件包
    ,'servicecdlFile':35 # 业务CDL文件
    ,'mroFile':36 # MRO文件
    ,'mrsFile':37 # MRS文件
    ,'mreFile':38 # MRE文件
    ,'mmlOpLog':39 # 直连接口操作日志
    ,'mmlPmFile':40 # 直连接口性能文件
    ,'gtsaLog':41 # GTSA远程日志
    ,'iotLog':42 # IOT测量日志
    ,'traceUserLog':'XXXXX' # 跟踪用户日志
    ,'pcapLog':44 # PCAP日志
    ,'immediatMdt':45 # ImmediatMdt文件
    ,'loggedMdt':46 # LoggedMdt文件
    ,'rlf':47 # RlfMdt文件
    ,'ripLog':48 # RIP测量日志
    ,'rncDisa':49 # RNC容灾配置数据文件
    ,'raeFile':50 # RAE相关文件
    ,'riaLog':51 # RIA检测日志
    ,'slotRipFile':52 # 时隙级干扰统计文件
    ,'symbolRipFile':53 # 符号级干扰统计文件
#添加RRU日志内容
    ,'rrualarm': '_00rrualarm.lgz'#告警日志
    ,'rruuser':'_00rruuser.lgz' #用户日志
    ,'rrusys':'_00rrusys.lgz' #系统日志
    #,'all':['_00rrualarm.lgz', '_00rruuser.lgz', '_00rrusys.lgz'] #全部rru日志
    }
#Board Log
HSCTD_PROCID_AND_FILETYPE = {
    '0' : '1;11;13;15;16;17;18;44;45;49;50;51;55;56;57;58;59;61;70;71;74;81',
    #'1' : 'all',
    '2' : '1;44;45;49;50;51;55;56;57;58;59;61;71;81',
    '3' : '1;44;45;49;50;51;55;56;57;58;59;61;71;81',
    '4' : '1;44;45;49;50;51;55;56;57;58;59;61;71;81',
}
#cell log
HBPODD_cell_FILETYPE = {
    'cell' : '_0000060001.lgz'
}

HBPOD_PROCID_AND_FILETYPE = {
    '0' : '1;10;14;71;74;81',
    '1' : '1;60;64;66;71;81',
    '2' : '1;60;64;66;71;81',
    '3' : '1;60;64;66;71;81',
    '4' : '1;60;64;66;71;81',
    '5' : '1;60;64;66;71;81',
    '6' : '1;61;63;65;67;71;81',
    #'7' : 'all',
    '8' : '1;71;81',
    #'9' : 'all',
    '10': '1;71;81',
    #'11': 'all',
}
#~ #----------------------------------------------------------------------
def IsSubString_bak(SubStrList,Str):
    '''
    #判断字符串Str是否包含序列SubStrList中的每一个子字符串
    #>>>SubStrList=['F','EMS','txt']
    #>>>Str='F06925EMS91.txt'
    #>>>IsSubString(SubStrList,Str)#return True (or False)
    '''
    flag=True
    for substr in SubStrList:
        print("substr:{0}".format(substr))
        if not(substr in Str):
            flag=False

    return flag

#~ #----------------------------------------------------------------------
def IsSubString(SubStrList,Str):
    '''
    #判断字符串Str是否包含序列SubStrList中的每一个子字符串
    #>>>SubStrList=['F','EMS','txt']
    #>>>Str='F06925EMS91.txt'
    #>>>IsSubString(SubStrList,Str)#return True (or False)
    '''
    flag=True
    print("SubStrList:{0}".format(SubStrList))
    if not(SubStrList in Str):
        flag=False

    return flag

#~ #----------------------------------------------------------------------
def IsLogFileExists(FindPath,FlagStr=[]):
    '''
    #获取目录中指定的文件名
    #>>>FlagStr=['F','EMS','txt'] #要求文件名称中包含这些字符
    #>>>FileList=IsLogFileExists(FindPath,FlagStr) #
    '''
    import os
    if (type(FlagStr) == int):
        FlagStr = str(FlagStr)

    flag=False
    FileList=[]
    FileNames=os.listdir(FindPath)
    print(FileNames)
    if (len(FileNames)>0):
       for fn in FileNames:
           if (len(FlagStr)>0):
               #返回指定类型的文件名
               if (IsSubString(FlagStr,fn)):
                   flag=True
                   break
           else:
               #默认直接返回所有文件名
               flag=False
    return flag
#~ #----------------------------------------------------------------------
def isRRULogFileExists(ftp_dir, name_key):
    """
    包含name_key的文件是否都出现在dir中
    返回bool
    """
    wait_seconds = 0
    while True:
        time.sleep(1)
        wait_seconds += 1
        try:
            listdir = os.listdir(ftp_dir)
        except FileNotFoundError:
            listdir = os.listdir(os.makedirs(ftp_dir))
        for file in listdir:
            if name_key in file:
                return True
            elif wait_seconds == 200:
                return False
#~ #----------------------------------------------------------------------
def GetFileList(FindPath,FlagStr=[]):
    '''
    #获取目录中指定的文件名
    #>>>FlagStr=['F','EMS','txt'] #要求文件名称中包含这些字符
    #>>>FileList=GetFileList(FindPath,FlagStr) #
    '''
    import os
    FileList=[]
    FileNames=os.listdir(FindPath)
    if (len(FileNames)>0):
       for fn in FileNames:
           if (len(FlagStr)>0):
               #返回指定类型的文件名
               if (IsSubString(FlagStr,fn)):
                   fullfilename=os.path.join(FindPath,fn)
                   FileList.append(fullfilename)
           else:
               #默认直接返回所有文件名
               fullfilename=os.path.join(FindPath,fn)
               FileList.append(fullfilename)

    #对文件名排序
    if (len(FileList)>0):
        FileList.sort()

    return FileList


#~ #----------------------------------------------------------------------
def GetFileTransTypeIndexByName(strName):
    '''
    #根据名称获取传输文件类型的索引
    #>>>GetFileTransTypeIndexByName('operationLog') #Return 1
    '''
    return FILE_TRANS_TYPE_DIC[strName]

def GetLogFileKeyNameByType(strType):
    '''
    #根据日志文件类型获取文件名称的关键字，用于检查日志文件是否上传成功。
    #如：文件名为'enb_0_20090110011032+8_operatelog.lgz'，关键字为'_operatelog.lgz'
    #>>>GetLogFileKeyNameByType('operationLog') # Return '_operatelog.lgz'
	'''
    return LOG_FILE_TYPE_AND_NAME_DIC[strType]

def Getcell_LogFileByType(strType):
    '''
    #根据日志文件类型获取文件名称的关键字，用于检查日志文件是否上传成功。
    #如：文件名为'enb_0_20090110011032+8_operatelog.lgz'，关键字为'_operatelog.lgz'
    #>>>GetLogFileKeyNameByType('operationLog') # Return '_operatelog.lgz'
    '''
    return HBPODD_cell_FILETYPE[strType]
#~ #majingwei-------------------------------------------------------------------
def get_index_by_slotNo(slotNo):
    '''根据槽位号获取实例列表
    例如：slotNo = 6 return [ 0.0.6.0 | 0.0.6.1 | 0.0.6.2 | 0.0.6.3 | 0.0.6.4 | 0.0.6.5 | 0.0.6.6 | 0.0.6.7 | 0.0.6.8 | 0.0.6.9 | 0.0.6.10 ]
    '''
    index_list = list()
    hsctd_slotNo_range = (0, 1)
    hbpod_slotNo_range = (6, 7, 8, 9, 10, 11)
    if int(slotNo) in hsctd_slotNo_range:
        for procId in read_xml_of_board_log(LMT_PATH, 'HSCTD', '0-0.23').keys():
            index_list.append('0.0.' + str(slotNo) + '.' + str(procId))
        return index_list
    elif int(slotNo) in hbpod_slotNo_range:
        for procId in read_xml_of_board_log(LMT_PATH, 'HBPOD', '22').keys():
            index_list.append('0.0.' + str(slotNo) + '.' + str(procId))
        return index_list
    else:
        return 'error: slotNo is wrong!'

def parse_board_log_idx(board_log_idx):
    '''根据实例索引获取debugUplpadType取值
    例如：0.0.6.2 返回'1;44;45;49;50;51;55;56;57;58;59;61;71;81'
    '''
    idx_list = board_log_idx.split('.')
    hsctd_slotNo_range = (0, 1, )
    hbpod_slotNo_range = (6, 7, 8, 9, 10, 11, )
    if int(idx_list[2]) in hsctd_slotNo_range:
        #return HSCTD_PROCID_AND_FILETYPE[str(idx_list[3])]
        return read_xml_of_board_log(LMT_PATH, 'HSCTD', '0-0.23')[str(idx_list[3])]
    elif int(idx_list[2]) in hbpod_slotNo_range:
        #return HBPOD_PROCID_AND_FILETYPE[str(idx_list[3])]
        return read_xml_of_board_log(LMT_PATH, 'HBPOD', '22')[str(idx_list[3])]        
    return 'error'

def Clear_folder(folder_path):
    '''清空指定文件夹'''
    shutil.rmtree(folder_path)
    os.makedirs(folder_path)

def get_file_keyname(index):
    index_list = index.split('.')
    slot_str = str(index_list[2])
    procId_str = str(index_list[3])
    if 1 == len(str(index_list[2])):
        slot_str = '0' + str(index_list[2])
    if 1 == len(str(index_list[3])):
        procId_str = '0' + str(index_list[3])
    return '0000' + slot_str + procId_str

def isBoardLogFileExists(ftp_dir, index, typeNo):
    """检查0.0.6.1的'1;10;14;71;74;81'这些日志是否存在
    """
    wait_seconds = 0
    type_list = typeNo.split(';')

    file_keyname_list = list()
    for subTypeNo in type_list:
        if 1 == len(subTypeNo):
            file_keyname_list.append(get_file_keyname(index) + '0' + str(subTypeNo))
        else:    
            file_keyname_list.append(get_file_keyname(index) + str(subTypeNo))
    print(file_keyname_list)
    while True:
        time.sleep(1)
        wait_seconds += 1
        try:
            listdir = os.listdir(ftp_dir)
        except FileNotFoundError:
            listdir = os.listdir(os.makedirs(ftp_dir))
        for file in listdir:
            for name_key in file_keyname_list:
                if name_key in file:
                    print(name_key)
                    file_keyname_list.remove(name_key)

            if 0 == len(file_keyname_list):
                return True
            elif wait_seconds == 200:
                return False

def read_xml_of_board_log(lmt_path, board_describe, board_type):
    #example: <BOARD TYPE="0-0.23" DESCRIBE="HSCTD">  board_describe is "HSCTD",board_type is "0-0.23"
    board_type_dict = dict()

    dom = xml.dom.minidom.parse(lmt_path + '\\LMT\\config\\LMTBoardLogType5216.xml')
    basebandtoDsp = dom.documentElement
    boards = basebandtoDsp.getElementsByTagName('BOARD')
    for board in boards:
        if board.hasAttribute('DESCRIBE'):
            if (board_describe == board.getAttribute('DESCRIBE') and board_type == board.getAttribute('TYPE')):
                processers = board.getElementsByTagName('PROCESSOR')
                for processer in processers:
                    cores = processer.getElementsByTagName('CORE')
                    for core in cores:
                        if core.hasAttribute('TYPE'):
                            logshows = core.getElementsByTagName('LOGSHOW')
                            board_type_value = ''
                            for logshow in logshows:
                                board_type_value +=logshow.getAttribute('TYPE') + ';'
                            #print(core.getAttribute('TYPE'))
                            #print(board_type_value)
                            if '6' == processer.getAttribute('TYPE') and 'ZU21DR' == processer.getAttribute('DESCRIBE'):
                                board_type_dict['8'] = board_type_value
                                board_type_dict['10'] = board_type_value
                            else:
                                board_type_dict[str(core.getAttribute('TYPE'))] = board_type_value
    return board_type_dict

def Copy_Files_To_SpecifiedDir(osp_path, specified_path):
    alllist = os.listdir(osp_path)

    for file in alllist:
        old_name = osp_path + '\\' + str(file)
        new_name = specified_path + '\\' + str(file)
        shutil.copyfile(old_name, new_name)
#~#xinjinadd
def get_index_by_slotNo_two(slotNo):
    '''根据槽位号获取实例列表
    例如：slotNo = 6 return 0.0.6
    '''
    index_num = '0.0.'
    hsctd_slotNo_range = (0, 1)
    hbpod_slotNo_range = (6, 7, 8, 9, 10, 11)
    if int(slotNo) in hsctd_slotNo_range:
        index_num += str(slotNo)
        return index_num
    elif int(slotNo) in hbpod_slotNo_range:
        index_num += str(slotNo)
        return index_num
    else:
        return 'error: slotNo is wrong!'

def member_decode(item):
    """TSP测试用 引用参数接收后解码"""
    ret = hex(int.from_bytes(item[0], byteorder="big"))
    return ret

def member_decode_to_integer_little(item):
    ret = int(int.from_bytes(item[0], byteorder="little"))
    return ret

def member_decode_to_binary_little(item):
    ret = bin(int.from_bytes(item[0], byteorder="little"))
    return ret

def member_decode_to_hex_little(item):
    ret = hex(int.from_bytes(item[0], byteorder="little"))
    return ret

def member_decode_to_integer_negative(item):
    import string
    ret = int(int.from_bytes(item[0], byteorder="little"))

    if(0x80000000 == (ret & 0x80000000)):
        ret_cvt = ~(ret - 1) & 0xffff
        ret = ret_cvt
    return (-ret)

def set_DownloadTime():

    import time
    import string

    #软件本版下载时间需要特殊格式
    oid_time_formart = (7, 226, 9, 27, 6, 33, 17, 0, 43, 0, 0)
    oid_time_src = list(oid_time_formart)

    local_time = time.localtime(time.time())

    time_Year = local_time[0]
    time_Month = local_time[1]
    time_Day = local_time[2]
    time_Hour = local_time[3]
    time_Minite = local_time[4]
    time_Second = local_time[5]

    oid_time_src[0] = time_Year / (256)
    oid_time_src[1] = time_Year % (256)
    oid_time_src[2] = time_Month
    oid_time_src[3] = time_Day
    oid_time_src[4] = (time_Hour - 8)
    oid_time_src[5] = time_Minite
    oid_time_src[6] = time_Second
    oid_time_src[7] = 0

    return tuple(oid_time_src)

def member_decode_str_to_list(item):
    """sysiic用 结构体引用参数接收后解码"""
    import struct
    print(type(item[0]))
    ret = struct.unpack('BBBBi', item[0])
    return ret
    
def get_boardIndex_by_slotNo(slotNo):
	boardIndex_list = list()
	hsctd_slotNo_range = (0, 1)
	hbpod_slotNo_range = (6, 7 , 8, 9, 10, 11)

	if int(slotNo) in hsctd_slotNo_range:
		index_str = '0.0.' + str(slotNo)
		boardIndex_list.append(index_str)
		return boardIndex_list
	elif int(slotNo) in hbpod_slotNo_range:
		index_str = '0.0.' + str(slotNo)
		boardIndex_list.append(index_str)	
		return boardIndex_list
	else:
		return 'error'	
	return boardIndex_list

def get_procIndex_by_slotNo(slotNo):
	boardIndex_list = list()
	hsctd_slotNo_range = (0, 1)
	hbpod_slotNo_range = (6, 7 , 8, 9, 10, 11)

	if int(slotNo) in hsctd_slotNo_range:
		boardIndex_list.append('0.0.' + str(slotNo) + '.0')
		return boardIndex_list
	elif int(slotNo) in hbpod_slotNo_range:
		for loop in range(0, 6):
			boardIndex_list.append('0.0.' + str(slotNo) + '.' + str(loop))
		return boardIndex_list
	else:
		return 'error'	
	return boardIndex_list
def should_be_equal_for_str(str1, str2):
    if str(str1) == str(str2):
        return True
    return False

def get_host_ip():
    import socket
    IP_List = list()
    Target_Ip = '0.0.0.0'

    #获取包含主机名和IP在内的IP信息表
    HostInfo_List = socket.gethostbyname_ex(socket.gethostname())
    #获取我们需要的内外网IP集合
    IP_List = HostInfo_List[2]
    
    #遍历列表，查找是否存在外网IP网段
    for ip_loop in IP_List:
        ip = ip_loop[0:10]
        if(ip == '172.27.45.' or ip == '172.27.245' or ip == '172.27.246'):
            Target_Ip = ip_loop
            break

    return Target_Ip