#-*- coding: utf-8 -*-

__author__ = 'wangruixuan'

import os,sys

class OM_SFT_ApiFile(object):

    #object scope define
    ROBOT_LIBRARY_SCOPE = 'GLOBAL'

    def __init__(self):
        self.__List = list()

    #ASCII码转字符 返回字符串
    def asciiCodeToWords(self, asciiList):
        FileVersion = ''
        for asciiCode in asciiList:
            Words = chr(asciiCode)
            FileVersion = FileVersion + Words
            FileVersion = str(FileVersion)
        return FileVersion

    #根据位置取List中的指定信息 并删除多余信息
    def SelectListItem(self, asciiList, Num):
        ListItem = str(asciiList[Num])
        print(ListItem)
        ListItem = ListItem.strip('\'')
        print(ListItem)
        ListItem = ListItem.strip('b\'')
        print(ListItem)
        #ListItem = ListItem.replace("\\", "@")
        #print(ListItem)
        ListItem = ListItem.strip('\\x00')
        print(ListItem)
        return ListItem

    #根据位置取List中的指定信息 不删除多余信息
    def SelectListItemNotDel(self, asciiList, Num):
        ListItem = str(asciiList[Num])
        print(ListItem)
        return ListItem

    #由入参文件名组该文件的ata2路径
    def GetFileATA2FullPath(self, Filename):
        FullPath = '/ata2/VER/RUNNING/SW/'
        FullPath = FullPath + Filename
        FullPath = FullPath.strip()
        return FullPath

    def GetAAUSubFileName(self, FileFlag):
        if 1 == FileFlag:
            return 'aiufw_dmbg.dtz'
        elif 2 == FileFlag:
            return 'arufw_rmbel.dtz'
        elif 3 == FileFlag:
            return 'rru.ini'
        else:
            return 'error'

if __name__ == '__main__':
    pass