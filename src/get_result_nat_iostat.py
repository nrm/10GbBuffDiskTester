#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Анализ лог файла zpool iostat

Основные возможности:
    выдаем min, aver, max скорости записи на пул

"""

def check(value):
    """
    В зависимости от коэфициента на конце переменной(G, M, K)
    приводим все числа к байтам
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
        """
                         extended device statistics
device     r/s   w/s    kr/s    kw/s qlen svc_t  %b
da32       0.0   0.0     0.0     0.0    0   0.0   0
da33       0.0   0.0     0.0     0.0    0   0.0   0
da35       0.0   0.0     0.0     0.0    0   0.0   0
da38       0.0   0.0     0.0     0.0    0   0.0   0
da39       0.0   0.0     0.0     0.0    0   0.0   0
        """
        line=line.strip().split()
        if "da" in line[0]:
            tmp=(line[0], line[-4])
            if tmp[1] != "0.0":
                try:
                    result.append(int(tmp[1]))
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
        result = get_speed_one_log(infile=args.infile, outmode=output)
        print "%.3f\t%.3f\t%f"%(result[0], result[1], result[2])


if __name__ == "__main__":
    args()

