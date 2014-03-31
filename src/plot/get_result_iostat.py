#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
~Pнализ лог ~Dайла zpool iostat

~^~Aновн~Kе возможно~A~Bи:
    в~Kдаем min, aver, max ~Aко~@о~A~Bи запи~Aи на п~Cл

"""

def check(value):
    """
    ~R зави~Aимо~A~Bи о~B ко~M~Dи~Fиен~Bа на кон~Fе пе~@еменной(G, M, K)
    п~@иводим в~Aе ~Gи~Aла к бай~Bам
    """
    if value[-1] == "M":
        result = float(value[0:-1]) * 1024 * 1024        # in Bytes
    elif value[-1] == "K":
        result = float(value[0:-1]) * 1024               # in Bytes
    elif value[-1] == "G":
        result = float(value[0:-1]) * 1024 * 1024 * 1024 # in Bytes
    else:
        result = float(value) * 1               # in Bytes

    return result


def get_speed_one_log(infile, outmode="M"):
    """docstring for get_speed_one_log

    """
    result=[]
    for line in open(infile, 'r'):
        line=line.strip().split()
        tmp=(line[0], line[-1])
        if "storage" in tmp[0] and tmp[1] != "0":
            try:
                result.append(check(tmp[1]))
            except UnboundLocalError:
                print tmp[1]
    if outmode=="M":
        coef=1024*1024
    elif outmode=="K":
        coef=1024
    elif outmode=="G":
        coef=1024*1024*1024
    else:
        coef=1

    return min(result)/coef, sum(result)/len(result)/coef, max(result)/coef


def args():
    """
        Info about programms
        args:
            -i, --infile: infile log file
            -o, --outmode: output mode ["K", "M", "B", "G"]
    """

    import argparse

    parser = argparse.ArgumentParser(description='~_~@ог~@амма ~Cп~@авлени~O ШС~_С')
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
        result = get_speed_one_log(infile=args.infile, outmode=output)
        print "%.3f\t%.3f\t%f"%(result[0], result[1], result[2])


if __name__ == "__main__":
    args()

