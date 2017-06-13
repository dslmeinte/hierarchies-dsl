# Hierarchies DSL

Intention:

* A DSL for defining type hierarchies in a TypeScript setting, from which valid TypeScript (and also e.g. JSON Schema) is generated which can be used immediately.
* A projectional editor for writing DSL prose which can be run as a plugin in Visual Studio Code (or alternatively: Electron, Theia).


Note:

* DSL prose is stored in JSON format.
* Assume each DSL JSON file "is its own universe", together with what's available as direct TypeScript types.
* We might want to have postfix opt-in *per sub type*.
* It might not be the best idea to define completely hierarchies inclusively.
    Maybe work from inheritance instead, and have flags to infer tags and values.
* Generics are ultimately desired (but not at first)...

