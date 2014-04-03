#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
Проведение эксперимента

Проверка следующих вариантов

Stripe/raid0
    2 disk
    3 disk
    4 disk

Raidz/raid5
    3 disk
    4 disk
    5 disk


Проверка, инициализация

Создание пулов, файловой системы и монтирование

Запуск мониторинга пулов

Запуск dd

и далее в цикле

"""

import subprocess
import traceback
import os
import datetime

from hwutils import Mfiutil

class Experiment(Mfiutil):
    """
    Input:
        type_disk (str):    "SAS", "SATA", "NL-SAS", "SSD"
        pool_names (int):   number of pool in this session
        test_iteration (int):   count of scan in session. default = 60
        adapter (int):          number of raid controller. default = 1
    """
    def __init__(self, type_disk, pool_number, test_iteration = 60, adapter = 1):
        super(Experiment, self).__init__(type_disk)
        self.type_disk = type_disk
        self.pool_number = pool_number
        self.adapter = adapter
        self.test_iteration = test_iteration

        self.base_path = os.path.dirname(os.path.realpath(__file__))
        self.time_step = 3
        self.rand_data = "/old/root/rand.data.0"
        #self.mount_point = dict(zip([ "ch%d"%x for x in xrange(pool_number)], ['']*pool_number))


    def raid(self, pool_disks, type_raid):
        """
        Input:
            pool_disks (int):   number of disk in each raid/pool
            type_raid  (str):   type od raid ( raid0 or raid5)

        Return:
            0   (int):          if success
            raise SystemError() if some Error

        YES     размонтировать
        YES     удалить "storageN?",        \
                проверить что хватит дисков для запрашиваемого экспериметна \
                создать "storageN?",        \
                создать constant FileSystem \
                смонтировать
        """
        try:
            self.clean_work_pool(pool_number = self.pool_number, \
                    adapter = self.adapter)
        except: # this function not raise any exception
            raise SystemError("Error during delete and unmounted old pool")

        try:
            result = self.manager_create_raid(type_raid = type_raid,    \
                    pool_disks_number = pool_disks,                     \
                    pool_number = self.pool_number,                     \
                    adapter = self.adapter)
        except:
            print traceback.format_exc()
            raise SystemError("Error create raid")
        if len(result) != self.pool_number:
            raise SystemError("Error create %d raids"%self.pool_number)

        return 0

    def manager_dd(self):
        """
        Старт страйп 2, 3, 4 и райд 3, 4, 5
        """
        date = datetime.datetime.now().strftime("%d-%m-%y")

        for type_raid in [ "raid0", "raid5"]:
            if type_raid == "raid0":
                array = [2,3,4]
            elif type_raid == "raid5":
                array = [3,4,5]
            for disk_in_pool in array:
                path_log = os.path.join(self.base_path, "Log", "DD", date)
                path_log = os.path.join(path_log, "%sD%s%s"%(disk_in_pool, type_raid, self.type_disk))
                if not os.path.exists(path_log):
                    try:
                        os.makedirs(path_log)
                    except:
                        print traceback.format_exc()
                        raise SystemError("os.makedirs error")

                try:
                    self.run_dd(path_log, type_raid=type_raid, disk_in_pool = disk_in_pool)
                except:
                    ALALAARM #TODO:

    def monitor(self, log_path, time_step = 3):
        """
        запуск iostat для всех пулов по отдельности
        без ограничения по времения
        """
        self.pool_names = self.list_volumes(self.adapter)
        if len(self.pool_names) < 1:
            raise SystemError("Pool not exists in system")
        monitor_queue = dict()
        for pool_name, dev_name in self.pool_names:
            cmd = "iostat -dx %s %d"%(dev_name, time_step)
            try:
                monitor_queue[pool_name] = subprocess.Popen(cmd,                   \
                    shell=True,                                                     \
                    stdout=open(os.path.join(log_path, ("Iostat_" + pool_name+"_"+dev_name + ".log")), "w"))
            except:
                print traceback.format_exc()
                raise SystemError("Error: iostat monitoring")
        try:
            cmd = "while true; do top -b -HSz -n 60 >> %s; sleep %d; done"%(os.path.join(log_path, "Top.log"), self.time_step)
            monitor_queue['top'] = subprocess.Popen(cmd, shell=True)
        except:
            print traceback.format_exc()
            raise SystemError("Error: top monitoring")



        return monitor_queue

    def dd_test(self, log_path, disk_in_pool):
        """
        1 запуск прогрева, копируем набор подготовленных данных (self.rand_data) в /dev/null
        2 В цикле запускаем dd на все доступные пулы
        """
        #pre init test copy random data to RAM
        for i in xrange(3):
            _R =subprocess.Popen("dd if=%s of=/dev/null bs=128K"%self.rand_data,
                shell=True,
                stderr=subprocess.STDOUT)
            _R.wait()
            if _R.returncode != 0: raise SystemError("Error write random preset data to /dev/null")

        #run dd
        for i in xrange(self.test_iteration):
            _ch = 0
            queue_dd = {}
            for pool_name, dev_name in self.pool_names:
                mount_point = "ch%d"%_ch
                name_file   = "dd_scan_%d"%i
                log_file    = "DD-%dscan-%s%dD%s"%(self.test_iteration, \
                        self.type_raid,                                 \
                        disk_in_pool,                                   \
                        self.type_disk)
                cmd = "dd if=%s of=%s bs=1m"%(self.rand_data, os.path.join("/", mount_point, name_file))
                queue_dd[mount_point] = subprocess.Popen(cmd,
                        shell=True,
                        stderr=subprocess.STDOUT,
                        stdout=open(os.path.join(log_path, log_file)))
                _ch += 1
            for mount_point in queue_dd.keys():
                queue_dd[mount_point].wait()
                if queue_dd[mount_point].returncode != 0:
                    raise SystemError("Error in main dd on %s mount point"%mount_point)
                queue_dd.pop(mount_point)

        return 0

    def run_dd(self, log, type_raid, disk_in_pool):
        """
        1. Создаем пулы
        2. Запускаем мониторинг
        3. Запускаем тест
        """
        try:
            self.raid(pool_disks = disk_in_pool, type_raid = type_raid)
        except SystemError, err:
            raise SystemError(err)

        try:
            #time_step задан константой!!!
            monitor_queue = self.monitor(log_path = log, time_step = self.time_step)
        except: #TODO
            pass

        try:
            self.dd_test(log_path = log, disk_in_pool = disk_in_pool)
        except: #TODO
            raise SystemError("Error in ")
        #TODO: ждем пока выполнится dd_test() и останавливаем monitor()
        for monitor_name in monitor_queue.keys():
            monitor_queue[monitor_name].kill()
            monitor_queue[monitor_name].wait()
            monitor_queue.pop(monitor_name)


