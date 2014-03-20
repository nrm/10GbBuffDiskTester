#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Запуск iostat, вычисляем из gpt labels физические адреса устройств

версия для FreeBSD and for ZFS ( LVM and softraid)

"""
import subprocess
import cPickle as pickle
import sys
import re
import traceback
import time


def zpool_status():
    """docstring for """
    gpt_da_dict = pickle.load( open("/tmp/gpt_da.tmp", 'r') )
    zpool_dict=dict()
    for el in xrange(8):
        el="storage%d"%el
        zpool_dict[el]=[]
        try:
            pool=subprocess.check_output(["zpool", "status", el])
        except Exception:
            print traceback.format_exc()
            sys.exit()
        gpt_labels = re.findall("(?<=gpt/)\w+", pool)
        for label in gpt_labels:
            zpool_dict[el].append(gpt_da_dict[label])

    return zpool_dict

def main(log, count, atime ):
    """docstring for main"""
    # zpool_dict  { "starageN": ["daX", "daY", ...], "storageN+1: [...] }
    zpool_dict = zpool_status()
    queue = dict()
    for el in xrange(8):
        el="storage%d"%el
        cmd = "iostat -dx %s %s %d"%(" ".join(zpool_dict[el]), atime, int(count)*23)
        queue[el] = subprocess.Popen(cmd, shell=True, stdout=open("%s_%s.log"%(log, el), "w") )

    # wait()
    #while len(queue) > 0:
    #    for el in queue.keys():
    #        if queue[el].poll() == 0:
    #            queue.pop(el)

    #    time.sleep(1)

    return 0




def args():
    """
    Запуск программы
        ключи:
            -l, --log: name of pattern output log file
            -c, --count: count of scan in test session
            -t, --time: time of ACCUMULATION iostat per scan
    """

    import argparse

    parser = argparse.ArgumentParser(description='run iostat')
    parser.add_argument("-l", "--log", metavar="log",
                      help="name of pattern output log file")
    parser.add_argument("-c", "--count", metavar="count",
                      help='count of scan in test session')
    parser.add_argument("-t", "--time", metavar="time",
                      help='time of ACCUMULATION iostat per period')
    #parser.add_argument("-d", "--cwd", metavar="cwd",
    #                  help='current work dir')


    args = parser.parse_args()
    if not args.log and not args.count and not args.time: # and not args.cwd:
        print parser.print_help()
    else:
        main(log=args.log, count=args.count, atime=args.time) #, cwd=args.cwd)


if __name__ == "__main__":
    args()
