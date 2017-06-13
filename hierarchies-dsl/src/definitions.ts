export interface IHierachyDefinitions {
    $schema: string;
    hierarchies: IHierarchy[];
}


export /* abstract */ interface INamed {
    name: string;
}


export interface IHierarchy extends INamed {
    path: string;
    asPostfix: boolean;
    baseProperties: IProperty[];
}


export interface ISubType extends INamed {
    superType: ISubType | null;
    properties: IProperty[];
}


export interface IProperty extends INamed {
    type: Type;
}



export type TypeType = "primitive" | "definedTypeReference" | "map" | "importedTypeReference" | "unknown";

export type Type = IPrimitiveType | IDefinedTypeReference | IMapType;

export /* abstract */ interface IType {
    typeType: TypeType;
}

export enum PrimitiveTypes {
    string, boolean, number, date
}

export interface IPrimitiveType extends IType {
    typeType: "primitive";
    primitiveType: PrimitiveTypes;
}

export interface IDefinedTypeReference extends IType {
    typeType: "definedTypeReference";
    nameOfReferredType: string;
    kindOfReferredType: "hierarchy" | "subType";
}

export interface IMapType extends IType {
    typeType: "map";
    keyName: string;
    valueType: Type;
}

export interface IImportedTypeReference extends IType {
    typeType: "importedTypeReference";
    requirePath: string;
    selection: Selection;
    alias?: string;
}

export interface IUnknownType extends IType {
    typeType: "unknown";
}


export type Selection = IDirectSelection | IAllSelection;

export type SelectionType = "direct" | "all";

export /* abstract */ interface ISelection {
    selectionType: SelectionType;
}

export interface IDirectSelection extends ISelection {
    selectionType: "direct";
}

export interface IAllSelection extends ISelection {
    selectionType: "all";
    alias: string;
}

