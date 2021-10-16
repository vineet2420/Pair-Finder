#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
**manager.py**

**Platform:**
	Windows, Linux, Mac Os X.

**Description:**
	This module defines the :class:`Manager` class and others helper objects.

**Others:**

"""

#**********************************************************************************************************************
#***	External imports.
#**********************************************************************************************************************
import inspect
import itertools
import os
import sys
import re

#**********************************************************************************************************************
#***	Internal imports.
#**********************************************************************************************************************
import foundations.common
import foundations.dataStructures
import foundations.exceptions
import foundations.strings
import foundations.verbose
import foundations.walkers
import manager.exceptions
from foundations.parsers import SectionsFileParser
from manager.component import Component
from manager.qobjectComponent import QObjectComponent
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

__all__ = ["LOGGER", "Components", "Profile", "Manager"]

LOGGER = foundations.verbose.installLogger()

#**********************************************************************************************************************
#***	Module classes and definitions.
#**********************************************************************************************************************
class Components(foundations.dataStructures.Structure):
	"""
	This class represents a storage object for :class:`Manager` class Components.
	"""

	def __init__(self, **kwargs):
		"""
		This method initializes the class.

		:param \*\*kwargs: Arguments. ( Key / Value pairs )
		"""

		LOGGER.debug("> Initializing '{0}()' class.".format(self.__class__.__name__))

		foundations.dataStructures.Structure.__init__(self, **kwargs)

class Profile(object):
	"""
	This class is used by the :class:`Manager` class to store Components informations and objects.
	"""

	def __init__(self, name=None, file=None):
		"""
		This method initializes the class.
		
		:param name: Name of the Component. ( String )
		:param file: File of the Component. ( String )
		"""

		LOGGER.debug("> Initializing '{0}()' class.".format(self.__class__.__name__))

		# --- Setting class attributes. ---
		self.__name = None
		self.name = name
		self.__file = None
		self.file = file

		self.__directory = None
		self.__attribute = None
		self.__require = None
		self.__module = None
		self.__interface = None
		self.__category = None

		self.__title = None
		self.__package = None
		self.__version = None
		self.__author = None
		self.__email = None
		self.__url = None
		self.__description = None

	#******************************************************************************************************************
	#***	Attributes properties.
	#******************************************************************************************************************
	@property
	def name(self):
		"""
		This method is the property for **self.__name** attribute.

		:return: self.__name. ( String )
		"""

		return self.__name

	@name.setter
	@foundations.exceptions.handleExceptions(AssertionError)
	def name(self, value):
		"""
		This method is the setter method for **self.__name** attribute.

		:param value: Attribute value. ( String )
		"""

		if value is not None:
			assert type(value) in (str, unicode), "'{0}' attribute: '{1}' type is not 'str' or 'unicode'!".format(
			"name", value)
		self.__name = value

	@name.deleter
	@foundations.exceptions.handleExceptions(foundations.exceptions.ProgrammingError)
	def name(self):
		"""
		This method is the deleter method for **self.__name** attribute.
		"""

		raise foundations.exceptions.ProgrammingError(
		"{0} | '{1}' attribute is not deletable!".format(self.__class__.__name__, "name"))

	@property
	def file(self):
		"""
		This method is the property for **self.__file** attribute.

		:return: self.__file. ( String )
		"""

		return self.__file

	@file.setter
	@foundations.exceptions.handleExceptions(AssertionError)
	def file(self, value):
		"""
		This method is the setter method for **self.__file** attribute.

		:param value: Attribute value. ( String )
		"""

		if value is not None:
			assert type(value) in (str, unicode), "'{0}' attribute: '{1}' type is not 'str' or 'unicode'!".format("file", value)
		self.__file = value

	@file.deleter
	@foundations.exceptions.handleExceptions(foundations.exceptions.ProgrammingError)
	def file(self):
		"""
		This method is the deleter method for **self.__file** attribute.
		"""

		raise foundations.exceptions.ProgrammingError(
		"{0} | '{1}' attribute is not deletable!".format(self.__class__.__name__, "file"))

	@property
	def directory(self):
		"""
		This method is the property for **self.__directory** attribute.

		:return: self.__directory. ( String )
		"""

		return self.__directory

	@directory.setter
	@foundations.exceptions.handleExceptions(AssertionError)
	def directory(self, value):
		"""
		This method is the setter method for **self.__directory** attribute.

		:param value: Attribute value. ( String )
		"""

		if value is not None:
			assert type(value) in (str, unicode), "'{0}' attribute: '{1}' type is not 'str' or 'unicode'!".format(
			"directory", value)
			assert os.path.exists(value), "'{0}' attribute: '{1}' directory doesn't exists!".format("directory", value)
		self.__directory = value

	@directory.deleter
	@foundations.exceptions.handleExceptions(foundations.exceptions.ProgrammingError)
	def directory(self):
		"""
		This method is the deleter method for **self.__directory** attribute.
		"""

		raise foundations.exceptions.ProgrammingError(
		"{0} | '{1}' attribute is not deletable!".format(self.__class__.__name__, "directory"))

	@property
	def attribute(self):
		"""
		This method is the property for **self.__attribute** attribute.

		:return: self.__attribute. ( String )
		"""

		return self.__attribute

	@attribute.setter
	@foundations.exceptions.handleExceptions(AssertionError)
	def attribute(self, value):
		"""
		This method is the setter method for **self.__attribute** attribute.

		:param value: Attribute value. ( String )
		"""

		if value is not None:
			assert type(value) in (str, unicode), "'{0}' attribute: '{1}' type is not 'str' or 'unicode'!".format(
			"attribute", value)
		self.__attribute = value

	@attribute.deleter
	@foundations.exceptions.handleExceptions(foundations.exceptions.ProgrammingError)
	def attribute(self):
		"""
		This method is the deleter method for **self.__attribute** attribute.
		"""

		raise foundations.exceptions.ProgrammingError(
		"{0} | '{1}' attribute is not deletable!".format(self.__class__.__name__, "attribute"))

	@property
	def require(self):
		"""
		This method is the property for **self.__require** attribute.

		:return: self.__require. ( Tuple / List )
		"""

		return self.__require

	@require.setter
	@foundations.exceptions.handleExceptions(AssertionError)
	def require(self, value):
		"""
		This method is the setter method for **self.__require** attribute.

		:param value: Attribute value. ( Tuple / List )
		"""

		if value is not None:
			assert type(value) in (tuple, list), "'{0}' attribute: '{1}' type is not 'tuple' or 'list'!".format(
			"require", value)
		self.__require = value

	@require.deleter
	@foundations.exceptions.handleExceptions(foundations.exceptions.ProgrammingError)
	def require(self):
		"""
		This method is the deleter method for **self.__require** attribute.
		"""

		raise foundations.exceptions.ProgrammingError(
		"{0} | '{1}' attribute is not deletable!".format(self.__class__.__name__, "require"))

	@property
	def module(self):
		"""
		This method is the property for **self.__module** attribute.

		:return: self.__module. ( Module )
		"""

		return self.__module

	@module.setter
	@foundations.exceptions.handleExceptions(AssertionError)
	def module(self, value):
		"""
		This method is the setter method for **self.__module** attribute.

		:param value: Attribute value. ( Module )
		"""

		if value is not None:
			assert type(value) is type(sys), "'{0}' attribute: '{1}' type is not 'module'!".format("module", value)
		self.__module = value

	@module.deleter
	@foundations.exceptions.handleExceptions(foundations.exceptions.ProgrammingError)
	def module(self):
		"""
		This method is the deleter method for **self.__module** attribute.
		"""

		raise foundations.exceptions.ProgrammingError(
		"{0} | '{1}' attribute is not deletable!".format(self.__class__.__name__, "module"))

	@property
	def interface(self):
		"""
		This method is the property for **self.__interface** attribute.

		:return: self.__interface. ( Object )
		"""

		return self.__interface

	@interface.setter
	def interface(self, value):
		"""
		This method is the setter method for **self.__interface** attribute.

		:param value: Attribute value. ( Object )
		"""

		self.__interface = value

	@interface.deleter
	@foundations.exceptions.handleExceptions(foundations.exceptions.ProgrammingError)
	def interface(self):
		"""
		This method is the deleter method for **self.__interface** attribute.
		"""

		raise foundations.exceptions.ProgrammingError(
		"{0} | '{1}' attribute is not deletable!".format(self.__class__.__name__, "interface"))

	@property
	def category(self):
		"""
		This method is the property for **self.__category** attribute.

		:return: self.__category. ( String )
		"""

		return self.__category

	@category.setter
	@foundations.exceptions.handleExceptions(AssertionError)
	def category(self, value):
		"""
		This method is the setter method for **self.__category** attribute.

		:param value: Attribute value. ( String )
		"""

		if value is not None:
			assert type(value) in (str, unicode), "'{0}' attribute: '{1}' type is not 'str' or 'unicode'!".format(
			"category", value)
		self.__category = value

	@category.deleter
	@foundations.exceptions.handleExceptions(foundations.exceptions.ProgrammingError)
	def category(self):
		"""
		This method is the deleter method for **self.__category** attribute.
		"""

		raise foundations.exceptions.ProgrammingError(
		"{0} | '{1}' attribute is not deletable!".format(self.__class__.__name__, "category"))

	@property
	def title(self):
		"""
		This method is the property for **self.__title** attribute.

		:return: self.__title. ( String )
		"""

		return self.__title

	@title.setter
	@foundations.exceptions.handleExceptions(AssertionError)
	def title(self, value):
		"""
		This method is the setter method for **self.__title** attribute.

		:param value: Attribute value. ( String )
		"""

		if value is not None:
			assert type(value) in (str, unicode), "'{0}' attribute: '{1}' type is not 'str' or 'unicode'!".format(
			"title", value)
		self.__title = value

	@title.deleter
	@foundations.exceptions.handleExceptions(foundations.exceptions.ProgrammingError)
	def title(self):
		"""
		This method is the deleter method for **self.__title** attribute.
		"""

		raise foundations.exceptions.ProgrammingError(
		"{0} | '{1}' attribute is not deletable!".format(self.__class__.__name__, "title"))

	@property
	def package(self):
		"""
		This method is the property for **self.__package** attribute.

		:return: self.__package. ( String )
		"""

		return self.__package

	@package.setter
	@foundations.exceptions.handleExceptions(AssertionError)
	def package(self, value):
		"""
		This method is the setter method for **self.__package** attribute.

		:param value: Attribute value. ( String )
		"""

		if value is not None:
			assert type(value) in (str, unicode), "'{0}' attribute: '{1}' type is not 'str' or 'unicode'!".format(
			"package", value)
		self.__package = value

	@package.deleter
	@foundations.exceptions.handleExceptions(foundations.exceptions.ProgrammingError)
	def package(self):
		"""
		This method is the deleter method for **self.__package** attribute.
		"""

		raise foundations.exceptions.ProgrammingError(
		"{0} | '{1}' attribute is not deletable!".format(self.__class__.__name__, "package"))

	@property
	def version(self):
		"""
		This method is the property for **self.__version** attribute.

		:return: self.__version. ( String )
		"""

		return self.__version

	@version.setter
	@foundations.exceptions.handleExceptions(AssertionError)
	def version(self, value):
		"""
		This method is the setter method for **self.__version** attribute.

		:param value: Attribute value. ( String )
		"""

		if value is not None:
			assert type(value) in (str, unicode), "'{0}' attribute: '{1}' type is not 'str' or 'unicode'!".format(
			"version", value)
		self.__version = value

	@version.deleter
	@foundations.exceptions.handleExceptions(foundations.exceptions.ProgrammingError)
	def version(self):
		"""
		This method is the deleter method for **self.__version** attribute.
		"""

		raise foundations.exceptions.ProgrammingError(
		"{0} | '{1}' attribute is not deletable!".format(self.__class__.__name__, "version"))

	@property
	def author(self):
		"""
		This method is the property for **self.__author** attribute.

		:return: self.__author. ( String )
		"""

		return self.__author

	@author.setter
	@foundations.exceptions.handleExceptions(AssertionError)
	def author(self, value):
		"""
		This method is the setter method for **self.__author** attribute.

		:param value: Attribute value. ( String )
		"""

		if value is not None:
			assert type(value) in (str, unicode), "'{0}' attribute: '{1}' type is not 'str' or 'unicode'!".format(
			"author", value)
		self.__author = value

	@author.deleter
	@foundations.exceptions.handleExceptions(foundations.exceptions.ProgrammingError)
	def author(self):
		"""
		This method is the deleter method for **self.__author** attribute.
		"""

		raise foundations.exceptions.ProgrammingError(
		"{0} | '{1}' attribute is not deletable!".format(self.__class__.__name__, "author"))

	@property
	def email(self):
		"""
		This method is the property for **self.__email** attribute.

		:return: self.__email. ( String )
		"""

		return self.__email

	@email.setter
	@foundations.exceptions.handleExceptions(AssertionError)
	def email(self, value):
		"""
		This method is the setter method for **self.__email** attribute.

		:param value: Attribute value. ( String )
		"""

		if value is not None:
			assert type(value) in (str, unicode), "'{0}' attribute: '{1}' type is not 'str' or 'unicode'!".format(
			"email", value)
		self.__email = value

	@email.deleter
	@foundations.exceptions.handleExceptions(foundations.exceptions.ProgrammingError)
	def email(self):
		"""
		This method is the deleter method for **self.__email** attribute.
		"""

		raise foundations.exceptions.ProgrammingError(
		"{0} | '{1}' attribute is not deletable!".format(self.__class__.__name__, "email"))

	@property
	def url(self):
		"""
		This method is the property for **self.__url** attribute.

		:return: self.__url. ( String )
		"""

		return self.__url

	@url.setter
	@foundations.exceptions.handleExceptions(AssertionError)
	def url(self, value):
		"""
		This method is the setter method for **self.__url** attribute.

		:param value: Attribute value. ( String )
		"""

		if value is not None:
			assert type(value) in (str, unicode), "'{0}' attribute: '{1}' type is not 'str' or 'unicode'!".format(
			"url", value)
		self.__url = value

	@url.deleter
	@foundations.exceptions.handleExceptions(foundations.exceptions.ProgrammingError)
	def url(self):
		"""
		This method is the deleter method for **self.__url** attribute.
		"""

		raise foundations.exceptions.ProgrammingError(
		"{0} | '{1}' attribute is not deletable!".format(self.__class__.__name__, "url"))

	@property
	def description(self):
		"""
		This method is the property for **self.__description** attribute.

		:return: self.__description. ( String )
		"""

		return self.__description

	@description.setter
	@foundations.exceptions.handleExceptions(AssertionError)
	def description(self, value):
		"""
		This method is the setter method for **self.__description** attribute.

		:param value: Attribute value. ( String )
		"""

		if value is not None:
			assert type(value) in (str, unicode), "'{0}' attribute: '{1}' type is not 'str' or 'unicode'!".format(
			"description", value)
		self.__description = value

	@description.deleter
	@foundations.exceptions.handleExceptions(foundations.exceptions.ProgrammingError)
	def description(self):
		"""
		This method is the deleter method for **self.__description** attribute.
		"""

		raise foundations.exceptions.ProgrammingError(
		"{0} | '{1}' attribute is not deletable!".format(self.__class__.__name__, "description"))

	#******************************************************************************************************************
	#***	Class methods.
	#******************************************************************************************************************
	@foundations.exceptions.handleExceptions(foundations.exceptions.FileStructureParsingError)
	def initializeProfile(self):
		"""
		This method gets initializes the Component Profile.
		
		:return: Method success. ( Boolean )
		"""

		LOGGER.debug("> Building '{0}' profile.".format(self.__file))

		sectionsFileParser = SectionsFileParser(self.__file)
		sectionsFileParser.read() and sectionsFileParser.parse()

		if sectionsFileParser.sections:
			fileStructureParsingError = lambda attribute: foundations.exceptions.FileStructureParsingError(
			"{0} | No '{1}' attribute found, '{2}' file structure seems invalid!".format(
			self.__class__.__name__, attribute, self.__file))

			self.__directory = os.path.dirname(self.__file)
			self.__name = sectionsFileParser.getValue("Name", "Component", default=None)
			if self.__name is None:
				raise fileStructureParsingError("Name")

			self.__title = sectionsFileParser.getValue("Title", "Component", default=None)
			if self.__title is None:
				self.__title = self.__name

			self.__package = sectionsFileParser.getValue("Module", "Component", default=None)
			if self.__package is None:
				raise fileStructureParsingError("Module")

			self.__attribute = sectionsFileParser.getValue("Object", "Component", default=None)
			if self.__attribute is None:
				raise fileStructureParsingError("Object")

			self.__require = sectionsFileParser.getValue("Require", "Component", default=None)
			self.__require = list() if self.__require is None else self.__require.split("|")

			self.__version = sectionsFileParser.getValue("Version", "Component", default=None)
			if self.__version is None:
				raise fileStructureParsingError("Version")

			self.__author = sectionsFileParser.getValue("Author", "Informations", default=None)

			self.__email = sectionsFileParser.getValue("Email", "Informations", default=None)

			self.__url = sectionsFileParser.getValue("Url", "Informations", default=None)

			self.__description = sectionsFileParser.getValue("Description", "Informations", default=None)

			return True
		else:
			raise foundations.exceptions.FileStructureParsingError(
			"{0} | No sections found, '{1}' file structure seems invalid!".format(self.__class__.__name__, self.__file))

class Manager(object):
	"""
	| This class defines methods to manage Components, allowing Components registration / unregistration,
		instantiation and reloading.
	| The Components can be registered in mass by providing paths that are recursively walk for candidates
		or simply by calling the registration method on a given Component file.
	| When a Component is registered, a Profile ( Stored using the :class:`Profile` class ) is built and associated to it,
		 this Profile object contains the Component Interface and various description attributes. 
	"""

	def __init__(self,
				paths=None,
				extension="rc",
				categories={"Default" : Component, "QWidget" : QWidgetComponentFactory(), "QObject" : QObjectComponent}):
		"""
		This method initializes the class.

		Usage::

			>>> manager = Manager(("./manager/tests/testsManager/resources/components/core",))
			>>> manager.registerComponents()
			True
			>>> manager.listComponents()
			['core.testsComponentA', 'core.testsComponentB']
			>>> manager.instantiateComponents()
			True
			>>> manager.getInterface("core.testsComponentA")
			<testsComponentA.TestsComponentA object at 0x11dd990>

		:param paths: Paths to walk. ( Tuple / List )
		:param extension: Components file extension. ( String )
		:param categories: Components categories. ( Dictionary )
		"""

		LOGGER.debug("> Initializing '{0}()' class.".format(self.__class__.__name__))

		# --- Setting class attributes. ---
		self.__paths = None
		self.paths = paths
		self.__extension = None
		self.extension = extension
		self.__categories = None
		self.categories = categories
		self.__components = Components()

	#******************************************************************************************************************
	#***	Attributes properties.
	#******************************************************************************************************************
	@property
	def paths(self):
		"""
		This method is the property for **self.__paths** attribute.

		:return: self.__paths. ( Tuple / List )
		"""

		return self.__paths

	@paths.setter
	@foundations.exceptions.handleExceptions(AssertionError)
	def paths(self, value):
		"""
		This method is the setter method for **self.__paths** attribute.

		:param value: Attribute value. ( Tuple / List )
		"""

		if value is not None:
			assert type(value) in (tuple, list), "'{0}' attribute: '{1}' type is not 'tuple' or 'list'!".format(
			"paths", value)
			for path in value:
				assert type(path) in (str, unicode), "'{0}' attribute: '{1}' type is not 'str' or 'unicode'!".format(
				"paths", path)
				assert os.path.exists(path), "'{0}' attribute: '{1}' directory doesn't exists!".format("paths", path)
		self.__paths = value

	@paths.deleter
	@foundations.exceptions.handleExceptions(foundations.exceptions.ProgrammingError)
	def paths(self):
		"""
		This method is the deleter method for **self.__paths** attribute.
		"""

		raise foundations.exceptions.ProgrammingError(
		"{0} | '{1}' attribute is not deletable!".format(self.__class__.__name__, "paths"))

	@property
	def extension(self):
		"""
		This method is the property for **self.__extension** attribute.

		:return: self.__extension. ( String )
		"""

		return self.__extension

	@extension.setter
	@foundations.exceptions.handleExceptions(AssertionError)
	def extension(self, value):
		"""
		This method is the setter method for **self.__extension** attribute.

		:param value: Attribute value. ( String )
		"""

		if value is not None:
			assert type(value) in (str, unicode), "'{0}' attribute: '{1}' type is not 'str' or 'unicode'!".format(
			"extension", value)
		self.__extension = value

	@extension.deleter
	@foundations.exceptions.handleExceptions(foundations.exceptions.ProgrammingError)
	def extension(self):
		"""
		This method is the deleter method for **self.__extension** attribute.
		"""

		raise foundations.exceptions.ProgrammingError(
		"{0} | '{1}' attribute is not deletable!".format(self.__class__.__name__, "extension"))

	@property
	def categories(self):
		"""
		This method is the property for **self.__categories** attribute.

		:return: self.__categories. ( Dictionary )
		"""

		return self.__categories

	@categories.setter
	@foundations.exceptions.handleExceptions(AssertionError)
	def categories(self, value):
		"""
		This method is the setter method for **self.__categories** attribute.

		:param value: Attribute value. ( Dictionary )
		"""

		if value is not None:
			assert type(value) is dict, "'{0}' attribute: '{1}' type is not 'dict'!".format("categories", value)
			for key in value:
				assert type(key) in (str, unicode), "'{0}' attribute: '{1}' type is not 'str' or 'unicode'!".format(
				"categories", key)
		self.__categories = value

	@categories.deleter
	@foundations.exceptions.handleExceptions(foundations.exceptions.ProgrammingError)
	def categories(self):
		"""
		This method is the deleter method for **self.__categories** attribute.
		"""

		raise foundations.exceptions.ProgrammingError(
		"{0} | '{1}' attribute is not deletable!".format(self.__class__.__name__, "categories"))

	@property
	def components(self):
		"""
		This method is the property for **self.__components** attribute.

		:return: self.__components. ( Dictionary )
		"""

		return self.__components

	@components.setter
	@foundations.exceptions.handleExceptions(foundations.exceptions.ProgrammingError)
	def components(self, value):
		"""
		This method is the setter method for **self.__components** attribute.

		:param value: Attribute value. ( Dictionary )
		"""

		raise foundations.exceptions.ProgrammingError(
		"{0} | '{1}' attribute is read only!".format(self.__class__.__name__, "components"))

	@components.deleter
	@foundations.exceptions.handleExceptions(foundations.exceptions.ProgrammingError)
	def components(self):
		"""
		This method is the deleter method for **self.__components** attribute.
		"""

		raise foundations.exceptions.ProgrammingError(
		"{0} | '{1}' attribute is not deletable!".format(self.__class__.__name__, "components"))

	#******************************************************************************************************************
	#***	Class methods.
	#******************************************************************************************************************
	def __getitem__(self, component):
		"""
		This method reimplements the :meth:`object.__getitem__` method.

		Usage::

			>>> manager = Manager(("./manager/tests/testsManager/resources/components/core",))
			>>> manager.registerComponents()
			True
			>>> manager["core.testsComponentA"]
			<manager.componentsManager.Profile object at 0x101c4bd50>
		
		:param component: Component name. ( String )
		:return: Component profile. ( Profile )
		"""

		return self.__components.__getitem__(component).interface

	def __iter__(self):
		"""
		This method reimplements the :meth:`object.__iter__` method.

		Usage::

			>>> manager = Manager(("./manager/tests/testsManager/resources/components/core",))
			>>> manager.registerComponents()
			True
			>>> for name, profile in manager:
			...	print(name)
			...
			core.testsComponentB
			core.testsComponentA
		
		:return: Components iterator. ( Object )
		"""

		return self.__components.iteritems()

	def __contains__(self, component):
		"""
		This method reimplements the :meth:`object.__contains__` method.

		Usage::

			>>> manager = Manager(("./manager/tests/testsManager/resources/components/core",))
			>>> manager.registerComponents()
			True
			>>> "core.testsComponentA" in manager
			True
			>>> "core.nemoComponent" in manager
			False
		
		:param component: Component name. ( String )
		:return: Component existence. ( Boolean )
		"""

		return component in self.__components.keys()

	def __len__(self):
		"""
		This method reimplements the :meth:`object.__len__` method.

		Usage::

			>>> manager = Manager(("./manager/tests/testsManager/resources/components/core",))
			>>> manager.registerComponents()
			True
			>>> len(manager)
			2
		
		:return: Components count. ( Integer )
		"""

		return len(self.__components.keys())

	@foundations.exceptions.handleExceptions(manager.exceptions.ComponentModuleError,
											manager.exceptions.ComponentProfileError)
	def registerComponent(self, path):
		"""
		This method registers a Component using given path.

		Usage::

			>>> manager = Manager()
			>>> manager.registerComponent("testsComponentA.rc")
			True
			>>> manager.components
			{'core.testsComponentA': <manager.componentsManager.Profile object at 0x11c9eb0>}

		:param path: Component path. ( String )
		:return: Method success. ( Boolean )
		"""

		component = foundations.strings.getSplitextBasename(path)
		LOGGER.debug("> Current Component: '{0}'.".format(component))
		profile = Profile(file=path)
		if profile.initializeProfile():
			if os.path.isfile(os.path.join(profile.directory, profile.package) + ".py") or \
			os.path.isdir(os.path.join(profile.directory, profile.package)) or \
			os.path.basename(profile.directory) == profile.package:
				self.__components[profile.name] = profile
				return True
			else:
				raise manager.exceptions.ComponentModuleError(
				"{0} | '{1}' has no associated module and has been rejected!".format(self.__class__.__name__, component))
		else:
			raise manager.exceptions.ComponentProfileError(
			"{0} | '{1}' is not a valid Component and has been rejected!".format(self.__class__.__name__, component))

	def unregisterComponent(self, component):
		"""
		This method unregisters given Component.

		.. warning::

			The :class:`Manager` class is not responsible of any deactivation / cleanup actions
			and will not trigger anything while unregistering a Component.
	
		Usage::

			>>> manager = Manager()
			>>> manager.registerComponent("testsComponentA.rc")
			True
			>>> manager.unregisterComponent("core.testsComponentA")
			True
			>>> manager.components
			{}

		:param component: Component to remove. ( String )
		:return: Method success. ( Boolean )
		"""

		del(self.__components[component])
		return True

	@foundations.exceptions.handleExceptions(manager.exceptions.ComponentRegistrationError)
	def registerComponents(self):
		"""
		This method registers the Components.

		Usage::

			>>> manager = Manager(("./manager/tests/testsManager/resources/components/core",))
			>>> manager.registerComponents()
			True
			>>> manager.components.keys()
			['core.testsComponentA', 'core.testsComponentB']
		
		:return: Method success. ( Boolean )
		"""

		unregisteredComponents = []
		for path in self.paths:
			for file in foundations.walkers.filesWalker(path, ("\.{0}$".format(self.__extension),), ("\._",)):
				if not self.registerComponent(file):
					unregisteredComponents.append(file)

		if not unregisteredComponents:
			return True
		else:
			raise manager.exceptions.ComponentRegistrationError(
			"{0} | '{1}' Components failed to register!".format(self.__class__.__name__,
																", ".join(unregisteredComponents)))

	def unregisterComponents(self):
		"""
		This method unregisters the Components.

		.. warning::

			The :class:`Manager` class is not responsible of any deactivation / cleanup actions
			and will not trigger anything while unregistering a Component.
	
		Usage::

			>>> manager = Manager(("./manager/tests/testsManager/resources/components/core",))
			>>> manager.registerComponents()
			True
			>>> manager.unregisterComponents()
			True
			>>> manager.components
			{}

		:return: Method success. ( Boolean )
		"""

		self.__components.clear()
		return True

	@foundations.exceptions.handleExceptions(manager.exceptions.ComponentInterfaceError)
	def instantiateComponent(self, component, callback=None):
		"""
		This method instantiates given Component.

		Usage::

			>>> manager = Manager()
			>>> manager.registerComponent("testsComponentA.rc")
			True
			>>> manager.instantiateComponent("core.testsComponentA")
			True
			>>> manager.getInterface("core.testsComponentA")
			<testsComponentA.TestsComponentA object at 0x17a5b90>

		:param component: Component to instantiate. ( String )
		:param callback: Callback object. ( Object )
		"""

		profile = self.__components[component]
		callback and callback(profile)

		LOGGER.debug("> Current Component: '{0}'.".format(component))

		if os.path.isfile(os.path.join(profile.directory, profile.package) + ".py") or \
		os.path.isdir(os.path.join(profile.directory, profile.package)):
			path = profile.directory
		elif os.path.basename(profile.directory) == profile.package:
			path = os.path.join(profile.directory, "..")
		not path in sys.path and sys.path.append(path)

		profile.module = __import__(profile.package)
		object = profile.attribute in profile.module.__dict__ and getattr(profile.module, profile.attribute) or None
		if object and inspect.isclass(object):
			instance = object(name=profile.name)
			for category, type in self.__categories.iteritems():
				if type.__name__ in (base.__name__ for base in object.__bases__):
					profile.category = category
					profile.interface = instance
					LOGGER.info("{0} | '{1}' Component has been instantiated!".format(self.__class__.__name__, profile.name))
					return True
		else:
			del(self.__components[component])
			raise manager.exceptions.ComponentInterfaceError(
			"{0} | '{1}' Component has no Interface and has been rejected!".format(self.__class__.__name__, profile.name))

	def instantiateComponents(self, callback=None):
		"""
		This method instantiates the Components.

		Usage::

			>>> manager = Manager(("./manager/tests/testsManager/resources/components/core",))
			>>> manager.registerComponents()
			True
			>>> manager.instantiateComponents()
			True
			>>> manager.getInterface("core.testsComponentA")
			<testsComponentA.TestsComponentA object at 0x17a5bb0>

		:param callback: Callback object. ( Object )
		"""

		uninstantiatedComponents = [component
									for component in self.listComponents()
									if not self.instantiateComponent(component, callback)]
		if not uninstantiatedComponents:
			return True
		else:
			raise manager.exceptions.ComponentInstantiationError(
			"{0} | '{1}' Components failed to instantiate!".format(self.__class__.__name__,
																	", ".join(uninstantiatedComponents)))

	def reloadComponent(self, component):
		"""
		This method reload given Component module.

		Usage::

			>>> manager = Manager()
			>>> manager.registerComponent("testsComponentA.rc")
			True
			>>> manager.instantiateComponent("core.testsComponentA")
			True
			>>> manager.getInterface("core.testsComponentA")
			<testsComponentA.TestsComponentA object at 0x17b4890>
			>>> manager.reloadComponent("core.testsComponentA")
			True
			>>> manager.getInterface("core.testsComponentA")
			<testsComponentA.TestsComponentA object at 0x17b0d70>

		:param component: Component name. ( String )
		:return: Reload success. ( Boolean )
		"""

		dependents = list(reversed(self.listDependents(component)))
		dependents.append(component)

		for dependent in dependents:
			profile = self.__components[dependent]
			module = __import__(profile.package)
			reload(module)
			object = profile.attribute in dir(module) and getattr(module, profile.attribute) or None
			if object and inspect.isclass(object):
				for type in self.__categories.itervalues():
					if type.__name__ in (base.__name__ for base in object.__bases__):
						instance = object(name=profile.name)
						profile.module = module
						profile.interface = instance
						LOGGER.info("{0} | '{1}' Component has been reloaded!".format(self.__class__.__name__, profile.name))
		return True

	def listComponents(self, dependencyOrder=True):
		"""
		This method lists the Components by dependency resolving.

		Usage::

			>>> manager = Manager(("./manager/tests/testsManager/resources/components/core",))
			>>> manager.registerComponents()
			True
			>>> manager.listComponents()
			['core.testsComponentA', 'core.testsComponentB']

		:param dependencyOrder: Components are returned by dependency order. ( Boolean )
		"""

		if dependencyOrder:
			return list(itertools.chain.from_iterable([sorted(list(batch)) for batch in
			foundations.common.dependencyResolver(dict((key, value.require) for (key, value) in self))]))
		else:
			return [key for (key, value) in self]

	def listDependents(self, component, dependents=None):
		"""
		This method lists given Component dependents Components.

		Usage::

			>>> manager = Manager(("./manager/tests/testsManager/resources/components/core",))
			>>> manager.registerComponents()
			True
			>>> manager.listDependents("core.testsComponentA")
			['core.testsComponentB']

		:param component: Component to retrieve the dependents Components. ( String )
		:param dependents: Component dependents Components. ( Set )
		:return: Dependent Components. ( List )
		"""

		dependents = set() if dependents is None else dependents
		for name, profile in self:
			if not component in profile.require:
				continue

			dependents.add(name)
			self.listDependents(name, dependents)

		return sorted(list(dependents), key=(self.listComponents()).index)

	def filterComponents(self, pattern, category=None):
		"""
		This method filters the Components using given regex pattern.

		Usage::

			>>> manager = Manager(("./manager/tests/testsManager/resources/components/core",))
			>>> manager.registerComponents()
			True
			>>> manager.filterComponents("\w+A$")
			['core.testsComponentA']

		:param pattern: Regex filtering pattern. ( String )
		:param category: Category filter. ( String )
		:return: Matching Components. ( List )
		"""

		matchingItems = []
		for component, profile in self:
			if category:
				if profile.category != category:
					continue

			if re.search(pattern, component):
				matchingItems.append(component)
		return matchingItems

	def getProfile(self, component):
		"""
		This method gets given Component profile.

		Usage::

			>>> manager = Manager()
			>>> manager.registerComponent("testsComponentA.rc")
			True
			>>> manager.getProfile("core.testsComponentA")
			<manager.componentsManager.Profile object at 0x10258ef10>

		:param component: Component to get the profile. ( String )
		:return: Component profile. ( Profile )
		"""

		components = self.filterComponents(r"^{0}$".format(component))
		if components != []:
			return self.__components[foundations.common.getFirstItem(components)]

	def getInterface(self, component):
		"""
		This method gets given Component interface.

		Usage::

			>>> manager = Manager()
			>>> manager.registerComponent("testsComponentA.rc")
			True
			>>> manager.getInterface("core.testsComponentA")
			<testsComponentA.TestsComponentA object at 0x17b0d70>

		:param component: Component to get the interface. ( String )
		:return: Component interface. ( Object )
		"""

		profile = self.getProfile(component)
		if profile:
			return profile.interface

	@staticmethod
	def getComponentAttributeName(component):
		"""
		This method gets given Component attribute name.

		Usage::

			>>> Manager.getComponentAttributeName("factory.componentsManagerUi")
			'factoryComponentsManagerUi'

		:param component: Component to get the attribute name. ( String )
		:return: Component attribute name. ( Object )
		"""

		search = re.search(r"(?P<category>\w+)\.(?P<name>\w+)", component)
		if search:
			name = "{0}{1}{2}".format(search.group("category"), search.group("name")[0].upper(), search.group("name")[1:])
			LOGGER.debug("> Component name: '{0}' to attribute name Active_QLabel: '{1}'.".format(component, name))
		else:
			name = component
		return name
