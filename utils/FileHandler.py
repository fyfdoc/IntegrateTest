#!usr/bin/env python3
#-*- coding: utf-8 -*-

'file handle module'

__author__ = 'zhuqingshuang'

import os,sys

class FileHandler(object):
    
    #object scope define
    ROBOT_LIBRARY_SCOPE = 'GLOBAL'

    def __init__(self):
        #relative path
        self.__tools = r'tools\CMDLMTZip.exe'
        self.__verPath = r'version'
        self.__splitAAUPath = r'version\split\AAU'
        self.__splitBBUPath = r'version\split\BBU'

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

if __name__ == '__main__':
    pass