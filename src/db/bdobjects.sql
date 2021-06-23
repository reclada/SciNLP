SELECT reclada_object.create_subclass('{
    "class": "RecladaObject",
    "attrs": {
        "newClass": "Document",
        "properties": {
            "name": {"type": "string"}
        },
        "required": ["name"]
    }
}'::jsonb);
SELECT reclada_object.create_subclass('{
    "class": "RecladaObject",
    "attrs": {
        "newClass": "Page",
        "properties": {
            "number": {"type": "number"},
            "bbox": {"type": "string"},
            "document": {"type": "string"}
        },
        "required": ["number", "bbox", "document"]
    }
}'::jsonb);
SELECT reclada_object.create_subclass('{
    "class": "RecladaObject",
    "attrs": {
        "newClass": "BBox",
        "properties": {
            "left": {"type": "number"},
            "top": {"type": "number"},
            "height": {"type": "number"},
            "width": {"type": "number"}
        },
        "required": ["left", "top", "height", "width"]
    }
}'::jsonb);
SELECT reclada_object.create_subclass('{
    "class": "RecladaObject",
    "attrs": {
        "newClass": "TextBlock",
        "properties": {
            "bbox": {"type": "string"},
            "text": {"type": "string"},
            "page": {"type": "string"}
        },
        "required": ["bbox", "text", "page"]
    }
}'::jsonb);
SELECT reclada_object.create_subclass('{
    "class": "RecladaObject",
    "attrs": {
        "newClass": "Table",
        "properties": {
            "bbox": {"type": "string"},
            "page": {"type": "string"}
        },
        "required": ["bbox", "page"]
    }
}'::jsonb);
SELECT reclada_object.create_subclass('{
    "class": "RecladaObject",
    "attrs": {
        "newClass": "Cell",
        "properties": {
            "row": {"type": "number"},
            "column": {"type": "number"},
            "rowspan": {"type": "number"},
            "colspan": {"type": "number"},
            "bbox": {"type": "string"},
            "text": {"type": "string"},
            "cellType": {"type": "string"},
            "table": {"type": "string"}
        },
        "required": ["row", "column", "rowspan", "colspan", "bbox", "text", "cellType", "table"]
    }
}'::jsonb);
