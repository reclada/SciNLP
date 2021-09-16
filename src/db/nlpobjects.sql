/*
SELECT reclada_object.create_subclass('{
    "class": "RecladaObject",
    "attributes": {
        "newClass": "Data",
        "properties": {
            "table": {"type": "string"},
            "row": {"type": "number"}
        },
        "required": ["table", "row"]
    }
}'::jsonb);
SELECT reclada_object.create_subclass('{
    "class": "RecladaObject",
    "attributes": {
        "newClass": "Attribute",
        "properties": {
            "attribute": {"type": "string"},
            "value": {"type": "string"},
            "attributeEntities": {"type": "array"},
            "valueEntities": {"type": "array"},
            "object": {"type": "string"}
        },
        "required": ["attribute", "value", "attributeEntities", "valueEntities", "object"]
    }
}'::jsonb);*/
SELECT reclada_object.create_subclass('{
    "class": "RecladaObject",
    "attributes": {
        "newClass": "DataRow",
        "properties": {
            "table": {"type": "string"},
            "row": {"type": "number"}
        },
        "required": ["table", "row"]
    }
}'::jsonb);
