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

	def definitionFile(Hierarchy hierarchy) {
		EcoreUtil2.getContainerOfType(hierarchy, DefinitionFile)
	}

	def discriminatorPropertyName(Hierarchy it) {
		'''«name.toFirstLower»Type'''
	}

	def discriminatorTypeName(Hierarchy it) {
		'''«name.toFirstUpper»Type'''		
	}

	def typeName(Hierarchy it) {
		name.toFirstUpper
	}

	def requiresBaseType(Hierarchy it) {
		!(baseProperties.empty && noBaseType)
	}


	def hierarchy(SubType it) {
		eContainer as Hierarchy
	}

	def postfixedName(SubType it) {
		name.toFirstUpper + if (hierarchy.asPostfix) hierarchy.name.toFirstUpper else ""
	}

	def discriminatorPropertyValue(SubType it) {
		name.toFirstLower
	}


	def postfixedName(ReferableType it) {
		switch it {
			Hierarchy: name.toFirstUpper
			SubType: postfixedName
		}		
	}


	private def referencedHierarchies(DefinitionFile thisFile) {
		EcoreUtil2
			.eAllOfType(thisFile, ReferableTypeReference)
			.map[referableType]
			.filter(Hierarchy)
	}

	def referencedExternalHierarchies(DefinitionFile thisFile) {
		thisFile.referencedHierarchies
			.filter[eResource !== thisFile.eResource]
	}

}
