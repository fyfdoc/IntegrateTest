from scapy.all import *
from scapy.contrib.gtp import *
from .exheader import InnerExHeader
import copy
import pyshark

class CheckPacket(object):

	def __init__(self):
		pass

	def check_udp(self, pcapfile, src, dst, sport, dport):
		"""
		检查pcap中数据包是否有与指定参数匹配项
		且校验pacp中有无校验和错误项
		"""
		ver = "IPv6" if ':' in src else "IP"
		pkt = rdpcap(pcapfile)
		count = self._check(pkt,**{ver:{"src":src,"dst":dst},"UDP":{"sport":sport,"dport":dport}})
		checksum_error = self._check_checksum(pcapfile)
		print("总计有%d个包，其中校验和错误的有%d处"%(count,checksum_error))
		return True if count>0 and checksum_error == 0 else False

	def check_gtpu(self, pcapfile, src, dst, sport, dport, teid):
		"""
		检查pcap中数据包是否有与指定参数匹配项
		且校验pacp中有无校验和错误项
		"""
		ver = "IPv6" if ':' in src else "IP"
		pkt = rdpcap(pcapfile)
		count = 0
		for p in pkt:
			try:
				temp = GTP_U_Header(p['UDP'].payload)
			except IndexError:
				continue
			if	p[ver].src == src and \
				p[ver].dst == dst and \
				p.sport == sport and \
				p.dport == dport and \
				temp.teid == teid:
				count += 1
		checksum_error = self._check_checksum(pcapfile)
		print("总计有%d个包，其中校验和错误的有%d处"%(count,checksum_error))
		return True if count>0 and checksum_error == 0 else False

	def check_sctp(self, pcapfile, src, dst, sport, dport):
		"""
		检查pcap中数据包是否有与指定参数匹配项
		且校验pacp中有无校验和错误项
		"""
		ver = "IPv6" if ':' in src else "IP"
		pkt = rdpcap(pcapfile)
		count = self._check(pkt,**{ver:{"src":src,"dst":dst},"SCTP":{"sport":sport,"dport":dport}})
		checksum_error = self._check_checksum(pcapfile)
		print("总计有%d个包，其中校验和错误的有%d处"%(count,checksum_error))
		return True if count>0 and checksum_error == 0 else False

	def _check(self,pkts,**verify):
		count=0
		for p in pkts:
			check_items_count=0
			check_items_total=0
			for layer_name,layer_options in verify.items():
				if(len(layer_options))==0:
					check_items_total=check_items_total+1
					if layer_name in p:
						check_items_count=check_items_count+1
						continue
				for layer_option_name,layer_option in layer_options.items():
					check_items_total=check_items_total+1
					if layer_name in p and \
						hasattr(p[layer_name],layer_option_name) and \
						getattr(p[layer_name],layer_option_name) == layer_option:
							check_items_count=check_items_count+1
			if check_items_count == check_items_total:
				count=count+1
		return count

	def _check_checksum(self, pcapfile):
		cap=pyshark.FileCapture(pcapfile)
		checksum_error = 0
		for p in cap:
			for layer in p:
				msg=layer.get_field('checksum_bad') if 'checksum_bad' in dir(layer) else None
				if isinstance(msg,str) and ('bad' in msg.lower() or '1' in msg):
					checksum_error = checksum_error+1
					print(p)
		return checksum_error


if __name__ == '__main__':
	a = CheckPacket()
	b = a.check_gtpu('gtpu.pcap', '2001:11::3', '2001:11::9', 9999, 9999, 1234)
	print(b)