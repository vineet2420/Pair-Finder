#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
**exceptions.py**

**Platform:**
	Windows, Linux, Mac Os X.

**Description:**
	This module defines **Manager** package exceptions. 

**Others:**

"""

#**********************************************************************************************************************
#***	Internal imports.
#**********************************************************************************************************************
import foundations.exceptions

#**********************************************************************************************************************
#***	Module attributes.
#**********************************************************************************************************************
__author__ = "Thomas Mansencal"
__copyright__ = "Copyright (C) 2008 - 2012 - Thomas Mansencal"
__license__ = "GPL V3.0 - http://www.gnu.org/licenses/"
__maintainer__ = "Thomas Mansencal"
__email__ = "thomas.mansencal@gmail.com"
__status__ = "Production"

__all__ = ["AbstractComponentsManagerError",
			"ComponentProfileError",
			"ComponentModuleError",
			"ComponentRegistrationError",
			"ComponentInterfaceError",
			"ComponentInstantiationError",
			"ComponentActivationError",
			"ComponentDeactivationError",
			"ComponentReloadError",
			"ComponentExistsError"]

#**********************************************************************************************************************
#***	Module classes and definitions.
#**********************************************************************************************************************
class AbstractComponentsManagerError(foundations.exceptions.AbstractError):
	"""
	This class is the abstract base class for :class:`manager.componentsManager.Manager` related exceptions.
	"""

	pass

class ComponentProfileError(AbstractComponentsManagerError):
	"""
	This class is used for Component profile exceptions.
	"""

	pass

class ComponentModuleError(AbstractComponentsManagerError):
	"""
	This class is used for Component associated module exceptions.
	"""

	pass

class ComponentRegistrationError(AbstractComponentsManagerError):
	"""
	This class is used for Component registration exceptions.
	"""

	pass

class ComponentInterfaceError(AbstractComponentsManagerError):
	"""
	This class is used for Component Interface exceptions.
	"""

	pass

class ComponentInstantiationError(AbstractComponentsManagerError):
	"""
	This class is used for Component instantiation exceptions.
	"""

	pass

class ComponentActivationError(AbstractComponentsManagerError):
	"""
	This class is used for Component activation exceptions.
	"""

	pass

class ComponentDeactivationError(AbstractComponentsManagerError):
	"""
	This class is used for Component deactivation exceptions.
	"""

	pass

class ComponentReloadError(AbstractComponentsManagerError):
	"""
	This class is used for Component reload exceptions.
	"""

	pass

class ComponentExistsError(AbstractComponentsManagerError):
	"""
	This class is used for non existing Component exceptions.
	"""

	pass
