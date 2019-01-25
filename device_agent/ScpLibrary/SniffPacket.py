from scapy.all import *
from scapy.contrib.gtp import *
from .exheader import InnerExHeader


class SniffPacket(object):

	def __init__(self):
		pass

	def sniffing(self, bpfilter, iface, ret, pcapfile):
		pkgs = sniff(filter=bpfilter, iface=iface,
					 prn=Packet.summary, timeout=5)
		print(pkgs)
		# print(len(pkgs))
		wrpcap(pcapfile, pkgs)
		ret[0] = len(pkgs)	