package com.dslconsultancy.hierarchies.generator

import com.fasterxml.jackson.databind.DeserializationFeature
import com.fasterxml.jackson.databind.JsonNode
import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.databind.SerializationFeature

class JsonUtil {

	ObjectMapper objectMapper = (new ObjectMapper).configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false)

	def newObject() {
		objectMapper.createObjectNode
	}

	def newArray() {
		objectMapper.createArrayNode
	}

	def prettyPrint(JsonNode json) {
		objectMapper.writer.with(SerializationFeature.INDENT_OUTPUT).writeValueAsString(json)
	}

}
