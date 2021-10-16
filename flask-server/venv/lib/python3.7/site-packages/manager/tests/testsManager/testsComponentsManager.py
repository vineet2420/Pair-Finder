#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
**testsManager.py**

**Platform:**
	Windows, Linux, Mac Os X.

**Description:**
	This module defines units tests for :mod:`manager.componentsManager` module.

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

#**********************************************************************************************************************
#***	Internal imports.
#**********************************************************************************************************************
from manager.component import Component
from manager.componentsManager import Manager
from manager.componentsManager import Profile

#**********************************************************************************************************************
#***	Module attributes.
#**********************************************************************************************************************
__author__ = "Thomas Mansencal"
__copyright__ = "Copyright (C) 2008 - 2012 - Thomas Mansencal"
__license__ = "GPL V3.0 - http://www.gnu.org/licenses/"
__maintainer__ = "Thomas Mansencal"
__email__ = "thomas.mansencal@gmail.com"
__status__ = "Production"

__all__ = ["RESOURCES_DIRECTORY",
			"SINGLE_COMPONENT",
			"COMPONENTS_DIRECTORY",
			"COMPONENTS",
			"COMPONENTS_NAMES",
			"COMPONENTS_DEPENDENCY_ORDER",
			"STANDARD_PROFILE_CONTENT",
			"managerCallback",
			"ProfileTestCase",
			"ManagerTestCase"]

RESOURCES_DIRECTORY = os.path.join(os.path.dirname(__file__), "resources")
SINGLE_COMPONENT = ("core.testsComponentA", os.path.join(os.path.dirname(__file__),
					"resources/components/core/testsComponentA/testsComponentA.rc"), Component)
COMPONENTS_DIRECTORY = os.path.join(RESOURCES_DIRECTORY, "components")
ALTERNATIVE_COMPONENTS_DIRECTORY = os.path.join(COMPONENTS_DIRECTORY, "extras", "addons")
COMPONENTS = {"core" : {"testsComponentA" : "core/testsComponentA",
					"testsComponentB" : "core/testsComponentB"},
			"addons" : {"testsComponentC" : "core/testsComponentC",
					"testsComponentD" : "core/testsComponentD"}}
COMPONENTS_NAMES = COMPONENTS_DEPENDENCY_ORDER = ["core.testsComponentA",
										"core.testsComponentB",
										"addons.testsComponentC",
										"addons.testsComponentD"]
COMPONENTS_DEPENDENTS = {"core.testsComponentA" : ["core.testsComponentB",
												"addons.testsComponentC",
												"addons.testsComponentD"],
						"core.testsComponentB" : ["addons.testsComponentC",
												"addons.testsComponentD"],
						"addons.testsComponentC" : ["addons.testsComponentD"],
						"addons.testsComponentD" :  []}
STANDARD_PROFILE_CONTENT = {"name" : "core.testsComponentA",
							"file" : os.path.join(COMPONENTS_DIRECTORY, COMPONENTS["core"]["testsComponentA"],
									"testsComponentA.rc"),
							"directory":os.path.join(COMPONENTS_DIRECTORY, COMPONENTS["core"]["testsComponentA"]),
							"title" : "Tests Component A",
							"package" : "testsComponentA",
							"attribute" : "TestsComponentA",
							"require" : [],
							"version" : "1.0",
							"author" : "Thomas Mansencal",
							"email" : "thomas.mansencal@gmail.com",
							"url" : "http://www.hdrlabs.com/",
							"description" : "Core tests Component A."}

#**********************************************************************************************************************
#***	Module classes and definitions.
#**********************************************************************************************************************
def managerCallback(profile):
	"""
	This definition provides :class:`manager.componentsManager.Manager` class test callback.
	"""

	profile.callback = True

class ProfileTestCase(unittest.TestCase):
	"""
	This class defines :class:`manager.componentsManager.Profile` class units tests methods.
	"""

	def testRequiredAttributes(self):
		"""
		This method tests presence of required attributes.
		"""

		requiredAttributes = ("name",
							"file",
							"directory",
							"attribute",
							"require",
							"module",
							"interface",
							"category",
							"title",
							"package",
							"version",
							"author",
							"email",
							"url",
							"description")

		for attribute in requiredAttributes:
			self.assertIn(attribute, dir(Profile))

	def testRequiredMethods(self):
		"""
		This method tests presence of required methods.
		"""

		requiredMethods = ("initializeProfile",)

		for method in requiredMethods:
			self.assertIn(method, dir(Profile))

	def testInitializeProfile(self):
		"""
		This method tests :meth:`manager.componentsManager.Profile.initializeProfile` method.
		"""

		profile = Profile(file=STANDARD_PROFILE_CONTENT["file"])
		self.assertTrue(profile.initializeProfile())
		for attribute, value in STANDARD_PROFILE_CONTENT.iteritems():
			self.assertIsInstance(getattr(profile, attribute), type(value))
			self.assertEqual(getattr(profile, attribute), value)

class ManagerTestCase(unittest.TestCase):
	"""
	This class defines :class:`manager.componentsManager.Manager` class units tests methods.
	"""

	def testRequiredAttributes(self):
		"""
		This method tests presence of required attributes.
		"""

		requiredAttributes = ("paths",
							"extension",
							"categories",
							"components",)

		for attribute in requiredAttributes:
			self.assertIn(attribute, dir(Manager))

	def testRequiredMethods(self):
		"""
		This method tests presence of required methods.
		"""

		requiredMethods = ("__getitem__",
						"__iter__",
						"__contains__",
						"__len__",
						"registerComponents",
						"unregisterComponent",
						"registerComponents",
						"unregisterComponents",
						"instantiateComponent",
						"instantiateComponents",
						"reloadComponent",
						"listComponents",
						"listDependents",
						"filterComponents",
						"getProfile",
						"getInterface",
						"getComponentAttributeName")

		for method in requiredMethods:
			self.assertIn(method, dir(Manager))

	def test__getitem__(self):
		"""
		This method tests :meth:`manager.componentsManager.Manager.__getitem__` method.
		"""

		manager = Manager([os.path.join(COMPONENTS_DIRECTORY, item) for item in COMPONENTS])
		manager.registerComponents()
		manager.instantiateComponents()
		for name, profile in manager:
			self.assertIsInstance(manager[name], Component)

	def test__iter__(self):
		"""
		This method tests :meth:`manager.componentsManager.Manager.__iter__` method.
		"""

		componentsPaths = [os.path.join(COMPONENTS_DIRECTORY, item) for item in COMPONENTS]
		componentsPaths.append(ALTERNATIVE_COMPONENTS_DIRECTORY)
		manager = Manager(componentsPaths)
		manager.registerComponents()
		for name, profile in manager:
			self.assertIn(name, COMPONENTS_NAMES)
			self.assertIsInstance(profile, Profile)

	def test__contains__(self):
		"""
		This method tests :meth:`manager.componentsManager.Manager.__contains__` method.
		"""

		componentsPaths = [os.path.join(COMPONENTS_DIRECTORY, item) for item in COMPONENTS]
		componentsPaths.append(ALTERNATIVE_COMPONENTS_DIRECTORY)
		manager = Manager(componentsPaths)
		manager.registerComponents()
		for component in COMPONENTS_NAMES:
			self.assertIn(component, manager)

	def test__len__(self):
		"""
		This method tests :meth:`manager.componentsManager.Manager.__len__` method.
		"""

		manager = Manager([os.path.join(COMPONENTS_DIRECTORY, item) for item in COMPONENTS])
		manager.registerComponents()
		self.assertEqual(3, len(manager))

	def testRegisterComponent(self):
		"""
		This method tests :meth:`manager.componentsManager.Manager.registerComponent` method.
		"""

		manager = Manager()
		self.assertTrue(manager.registerComponent(SINGLE_COMPONENT[1]))
		self.assertIn(SINGLE_COMPONENT[0], manager.components)

	def testUnregisterComponent(self):
		"""
		This method tests :meth:`manager.componentsManager.Manager.unregisterComponent` method.
		"""

		manager = Manager([os.path.join(COMPONENTS_DIRECTORY, item) for item in COMPONENTS])
		manager.registerComponents()
		manager.instantiateComponents()
		for component in dict(manager.components):
			self.assertTrue(manager.unregisterComponent(component))
		self.assertTrue(not manager.components)

	def testRegisterComponents(self):
		"""
		This method tests :meth:`manager.componentsManager.Manager.registerComponents` method.
		"""

		componentsPaths = [os.path.join(COMPONENTS_DIRECTORY, item) for item in COMPONENTS]
		componentsPaths.append(ALTERNATIVE_COMPONENTS_DIRECTORY)
		manager = Manager(componentsPaths)
		manager.registerComponents()
		self.assertIsInstance(manager.components, dict)
		for component in ("{0}.{1}".format(item, name) for item in COMPONENTS for name in COMPONENTS[item]):
			self.assertIn(component, manager.components)

	def testUnregisterComponents(self):
		"""
		This method tests :meth:`manager.componentsManager.Manager.unregisterComponents` method.
		"""

		manager = Manager([os.path.join(COMPONENTS_DIRECTORY, item) for item in COMPONENTS])
		manager.registerComponents()
		manager.instantiateComponents()
		manager.unregisterComponents()
		self.assertTrue(not manager.components)

	def testInstantiateComponent(self):
		"""
		This method tests :meth:`manager.componentsManager.Manager.instantiateComponent` method.
		"""

		manager = Manager()
		manager.registerComponent(SINGLE_COMPONENT[1])
		self.assertTrue(manager.instantiateComponent(SINGLE_COMPONENT[0], managerCallback))
		self.assertIsInstance(manager.components.values()[0].interface, SINGLE_COMPONENT[2])

	def testInstantiateComponents(self):
		"""
		This method tests :meth:`manager.componentsManager.Manager.instantiateComponents` method.
		"""

		manager = Manager([os.path.join(COMPONENTS_DIRECTORY, item) for item in COMPONENTS])
		manager.registerComponents()
		manager.instantiateComponents()
		for component in manager.components.itervalues():
			self.assertIsInstance(component.interface, Component)
		manager.unregisterComponents()
		manager.registerComponents()
		manager.instantiateComponents(managerCallback)
		for component in manager.components.itervalues():
			self.assertTrue(component.callback)

	def testReloadComponent(self):
		"""
		This method tests :meth:`manager.componentsManager.Manager.reloadComponent` method.
		"""

		manager = Manager([os.path.join(COMPONENTS_DIRECTORY, item) for item in COMPONENTS])
		manager.registerComponents()
		manager.instantiateComponents()
		for component in manager.components:
			manager.reloadComponent(component)

	def testListComponents(self):
		"""
		This method tests :meth:`manager.componentsManager.Manager.listComponents` method.
		"""

		componentsPaths = [os.path.join(COMPONENTS_DIRECTORY, item) for item in COMPONENTS]
		componentsPaths.append(ALTERNATIVE_COMPONENTS_DIRECTORY)
		manager = Manager(componentsPaths)
		manager.registerComponents()
		manager.instantiateComponents()
		components = manager.listComponents()
		self.assertIsInstance(components, list)
		self.assertListEqual(components, COMPONENTS_DEPENDENCY_ORDER)
		self.assertListEqual(sorted(manager.listComponents(dependencyOrder=False)), sorted(COMPONENTS_DEPENDENCY_ORDER))

	def testListDependents(self):
		"""
		This method tests :meth:`manager.componentsManager.Manager.listDependents` method.
		"""

		componentsPaths = [os.path.join(COMPONENTS_DIRECTORY, item) for item in COMPONENTS]
		componentsPaths.append(ALTERNATIVE_COMPONENTS_DIRECTORY)
		manager = Manager(componentsPaths)
		manager.registerComponents()
		manager.instantiateComponents()
		for name, profile in manager:
			self.assertListEqual(sorted(COMPONENTS_DEPENDENTS[name]), sorted(manager.listDependents(name)))

	def testFilterComponents(self):
		"""
		This method tests :meth:`manager.componentsManager.Manager.filterComponents` method.
		"""

		manager = Manager([os.path.join(COMPONENTS_DIRECTORY, item) for item in COMPONENTS])
		manager.registerComponents()
		manager.instantiateComponents()
		components = manager.filterComponents("addons")
		self.assertIsInstance(components, list)
		self.assertListEqual(components, ["addons.testsComponentC"])

	def testGetProfile(self):
		"""
		This method tests :meth:`manager.componentsManager.Manager.getProfile` method.
		"""

		manager = Manager([os.path.join(COMPONENTS_DIRECTORY, item) for item in COMPONENTS])
		manager.registerComponents()
		manager.instantiateComponents()
		for component in manager.components:
			self.assertIsInstance(manager.getProfile(component), Profile)

	def testGetInterface(self):
		"""
		This method tests :meth:`manager.componentsManager.Manager.getInterface` method.
		"""

		manager = Manager([os.path.join(COMPONENTS_DIRECTORY, item) for item in COMPONENTS])
		manager.registerComponents()
		manager.instantiateComponents()
		for component in manager.components:
			self.assertIsInstance(manager.getInterface(component), Component)

	def testGetComponentAttributeName(self):
		"""
		This method tests :meth:`manager.componentsManager.Manager.getComponentAttributeName` method.
		"""

		self.assertEquals(Manager.getComponentAttributeName("factory.componentsManagerUi"), "factoryComponentsManagerUi")
		self.assertEquals(Manager.getComponentAttributeName("addons.loggingNotifier"), "addonsLoggingNotifier")
		self.assertEquals(Manager.getComponentAttributeName("myComponent"), "myComponent")

if __name__ == "__main__":
	import manager.tests.utilities
	unittest.main()
