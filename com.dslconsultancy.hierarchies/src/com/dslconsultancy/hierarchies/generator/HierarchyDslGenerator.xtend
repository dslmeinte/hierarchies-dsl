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
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.AbstractGenerator
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext

class HierarchyDslGenerator extends AbstractGenerator {

	override void doGenerate(Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
		resource.allContents.filter(DefinitionFile).forEach[ fsa.generateFile(path + ".ts", generateTypeScript) ]
	}


	@Inject
	extension HierarchyExtensions


	private def generateTypeScript(DefinitionFile it)
	'''
	// (generated by Hierarchy DSL)

	«FOR externalHierarchy : referencedExternalHierarchies»
		import {«externalHierarchy.postfixedName»} from "./«externalHierarchy.definitionFile.path»";
	«ENDFOR»

	«FOR it : hierarchies»

		«generateTypeScript»

	«ENDFOR»

	'''

	private def generateTypeScript(Hierarchy it)
	'''
	export type «name.toFirstUpper»Type = «concreteSubTypes.map['''"«name.toFirstLower»"'''].join(" | ")»;

	export type «name.toFirstUpper» = «concreteSubTypes.map['''I«postfixedName»'''].join(" | ")»;

	export /* abstract */ interface I«name.toFirstUpper» {
		«name.toFirstLower»Type: «name.toFirstUpper»Type;
		«FOR property : baseProperties»
			«property.generateTypeScript»
		«ENDFOR»
	}

	«FOR it : subTypes»
		«generateTypeScript»

	«ENDFOR»
	'''

	private def generateTypeScript(SubType it)
	'''
	export «IF abstract»/* abstract */ «ENDIF»interface I«postfixedName» extends I«IF superType === null»«hierarchy.name.toFirstUpper»«ELSE»«superType.postfixedName»«ENDIF» {
		«IF !abstract»
			«name.toFirstLower»Type: "«name.toFirstLower»";
		«ENDIF»
		«FOR property : properties»
			«property.generateTypeScript»
		«ENDFOR»
	}
	'''

	private def generateTypeScript(Property it)
	'''
	«name»: «type.generateTypeScript»;
	'''

	private def CharSequence generateTypeScript(Type it) {
		switch it {
			PrimitiveType: switch primitiveType {
				case PrimitiveTypes.DATE: "Date"
				default: primitiveType.literal
			}
			ReferableTypeReference: {
				val typeExpr = (if (referableType instanceof SubType) "I" else "") + referableType.postfixedName
				if (asPartial) '''Partial<«typeExpr»>''' else typeExpr
			}
			MapType: '''{ [«keyName»: string]: «valueType.generateTypeScript» }'''
		}
	}

}
