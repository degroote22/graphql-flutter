"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var debugging_1 = require("../debugging");
var get_directives_1 = require("../utils/get-directives");
function transformGraphQLEnum(schema, graphqlEnum) {
    debugging_1.debugLog("[transformGraphQLEnum] transformed enum " + graphqlEnum.name);
    var directives = get_directives_1.getDirectives(schema, graphqlEnum);
    var enumValues = graphqlEnum.getValues().map(function (enumItem) {
        return {
            name: enumItem.name,
            description: enumItem.description || '',
            value: enumItem.value
        };
    });
    return {
        name: graphqlEnum.name,
        description: graphqlEnum.description || '',
        values: enumValues,
        directives: directives,
        usesDirectives: Object.keys(directives).length > 0
    };
}
exports.transformGraphQLEnum = transformGraphQLEnum;
//# sourceMappingURL=transform-enum.js.map