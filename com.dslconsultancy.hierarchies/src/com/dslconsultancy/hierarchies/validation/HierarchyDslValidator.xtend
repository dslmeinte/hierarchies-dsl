package com.dslconsultancy.hierarchies.validation

import com.dslconsultancy.hierarchies.hierarchyDsl.Hierarchy
import com.dslconsultancy.hierarchies.hierarchyDsl.HierarchyDslPackage
import org.eclipse.xtext.validation.Check

class HierarchyDslValidator extends AbstractHierarchyDslValidator {
	
	@Check
	def checkReferableTypeStartsWithCapital(Hierarchy it) {
		if (!Character.isUpperCase(name.charAt(0))) {
			warning('The name of a hierarchy should start with a capital', HierarchyDslPackage.Literals.REFERABLE_TYPE__NAME)
		}
	}	

	@Check
	def checkHierarchyWithBasePropertiesHasBaseType(Hierarchy it) {
		if (!baseProperties.empty && noBaseType) {
			error('A hierarchy with base properties cannot have the "no-base-type" flag', HierarchyDslPackage.Literals.HIERARCHY__NO_BASE_TYPE)
		}
	}

}
