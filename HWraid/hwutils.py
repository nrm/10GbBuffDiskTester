#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Utils for work with LSI MegaRaid controllers
"""

import subprocess
import sys
import traceback
import re
import os


class Mfiutil():
    """
    Класс описывающий работу с утилитой mfiutil (OS FreeBSD ) управляющей
    hardware raid контроллером LSI MegaRaid


    Command:
        list_volumes : get list of pair (volume_name: mfi_number
        list_drives   : get list of free disk device ( "UNCONFIGURED GOOD")
        create_raid   : create raid volume
        delete_raid   : delete raid volume



    """
    def __init__(self, type_disk):
        #super(Mfiutil, self).__init__()
        self.type_disk = type_disk
        self.type_init = {"NL-SAS":["ST91000640SS",], "SSD":["SSDSC2CW48",]}

    def list_volumes(self, adapter=1):
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

    def list_drives(self, adapter=1):
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
                    if part_num in self.type_init["NL-SAS"]:
                        type_int = "NL-SAS"
                    else:
                        type_int = "SAS"
                elif type_int == "SATA":
                    if part_num in self.type_init["SSD"]:
                        type_int = "SSD"

                if not disk_dict.has_key(type_int):
                    disk_dict[type_int]={}
                if not disk_dict[type_int].has_key(enclosure):
                    disk_dict[type_int][enclosure] = []

                disk_dict[type_int][enclosure].append(slot)


        return disk_dict

    def create_raid(self, disks, type_raid, name, adapter=1):
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
            _pre_mfids = set( zip(*self.list_volumes(adapter))[1])
        except IndexError:
            _pre_mfids = set()
        if name in _pre_mfids:
            raise ValueError("name %s for raid already used")
        try:
            cmd = ["mfiutil", "-u%s"%adapter, "create", type_raid, "-s", "64K"]
            cmd.append(','.join(disks))
            subprocess.check_call(cmd)
        except subprocess.CalledProcessError:
            print cmd
            print traceback.format_exc()
            raise NameError("Error: create mfi raid.\nRaid: %s"%( type_raid))

        try:
            _mfids = set( zip(*self.list_volumes(adapter))[1])
        except IndexError:
            _mfids = set()
        _mfid_name = _pre_mfids^_mfids
        mfid = _mfid_name.pop()

        try:
            cmd = ["mfiutil", "-u1", "name", mfid, name]
            subprocess.check_call(cmd)
        except subprocess.CalledProcessError:
            print traceback.format_exc()
            raise NameError("Error: nameed mfid")

        try:
            cmd = ["gpart", "destroy", "-F", mfid]
            subprocess.check_call(cmd)
        except subprocess.CalledProcessError:
            print traceback.format_exc()

        try:
            cmd = ["gpart", "create", "-s", "gpt", mfid]
            subprocess.check_call(cmd)
            cmd = ["gpart", "add", "-t", "freebsd", mfid]
            subprocess.check_call(cmd)
            cmd = ["newfs", "/dev/%ss1"%mfid]
            subprocess.check_call(cmd)
        except subprocess.CalledProcessError:
            print "cmd:", cmd
            print traceback.format_exc()
            raise SystemError("create mfid raid.\tRaid: %s"%( type_raid))

        return mfid

    def delete_raid(self, name, adapter=1):
        """
        mfiutil -u 1 delete mfid2
        """
        #получение множества существующих томов ( mfid?? )
        _mfids = dict( self.list_volumes(adapter))
        if not _mfids.has_key(name):
            return 0 # successful exit
        try:
            cmd = ["mfiutil", "-u%s"%adapter, "delete", _mfids[name]]
            subprocess.check_call(cmd)
        except subprocess.CalledProcessError:
            print traceback.format_exc()
            raise SystemError("Error: Delete raid %s"%name)
        return 0

    def manager_create_raid(self, type_raid, pool_disks_number, pool_number = 8, adapter = 1):
        """
        Input:
            type_raid (str):            [raid0 or raid5]
            pool_disks_number (int):    number of disks in each pool
            pool_number (int):          number of pool

        Return:
            list_volumes (list):        list of tuple [ ( name_pool, mfid), ... (....)]
        """
        disks_numbers = pool_number * pool_disks_number
        disks_dict = self.list_drives(1)
        disks = disks_dict[self.type_disk]
        if len(disks.keys()) == 2:
            for enc_name in disks.keys():
                enc_disks = disks[enc_name]
                if disks_numbers/2 > len(enc_disks):
                    raise SystemError("In enclose not enough disks, Need: %s, exists: %s"%(disks_numbers/2, len(enc_disks)))
            name_index = 0
            for enc_name in disks.keys():
                enc_disks = disks[enc_name]
                disks_address = map(':'.join, zip( [enc_name]*len(enc_disks), enc_disks))
                _start  = 0
                _end    = pool_disks_number
                for index in xrange(pool_number/2):
                    name_pool = "storage%d"%(index + name_index)
                    curent_disks_address = disks_address[_start:_end]
                    try:
                        self.create_raid(disks = curent_disks_address, type_raid = type_raid, name = name_pool, adapter = 1)
                    except:
                        print traceback.format_exc()
                        sys.exit(-1)
                    _start   += pool_disks_number
                    _end     += pool_disks_number
                name_index += pool_number/2

        elif len(disks.keys()) == 1:
            enc_name = disks.keys()[0]
            enc_disks = disks[enc_name]
            if disks_numbers > len(enc_disks):
                raise SystemError("In data array not enough disks, Need: %s, exists: %s"%(disks_numbers, len(enc_disks)))
            disks_address = map(':'.join, zip( [enc_name]*len(enc_disks), enc_disks))
            _start  = 0
            _end    = pool_disks_number
            for index in xrange(pool_number):
                name_pool = "storage%d"%index
                curent_disks_address = disks_address[_start:_end]
                try:
                    self.create_raid(disks = curent_disks_address, type_raid = type_raid, name = name_pool, adapter = 1)
                except:
                    print traceback.format_exc()
                    sys.exit(-1)
                _start   += pool_disks_number
                _end     += pool_disks_number

        elif len(disks.keys()) < 1:
            raise NameError("Not enclosere with %s type of disk"%self.type_disk)
        else:
            raise NameError("Unexcpected error")

        name_mfids = dict(self.list_volumes(adapter))
        for i, name in enumerate(sorted(name_mfids.keys())):
            mount_point = "ch%d"%i
            try:
                self.mount(pool_dev_name = name_mfids[name], mount_point = mount_point)
            except SystemError:
                print traceback.format_exc()
                continue

        return self.list_volumes(1)

    def clean_work_pool(self, pool_number, adapter = 1):
        """
        Delete pool ['storage0', ...., 'storage7']
        """
        for i in xrange(pool_number):
            name = "storage%d"%i
            mount_point = "ch%d"%i
            try:
                self.umount(mount_point)
            except SystemError:
                print traceback.format_exc()

            try:
                self.delete_raid(name, adapter)
            except SystemError:
                print traceback.format_exc()
                continue
        return self.list_volumes(adapter)

    def umount(self, mount_point):
        """
        Input:
            mount_point (str):  name of dir name in "/" -> "ch0"

        """
        try:
            mount_point = os.path.join('/', mount_point)
            subprocess.check_call(["umount", mount_point])
        except subprocess.CalledProcessError:
            print traceback.format_exc()
            raise SystemError("umount return error")
        return 0

    def mount(self, pool_dev_name, mount_point):
        """
        Input:
            pool_dev_name (str): name raid in /dev -> "mfid2"
            mount_point   (str): name on mount point in "/" -> "ch0"
        """
        mount_point = os.path.join("/", mount_point)
        if not os.path.exists(mount_point): os.mkdir(mount_point)

        pool_dev_name = os.path.join("/dev", pool_dev_name, "s1")

        if not os.path.exists(pool_dev_name): raise SystemError("Error:  %s not exists")

        try:
           subprocess.check_call(["mount", pool_dev_name, mount_point])
        except subprocess.CalledProcessError:
            raise SystemError("mount return error")

        return 0


if __name__ == "__main__":

    print "\nResult of list_drives:\n"
    disks_dict = list_drives(1)
    print disks_dict
    print "\nResult of list_volumes:\n"
    print list_volumes(1)
    print "\nResult of list_volumes:\n"
    print list_volumes(1)
    print "\ncreate raid storage0"
    #get list disk address
    #disks_address_tuple=zip( [disks_dict['SAS'].keys()[0]]*len(disks_dict['SAS'][disks_dict['SAS'].keys()[0]]), disks_dict['SAS'][disks_dict['SAS'].keys()[0]])
    #disks_address = map( ':'.join , disks_address_tuple)
    #disks_str = ','.join(disks_address[:3])
    #print "Disks: %s"%disks_str
    ##print create_raid(disks_str, "raid0", "storage0")
    #print create_raid(disks_address[:3], "raid0", "storage0")
    print "\nResult of list_volumes:\n"
    print list_volumes(1)
    print delete_raid("storage0")


