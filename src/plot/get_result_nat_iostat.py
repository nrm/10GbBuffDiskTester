#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Parsing native iostat log file

Structure iostat log file:
{{{
        extended device statistics
    device     r/s   w/s    kr/s    kw/s qlen svc_t  %b
    da1        0.0 158.3     0.0 20106.1    1   6.5 100
    da2        0.0 186.6     0.0 23642.3    1   5.5  99
    da3        0.0 178.6     0.0 22861.7    1   5.7 100
}}}
where:
    r/s   : read operations per second
    w/s   : write operations per	second
    kr/s  : kilobytes read per second
    kw/s  : kilobytes write per second
    qlen  : transactions queue length
    svc_t : average duration of transactions, in milliseconds
    %b    : % of time the device had one or more outstanding transactions

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
    result={}
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
            if not result.has_key(line[0]):
                result[line[0]] = []

            tmp=(line[0], line[-4])
            if tmp[1] != "0.0":
                try:
                    result[tmp[0]].append(float(tmp[1])*1024)
                    #result.append(float(tmp[1])*1024)
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

    for el_dict in result.keys():
        result[el_dict] = [ min(result[el_dict])/coef, sum(result[el_dict])/len(result[el_dict])/coef, max(result[el_dict])/coef ]

    return result
    #return min(result)/coef, sum(result)/len(result)/coef, max(result)/coef


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
        output=args.outmode
    result = get_speed_one_log(infile=args.infile, outmode=output)
    for el_dict in result.keys():
        print "%s\t%.3f\t%.3f\t%f"%(el_dict, result[el_dict][0], result[el_dict][1], result[el_dict][2])


if __name__ == "__main__":
    args()
