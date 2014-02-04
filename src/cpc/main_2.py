#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Программа управления ШСПС

Основные возможности:
    читаем конф файл, в котором лежат МАС адреса, IP, и вся необходимая инф

"""
import socket
import sys
import crcmod
import datetime
import time

from struct import pack, unpack

from conf import HOST_1, HOST_2, PORT, R3305_ADDR_2, R3305_ADDR_1

from conf import CMD_NAME, CMD_VERSION, CMD_GET_TIME, CMD_GET_STAT_REG, SREG_REC_STATUS, CMD_SET_TIME

#from conf import SREG_VDIF_TEST_MODE

from conf import CMD_GET_MAC_ADDR, CMD_SET_MAC_ADDR, CMD_SET_REC_STARTTIME, CMD_SET_REC_STOPTIME

##from conf import DST_MAC_ADDR_ix1 as MAC_DST  #FREEBSD ipabuf1
##from conf import DST_MAC_ADDR_ix3 as MAC_DST_2  #FREEBSD ipabuf1
##from conf import DST_MAC_ADDR_ix0 as MAC_DST_3  #FREEBSD ipabuf1
##from conf import DST_MAC_ADDR_ix2 as MAC_DST_4  #FREEBSD ipabuf1

#from conf import DST_MAC_ADDR_ix0 as MAC_DST #FREEBSD
#from conf import DST_MAC_ADDR_ETH4 as MAC_DST #Linux
#rom conf import DST_MAC_ADDR_ETH5 as MAC_DST #Linux ipabuf2

from conf import DST_MAC_ADDR_FF as MAC_DST  # FF:FF:FF:FF:FF:FF
from conf import DST_MAC_ADDR_FF as MAC_DST_2  # FF:FF:FF:FF:FF:FF
from conf import DST_MAC_ADDR_FF as MAC_DST_3  # FF:FF:FF:FF:FF:FF
from conf import DST_MAC_ADDR_FF as MAC_DST_4  # FF:FF:FF:FF:FF:FF

from conf import SRC_MAC_ADDR_C1 as MAC_SRC_C1
from conf import SRC_MAC_ADDR_C2 as MAC_SRC_C2
from conf import SRC_MAC_ADDR_124_C1 as MAC_SRC_CPC2_C1
from conf import SRC_MAC_ADDR_124_C2 as MAC_SRC_CPC2_C2


# Poly 0x31 == 0x131
crc8_func = crcmod.mkCrcFun(0x131, initCrc=0xFF, xorOut=0x00, rev=False)

#print hex(crc8_func('123456789'))

def create_msg(Cmd, data='', addr=R3305_ADDR_1):
    """
     Формирование сообщения.
      1 байт: длина данных сообщения и адрес устройства
      2 байт: команда
      ....  : данные если есть
      n байт: crc8

     Return:
         msg
    """
    tmp = pack("BB", (len(data)<<4 | addr), Cmd)
    #for el in data:
    #    tmp += pack('B', el)
    if len(data): tmp += data
    tmp += pack('B', crc8_func(tmp))

    return tmp

def send_cmd(sock, Cmd, data='', addr=R3305_ADDR_1):
    """
    Отправка команды и получение длины ожидаемого сообщения
    """
    result = None
    if sock is None: sys.exit()
    msg = create_msg(Cmd, data=data, addr=addr)
    sock.send(msg)
    recv = sock.recv(3)
    rlen, rcmd, rcrc = unpack("BBB", recv)
    #print hex(rcmd), hex(rlen), hex(rcrc)
    rxLen = (rlen>>4) & 0x0F
    if rxLen > 14:
        #print "more 14Bytes"
        tmp = unpack("BB", sock.recv(2))
        rxLen = (tmp[0]<<8) + tmp[1]

    rxData = sock.recv(rxLen)

    rxBuff = unpack("B"*rxLen, rxData)

    if Cmd == CMD_NAME or Cmd == CMD_VERSION:
        print ''.join(map(chr, rxBuff))
    elif Cmd == CMD_GET_STAT_REG:
        SReg = rxBuff[0] + (rxBuff[1]<<8) + (rxBuff[2]<<16) + (rxBuff[3]<<24);
        #print("REC STATUS = %d"%(SReg & SREG_REC_STATUS));
        #print("VDIF_TEST_MODE = %d"%(SReg & SREG_VDIF_TEST_MODE));
        result = SReg & SREG_REC_STATUS
    elif Cmd == CMD_GET_TIME:
        Cur_Epoch = rxBuff[0];
        Cur_Sec = rxBuff[1] + (rxBuff[2]<<8) + (rxBuff[3]<<16) + (rxBuff[4]<<24);
        Cur_mSec = rxBuff[5] + (rxBuff[6]<<8);
        print("Cur_Epoch = %d, Cur_Sec = %d, Cur_mSec = %d"%( Cur_Epoch, Cur_Sec, Cur_mSec));
        #print '%s%s'%(datetime.datetime.now().year, time.strftime('-%m-%d %H:%M:%S', time.gmtime(Cur_Sec)))
    elif Cmd == CMD_GET_MAC_ADDR:
        print("Mac address DST is:\t %s\nMac address SRC is:\t %s"%(':'.join(map(hex, rxBuff[:6])), ':'.join(map(hex, rxBuff[6:])) ))


    rxCrc = sock.recv(1)    #recive crc8

    #return 0
    if result is None:
        result = 0

    return result

def set_utc_time(now, delta=0):
    """
    Inputs:
        now (datetime): start time

    """
    epoch   = 2*(now.year - 2000)
    if now.month > 6: epoch +=1
    init    = datetime.datetime(now.year, 1, 1, 0, 0, 0)
    second  = int(( now  - init).total_seconds())


    buf = []
    if not delta:
        buf.append( epoch & 0x000000FF)
    else:
        second +=delta
    print("number epoch %d and UTC seconds = %d"%( epoch, second))
    buf.append(second>>24 & 0x000000FF)
    buf.append(second>>16 & 0x000000FF)
    buf.append(second>>8 & 0x000000FF)
    buf.append(second & 0x000000FF)

    tmp = ''
    for el in buf: tmp += pack('B', el)
    return tmp


def main(count, rec_time, pause):
    """Основная фун программы

    Args:
        (str) conf: full path to conf *.cfg file

    Return:
        pass
    """
    #connect to 1 CPC HOST_1
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.connect((HOST_1, PORT))
    send_cmd(s, CMD_NAME)
    send_cmd(s, CMD_VERSION)
    send_cmd(s, CMD_GET_STAT_REG)
    now = datetime.datetime.utcnow()
    send_cmd(s, CMD_SET_TIME, data=set_utc_time(now))
    send_cmd(s, CMD_GET_TIME)


    #connect to 2 CPC HOST_2
    s_2 = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s_2.connect((HOST_2, PORT))
    send_cmd(s_2, CMD_NAME)
    send_cmd(s_2, CMD_VERSION)
    send_cmd(s_2, CMD_GET_STAT_REG)
    now = datetime.datetime.utcnow()
    send_cmd(s_2, CMD_SET_TIME, data=set_utc_time(now))
    send_cmd(s_2, CMD_GET_TIME)




    ## FOR 1 CPC HOST_1
    #set MAC ADDRESS Chanel 1
    print "\nSet MAC address for Chanel 1"
    dst_mac = src_mac = ''
    for el in MAC_DST: dst_mac += pack('B', el)
    for el in MAC_SRC_C1: src_mac += pack('B', el)

    send_cmd(s, CMD_SET_MAC_ADDR, data = dst_mac+src_mac, addr=R3305_ADDR_1)
    send_cmd(s, CMD_GET_MAC_ADDR, addr=R3305_ADDR_1)

    #return 0

    print "\nSet MAC address for Chanel 2"
    dst_mac = src_mac = ''
    for el in MAC_DST_3: dst_mac += pack('B', el)
    for el in MAC_SRC_C2: src_mac += pack('B', el)

    send_cmd(s, CMD_SET_MAC_ADDR, data = dst_mac+src_mac, addr=R3305_ADDR_2)
    send_cmd(s, CMD_GET_MAC_ADDR, addr=R3305_ADDR_2)

    #return 0




    ## FOR 2 CPC HOST_2
    #set MAC ADDRESS Chanel 1
    print "\nSet MAC address for Chanel 1"
    dst_mac = src_mac = ''
    for el in MAC_DST_4: dst_mac += pack('B', el)
    for el in MAC_SRC_CPC2_C1: src_mac += pack('B', el)

    send_cmd(s_2, CMD_SET_MAC_ADDR, data = dst_mac+src_mac, addr=R3305_ADDR_1)
    send_cmd(s_2, CMD_GET_MAC_ADDR, addr=R3305_ADDR_1)

    #return 0

    print "\nSet MAC address for Chanel 2"
    dst_mac = src_mac = ''
    for el in MAC_DST_2: dst_mac += pack('B', el)
    for el in MAC_SRC_CPC2_C2: src_mac += pack('B', el)

    send_cmd(s_2, CMD_SET_MAC_ADDR, data = dst_mac+src_mac, addr=R3305_ADDR_2)
    send_cmd(s_2, CMD_GET_MAC_ADDR, addr=R3305_ADDR_2)

    #return 0



    for el in xrange(count):
        #Sync time before start record scan
        #CPC 1 HOST_1
        #Channel 1
        now = datetime.datetime.utcnow()
        send_cmd(s, CMD_SET_TIME, data=set_utc_time(now), addr=R3305_ADDR_1)
        send_cmd(s, CMD_GET_TIME, addr=R3305_ADDR_1)
        #Channel 2
        now = datetime.datetime.utcnow()
        send_cmd(s, CMD_SET_TIME, data=set_utc_time(now), addr=R3305_ADDR_2)
        send_cmd(s, CMD_GET_TIME, addr=R3305_ADDR_2)


        #CPC 2 HOST_2
        #Channel 1
        now = datetime.datetime.utcnow()
        send_cmd(s_2, CMD_SET_TIME, data=set_utc_time(now), addr=R3305_ADDR_1)
        send_cmd(s_2, CMD_GET_TIME, addr=R3305_ADDR_1)
        #Channel 2
        now = datetime.datetime.utcnow()
        send_cmd(s_2, CMD_SET_TIME, data=set_utc_time(now), addr=R3305_ADDR_2)
        send_cmd(s_2, CMD_GET_TIME, addr=R3305_ADDR_2)


        #send Start and Stop time
        now = datetime.datetime.utcnow()
        print "\n\t\tStart time for %s scan == %s"%(el+1, now)
        #print "\n\t\tScan %d\n"%(el+1)
        start = now + datetime.timedelta(seconds=4)

        #set start REC time
        #CPC 1 HOST_1
        send_cmd(s, CMD_SET_REC_STARTTIME, data=set_utc_time(start, delta=1), addr=R3305_ADDR_1)
        send_cmd(s, CMD_SET_REC_STARTTIME, data=set_utc_time(start, delta=1), addr=R3305_ADDR_2)

        #CPC 2 HOST_2
        send_cmd(s_2, CMD_SET_REC_STARTTIME, data=set_utc_time(start, delta=1), addr=R3305_ADDR_1)
        send_cmd(s_2, CMD_SET_REC_STARTTIME, data=set_utc_time(start, delta=1), addr=R3305_ADDR_2)

        #Set STOP REC TIME
        stop = start+datetime.timedelta(seconds=rec_time-1)

        #CPC 1 HOST_1
        send_cmd(s, CMD_SET_REC_STOPTIME, data = set_utc_time(stop, delta = 2), addr=R3305_ADDR_1)
        send_cmd(s, CMD_SET_REC_STOPTIME, data = set_utc_time(stop, delta = 2), addr=R3305_ADDR_2)


        #CPC 2 HOST_2
        send_cmd(s_2, CMD_SET_REC_STOPTIME, data = set_utc_time(stop, delta = 2), addr=R3305_ADDR_1)
        send_cmd(s_2, CMD_SET_REC_STOPTIME, data = set_utc_time(stop, delta = 2), addr=R3305_ADDR_2)

        print "Start time %s, and Stop time %s"%(start, stop+datetime.timedelta(seconds=1))



        while datetime.datetime.utcnow() <= stop+datetime.timedelta(seconds=1):
            time.sleep(1)
            print "Rec status CPC 1 Ch 1: %s"%send_cmd(s, CMD_GET_STAT_REG, addr=R3305_ADDR_1)
            print "Rec status CPC 1 Ch 2: %s"%send_cmd(s, CMD_GET_STAT_REG, addr=R3305_ADDR_2)
            print "Rec status CPC 2 Ch 1: %s"%send_cmd(s_2, CMD_GET_STAT_REG, addr=R3305_ADDR_1)
            print "Rec status CPC 2 Ch 2: %s"%send_cmd(s_2, CMD_GET_STAT_REG, addr=R3305_ADDR_2)
        time.sleep(1)
        print datetime.datetime.utcnow()
        print "Rec status CPC 1 Ch 1: %s"%send_cmd(s, CMD_GET_STAT_REG, addr=R3305_ADDR_1)
        print "Rec status CPC 1 Ch 2: %s"%send_cmd(s, CMD_GET_STAT_REG, addr=R3305_ADDR_2)
        print "Rec status CPC 2 Ch 1: %s"%send_cmd(s_2, CMD_GET_STAT_REG, addr=R3305_ADDR_1)
        print "Rec status CPC 2 Ch 2: %s"%send_cmd(s_2, CMD_GET_STAT_REG, addr=R3305_ADDR_2)
        print "Pause %s sec"%pause
        time.sleep(pause)
        print "\t\tEnd time for %s scan == %s"%(el+1, datetime.datetime.utcnow())



def args():
    """
    Запуск программы
        ключи:
            -c, --count: count of scan in session
            -t, --time: rec time one scan
    """

    import argparse

    parser = argparse.ArgumentParser(description='Программа управления ШСПС')
    parser.add_argument("-c", "--count", metavar="count",
                      help="count of scan in session")
    parser.add_argument("-t", "--time", metavar="time",
                      help="rec time one scan")
    parser.add_argument("-p", "--pause", metavar="pause",
                      help="pause time between rec scan")


    args = parser.parse_args()
    #if not args.path:
    if not args.count and not args.time:
        print parser.print_help()
    else:
        main(count = int(args.count), rec_time = int(args.time), pause = int(args.pause))


if __name__ == "__main__":
    args()

