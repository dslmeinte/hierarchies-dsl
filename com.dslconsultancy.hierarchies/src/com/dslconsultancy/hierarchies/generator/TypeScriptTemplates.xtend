package com.dslconsultancy.hierarchies.generator

import com.dslconsultancy.hierarchies.hierarchyDsl.DefinitionFile
import com.dslconsultancy.hierarchies.hierarchyDsl.Hierarchy
import com.dslconsultancy.hierarchies.hierarchyDsl.MapType
import com.dslconsultancy.hierarchies.hierarchyDsl.PrimitiveType
import com.dslconsultancy.hierarchies.hierarchyDsl.PrimitiveTypes
import com.dslconsultancy.hierarchies.hierarchyDsl.Property
import com.dslconsultancy.hierarchies.hierarchyDsl.ReferableTypeReference
import com.dslconsultancy.hierarchies.hierarchyDsl.SubType
import com.dslconsultancy.hierarchies.hierarchyDsl.Type
import javax.inject.Inject

class TypeScriptTemplates {

	@Inject
	extension HierarchyExtensions


	def asTypeScript(DefinitionFile it)
		'''
		// (generated by Hierarchy DSL)

		«FOR externalHierarchy : referencedExternalHierarchies»
			import {«externalHierarchy.postfixedName»} from "./«externalHierarchy.definitionFile.path»";
		«ENDFOR»

		«FOR it : hierarchies»
			«asTypeScript»

		«ENDFOR»

		'''


	private def asTypeScript(Hierarchy it) {
		val concreteSubs = concreteSubTypes.sortBy[name]

		'''
		export type «discriminatorTypeName» = «concreteSubs.map['''"«discriminatorPropertyValue»"'''].join("\n\t| ")»;

		export type «typeName» = «concreteSubs.map['''I«postfixedName»'''].join("\n\t| ")»;

		export /* abstract */ interface I«typeName» {
			«discriminatorPropertyName»: «discriminatorTypeName»;
			«FOR property : baseProperties»
				«property.asTypeScript»
			«ENDFOR»
		}

		«FOR it : subTypes.sortBy[name]»
			«asTypeScript»

		«ENDFOR»
		'''
	}


	private def asTypeScript(SubType it)
		'''
		export «IF abstract»/* abstract */ «ENDIF»interface I«postfixedName» extends I«IF superType === null»«hierarchy.typeName»«ELSE»«superType.postfixedName»«ENDIF» {
			«IF !abstract»
				«hierarchy.discriminatorPropertyName»: "«discriminatorPropertyValue»";
			«ENDIF»
			«FOR property : properties»
				«property.asTypeScript»
			«ENDFOR»
		}
		'''


	private def asTypeScript(Property it)
		'''
		«name»«IF optional»?«ENDIF»: «type.asTypeScript»;
		'''


	private def CharSequence asTypeScript(Type it) {
		switch it {
			PrimitiveType: switch primitiveType {
				case PrimitiveTypes.DATE: "Date"
				default: primitiveType.literal
			}
			ReferableTypeReference: {
				val typeExpr = (if (referableType instanceof SubType) "I" else "") + referableType.postfixedName
				if (asPartial) '''Partial<«typeExpr»>''' else typeExpr
			}
			MapType: '''{ [«keyName»: string]: «valueType.asTypeScript» }'''
		}
	}

}
