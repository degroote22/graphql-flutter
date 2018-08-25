import { DocumentNode, FragmentDefinitionNode, GraphQLSchema, OperationDefinitionNode } from 'graphql';
import { Document } from '../types';
export declare function fixAnonymousDocument(documentNode: FragmentDefinitionNode | OperationDefinitionNode): string | null;
export declare function transformDocument(schema: GraphQLSchema, documentNode: DocumentNode): Document;
