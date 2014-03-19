#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Соотносим номер устройства /dev/da* и gpt label

"""
import subprocess
import traceback
import re
import sys


def get_da_str(string):
    """
    Get drive address from string"""
    p=re.compile(r'da\d+')
    try:
        s=p.search(string)
        return string[s.start():s.end()]
    except AttributeError:
        raise NameError("Empty string")


def get_all_da():
    """
    Get all disk address"""
    try:
        P=subprocess.check_output(["camcontrol", "dev"])
    except Exception:
        print traceback.format_exc()
        sys.exit()

    #result_da=[]
    #for line in P.split("\n"):
        #try:
            #result_da.append(get_da_str(line))
        #except NameError:
        #    pass
    #return result_da
    return re.findall(r'da\d+', P)


def get_gpt(disknumber):
    """
    Get GPT labels from gpart
    """
    try:
        P=subprocess.check_output(["gpart", "show", "-l", "%s"%disknumber])
    except Exception:
        print traceback.format_exc()
        sys.exit()
    #dict_gpt-da={} # {"gpt-label":"disk number"}
    return P.strip().split()[-2]


def compare_disk_gpt():
    """docstring for compare_disk_gpt"""
    #get all disk drive in camcontrol
    all_da=get_all_da()
    gpt_da=dict()
    for disk in all_da:
        gpt_da["%s"%get_gpt(disk)]=disk

    return gpt_da


def args():
    """
    Запуск программы
        ключи:
            -i, --infile: infile log file
            -o, --outmode: output mode ["K", "M", "B", "G"]
    """

    import argparse

    parser = argparse.ArgumentParser(description='Программа управления ШСПС')
    parser.add_argument("-i", "--infile", metavar="infile",
                      help="infile log file")
    parser.add_argument("-o", "--outmode", metavar="outmode",
                      help='output mode ["K", "M", "B", "G"]')


    args = parser.parse_args()
    if not args.infile:
        print parser.print_help()
    else:
        if not args.infile:
            output="M"
        else:
            output=args.outmode
        pass
        #result = get_speed_one_log(infile=args.infile, outmode=output)
        #print "%.3f\t%.3f\t%f"%(result[0], result[1], result[2])


if __name__ == "__main__":
    #args()

    print compare_disk_gpt()

