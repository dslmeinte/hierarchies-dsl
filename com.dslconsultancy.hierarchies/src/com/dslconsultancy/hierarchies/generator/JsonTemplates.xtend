package com.dslconsultancy.hierarchies.generator

import com.dslconsultancy.hierarchies.hierarchyDsl.DefinitionFile
import com.dslconsultancy.hierarchies.hierarchyDsl.Hierarchy
import com.dslconsultancy.hierarchies.hierarchyDsl.MapType
import com.dslconsultancy.hierarchies.hierarchyDsl.PrimitiveType
import com.dslconsultancy.hierarchies.hierarchyDsl.Property
import com.dslconsultancy.hierarchies.hierarchyDsl.ReferableTypeReference
import com.dslconsultancy.hierarchies.hierarchyDsl.SubType
import com.dslconsultancy.hierarchies.hierarchyDsl.Type
import com.fasterxml.jackson.databind.node.ObjectNode
import javax.inject.Inject

class JsonTemplates {

	@Inject
	extension JsonUtil

	def asJson(DefinitionFile it) {
		newObject
			.put("$schema", "http://www.dslconsultancy.com/hierarchies")
			.put("destinationPath", path)
			.set("hierarchies", newArray.addAll(hierarchies.map[asJson]))
	}

	private def asJson(Hierarchy it) {
		newObject
			.put("name", name)
			.put("asPostfix", asPostfix) => [ o |
				o.set("baseProperties", newArray.addAll(baseProperties.map[asJson]));
				o.set("subTypes", newArray.addAll(subTypes.map[asJson]))
			]
	}

	private def asJson(SubType it) {
		((newObject
			.put("name", name)
			.put("abstract", abstract)) => [ json |
				if (superType !== null) {
					json.put("superType", superType.name)
				}
			])
			.set("properties", newArray.addAll(properties.map[asJson]))
	}

	private def asJson(Property it) {
		newObject
			.put("name", name)
			.set("type", type.asJson)
	}

	private def ObjectNode asJson(Type it) {
		(newObject
			.put("$type", eClass.name)) => [ json |
				switch it {
					PrimitiveType: json.put("primitiveType", primitiveType.literal)
					ReferableTypeReference: json.put("typeReference", referableType.name).put("asPartial", asPartial)
					MapType: json.put("keyName", keyName).set("valueType", valueType.asJson)
				}
			]
	}

}
