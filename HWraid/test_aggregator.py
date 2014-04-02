#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
Agregator Unittest
"""

import unittest
import test_hwutils

suiteMfiutil = test_hwutils.suite()


suite = unittest.TestSuite()
suite.addTest(suiteMfiutil)

unittest.TextTestRunner(verbosity=2).run(suite)


