#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Utils for work with LSI MegaRaid controllers
"""

import subprocess
import sys
import traceback
import re

#TODO: depricated
def list_volumes(adapter):
    """
    Get list of raid volume

    {{{

    # mfiutil -u 1 show config
        mfi1 Configuration: 2 arrays, 2 volumes, 0 spares
        array 0 of 2 drives:
            drive 29 (   0.0) ONLINE <SEAGATE ST91000640SS AS08 serial=9XG3ZREM> SCSI-6
            drive 30 (   0.0) ONLINE <SEAGATE ST91000640SS AS08 serial=9XG3YZ7Y> SCSI-6
        array 1 of 3 drives:
            drive 31 (   0.0) ONLINE <SEAGATE ST91000640SS AS08 serial=9XG3ZA9R> SCSI-6
            drive 32 (   0.0) ONLINE <SEAGATE ST91000640SS AS08 serial=9XG3ZE71> SCSI-6
            drive 33 (   0.0) ONLINE <SEAGATE ST91000640SS AS08 serial=9XG3Z989> SCSI-6
        volume mfid2 (1862G) RAID-0 64K OPTIMAL <TESTR0> spans:
            array 0
        volume mfid3 (2793G) RAID-0 1M OPTIMAL <Test3DR0> spans:
            array 1
    }}}

    Return:
        (list) (str) : list of volume name (Example: ["mfid2", "mfid3"]
    """
    try:
        volumes=subprocess.check_output(["mfiutil", "-u%s"%adapter, "show", "config"])
    except Exception:
        print traceback.format_exc()
        sys.exit()
    return re.findall("(?<=volume )\w+\d+", volumes)

def list_volumes2(adapter):
    """
    mfiutil -u 1 show volumes

    mfi1 Volumes:
      Id     Size    Level   Stripe  State   Cache   Name
     mfid2 ( 1117G) RAID-0      64K OPTIMAL Writes   <TESTR0>

     Return:
         result (list): list of tuple [ ("name", "mfid?"), (....) ]

    """
    try:
        volumes=subprocess.check_output(["mfiutil", "-u%s"%adapter, "show", "volumes"])
    except Exception:
        print traceback.format_exc()
        sys.exit()
    result = []
    for line in volumes.split("\n"):
        line = line.strip()
        if "mfid" in line[:4]:
            line = line.split()
            result.append( (line[-1][1:-1], line[0]) )

    return result

def list_drives(adapter=1):
    """
    Get list of all drives on mfi1 controller

    {{{
    # mfiutil -u 1 show drives
        mfi1 Physical Drives:
        29 (   0.0) ONLINE            <SEAGATE ST91000640SS AS08 serial=9XG3ZREM> SCSI-6 E2:S5
        30 (   0.0) ONLINE            <SEAGATE ST91000640SS AS08 serial=9XG3YZ7Y> SCSI-6 E2:S3
        31 (   0.0) ONLINE            <SEAGATE ST91000640SS AS08 serial=9XG3ZA9R> SCSI-6 E2:S2
        32 (   0.0) ONLINE            <SEAGATE ST91000640SS AS08 serial=9XG3ZE71> SCSI-6 E2:S1
        33 (   0.0) ONLINE            <SEAGATE ST91000640SS AS08 serial=9XG3Z989> SCSI-6 E2:S0
        34 (   0.0) UNCONFIGURED GOOD <SEAGATE ST91000640SS AS08 serial=9XG3YPKX> SCSI-6 E2:S4
        35 (   0.0) UNCONFIGURED GOOD <SEAGATE ST91000640SS AS08 serial=9XG3X5YQ> SCSI-6 E2:S6
        36 (   0.0) UNCONFIGURED GOOD <SEAGATE ST91000640SS AS08 serial=9XG3ZED1> SCSI-6 E2:S7
        37 (   0.0) UNCONFIGURED GOOD <SEAGATE ST91000640SS AS08 serial=9XG48THZ> SCSI-6 E2:S8
        ....................................................................................
        ....................................................................................
    }}}

    Return:
        (list) (int) : list of drive number (Example: [12, 13]
    """
    Type_int = {"NL-SAS":["ST91000640SS",], "SSD":["SSDSC2CW48",]}

    disk_dict = {}
    try:
        drives=subprocess.check_output(["mfiutil", "-u", "%d"%adapter, "show", "drives"])
    except subprocess.CalledProcessError:
        print traceback.format_exc()
    for line in drives.split("\n"):
        if "UNCONFIGURED GOOD" in line:
            _,_,_,_,_,vendor, part_num,_,_,type_int, address = line.strip().split()
            try:
                enclosure, slot = address.split(":")
            except ValueError:
                enclosure = "None"
                slot = address
            if type_int == "SCSI-6":
                if part_num in Type_int["NL-SAS"]:
                    type_int = "NL-SAS"
                else:
                    type_int = "SAS"
            elif type_int == "SATA":
                if part_num in Type_int["SSD"]:
                    type_int = "SSD"

            if not disk_dict.has_key(type_int):
                disk_dict[type_int]={}
            if not disk_dict[type_int].has_key(enclosure):
                disk_dict[type_int][enclosure] = []

            disk_dict[type_int][enclosure].append(slot)


    return disk_dict



def umount(mount_point=["ch0", "ch1", "ch2", "ch3", "ch4", "ch5", "ch6", "ch7"]):
    """

    """
    for point in mount_point:
        try:
           subprocess.check_call(["umount", point])
        except subprocess.CalledProcessError:
            print traceback.format_exc()
            raise NameError
    return 1

def create_raid(disks, type_raid, name, adapter=1):
    """
    Input:
        disks (list):
        type_raid (str):    type of raid [raid0, raid5]
        name (str):         name of mfid? raid [storage0, ....]
        adapter (int):      number of raid controllers

    mfiutil -u 1 create raid0 -s 64K 29,30
    mfiutil -u 1 name mfid2 TESTR0
    """
    #получение множества существующих томов ( mfid?? )
    try:
        _pre_mfids = set( zip(*list_volumes2(adapter))[1])
    except IndexError:
        _pre_mfids = set()
    try:
        cmd = ["mfiutil", "-u%s"%adapter, "create", type_raid, "-s", "64K"]
        cmd.append(','.join(disks))
        subprocess.check_call(cmd)
    except subprocess.CalledProcessError:
        print cmd
        print traceback.format_exc()
        raise NameError("Error: create mfi raid.\nRaid: %s"%( type_raid))

    _mfids = set( zip(*list_volumes2(adapter))[1])
    _mfid_name = _pre_mfids^_mfids

    try:
        cmd = ["mfiutil", "-u1", "name", _mfid_name.pop(), name]
        subprocess.check_call(cmd)
    except subprocess.CalledProcessError:
        print traceback.format_exc()
        raise NameError("Error: nameed mfid")

    return _mfid_name

def delete_raid(name, adapter=1):
    """
    mfiutil -u 1 delete mfid2
    """
    #получение множества существующих томов ( mfid?? )
    _mfids = dict( zip(*list_volumes2(adapter)))
    if not _mfids.has_key(name):
        raise NameError("%s volume not exists"%name)
    try:
        cmd = ["mfiutil", "-u%s"%adapter, "delete", _mfids[name]]
        subprocess.check_call(cmd)
    except subprocess.CalledProcessError:
        print cmd
        print traceback.format_exc()
        raise NameError("Error: Delete raid %s"%name)
    return 0



if __name__ == "__main__":
    print "\nResult of list_drives:\n"
    disks_dict = list_drives(1)
    print disks_dict
    print "\nResult of list_volumes2:\n"
    print list_volumes2(1)
    print "\nResult of list_volumes:\n"
    print list_volumes(1)
    print "\ncreate raid storage0"
    #get list disk address
    disks_address_tuple=zip( [disks_dict['SAS'].keys()[0]]*len(disks_dict['SAS'][disks_dict['SAS'].keys()[0]]), disks_dict['SAS'][disks_dict['SAS'].keys()[0]])
    disks_address = map( ':'.join , disks_address_tuple)
    disks_str = ','.join(disks_address[:3])
    print "Disks: %s"%disks_str
    #print create_raid(disks_str, "raid0", "storage0")
    print create_raid(disks_address[:3], "raid0", "storage0")
    print "\nResult of list_volumes2:\n"
    print list_volumes2(1)
    print delete_raid("storage0")


