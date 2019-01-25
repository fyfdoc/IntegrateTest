# encoding utf-8
'''
@company: Datang Mobile
@license: (c) Copyright 2018, Datang Mobile
@author:  pengqiang
@file:    TestCaseLibMain.py
@time:    2018/07/28
@desc:     
'''
import os
import sys

sys.path.append('..' + os.path.sep)

from TestCaseLib import TestCaseLib
from TestCaseClient import TestCaseClient
from CTypesHelper import CTypesHelper

#test TestCaseClient entry
def main():
    hostName = "SCTF"
    hostIP = "172.27.245.92"

    testCaseLib = TestCaseLib()
    testCaseLib.initialize()

    ctypesHelper = CTypesHelper()

    testCaseClient = TestCaseClient(testCaseLib.getLibrary(), ctypesHelper)
    testCaseClient.connect(hostName, hostIP)

    testCaseClient.execute_command("OM_MIB_CheckInitInfo", [])

    userinputs = input(">")
    while "quit" != userinputs:
        userinputs = input(">")

    testCaseClient.disconnect()

    return

if __name__ == '__main__':
    main()

