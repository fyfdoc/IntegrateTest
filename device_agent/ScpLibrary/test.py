
from SendPacket import SendPacket
from SniffPacket import SniffPacket
from CheckPacket import CheckPacket
class Test(SendPacket, SniffPacket, CheckPacket):
	def __init__(self):
		pass



if __name__ == "__main__":
	a = Test()