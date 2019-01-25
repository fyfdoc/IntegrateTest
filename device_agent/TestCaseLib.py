# encoding utf-8
'''
@company: Datang Mobile
@license: (c) Copyright 2018, Datang Mobile
@author:  pengqiang
@file:    TestCaseLib.py
@time:    2018/07/28
@desc:    to load testcaselib.dll 
'''

import os.path
import sys

from ctypes import *

class TestCaseLib(object):

    def __init__(self):
        self.initialize()
    
    def initialize(self):
        lib_path = self.getLibPath()

        self.addLibPathtoEnv(lib_path)

        return self.loadLibrary(lib_path)
   

    def getLibPath(self):
        return os.path.dirname(os.path.abspath(__file__)) + os.path.sep + 'lib' + os.path.sep


    def addLibPathtoEnv(self, lib_path):
        os.environ['path'] += ';{0}'.format(lib_path)


    def loadLibrary(self, lib_path):
        loadlibrary_path = lib_path + 'TestCaseLib.dll'
        try:
            self._testcaselib = cdll.LoadLibrary(loadlibrary_path)
            self._testcaselib.TestCase_Init()
            return 0
        except OSError as err:
            print("Load TestCaseLib failed, caused by {0}".format(err))
            return -1


    def getLibrary(self):
        return self._testcaselib

