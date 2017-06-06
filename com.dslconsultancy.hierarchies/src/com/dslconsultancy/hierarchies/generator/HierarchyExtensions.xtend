package com.dslconsultancy.hierarchies.generator

import com.dslconsultancy.hierarchies.hierarchyDsl.DefinitionFile
import com.dslconsultancy.hierarchies.hierarchyDsl.Hierarchy
import com.dslconsultancy.hierarchies.hierarchyDsl.ReferableType
import com.dslconsultancy.hierarchies.hierarchyDsl.ReferableTypeReference
import com.dslconsultancy.hierarchies.hierarchyDsl.SubType
import org.eclipse.xtext.EcoreUtil2

class HierarchyExtensions {

	def concreteSubTypes(Hierarchy it) {
		subTypes.filter[!abstract]	
	}

	def hierarchy(SubType it) {
		eContainer as Hierarchy
	}

	def postfixedName(SubType it) {
		name.toFirstUpper + if (hierarchy.asPostfix) hierarchy.name.toFirstUpper else ""
	}

	def postfixedName(ReferableType it) {
		switch it {
			Hierarchy: name.toFirstUpper
			SubType: postfixedName
		}		
	}

	def referencedExternalHierarchies(DefinitionFile definitionFile) {
		EcoreUtil2
			.eAllOfType(definitionFile, ReferableTypeReference)
			.map[referableType]
			.filter(Hierarchy)
			.filter[eResource !== definitionFile.eResource]
	}

	def definitionFile(Hierarchy hierarchy) {
		EcoreUtil2.getContainerOfType(hierarchy, DefinitionFile)
	}

}
