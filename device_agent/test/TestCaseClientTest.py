
from unittest import mock
import unittest, sys

sys.path.append('../')

from TestCaseClient import TestCaseClient
from CTypesHelper import CTypesHelper
from TestCaseLib import TestCaseLib


class TestCaseClientTestCase(unittest.TestCase):

    def test_should_connect_failed_when_testcaselib_is_none(self):
        ctypesHlp = CTypesHelper()
        testcaseClient = TestCaseClient(None, ctypesHlp)
        connect_result = testcaseClient.connect("sctf", "172.27.245.92")
        self.assertTrue(-1 == connect_result)


    def test_should_connect_failed_when_typeshelper_is_none(self):
        testcaseLib = TestCaseLib()
        testcaseLib.getLibrary = mock.Mock(return_value=0)
        
        testcaseClient = TestCaseClient(testcaseLib.getLibrary(), None)
        connect_result = testcaseClient.connect("sctf", "172.27.245.92")
        self.assertTrue(-1 == connect_result)


    def test_should_connect_success_when_all_input_right(self):
        ctypesHlp = CTypesHelper()
        testcaseLib = mock.Mock()
        testcaseLib.TestCase_RegisterTargetProc_Ex = mock.Mock(return_value=0)

        testcaseClient = TestCaseClient(testcaseLib, ctypesHlp)
        connect_result = testcaseClient.connect("sctf", "172.27.245.92")
        self.assertTrue(0 == connect_result)


if __name__ == '__main__':
    unittest.main()

