from scapy.all import *

class InnerExHeader(Packet):
	name = 'inner extension transfer header'
	fields_desc=[IP6Field('remote', '0000:0000:0000:0000:0000:ffff:11.11.11.11'),
				 IntField('qos', 0x0)]
# ls(IPv6)