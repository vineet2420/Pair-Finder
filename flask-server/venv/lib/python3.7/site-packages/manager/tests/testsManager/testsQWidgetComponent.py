#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
**testsQWidgetComponent.py**

**Platform:**
	Windows, Linux, Mac Os X.

**Description:**
	This module defines units tests for :mod:`manager.qwidgetComponent` module.

**Others:**

"""

#**********************************************************************************************************************
#***	External imports.
#**********************************************************************************************************************
import os
import sys
if sys.version_info[:2] <= (2, 6):
	import unittest2 as unittest
else:
	import unittest
from PyQt4.QtGui import QApplication

#**********************************************************************************************************************
#***	Internal imports.
#**********************************************************************************************************************
from manager.qwidgetComponent import QWidgetComponentFactory

#**********************************************************************************************************************
#***	Module attributes.
#**********************************************************************************************************************
__author__ = "Thomas Mansencal"
__copyright__ = "Copyright (C) 2008 - 2012 - Thomas Mansencal"
__license__ = "GPL V3.0 - http://www.gnu.org/licenses/"
__maintainer__ = "Thomas Mansencal"
__email__ = "thomas.mansencal@gmail.com"
__status__ = "Production"

__all__ = ["RESOURCES_DIRECTORY", "UI_FILE" , "APPLICATION" , "QWidgetComponentFactoryTestCase"]

RESOURCES_DIRECTORY = os.path.join(os.path.dirname(__file__), "resources")
UI_FILE = os.path.join(RESOURCES_DIRECTORY, "standard.ui")

APPLICATION = QApplication(sys.argv)

#**********************************************************************************************************************
#***	Module classes and definitions.
#**********************************************************************************************************************
class QWidgetComponentFactoryTestCase(unittest.TestCase):
	"""
	This class defines :func:`manager.qwidgetComponent.QWidgetComponentFactory` factory units tests methods.
	"""

	def testRequiredAttributes(self):
		"""
		This method tests presence of required attributes.
		"""

		requiredAttributes = ("name",
							"uiFile",
							"activated",
							"initializedUi",
							"deactivatable")

		for attribute in requiredAttributes:
			self.assertIn(attribute, dir(QWidgetComponentFactory()))

	def testRequiredMethods(self):
		"""
		This method tests presence of required methods.
		"""

		requiredMethods = ("activate",
						"deactivate",
						"initializeUi",
						"uninitializeUi")

		for method in requiredMethods:
			self.assertIn(method, dir(QWidgetComponentFactory()))

if __name__ == "__main__":
	import manager.tests.utilities
	unittest.main()
