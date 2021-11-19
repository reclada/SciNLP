SELECT reclada_object.create_subclass('{
    "class": "RecladaObject",
    "attributes": {
        "newClass": "NLPattern",
        "properties": {
            "pattern": {"type": "string"}
        },
        "required": ["pattern"]
    }
}'::jsonb);
SELECT reclada_object.create_subclass('{
    "class": "RecladaObject",
    "attributes": {
        "newClass": "NLPatternAttribute",
        "properties": {
            "attribute": {"type": "string"},
            "evaluation": {"type": "string"},
            "NLPatternGUID": {"type": "string"}
        },
        "required": ["attribute", "evaluation", "NLPatternGUID"]
    }
}'::jsonb);
SELECT reclada_object.create_subclass('{
    "class": "RecladaObject",
    "attributes": {
        "newClass": "HeaderTerm",
        "properties": {
            "name": {"type": "string"}
        },
        "required": ["name"]
    }
}'::jsonb);
