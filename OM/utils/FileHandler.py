#!usr/bin/env python3
#-*- coding: utf-8 -*-

'file handle module'

__author__ = 'zhuqingshuang'

import os,sys
import time
class FileHandler(object):
    
    #object scope define
    ROBOT_LIBRARY_SCOPE = 'GLOBAL'

    def __init__(self):
        #relative path
        self.__tools = r'tools\CMDLMTZip.exe'
        self.__verPath = r'version'
        #add by zhaobaoxin@1115 :添加文件夹生成日期，供调试用
        #self.__splitAAUPath = r'version\split_'+time.strftime("%m%d%H%M%S", time.localtime())+'\AAU' 
        self.__splitAAUPath = r'version\split\AAU'
        self.__splitBBUPath = r'version\split\BBU'
        self.__loopNum = 0
        self.__postfix = r'.100'

    def get_tools(self):
        return self.__tools

    def set_tools(self, tools):
        self.__tools = tools

    def get_verPath(self):
        return self.__verPath

    def set_verPath(self, verPath):
        self.__verPath = verPath

    def get_splitAAUPath(self):
        return self.__splitAAUPath

    def set_splitAAUPath(self, splitAAUPath):
        self.__splitAAUPath = splitAAUPath

    def get_splitBBUPath(self):
        return self.__splitBBUPath

    def set_splitBBUPath(self, splitBBUPath):
        self.__splitBBUPath = splitBBUPath

    def get_RRUTypeName(self, RRUbasename):
        RRUTypeName = os.path.join(RRUbasename, self.__postfix)
        return RRUTypeName

    def getAbspath(self):
        prefix = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
        self.__tools = os.path.join(prefix, self.__tools)
        self.__verPath = os.path.join(prefix, self.__verPath)
        self.__splitAAUPath = os.path.join(prefix, self.__splitAAUPath)
        self.__splitBBUPath = os.path.join(prefix, self.__splitBBUPath)
        return {'tools':self.__tools, 'verPath':self.__verPath, 'splitAAUPath':self.__splitAAUPath, 'splitBBUPath':self.__splitBBUPath}

    def getVerNum(self, packagePath):
        verNum = None
        self.getAbspath()
        if os.path.exists(self.__tools):
            if not os.path.exists(self.__verPath):
                os.makedirs(self.__verPath)
            packagePath = os.path.join(self.__verPath, os.path.basename(packagePath))
            if os.path.exists(packagePath):
                os.system(self.__tools+' /i '+packagePath+' '+self.__verPath)
                csvFile = os.path.join(self.__verPath, os.path.basename(packagePath).split('.')[0])+'.csv'
                with open(csvFile, 'r') as file:
                    for line in file.readlines():
                        if '文件大版本' in line:
                        #if 'EMB6116' in line:
                            verNum = line.split(',')[1].strip('\n')
            else:
                print('There is not package: '+packagePath)
        else:
            print('There is not slpit tool in '+os.path.dirname(self.__tools))
        return verNum

    def getSubVer(self, fullPath):
        SubVer = list()
        self.getAbspath()
        
        if os.path.exists(self.__tools):
            #if not os.path.exists(self.__verPath):
            #    os.makedirs(self.__verPath)
            #packagePath = os.path.join(self.__verPath, os.path.basename(packagePath))    
            self.__AAUverPath = os.path.dirname(fullPath)
            if os.path.exists(fullPath):
                #os.system(self.__tools+' /i '+packagePath+' '+self.__verPath)
                os.system(self.__tools+' /i '+fullPath+' '+self.__AAUverPath)
                #csvFile = os.path.join(self.__verPath, os.path.basename(packagePath).split('.')[0])+'.csv'
                csvFile = os.path.join(self.__AAUverPath, os.path.basename(fullPath).split('.')[0])+'.csv'
                with open(csvFile, 'r') as file:
                    for line in file.readlines():
                        if '文件小版本' in line:
                        #if 'rru.ini' in line:
                            SubVer.append(line.split(',')[1].strip('\n'))
            else:
                print('There is not package: '+fullath)
        else:
            print('There is not slpit tool in '+os.path.dirname(self.__tools))
        return SubVer


    def splitPackage(self, packagePath):
        subpackageNum = 0
        self.getAbspath()
        if os.path.exists(self.__tools):
            if not os.path.exists(self.__verPath):
                os.makedirs(self.__verPath)
            packagePath = os.path.join(self.__verPath, os.path.basename(packagePath))
            if os.path.exists(packagePath):

                if '5GIIIBBU' in os.path.basename(packagePath):
                    if not os.path.exists(self.__splitBBUPath):
                        os.makedirs(self.__splitBBUPath)
                    os.system(self.__tools+' '+'/up '+packagePath+' '+self.__splitBBUPath)
                    for root, dirs, files in os.walk(self.__splitBBUPath):
                        for file in files:
                            if 'Part' in file and '.dtz' in file:
                                subpackageNum = subpackageNum+1

                if '5GIIIAAU' in os.path.basename(packagePath):
                    if not os.path.exists(self.__splitAAUPath):
                        os.makedirs(self.__splitAAUPath)
                    os.system(self.__tools+' '+'/up '+packagePath+' '+self.__splitAAUPath)
                    for root, dirs, files in os.walk(self.__splitAAUPath):
                        for file in files:
                            if 'Part' in file and '.dtz' in file:
                                subpackageNum = subpackageNum+1
            else:
                print('There is not package: '+packagePath)
        else:
            print('There is not slpit tool in '+os.path.dirname(self.__tools))

        return subpackageNum

    def delSplitedPackage(self, packageNum, fullPath):
        counter = 1
        if fullPath == 'AAUPathIsNone':
            self.getAbspath()
        else:    
            self.__verPath = os.path.dirname(fullPath)

        while counter <= packageNum:
            if fullPath == 'AAUPathIsNone':
                delPath = os.path.join(self.__splitAAUPath, 'Part'+str(counter)+'.dtz')
            else:
                delPath = os.path.join(self.__verPath, 'Part'+str(counter)+'.dtz')
            print('delSplitedPackage: delPath is '+delPath)
            os.remove(delPath)
            counter = counter + 1

    def newSpiltPackage(self, fullPath):
        subpackageNum = 0
        self.getAbspath()
        if os.path.exists(self.__tools):
            self.__splitBBUPath = os.path.dirname(fullPath)
            print('newSplitPackage: splitBBUPath is '+self.__splitBBUPath)
            packageName = os.path.basename(fullPath)
            os.system(self.__tools+' '+'/up '+fullPath+' '+self.__splitBBUPath)
            for root, dirs, files in os.walk(self.__splitBBUPath):
                        for file in files:
                            if 'Part' in file and '.dtz' in file:
                                subpackageNum = subpackageNum+1
        else:
            print('There is not slpit tool in '+os.path.dirname(self.__tools))

        return subpackageNum

    def newGetVerNum(self, fullPath):
        verNum = None
        self.getAbspath()
        if os.path.exists(self.__tools):
            if os.path.exists(fullPath):
                self.__verPath = os.path.dirname(fullPath)
                print('newGetVerNum: verPath is '+self.__verPath)
                os.system(self.__tools+' /i '+fullPath+' '+self.__verPath)
                csvFile = os.path.join(self.__verPath, os.path.basename(fullPath).split('.')[0])+'.csv'
                with open(csvFile, 'r') as file:
                    for line in file.readlines():
                        if '文件大版本' in line:
                            verNum = line.split(',')[1].strip('\n')
            else:
                print('There is not package: '+fullPath)
        else:
            print('There is not slpit tool in '+os.path.dirname(self.__tools))

        return verNum

    def loopGetPackName(self):
        self.__loopNum = self.__loopNum + 1

        return self.__loopNum

    def getFileName(self, fullPath):
        FileName = list()
        self.getAbspath()
        if os.path.exists(self.__tools):
            if os.path.exists(fullPath):
                self.__verPath = os.path.dirname(fullPath)
                print('newGetVerNum: verPath is '+self.__verPath)
                os.system(self.__tools+' /i '+fullPath+' '+self.__verPath)
                csvFile = os.path.join(self.__verPath, os.path.basename(fullPath).split('.')[0])+'.csv'
                with open(csvFile, 'r') as file:
                    for line in file.readlines():
                        if '文件名' in line:
                            FileName.append(line.split(',')[1].strip('\n'))
            else:
                print('There is not package: '+fullPath)
        else:
            print('There is not slpit tool in '+os.path.dirname(self.__tools))

        return FileName

    def getFileNum(self, fullPath):
        fileNum = None
        self.getAbspath()
        if os.path.exists(self.__tools):
            if os.path.exists(fullPath):
                self.__verPath = os.path.dirname(fullPath)
                print('newGetVerNum: verPath is '+self.__verPath)
                os.system(self.__tools+' /i '+fullPath+' '+self.__verPath)
                csvFile = os.path.join(self.__verPath, os.path.basename(fullPath).split('.')[0])+'.csv'
                with open(csvFile, 'r') as file:
                    for line in file.readlines():
                        if '子文件个数' in line:
                            fileNum = line.split(',')[1].strip('\n')
            else:
                print('There is not package: '+fullPath)
        else:
            print('There is not slpit tool in '+os.path.dirname(self.__tools))

        return fileNum

if __name__ == '__main__':
    pass