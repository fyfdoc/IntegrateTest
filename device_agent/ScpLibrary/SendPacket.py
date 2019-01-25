from scapy.all import *
from scapy.contrib.gtp import *
from .exheader import InnerExHeader

class SendPacket(object):

	def __init__(self):
		pass

	def send_udp(self, src, dst, sport, dport, iface):
		data = 'dtm.'  #0x64746d2e
		pkg = (Ether(dst='00:1e:a8:61:b6:6c') \
			/ IPv6(src=src, \
				   dst=dst, ) \
			/ UDP(sport=sport, dport=dport) \
			/ data) \
			if ':' in src else \
			(Ether(dst='00:1e:a8:61:b6:6c') \
			/ IP(src=src, \
				   dst=dst, ) \
			/ UDP(sport=sport, dport=dport) \
			/ data)
		sendp(pkg, iface=iface)

	def send_udp_mf(self, src, dst, sport, dport, iface):
		data = '5' * 5000
		pkg = (Ether(dst='00:1e:a8:61:b6:6c') \
			/ IPv6(src=src, \
				   dst=dst, ) \
			/ IPv6ExtHdrFragment() \
			/ UDP(sport=sport, dport=dport) \
			/ data) \
			if ':' in src else \
			(Ether(dst='00:1e:a8:61:b6:6c') \
			/ IP(src=src, dst=dst) \
			/ UDP(sport=sport, dport=dport) \
			/ data) 
	
		frags = fragment6(pkg, fragSize=1450) if ':' in src else fragment(pkg, fragsize=1450)
		# print(len(frags))
		for frag in frags:
			# fragment.show()
			sendp(frag, iface=iface)

	def send_gtpu(self, src, dst, sport, dport, teid, iface):
		data = 'dtm.'  #0x64746d2e
		pkg = (Ether(dst='00:1e:a8:61:b6:6c') \
			/ IPv6(src=src, \
				   dst=dst, ) \
			/ UDP(sport=sport, dport=dport) \
			/ GTP_U_Header(teid=teid) \
			/ data) \
			if ':' in src else \
			(Ether(dst='00:1e:a8:61:b6:6c') \
			/ IP(src=src, \
				   dst=dst, ) \
			/ UDP(sport=sport, dport=dport) \
			/ GTP_U_Header(teid=teid) \
			/ data)
		sendp(pkg, iface=iface)

	def send_gtpu_mf(self, src, dst, sport, dport, teid, iface):
		data = '5' * 5000
		pkg = (Ether(dst='00:1e:a8:61:b6:6c') \
			/ IPv6(src=src, \
				   dst=dst, ) \
			/ IPv6ExtHdrFragment() \
			/ UDP(sport=sport, dport=dport) \
			/ GTP_U_Header(teid=teid) \
			/ data) \
			if ':' in src else \
			(Ether(dst='00:1e:a8:61:b6:6c') \
			/ IP(src=src, \
				   dst=dst, ) \
			/ UDP(sport=sport, dport=dport) \
			/ GTP_U_Header(teid=teid) \
			/ data)

		frags = fragment6(pkg, fragSize=1450) if ':' in src else fragment(pkg, fragsize=1450)
		# print(len(frags))
		for frag in frags:
			# fragment.show()
			sendp(frag, iface=iface)

	def send_gtpu_up(self, src, dst, sport, dport, remote, qos, teid, iface):
		data = 'dtm.'  #0x64746d2e
		pkg = (Ether(dst='00:1e:a8:61:b6:6c') \
			/ IPv6(src=src, \
				   dst=dst, ) \
			/ UDP(sport=sport, dport=dport) \
			/ InnerExHeader(remote=remote, qos=qos) \
			/ GTP_U_Header(teid=teid) \
			/ data) \
			if ':' in src else \
			(Ether(dst='00:1e:a8:61:b6:6c') \
			/ IP(src=src, \
				   dst=dst, ) \
			/ UDP(sport=sport, dport=dport) \
			/ InnerExHeader(remote=remote, qos=qos) \
			/ GTP_U_Header(teid=teid) \
			/ data)
		sendp(pkg, iface=iface)

	def send_gtpu_up_mf(self, src, dst, sport, dport, remote, qos, teid, iface):
		data = '5' * 5000
		pkg = (Ether(dst='00:1e:a8:61:b6:6c') \
			/ IPv6(src=src, \
				   dst=dst, ) \
			/ IPv6ExtHdrFragment() \
			/ UDP(sport=sport, dport=dport) \
			/ InnerExHeader(remote=remote, qos=qos) \
			/ GTP_U_Header(teid=teid) \
			/ data) \
			if ':' in src else \
			(Ether(dst='00:1e:a8:61:b6:6c') \
			/ IP(src=src, \
				   dst=dst, ) \
			/ UDP(sport=sport, dport=dport) \
			/ InnerExHeader(remote=remote, qos=qos) \
			/ GTP_U_Header(teid=teid) \
			/ data)

		frags = fragment6(pkg, fragSize=1450) if ':' in src else fragment(pkg, fragsize=1450)
		# print(len(frags))
		for frag in frags:
			# fragment.show()
			sendp(frag, iface=iface)

	def send_sctp(self, src, dst, sport, dport, iface):
		data = 'dtm.'  #0x64746d2e
		pkg = (Ether(dst='00:1e:a8:61:b6:6c') \
			/ IPv6(src=src, \
				   dst=dst, ) \
			/ SCTP(sport=sport, dport=dport) \
			/ SCTPChunkData(len=20) \
			/ data) \
			if ':' in src else \
			(Ether(dst='00:1e:a8:61:b6:6c') \
			/ IP(src=src, \
				   dst=dst, ) \
			/ SCTP(sport=sport, dport=dport) \
			/ SCTPChunkData(len=20) \
			/ data)
		sendp(pkg, iface=iface)

	def send_sctp_mf(self, src, dst, sport, dport, iface):
		data = '5' * 5000
		pkg = (Ether(dst='00:1e:a8:61:b6:6c') \
			/ IPv6(src=src, dst=dst) \
			/ IPv6ExtHdrFragment() \
			/ SCTP(sport=sport, dport=dport) \
			/ SCTPChunkData(len=5016) \
			/ data) \
			if ':' in src else \
			(Ether(dst='00:1e:a8:61:b6:6c') \
			/ IP(src=src, dst=dst) \
			/ SCTP(sport=sport, dport=dport) \
			/ SCTPChunkData(len=5016) \
			/ data)
	
		frags = fragment6(pkg, fragSize=1450) if ':' in src else fragment(pkg, fragsize=1450)
		# print(len(frags))
		for frag in frags:
			# fragment.show()
			sendp(frag, iface=iface)

if __name__ == '__main__':
	a = SendPacket()
	# a.send_udp('2001:11::3','2001:11::9', 9999, 9999, conf.iface)
	# a.send_udp('11.11.11.11','22.22.22.22', 9999, 9999, conf.iface)

	# a.send_udp_mf('2001:11::3','2001:11::9', 9999, 9999, conf.iface)
	# a.send_udp_mf('11.11.11.11','22.22.22.22', 9999, 9999, conf.iface)

	# a.send_gtpu('2001:11::3','2001:11::9', 9999, 9999, 1234, conf.iface)
	# a.send_gtpu('11.11.11.11','22.22.22.22', 40000, 20003, 1234, conf.iface)

	# a.send_gtpu_mf('11.11.11.11','22.22.22.22', 9999, 9999, 1234, conf.iface)
	# a.send_gtpu_mf('2001:11::3','2001:11::9', 9999, 9999, 1234, conf.iface)
	 
	a.send_sctp('11.11.11.11', '22.22.22.22', 8888, 8888, conf.iface)
	a.send_sctp('2001:11::3','2001:11::9', 8888, 8888, conf.iface)

	# a.send_sctp_mf('11.11.11.11', '22.22.22.22', 8888, 8888, conf.iface)
	# a.send_sctp_mf('2001:11::3','2001:11::9', 8888, 8888, conf.iface)