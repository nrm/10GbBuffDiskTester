#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
Unittest for hwutils.py
"""

from hwutils import Mfiutil
import unittest
from mock import patch

class TestMfiutil (unittest.TestCase):

    def setUp(self):
        self.mfiutil = Mfiutil("SAS")
        self.data = """
            mfi1 Physical Drives:
            29 (   0.0) UNCONFIGURED GOOD <SEAGATE ST91000640SS AS08 serial=9XG3ZREM> SCSI-6 E2:S5
            30 (   0.0) UNCONFIGURED GOOD <SEAGATE ST91000640SS AS08 serial=9XG3YZ7Y> SCSI-6 E2:S3
            31 (   0.0) UNCONFIGURED GOOD <SEAGATE ST91000640SS AS08 serial=9XG3ZA9R> SCSI-6 E2:S2
            32 (   0.0) UNCONFIGURED GOOD <SEAGATE ST91000640SS AS08 serial=9XG3ZE71> SCSI-6 E2:S1
            33 (   0.0) UNCONFIGURED GOOD <SEAGATE ST91000640SS AS08 serial=9XG3Z989> SCSI-6 E2:S0
            34 (   0.0) UNCONFIGURED GOOD <SEAGATE ST91000640SS AS08 serial=9XG3YPKX> SCSI-6 E2:S4
            35 (   0.0) UNCONFIGURED GOOD <SEAGATE ST91000640SS AS08 serial=9XG3X5YQ> SCSI-6 E2:S6
            36 (   0.0) UNCONFIGURED GOOD <SEAGATE ST91000640SS AS08 serial=9XG3ZED1> SCSI-6 E2:S7
            37 (   0.0) UNCONFIGURED GOOD <SEAGATE ST91000640SS AS08 serial=9XG48THZ> SCSI-6 E2:S8
            38 (   0.0) UNCONFIGURED GOOD <SEAGATE ST91000640SS AS08 serial=9XG49ZMA> SCSI-6 E2:S11
            39 (   0.0) UNCONFIGURED GOOD <SEAGATE ST91000640SS AS08 serial=9XG48S95> SCSI-6 E2:S10
            40 (   0.0) UNCONFIGURED GOOD <SEAGATE ST91000640SS AS08 serial=9XG49VZE> SCSI-6 E2:S9
            41 (   0.0) UNCONFIGURED GOOD <SEAGATE ST91000640SS AS08 serial=9XG48TN7> SCSI-6 E2:S17
            42 (   0.0) UNCONFIGURED GOOD <SEAGATE ST91000640SS AS08 serial=9XG48TCZ> SCSI-6 E2:S16
            43 (   0.0) UNCONFIGURED GOOD <SEAGATE ST91000640SS AS08 serial=9XG48TRS> SCSI-6 E2:S15
            44 (   0.0) UNCONFIGURED GOOD <SEAGATE ST91000640SS AS08 serial=9XG49W8K> SCSI-6 E2:S14
            45 (   0.0) UNCONFIGURED GOOD <SEAGATE ST91000640SS AS08 serial=9XG45W9Z> SCSI-6 E2:S22
            46 (   0.0) UNCONFIGURED GOOD <SEAGATE ST91000640SS AS08 serial=9XG49ZQ8> SCSI-6 E2:S23
            47 (   0.0) UNCONFIGURED GOOD <SEAGATE ST91000640SS AS08 serial=9XG460WZ> SCSI-6 E2:S18
            48 (   0.0) UNCONFIGURED GOOD <SEAGATE ST91000640SS AS08 serial=9XG49HNH> SCSI-6 E2:S19
            50 (   0.0) UNCONFIGURED GOOD <SEAGATE ST91000640SS AS08 serial=9XG49ZWP> SCSI-6 E2:S12
            51 (   0.0) UNCONFIGURED GOOD <SEAGATE ST91000640SS AS08 serial=9XG49ZWL> SCSI-6 E2:S20
            52 (   0.0) UNCONFIGURED GOOD <SEAGATE ST91000640SS AS08 serial=9XG49HVF> SCSI-6 E2:S21
            54 (   0.0) UNCONFIGURED GOOD <SEAGATE ST9600205SS CS05 serial=6XR1P3G4> SAS E4:S20
            58 (   0.0) UNCONFIGURED GOOD <SEAGATE ST9600205SS CS05 serial=6XR1NQMA> SAS E4:S16
            73 (   0.0) UNCONFIGURED GOOD <SEAGATE ST91000640SS AS05 serial=9XG2EHK4> SCSI-6 E2:S13
            84 (   0.0) UNCONFIGURED GOOD <SEAGATE ST9600205SS CS05 serial=6XR1P4TG> SAS E4:S0
            85 (   0.0) UNCONFIGURED GOOD <SEAGATE ST9600205SS CS05 serial=6XR1P4VD> SAS E4:S1
            86 (   0.0) UNCONFIGURED GOOD <SEAGATE ST9600205SS CS05 serial=6XR1L1YA> SAS E4:S2
            87 (   0.0) UNCONFIGURED GOOD <SEAGATE ST9600205SS CS05 serial=6XR1NXWN> SAS E4:S3
            88 (   0.0) UNCONFIGURED GOOD <SEAGATE ST9600205SS CS05 serial=6XR1NFWL> SAS E4:S6
            89 (   0.0) UNCONFIGURED GOOD <SEAGATE ST9600205SS CS05 serial=6XR1NFWD> SAS E4:S7
            90 (   0.0) UNCONFIGURED GOOD <SEAGATE ST9600205SS CS05 serial=6XR1P4WC> SAS E4:S8
            91 (   0.0) UNCONFIGURED GOOD <SEAGATE ST9600205SS CS05 serial=6XR1N3QP> SAS E4:S11
            92 (   0.0) UNCONFIGURED GOOD <SEAGATE ST9600205SS CS05 serial=6XR1P4K1> SAS E4:S10
            93 (   0.0) UNCONFIGURED GOOD <SEAGATE ST9600205SS CS05 serial=6XR1P40H> SAS E4:S9
            94 (   0.0) UNCONFIGURED GOOD <SEAGATE ST9600205SS CS05 serial=6XR1P4LP> SAS E4:S17
            96 (   0.0) UNCONFIGURED GOOD <SEAGATE ST9600205SS CS05 serial=6XR1NZ2D> SAS E4:S15
            97 (   0.0) UNCONFIGURED GOOD <SEAGATE ST9600205SS CS05 serial=6XR1P52A> SAS E4:S14
            98 (   0.0) UNCONFIGURED GOOD <SEAGATE ST9600205SS CS05 serial=6XR1NZ29> SAS E4:S22
            99 (   0.0) UNCONFIGURED GOOD <SEAGATE ST9600205SS CS05 serial=6XR1NXD2> SAS E4:S23
            100 (   0.0) UNCONFIGURED GOOD <SEAGATE ST9600205SS CS05 serial=6XR15GM4> SAS E4:S18
            101 (   0.0) UNCONFIGURED GOOD <SEAGATE ST9600205SS CS05 serial=6XR1P0BK> SAS E4:S19
            102 (   0.0) UNCONFIGURED GOOD <SEAGATE ST9600205SS CS05 serial=6XR1NFF5> SAS E4:S13
            103 (   0.0) UNCONFIGURED GOOD <SEAGATE ST9600205SS CS05 serial=6XR1NRYX> SAS E4:S12
            105 (   0.0) UNCONFIGURED GOOD <SEAGATE ST9600205SS CS05 serial=6XR1NFEL> SAS E4:S21
            107 (   0.0) UNCONFIGURED GOOD <SEAGATE ST9600205SS CS05 serial=6XR1P534> SAS E4:S5
            108 (   0.0) UNCONFIGURED GOOD <SEAGATE ST9600205SS CS05 serial=6XR1P3W0> SAS E4:S4
            109 (   0.0) UNCONFIGURED GOOD <WDC WD1003FBYX-0 1V02 serial=WD-WMAW31167132> SATA S109
            110 (   0.0) UNCONFIGURED GOOD <WDC WD1003FBYX-0 1V02 serial=WD-WMAW31305788> SATA S110
            111 (   0.0) UNCONFIGURED GOOD <WDC WD1003FBYX-0 1V02 serial=WD-WMAW31297309> SATA S111
            112 (   0.0) UNCONFIGURED GOOD <WDC WD1002FAEX-0 1D05 serial=WD-WMAW31569288> SATA S112
            113 (   0.0) UNCONFIGURED GOOD <WDC WD1003FBYX-0 1V02 serial=WD-WMAW31297816> SATA S113
            114 (   0.0) UNCONFIGURED GOOD <WDC WD1003FBYX-0 1V02 serial=WD-WMAW31061945> SATA S114
            115 (   0.0) UNCONFIGURED GOOD <WDC WD1003FBYX-0 1V02 serial=WD-WMAW31296592> SATA S115
            116 (   0.0) UNCONFIGURED GOOD <WDC WD1003FBYX-0 1V02 serial=WD-WMAW31264757> SATA S116
            117 (   0.0) UNCONFIGURED GOOD <WDC WD1003FBYX-0 1V02 serial=WD-WCAW33971950> SATA S117
            118 (   0.0) UNCONFIGURED GOOD <WDC WD1003FBYX-0 1V02 serial=WD-WCAW34010770> SATA S118
            119 (   0.0) UNCONFIGURED GOOD <WDC WD1003FBYX-0 1V02 serial=WD-WCAW34098342> SATA S119
            120 (   0.0) UNCONFIGURED GOOD <WDC WD1003FBYX-0 1V02 serial=WD-WCAW34097313> SATA S120
            121 (   0.0) UNCONFIGURED GOOD <WDC WD1003FBYX-0 1V02 serial=WD-WCAW34110544> SATA S121
            122 (   0.0) UNCONFIGURED GOOD <WDC WD1003FBYX-0 1V02 serial=WD-WCAW34112799> SATA S122
            123 (   0.0) UNCONFIGURED GOOD <WDC WD1003FBYX-0 1V02 serial=WD-WCAW33970231> SATA S123
            124 (   0.0) UNCONFIGURED GOOD <WDC WD1003FBYX-0 1V02 serial=WD-WCAW33981474> SATA S124"""
        self.pattern_disk_dict = {'NL-SAS': {'E2': ['S5','S3','S2','S1','S0','S4','S6','S7','S8','S11','S10','S9','S17','S16','S15','S14','S22','S23','S18','S19','S12','S20','S21','S13']},'SAS': {'E4': ['S20', 'S16', 'S0', 'S1', 'S2', 'S3', 'S6', 'S7', 'S8', 'S11', 'S10', 'S9', 'S17', 'S15', 'S14', 'S22', 'S23', 'S18', 'S19', 'S13', 'S12', 'S21','S5', 'S4']},'SATA': {'None': ['S109','S110','S111','S112','S113','S114','S115','S116','S117','S118','S119','S120','S121','S122','S123','S124']}}
        self.pattern_list_volumes = [('storage0', 'mfid2'), ('storage1', 'mfid3'), ('storage2', 'mfid4')]

    def testMfiutilList_drives(self):
        """
        """
        with patch('subprocess.check_output') as perm_mock:
            perm_mock.return_value = self.data
            self.disk_dict = self.mfiutil.list_drives(1)

        self.assertEqual( self.pattern_disk_dict, self.disk_dict)

    def testMfiutilList_volume(self):
        """
        """
        with patch('subprocess.check_output') as perm_mock:
            perm_mock.return_value = """mfi1 Volumes:
                  Id     Size    Level   Stripe  State   Cache   Name
                 mfid2 ( 1675G) RAID-0      64K OPTIMAL Writes   <storage0>
                 mfid3 ( 1675G) RAID-0      64K OPTIMAL Writes   <storage1>
                 mfid4 ( 1675G) RAID-0      64K OPTIMAL Writes   <storage2>"""
            self.result_list_volumes = self.mfiutil.list_volumes(1)
            self.assertEqual( self.pattern_list_volumes, self.result_list_volumes)

    def testMfiutilCreate_raid(self):
        """docstring for """
        with patch('self.list_volumes') as list_volumes:
            list_volumes.return_value = self.result_list_volumes
            with patch('subprocess.check_call') as perm_mock:
                pass





def suite():
    suite = unittest.TestSuite()
    suite.addTest(unittest.makeSuite(TestMfiutil))
    return suite
