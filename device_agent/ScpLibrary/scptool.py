'''
自定义robot类库 
二次封装scapy
用于自动化测试
灌包抓包
'''
from scapy.all import *
from scapy.contrib.gtp import *
from .exheader import InnerExHeader
from .SendPacket import SendPacket
from .SniffPacket import SniffPacket
from .CheckPacket import CheckPacket
import threading
import time

class ScpTool(SendPacket, SniffPacket, CheckPacket):
	def __init__(self):
		self.eth = ['Realtek PCIe GBE Family Controller',
					'Intel(R) Ethernet Connection (2) I219-LM']

		# self.eth = [conf.iface,
		# 			conf.iface]

	def udp_test(self, srca, dsta, sporta, dporta, srcb, dstb, sportb, dportb, updownflag, pcapfile, mf=0):
		"""
		双网口
		从A/B端口发送指定属性报文，B\A端口抓取指定属性报文
		updownflag : eth[0]->eth[1]   or   eth[1]->eth[0] 
		"""
		ret = [0]
		send_func = self.send_udp if mf == 0 else self.send_udp_mf
		
		if mf == 0:
			# 过滤数据头4字节 ‘dtm.’ (0x64746d2e)
			flt = 'ip6[48:4] == 0x64746d2e' if ':' in srcb else 'udp[8:4] == 0x64746d2e'
		else:
			# 过滤分片包
			flt = 'ip6[6:1] == 0x2c' if ':' in srcb else 'ip[6:2] & 0x3fff != 0x000'
		# 确定发送接收端口
		send_port = self.eth[updownflag ^ 1]
		sniff_port = self.eth[updownflag ^ 0]

		send_task = threading.Thread(target=send_func, 
									args=(srca, dsta, sporta, dporta, send_port) )
		sniff_task = threading.Thread(target=self.sniffing, 
			   						  args=(flt, sniff_port, ret, pcapfile) )
		sniff_task.start()
		send_task.start()
		send_task.join()
		sniff_task.join()
		if ret[0] != 0:
			stat = self.check_udp(pcapfile, srcb, dstb, sportb, dportb)
		else:
			stat = False
		return stat

	def forward_udp_check_udp(self, srca, dsta, sporta, dporta, srcb, dstb, sportb, dportb, updownflag, pcapfile):
		a = self.udp_test(srca, dsta, sporta, dporta, srcb, dstb, sportb, dportb, updownflag, pcapfile+'.pcap')
		# b = True
		b = self.udp_test(srca, dsta, sporta, dporta, srcb, dstb, sportb, dportb, updownflag, pcapfile+'mf.pcap', mf=1)
		return a & b

	def gtpu_test(self, srca, dsta, sporta, dporta, teida, srcb, dstb, sportb, dportb, teidb, updownflag, pcapfile, mf=0):
		"""
		双网口
		从A/B端口发送指定属性报文，B\A端口抓取指定属性报文
		updownflag : eth[0]->eth[1]   or   eth[1]->eth[0] 
		"""
		ret = [0]
		send_func = self.send_gtpu if mf == 0 else self.send_gtpu_mf
		
		if mf == 0:
			# 过滤数据头4字节 ‘dtm.’ (0x64746d2e)
			flt = 'ip6[56:4] == 0x64746d2e' if ':' in srcb else 'udp[16:4] == 0x64746d2e'
		else:
			# 过滤分片包
			flt = 'ip6[6:1] == 0x2c' if ':' in srcb else 'ip[6:2] & 0x3fff != 0x000'
		# 确定发送接收端口
		send_port = self.eth[updownflag ^ 1]
		sniff_port = self.eth[updownflag ^ 0]

		send_task = threading.Thread(target=send_func, 
									args=(srca, dsta, sporta, dporta, teida, send_port) )
		sniff_task = threading.Thread(target=self.sniffing, 
			   						  args=(flt, sniff_port, ret, pcapfile) )
		sniff_task.start()
		send_task.start()
		send_task.join()
		sniff_task.join()
		if ret[0] != 0:
			stat = self.check_gtpu(pcapfile, srcb, dstb, sportb, dportb, teidb)
		else:
			stat = False
		return stat

	def forward_gtpu_check_gtpu(self, srca, dsta, sporta, dporta, teida, srcb, dstb, sportb, dportb, teidb, updownflag, pcapfile):
		a = self.gtpu_test(srca, dsta, sporta, dporta, teida, srcb, dstb, sportb, dportb, teidb, updownflag, pcapfile+'.pcap')
		# b = True
		b = self.gtpu_test(srca, dsta, sporta, dporta, teida, srcb, dstb, sportb, dportb, teidb, updownflag, pcapfile+'mf.pcap', mf=1)
		return a & b

	def gtpu_up_test(self, srca, dsta, sporta, dporta, remotea, qosa,  teida, srcb, dstb, sportb, dportb, teidb, updownflag, pcapfile, mf=0):
		"""
		双网口
		从A/B端口发送指定属性报文，B\A端口抓取指定属性报文
		updownflag : eth[0]->eth[1]   or   eth[1]->eth[0] 
		"""
		ret = [0]
		send_func = self.send_gtpu_up if mf == 0 else self.send_gtpu_up_mf
		
		if mf == 0:
			# 过滤数据头4字节 ‘dtm.’ (0x64746d2e)
			flt = 'ip6[56:4] == 0x64746d2e' if ':' in srcb else 'udp[16:4] == 0x64746d2e'
		else:
			# 过滤分片包
			flt = 'ip6[6:1] == 0x2c' if ':' in srcb else 'ip[6:2] & 0x3fff != 0x000'
		# 确定发送接收端口
		send_port = self.eth[updownflag ^ 1]
		sniff_port = self.eth[updownflag ^ 0]

		send_task = threading.Thread(target=send_func, 
									args=(srca, dsta, sporta, dporta, remotea, qosa, teida, send_port) )
		sniff_task = threading.Thread(target=self.sniffing, 
			   						  args=(flt, sniff_port, ret, pcapfile) )
		sniff_task.start()
		send_task.start()
		send_task.join()
		sniff_task.join()
		if ret[0] != 0:
			stat = self.check_gtpu(pcapfile, srcb, dstb, sportb, dportb, teidb)
		else:
			stat = False
		return stat

	def forward_gtpu_up_check_gtpu(self, srca, dsta, sporta, dporta, remotea, qosa, teida, srcb, dstb, sportb, dportb, teidb, updownflag, pcapfile):
		a = self.gtpu_up_test(srca, dsta, sporta, dporta, remotea, qosa, teida, srcb, dstb, sportb, dportb, teidb, updownflag, pcapfile+'.pcap')
		# b = True
		b = self.gtpu_up_test(srca, dsta, sporta, dporta, remotea, qosa, teida, srcb, dstb, sportb, dportb, teidb, updownflag, pcapfile+'mf.pcap', mf=1)
		return a & b

	def sctp_test(self, srca, dsta, sporta, dporta, srcb, dstb, sportb, dportb, updownflag, pcapfile, mf=0):
		"""
		双网口
		从A/B端口发送指定属性报文，B\A端口抓取指定属性报文
		updownflag : eth[0]->eth[1]   or   eth[1]->eth[0] 
		"""
		ret = [0]
		send_func = self.send_sctp if mf == 0 else self.send_sctp_mf
		
		if mf == 0:
			# 过滤数据头4字节 ‘dtm.’ (0x64746d2e)
			flt = 'ip6[68:4] == 0x64746d2e' if ':' in srcb else 'sctp[28:4] == 0x64746d2e'
		else:
			# 过滤分片包
			flt = 'ip6[6:1] == 0x2c' if ':' in srcb else 'ip[6:2] & 0x3fff != 0x000'
		# 确定发送接收端口
		send_port = self.eth[updownflag ^ 1]
		sniff_port = self.eth[updownflag ^ 0]

		send_task = threading.Thread(target=send_func, 
									args=(srca, dsta, sporta, dporta, send_port) )
		sniff_task = threading.Thread(target=self.sniffing, 
			   						  args=(flt, sniff_port, ret, pcapfile) )
		sniff_task.start()
		send_task.start()
		send_task.join()
		sniff_task.join()
		if ret[0] != 0:
			stat = self.check_sctp(pcapfile, srcb, dstb, sportb, dportb)
		else:
			stat = False
		return stat

	def forward_sctp_check_sctp(self, srca, dsta, sporta, dporta, srcb, dstb, sportb, dportb, updownflag, pcapfile):
		a = self.sctp_test(srca, dsta, sporta, dporta, srcb, dstb, sportb, dportb, updownflag, pcapfile+'.pcap')
		# b = True
		b = self.sctp_test(srca, dsta, sporta, dporta, srcb, dstb, sportb, dportb, updownflag, pcapfile+'mf.pcap', mf=1)
		return a & b

if __name__ == '__main__':
	s = ScpTool()
	# a = s.forward_udp_check_udp('2001:11::3', '2001:11::9', 9999, 9999, '2001:11::3', '2001:11::9', 9999, 9999, 0, 'udp')
	# print(a)
	# a = s.forward_gtpu_check_gtpu('2001:11::3', '2001:11::9', 9999, 9999, 1234, '2001:11::3', '2001:11::9', 9999, 9999, 1234, 0, 'gtpu')
	# print(a)
	# a = s.forward_gtpu_up_check_gtpu('2001:11::3', '2001:11::9', 9999, 9999, 'ffff::1',  0x0, 1234, '2001:11::3', '2001:11::9', 9999, 9999, 1234, 0, 'gtpu')
	# print(a)
	a = s.forward_sctp_check_sctp('2001:11::3', '2001:11::9', 9999, 9999, '2001:11::3', '2001:11::9', 9999, 9999, 0, 'sctp')
	print(a)
