import socket
import sys
import threading
import argparse
import time
import ipaddress
import os

#osp tpf port
HOST, PORT = "172.27.245.92", 10030

#tpf message start flag
TPF_MESSAGE_FLAG = 0x5a

TPF_LOGON_MESSAGE_TYPE = 0x01

TPF_LOGON_MESSAGE_FUNC = 0x01

TPF_LOGON_MESSAGE_LEN = 9

TPF_LOGON_MESSAGE_PARA_ID = 1

#Alive Message 
TPF_QUERY_MESSAGE_FUNC = 0x0a

TPF_QUERY_MESSAGE_TYPE = 0x01

TPF_ALIVE_MESSAGE_LEN = 8

#alive period unit second
TPF_ALIVE_PERIOD = 2 

TPF_RECEIVE_BUFFER_LEN = 1024

#logon message
LOGON_MESSAGE = TPF_MESSAGE_FLAG.to_bytes(1, byteorder='big') +\
         TPF_LOGON_MESSAGE_LEN.to_bytes(2, byteorder='big') +\
         TPF_LOGON_MESSAGE_TYPE.to_bytes(1, byteorder='big') +\
         TPF_LOGON_MESSAGE_FUNC.to_bytes(1, byteorder='big') +\
         bytes(3) +\
         TPF_LOGON_MESSAGE_PARA_ID.to_bytes(1, byteorder='big')

#ALIVE message
ALIVE_MESSAGE = TPF_MESSAGE_FLAG.to_bytes(1, byteorder='big') +\
         TPF_ALIVE_MESSAGE_LEN.to_bytes(2, byteorder='big') +\
         TPF_QUERY_MESSAGE_TYPE.to_bytes(1, byteorder='big') +\
         TPF_QUERY_MESSAGE_FUNC.to_bytes(1, byteorder='big') +\
         bytes(3)

#worker base class, wrapper for thread and connection
class Worker_base(threading.Thread):
    def __init__(self):
        threading.Thread.__init__(self)
        self._isStop = False

    def setConnection(self, connection):
        self._connection = connection

    def getConnection(self):
        return self._connection

    def setStop(self, stopFlag):
        self._isStop = stopFlag

    def run(self):
        while True != self._isStop:
            try:
                self.working()
            except socket.timeout as timeout_msg:
                continue
            except OSError as error_msg:
                self.setStop(True)
                break
        return


#alive worker, period send alive message to control port
class Alive_worker(Worker_base):
    def __init__(self):
        Worker_base.__init__(self)

    def working(self):
        self._connection.sendall(ALIVE_MESSAGE)
        time.sleep(TPF_ALIVE_PERIOD)
        return

#control channel worker,
class Control_worker(Worker_base):
    def __init__(self):
        Worker_base.__init__(self)

    def working(self):
        received_datas = self._connection.recv(TPF_RECEIVE_BUFFER_LEN)
        return

    
#console channel worker
class Console_worker(Worker_base):
    def __init__(self):
        Worker_base.__init__(self)

    def working(self):
        received_datas = self._connection.recv(TPF_RECEIVE_BUFFER_LEN)
        print(received_datas.decode(encoding="gb2312"))
        return

    def send_command(self, command_text):
        if (None != self._connection):
            send_content = command_text + os.linesep
            self._connection.sendall(send_content.encode(encoding="gb2312"))
        return


#TPF client that connect to board
class Tpfclient(object):
    def __init__(self):
        self._control_worker = None
        self._console_worker = None
        self._alive_worker = None
        self._workers = []

        self._connections = []
        return

    def begin_session(self, host, port):
        #connect control port
        self._control_worker = self.start_connection_worker(Control_worker, self.connect_control_port, host, port)
        
        #begin heart beat
        self._alive_worker = self.start_worker(Alive_worker, self._control_worker.getConnection())

        #connect console port
        self._console_worker = self.start_connection_worker(Console_worker, self.connect_console_port, host, port)
        
        return

    def stop_session(self):
        #stop work thread
        for worker in self._workers:
            worker.setStop(True)
            worker.join()

        #close socket
        for connection in self._connections:
            connection.close()

        return

    def execute_command(self, command_text):
        if None != self._console_worker:
            print("send command {0}".format(command_text))
            self._console_worker.send_command(command_text)
        return

    #internal implements
    def start_connection_worker(self, Worker_type, do_connection, host, port):
        connection = do_connection(host, port)
        connection.settimeout(1.0)

        self._connections.append(connection)
       
        return self.start_worker(Worker_type, connection)

    def start_worker(self, Worker_type, connection):
        worker = Worker_type()
        worker.setConnection(connection)
        self._workers.append(worker)
        worker.start()
        return worker

    #connect control port
    def connect_control_port(self, host, port):
        try:
            control_connection = socket.create_connection((host, port))
            print("connect control: {0}:{1} success!".format(host, port))
            if None != control_connection:
                #send logon request
                control_connection.sendall(LOGON_MESSAGE)
            return control_connection
        except OSError as error_msg:
            return None

    def connect_console_port(self, host, port):
        #todo: connection error resolve
        try:
            console_connection = socket.create_connection((host, port))
            print("connect console: {0}:{1} success!".format(host, port))
            return console_connection
        except OSError as error_msg:
            return None

#test Tpfclient entry
def main(args):
    tpf_client = Tpfclient()
    tpf_client.begin_session(HOST, PORT)

    userinputs = input(">")
    while "quit" != userinputs:
        tpf_client.execute_command(userinputs)
        userinputs = input(">")

    tpf_client.stop_session()
    return

if __name__ == '__main__':
    arg_parser = argparse.ArgumentParser(description="TPF Client")
    args = arg_parser.parse_args()
    main(args)

