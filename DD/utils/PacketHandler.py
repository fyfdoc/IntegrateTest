#
from scapy.all import *
import json
import importlib
#from exheader import *


class PacketHandler(object):
    pcapfile="D:\\a.pcap"
    _global_interface = {
        "s1":"Intel",
        "debug":"Realtek"
    }
    def __init__(self,arg1):
        if(isinstance(arg1,str)):
            self._raw_json=arg1
            self._decode=json.loads(arg1)
        else:
            self._raw_json=None
        if(isinstance(arg1,dict)):
            self._decode=dict
        self._parse_decode()
        
    def _parse_decode(self):
        pkt_options={}
        for l1,l1value in self._decode.items():
            if l1.isdigit():
                pkt_options[int(l1)]=l1value
            else:
                setattr(self,l1.lower(),l1value)
        self._pkt_options=pkt_options
        self._parse_packet()

    def _parse_packet(self):
        op=self._pkt_options
        pkt=None
        module_=importlib.import_module("scapy.all")
        for i in sorted(op.keys()):
            if op[i]['type'].lower() == 'data':
                if 'size' in op[i].keys():
                    pkt=pkt/(op[i]['char']*op[i]['size'])
                else :
                    pkt=pkt/op[i]['load']
                continue
            try:
                class_=getattr(module_,op[i]['type'])
            except KeyError:
                print("%d没有指定type" % i)
                return
            except AttributeError:
                print("在scapy中找不到%s类"%op[i]['type'])
                return
            p=class_()
            for inner_op_name,inner_op in op[i].items():
                if inner_op_name == 'type':
                    continue
                try:
                    setattr(p,inner_op_name,inner_op)
                except IndexError:
                    print("%s没有选项%s"%(op[i].type,inner_op_name))
            if pkt is None:
                pkt=p;
            else:
                pkt=pkt/p
        self._pkt=pkt

    def _send(self):
        if self.direction.lower()=='up':
            sendp(self._pkt,iface=_global_interface['debug'] if not hasattr(self,'interface') else self.interface['debug'])
        elif self.direction.lower()=='down':
            sendp(self._pkt,iface=_global_interface['s1'] if not hasattr(self,'interface') else self.interface['s1'])


    def _sniff(self):
        filter=''
        if self.direction.lower()=='up':
            iface=_global_interface['s1'] if not hasattr(self,'interface') else self.interface['s1']
        elif self.direction.lower()=='down':
            iface = _global_interface['debug'] if not hasattr(self,'interface') else self.interface['debug']
        if hasattr(self,'filter'):
            filter=self.filter
        pkgs = sniff(filter=filter  ,
                    iface=iface,
                    prn=Packet.summary, timeout=3)
        print(pkgs)
		# print(len(pkgs))
        wrpcap(self.pcapfile, pkgs)

    def start(self):
        ret = [0]
        send_task = threading.Thread(target=self._send)
        sniff_task = threading.Thread(target=self._sniff)
        sniff_task.start()
        send_task.start()
        send_task.join()
        sniff_task.join()
        return ret[0]

    def check(self):
        pkgs=rdpcap(self.pcapfile)
        count=0
        checksum_error=0
        for p in pkgs:
            check_items_count=0
            check_items_total=0
            for layer_name,layer_options in self.verify.items():
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
                for layer_name in self.verify.keys():
                    #检验校验和
                    if layer_name in p and hasattr(p[layer_name],'chksum'):
                        pkt_chksum=p[layer_name].chksum
                        del p[layer_name].chksum
                        p_new=p.__class__(raw(p))
                        if p_new[layer_name].chksum != pkt_chksum:
                            checksum_error=checksum_error+1
        return count,checksum_error


if __name__=="__main__":
    a=PacketHandler('''
{
    "1":{
        "type":"Ether",
        "dst":"00:1e:a8:ff:ff:ff"
    },
    "2":{
        "type":"IP",
        "src":"192.168.1.100",
        "dst":"192.168.1.5"
    },
    "3":{
        "type":"SCTP",
        "sport":36412,
        "dport":36412
    },
    "direction":"DOWN",
    "Interface":{
        "s1":"Broadcom NetXtreme Gigabit Ethernet",
        "debug":"Intel(R) Ethernet Connection (2) I219-LM"
    },
    "verify":{
        "IP":{
            "src":"192.168.0.3",
            "dst":"192.168.0.1"
        },
        "SCTP":{
            "sport":36411,
            "dport":36411
        }
    }
}
    ''')
    #a.start()
    #print(a.check())
    while True:
        a._send()
        time.sleep(1)