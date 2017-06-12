package com.dslconsultancy.hierarchies.generator

import com.dslconsultancy.hierarchies.hierarchyDsl.DefinitionFile
import javax.inject.Inject
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.AbstractGenerator
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext

class HierarchyDslGenerator extends AbstractGenerator {

	override void doGenerate(Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
		resource.allContents.filter(DefinitionFile).forEach[
			fsa.generateFile(path + ".ts", asTypeScript.toString.replace("\t", "    "))
		]
	}


	@Inject
	extension TypeScriptTemplates

}
