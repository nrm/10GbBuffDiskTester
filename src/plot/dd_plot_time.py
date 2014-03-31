#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Plot graf from DD-Nscans-log
"""

import re


#from numpy import exp, linspace
import matplotlib.pyplot as plt
import matplotlib.figure as fig


#решение проблемы с выводом на график русских шрифтов
from matplotlib import rcParams
rcParams['text.usetex']=False
rcParams['font.sans-serif'] = ['Liberation Sans']
rcParams['font.serif'] = ['Liberation Serif']


def get_data(inputf):
    """
    Get time (in sec) and write speed (in bytes)
    Args:
        Input:
            inputf (str): name of log file

        Return:
            result (list): list of tuple pair [(time, write_spedd), (...)..]

    Example log DD file:
    ==========
        9999220736 bytes transferred in 30.598968 secs (326782940 bytes/sec)
        9536+0 records in
        9536+0 records out
        9999220736 bytes transferred in 32.171326 secs (310811583 bytes/sec)
        9536+0 records in
        9536+0 records out
    ==========
    """
    with open(inputf, "r") as F:
        text = F.read()
        result = zip( re.findall("(?<=rred in )\d+.\d+", text), re.findall("(?<= \()\d+", text))
    return result


def graf(inputf):
    """
    """
    result = get_data(inputf)
    time, wr_speed = zip(*result)
    time=map(float, time)
    plt.plot(time, 'r-o', linewidth= 1.5)

    x_min = 1
    x_max = len(time)
    y_min = 0
    y_max = 70

    plt.axis([x_min, x_max, y_min, y_max])

    plt.xlabel(u'number of scan')    # обозначение оси абсцисс
    plt.ylabel(u'time, sec')    # обозначение оси ординат

    #plt.show()

    # Сохраняем диаграмму в файл
    image_name = inputf.split('.')
    img = image_name[0] + '_' + image_name[-1].split('_')[-1] + '_time.png'
    plt.savefig(img, format = 'png')




def args():
    """
    Graf plot from DD-Nscans-log
        args:
            -i, --inputf: inputf log file
    """

    import argparse

    parser = argparse.ArgumentParser(description='~_~@ог~@амма ~Cп~@авлени~O ШС~_С')
    parser.add_argument("-i", "--inputf", metavar="inputf",
                      help="inputf log file")
    #parser.add_argument("-o", "--outmode", metavar="outmode",
    #                  help='output mode ["K", "M", "B", "G"]')


    args = parser.parse_args()
    if not args.inputf:
        print parser.print_help()
    graf(inputf=args.inputf)


if __name__ == "__main__":
    args()
