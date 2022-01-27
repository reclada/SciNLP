BEGIN;
SELECT reclada_object.create_subclass('{
    "class": "RecladaObject",
    "attributes": {
        "newClass": "MeasurementType",
        "properties": {
            "name": {"type": "string"}
        },
        "required": ["name"]
    }
}'::jsonb);
SELECT reclada_object.create_subclass('{
    "class": "RecladaObject",
    "attributes": {
        "newClass": "MeasurementResultTemplate",
        "properties": {
            "measurementTypeGUID": {"type": "string"},
            "name": {"type": "string"},
            "unit": {"type": "string"},
            "valueType": {"type": "string"}
        },
        "required": ["measurementTypeGUID", "name"]
    }
}'::jsonb);
SELECT reclada_object.create_subclass('{
    "class": "RecladaObject",
    "attributes": {
        "newClass": "MeasurementResultDataMapping",
        "properties": {
            "measurementResultTemplateGUID": {"type": "string"},
            "isMandatory": {"type": "boolean"},
            "dataPath": {
                "anyOf": [
                    {"type": "string"},
                    {
                        "type": "array",
                        "items": {
                            "anyOf": [
                                {"type": ["string"]},
                                {
                                    "type": "array",
                                    "items": {"type": "string"}
                                }
                            ]
                        }
                    }
                ]
            }
        },
        "required": ["measurementResultTemplateGUID", "isMandatory", "dataPath"]
    }
}'::jsonb);
/*
SELECT reclada_object.create(
    '{
        "class": "MeasurementType",
        "GUID": "698f14c0-1bdc-4c2f-84c1-3a49b556855c",
        "attributes": {
            "name": "TmTagg"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "23622407-e9fa-474d-9955-073bd028c5e8",
        "attributes": {
            "name": "Analyzed Entity Type",
            "measurementTypeGUID": "698f14c0-1bdc-4c2f-84c1-3a49b556855c"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "bbb5184b-7aae-4fd9-8f77-527850f0aa3d",
        "attributes": {
            "measurementResultTemplateGUID": "23622407-e9fa-474d-9955-073bd028c5e8",
            "isMandatory": true,
            "dataPath": "PPB"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "fd53699c-6b33-4289-9669-26d7a67546c6",
        "attributes": {
            "name": "Analyzed Entity Name",
            "measurementTypeGUID": "698f14c0-1bdc-4c2f-84c1-3a49b556855c"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "e489f013-e0a8-4bd3-9fb6-89dda87ebc0a",
        "attributes": {
            "measurementResultTemplateGUID": "fd53699c-6b33-4289-9669-26d7a67546c6",
            "isMandatory": true,
            "dataPath": [
                "protein id (protein or sample identifier)",
                "protein"
            ]
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "5a027a7a-5c0a-4956-b9f4-cfdab8503990",
        "attributes": {
            "name": "Ratio 350nm/330nm (20C)",
            "measurementTypeGUID": "698f14c0-1bdc-4c2f-84c1-3a49b556855c"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "aef2397f-24e9-4133-99bd-fed79dc5692b",
        "attributes": {
            "measurementResultTemplateGUID": "5a027a7a-5c0a-4956-b9f4-cfdab8503990",
            "isMandatory": false,
            "dataPath": [
                "start [Entity] (initial value)"
            ]
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "f80258cd-90f3-40bf-bc73-1d5dd9539a22",
        "attributes": {
            "name": "T onset",
            "measurementTypeGUID": "698f14c0-1bdc-4c2f-84c1-3a49b556855c"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "8a03b322-db95-4dd4-a25d-f68306b4b41f",
        "attributes": {
            "measurementResultTemplateGUID": "f80258cd-90f3-40bf-bc73-1d5dd9539a22",
            "isMandatory": false,
            "dataPath": [
                "Tonset [Entity] (protein unfolding onset temperature)"
            ]
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "c137bad0-bb75-4f70-90dc-714be7633005",
        "attributes": {
            "name": "Tm1",
            "measurementTypeGUID": "698f14c0-1bdc-4c2f-84c1-3a49b556855c"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "b2d8521b-fd56-41e5-9f6f-26c25770d09d",
        "attributes": {
            "measurementResultTemplateGUID": "c137bad0-bb75-4f70-90dc-714be7633005",
            "isMandatory": false,
            "dataPath": [
                "Tm1 [Entity] (value of Tm1)"
            ]
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "4273346d-f397-4c1a-9e82-c66fc75de3df",
        "attributes": {
            "name": "Tm1 type",
            "measurementTypeGUID": "698f14c0-1bdc-4c2f-84c1-3a49b556855c"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "92b8161a-e314-47bb-9224-7abe3992891c",
        "attributes": {
            "measurementResultTemplateGUID": "4273346d-f397-4c1a-9e82-c66fc75de3df",
            "isMandatory": false,
            "dataPath": ""
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "f3892e0e-4ac4-4259-8805-06dc8c90b0dd",
        "attributes": {
            "name": "Tm2",
            "measurementTypeGUID": "698f14c0-1bdc-4c2f-84c1-3a49b556855c"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "947eaaf3-6dab-406b-a60a-8aaafb07320d",
        "attributes": {
            "measurementResultTemplateGUID": "f3892e0e-4ac4-4259-8805-06dc8c90b0dd",
            "isMandatory": false,
            "dataPath": [
                "Tm2 [Entity] (value of Tm2)"
            ]
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "7719e47f-a790-4d0a-81b2-ec052e4d506f",
        "attributes": {
            "name": "Tm2 type",
            "measurementTypeGUID": "698f14c0-1bdc-4c2f-84c1-3a49b556855c"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "75e7ef60-0104-4c5f-86ea-4f9210d1b9da",
        "attributes": {
            "measurementResultTemplateGUID": "7719e47f-a790-4d0a-81b2-ec052e4d506f",
            "isMandatory": false,
            "dataPath": ""
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "64961bec-bcc8-42a2-9322-60c5d781e4bc",
        "attributes": {
            "name": "Tagg",
            "measurementTypeGUID": "698f14c0-1bdc-4c2f-84c1-3a49b556855c"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "0b57fde4-b35b-4770-9b2b-ada26666d7a4",
        "attributes": {
            "measurementResultTemplateGUID": "64961bec-bcc8-42a2-9322-60c5d781e4bc",
            "isMandatory": false,
            "dataPath": [
                "scattering on ⌀"
            ]
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "1d668152-3446-46c5-95e7-a29162a2a48a",
        "attributes": {
            "name": "Tm3",
            "measurementTypeGUID": "698f14c0-1bdc-4c2f-84c1-3a49b556855c"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "b581d239-0e71-4ae2-85f6-406086e48ce9",
        "attributes": {
            "measurementResultTemplateGUID": "1d668152-3446-46c5-95e7-a29162a2a48a",
            "isMandatory": false,
            "dataPath": [
                "Tm3 [Entity] (value of Tm3)"
            ]
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "e810afeb-c756-4bb5-8e0f-4254ff7adec5",
        "attributes": {
            "name": "Tm3 type",
            "measurementTypeGUID": "698f14c0-1bdc-4c2f-84c1-3a49b556855c"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "43fa7ba5-950d-4146-82b7-bf0b1b7a624c",
        "attributes": {
            "measurementResultTemplateGUID": "e810afeb-c756-4bb5-8e0f-4254ff7adec5",
            "isMandatory": false,
            "dataPath": ""
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "cae6eb0b-0fb7-4798-bff8-1e499488d983",
        "attributes": {
            "name": "Tm4",
            "measurementTypeGUID": "698f14c0-1bdc-4c2f-84c1-3a49b556855c"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "abf5422d-2664-417d-ab36-7f20488e4d79",
        "attributes": {
            "measurementResultTemplateGUID": "cae6eb0b-0fb7-4798-bff8-1e499488d983",
            "isMandatory": false,
            "dataPath": [
                "Tm4 [Entity] (value of Tm4)"
            ]
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "6c9d004c-a9be-4861-ad78-29a72d20687c",
        "attributes": {
            "name": "Tm4 type",
            "measurementTypeGUID": "698f14c0-1bdc-4c2f-84c1-3a49b556855c"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "e59a743a-f629-4d8f-aec0-102dab9057cb",
        "attributes": {
            "measurementResultTemplateGUID": "6c9d004c-a9be-4861-ad78-29a72d20687c",
            "isMandatory": false,
            "dataPath": ""
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "aa519ba4-4cfa-45d3-b60c-9da69643d6a8",
        "attributes": {
            "name": "Comments",
            "measurementTypeGUID": "698f14c0-1bdc-4c2f-84c1-3a49b556855c"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "e6bbc61c-9514-4755-b08e-71006b08eeac",
        "attributes": {
            "measurementResultTemplateGUID": "aa519ba4-4cfa-45d3-b60c-9da69643d6a8",
            "isMandatory": false,
            "dataPath": "sys.argv[2]"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementType",
        "GUID": "b22c5144-7396-47d0-b915-e3fc3d071e0a",
        "attributes": {
            "name": "SEC"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "2adf71ff-7482-48d8-93ce-c77f453d085f",
        "attributes": {
            "name": "Analyzed Entity Type",
            "measurementTypeGUID": "b22c5144-7396-47d0-b915-e3fc3d071e0a"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "1efb592a-d963-4fbb-918c-07a654f3c601",
        "attributes": {
            "measurementResultTemplateGUID": "2adf71ff-7482-48d8-93ce-c77f453d085f",
            "isMandatory": true,
            "dataPath": "PPB"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "3e617603-b457-4072-a302-6c1d9ca5ffab",
        "attributes": {
            "name": "Analyzed Entity Name",
            "measurementTypeGUID": "b22c5144-7396-47d0-b915-e3fc3d071e0a"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "a9a382dc-7172-4544-b3a9-3ce2d30c9605",
        "attributes": {
            "measurementResultTemplateGUID": "3e617603-b457-4072-a302-6c1d9ca5ffab",
            "isMandatory": true,
            "dataPath": [
                "SampName"
            ]
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "8be5bd27-7e29-468c-9681-d9f784719fbe",
        "attributes": {
            "name": "Retention Time",
            "measurementTypeGUID": "b22c5144-7396-47d0-b915-e3fc3d071e0a"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "9408f638-efc6-4f4f-8c4d-378ec0bb7994",
        "attributes": {
            "measurementResultTemplateGUID": "8be5bd27-7e29-468c-9681-d9f784719fbe",
            "isMandatory": false,
            "dataPath": [
                "PeakRT"
            ]
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "0858e2a1-f09c-4f7b-9d05-670d03873907",
        "attributes": {
            "name": "% Monomer",
            "measurementTypeGUID": "b22c5144-7396-47d0-b915-e3fc3d071e0a"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "32e7c992-aff1-479f-be03-00cc9aba7736",
        "attributes": {
            "measurementResultTemplateGUID": "0858e2a1-f09c-4f7b-9d05-670d03873907",
            "isMandatory": true,
            "dataPath": [
                "PctMain"
            ]
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "3011866a-bb4b-4034-a6ae-f4f955233aff",
        "attributes": {
            "name": "% HMWS",
            "measurementTypeGUID": "b22c5144-7396-47d0-b915-e3fc3d071e0a"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "af6b8108-5d5d-46fa-8e4a-40088e2ce77c",
        "attributes": {
            "measurementResultTemplateGUID": "3011866a-bb4b-4034-a6ae-f4f955233aff",
            "isMandatory": false,
            "dataPath": [
                "PctAggregate"
            ]
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "591c1eed-d303-42a3-874e-4b411320de01",
        "attributes": {
            "name": "% LMWS",
            "measurementTypeGUID": "b22c5144-7396-47d0-b915-e3fc3d071e0a"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "36baeebd-3cc7-4798-8d98-4bac71e9a331",
        "attributes": {
            "measurementResultTemplateGUID": "591c1eed-d303-42a3-874e-4b411320de01",
            "isMandatory": false,
            "dataPath": [
                "PctFragment"
            ]
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementType",
        "GUID": "aefcaff7-85ee-4c5b-ae60-9ca6f0422c21",
        "attributes": {
            "name": "CIC"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "b3af2333-898c-4784-9e60-8d0e29ec16cb",
        "attributes": {
            "name": "Analyzed Entity Type",
            "measurementTypeGUID": "aefcaff7-85ee-4c5b-ae60-9ca6f0422c21"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "4d423fe3-aa21-4df8-8640-6023be7eedde",
        "attributes": {
            "measurementResultTemplateGUID": "b3af2333-898c-4784-9e60-8d0e29ec16cb",
            "isMandatory": true,
            "dataPath": "PPB"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "e293f605-f372-4607-8dfe-49b83de64f3c",
        "attributes": {
            "name": "Analyzed Entity Name",
            "measurementTypeGUID": "aefcaff7-85ee-4c5b-ae60-9ca6f0422c21"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "af1215b1-942b-4d43-8487-53e28f2edc46",
        "attributes": {
            "measurementResultTemplateGUID": "e293f605-f372-4607-8dfe-49b83de64f3c",
            "isMandatory": true,
            "dataPath": [
                "Analyzed Entity Name",
                "protein"
            ]
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "c13cf97a-a0d6-4ca5-bb68-d01966b71a8d",
        "attributes": {
            "name": "Retention Time",
            "measurementTypeGUID": "aefcaff7-85ee-4c5b-ae60-9ca6f0422c21"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "b1f0b54d-ef0c-4376-aad2-3325af7bc529",
        "attributes": {
            "measurementResultTemplateGUID": "c13cf97a-a0d6-4ca5-bb68-d01966b71a8d",
            "isMandatory": false,
            "dataPath": [
                "Retention Time"
            ]
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "bd1af74a-ec4d-473e-8632-b92ca81ae84e",
        "attributes": {
            "name": "Peak Width",
            "measurementTypeGUID": "aefcaff7-85ee-4c5b-ae60-9ca6f0422c21"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "023fcf93-1ea4-4d66-baef-cd27af4f5e3c",
        "attributes": {
            "measurementResultTemplateGUID": "bd1af74a-ec4d-473e-8632-b92ca81ae84e",
            "isMandatory": false,
            "dataPath": [
                "Peak Width"
            ]
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "2399124d-6192-491f-aaac-1f401e179885",
        "attributes": {
            "name": "Comments",
            "measurementTypeGUID": "aefcaff7-85ee-4c5b-ae60-9ca6f0422c21"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "4691c291-9f8c-4ebe-8c24-f21e51160ac6",
        "attributes": {
            "measurementResultTemplateGUID": "2399124d-6192-491f-aaac-1f401e179885",
            "isMandatory": false,
            "dataPath": "sys.argv[2]"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementType",
        "GUID": "c585af61-10a2-4e40-b872-331f117dcb61",
        "attributes": {
            "name": "HIC"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "04900eba-30e7-4aa2-980b-4d4445800e9d",
        "attributes": {
            "name": "Analyzed Entity Type",
            "measurementTypeGUID": "c585af61-10a2-4e40-b872-331f117dcb61"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "835096ec-1081-42ff-87db-e573280af6c8",
        "attributes": {
            "measurementResultTemplateGUID": "04900eba-30e7-4aa2-980b-4d4445800e9d",
            "isMandatory": true,
            "dataPath": "PPB"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "bab45528-b59a-4873-814e-bb791f4c8e70",
        "attributes": {
            "name": "Analyzed Entity Name",
            "measurementTypeGUID": "c585af61-10a2-4e40-b872-331f117dcb61"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "dda4bfc7-548f-4fbf-9611-d533c76ba55a",
        "attributes": {
            "measurementResultTemplateGUID": "bab45528-b59a-4873-814e-bb791f4c8e70",
            "isMandatory": true,
            "dataPath": [
                "SampName",
                "protein"
            ]
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "2963e9d1-675c-46f6-8218-1c3226f0f8f4",
        "attributes": {
            "name": "Retention Time",
            "measurementTypeGUID": "c585af61-10a2-4e40-b872-331f117dcb61"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "bae45c6f-e405-4878-9b57-67c87b66ef66",
        "attributes": {
            "measurementResultTemplateGUID": "2963e9d1-675c-46f6-8218-1c3226f0f8f4",
            "isMandatory": false,
            "dataPath": [
                "PeakRT"
            ]
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "da4cff24-011f-4a71-86cb-21c00fde9646",
        "attributes": {
            "name": "Hydrophobicity Index (vs CNTO607)",
            "measurementTypeGUID": "c585af61-10a2-4e40-b872-331f117dcb61"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "98baf9e8-a491-427d-8d5f-3868946f9fde",
        "attributes": {
            "measurementResultTemplateGUID": "da4cff24-011f-4a71-86cb-21c00fde9646",
            "isMandatory": false,
            "dataPath": [
                "Ratio"
            ]
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "89cd0006-de77-4cc3-b119-c3207e1f21d0",
        "attributes": {
            "name": "Comments",
            "measurementTypeGUID": "c585af61-10a2-4e40-b872-331f117dcb61"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "b5dfb35e-371f-4585-ab9a-b33bf0f76477",
        "attributes": {
            "measurementResultTemplateGUID": "89cd0006-de77-4cc3-b119-c3207e1f21d0",
            "isMandatory": false,
            "dataPath": "sys.argv[2]"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementType",
        "GUID": "bd27a034-4675-42ab-bd29-9f508cdb932f",
        "attributes": {
            "name": "Serum-Stability"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "f5ca5df1-894d-4581-be5a-e72635e1d0e0",
        "attributes": {
            "name": "Analyzed Entity Type",
            "measurementTypeGUID": "bd27a034-4675-42ab-bd29-9f508cdb932f"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "b76301e2-0434-4e8c-84f5-5635ba236b23",
        "attributes": {
            "measurementResultTemplateGUID": "f5ca5df1-894d-4581-be5a-e72635e1d0e0",
            "isMandatory": true,
            "dataPath": "PPB"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "bbcf99d9-67da-404e-b45e-cfadfa75ac2d",
        "attributes": {
            "name": "Analyzed Entity Name",
            "measurementTypeGUID": "bd27a034-4675-42ab-bd29-9f508cdb932f"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "edb3992b-0e51-43bf-b1f3-f03076cf2a8a",
        "attributes": {
            "measurementResultTemplateGUID": "bbcf99d9-67da-404e-b45e-cfadfa75ac2d",
            "isMandatory": true,
            "dataPath": [
                "SampName",
                "protein"
            ]
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "93d05aee-13bb-4bd1-83b1-c3fc2bad4036",
        "attributes": {
            "name": "Grouping Criterion",
            "measurementTypeGUID": "bd27a034-4675-42ab-bd29-9f508cdb932f"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "866671ca-8d5c-4b3e-814b-85a3e0c2fa56",
        "attributes": {
            "measurementResultTemplateGUID": "93d05aee-13bb-4bd1-83b1-c3fc2bad4036",
            "isMandatory": false,
            "dataPath": ""
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "90e2d2e8-7a42-4700-be78-e0942cb92742",
        "attributes": {
            "name": "Incubation Buffer",
            "measurementTypeGUID": "bd27a034-4675-42ab-bd29-9f508cdb932f"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "d6a48757-c080-4f00-a9fd-db0d90a28ccb",
        "attributes": {
            "measurementResultTemplateGUID": "90e2d2e8-7a42-4700-be78-e0942cb92742",
            "isMandatory": true,
            "dataPath": [
                "Matrix"
            ]
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "1888cfc6-2618-4c67-adcf-56caebdb6205",
        "attributes": {
            "name": "Analysis Time Point",
            "measurementTypeGUID": "bd27a034-4675-42ab-bd29-9f508cdb932f"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "bbac560f-6552-424b-8019-d4b80b77bcab",
        "attributes": {
            "measurementResultTemplateGUID": "1888cfc6-2618-4c67-adcf-56caebdb6205",
            "isMandatory": true,
            "dataPath": [
                "ResulTable"
            ]
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "a43c1d98-8381-4770-9d86-6b6acc51959c",
        "attributes": {
            "name": "% Monomer",
            "measurementTypeGUID": "bd27a034-4675-42ab-bd29-9f508cdb932f"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "60d67213-b84b-420d-9996-cdc33c3e2e33",
        "attributes": {
            "measurementResultTemplateGUID": "a43c1d98-8381-4770-9d86-6b6acc51959c",
            "isMandatory": true,
            "dataPath": [
                "PctMain"
            ]
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "195c9713-a858-4593-8bdd-ae6d46c66cde",
        "attributes": {
            "name": "% HMWS",
            "measurementTypeGUID": "bd27a034-4675-42ab-bd29-9f508cdb932f"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "df4d5f16-741f-4757-9c87-df757873693d",
        "attributes": {
            "measurementResultTemplateGUID": "195c9713-a858-4593-8bdd-ae6d46c66cde",
            "isMandatory": false,
            "dataPath": [
                "PctAggregate"
            ]
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "790d8c69-37ff-4837-95b5-5642d2f56e75",
        "attributes": {
            "name": "% LMWS",
            "measurementTypeGUID": "bd27a034-4675-42ab-bd29-9f508cdb932f"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "9d666c41-c403-43ee-86b8-b70f8bc3c2ef",
        "attributes": {
            "measurementResultTemplateGUID": "790d8c69-37ff-4837-95b5-5642d2f56e75",
            "isMandatory": false,
            "dataPath": [
                "PctFragment"
            ]
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "149fed2f-b3cf-4b00-b811-a09c28f1f020",
        "attributes": {
            "name": "Retention Time",
            "measurementTypeGUID": "bd27a034-4675-42ab-bd29-9f508cdb932f"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "e9fa1105-0ded-49db-9ead-c2f13c98ad68",
        "attributes": {
            "measurementResultTemplateGUID": "149fed2f-b3cf-4b00-b811-a09c28f1f020",
            "isMandatory": false,
            "dataPath": [
                "PeakRT"
            ]
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "18a9eb9e-1a40-422b-9449-7d077f8cde16",
        "attributes": {
            "name": "Comments",
            "measurementTypeGUID": "bd27a034-4675-42ab-bd29-9f508cdb932f"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "4d86efa4-35df-4a03-99d1-0218b29bbb2b",
        "attributes": {
            "measurementResultTemplateGUID": "18a9eb9e-1a40-422b-9449-7d077f8cde16",
            "isMandatory": false,
            "dataPath": "sys.argv[2]"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementType",
        "GUID": "92ed434e-8edb-4c6a-9e41-f0a611f316ce",
        "attributes": {
            "name": "SPR"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "73b875a4-024a-4d09-9b25-1f9195352ea3",
        "attributes": {
            "name": "Analyzed Entity Type",
            "measurementTypeGUID": "92ed434e-8edb-4c6a-9e41-f0a611f316ce"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "ef035860-75b5-4a70-b27c-6eb772d486fa",
        "attributes": {
            "measurementResultTemplateGUID": "73b875a4-024a-4d09-9b25-1f9195352ea3",
            "isMandatory": true,
            "dataPath": "PPB"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "0dc390a3-beda-42db-b664-51d5e73263de",
        "attributes": {
            "name": "Name",
            "measurementTypeGUID": "92ed434e-8edb-4c6a-9e41-f0a611f316ce"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "5e8248b0-1c94-434f-b2fb-1e6dfc6da5e8",
        "attributes": {
            "measurementResultTemplateGUID": "0dc390a3-beda-42db-b664-51d5e73263de",
            "isMandatory": true,
            "dataPath": "SPR Affinity"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "29770895-a987-4d34-b44e-d477dc333cbd",
        "attributes": {
            "name": "Assay Type",
            "measurementTypeGUID": "92ed434e-8edb-4c6a-9e41-f0a611f316ce"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "d59988a1-ebfc-4a8a-ae36-5c1f3b7b842e",
        "attributes": {
            "measurementResultTemplateGUID": "29770895-a987-4d34-b44e-d477dc333cbd",
            "isMandatory": true,
            "dataPath": "SPR"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "5c73a889-85e8-4ce8-9921-cbad51ae85be",
        "attributes": {
            "name": "Antibody Clone ID",
            "measurementTypeGUID": "92ed434e-8edb-4c6a-9e41-f0a611f316ce"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "c462d18f-e03d-496d-804b-7df28ae38109",
        "attributes": {
            "measurementResultTemplateGUID": "5c73a889-85e8-4ce8-9921-cbad51ae85be",
            "isMandatory": true,
            "dataPath": [
                "Sample ID",
                "protein"
            ]
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "08ebec3c-6627-4d5e-b4fc-9e52d0c32535",
        "attributes": {
            "name": "Antibody Clone Name",
            "measurementTypeGUID": "92ed434e-8edb-4c6a-9e41-f0a611f316ce"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "f6417361-22ed-4fa3-b017-bf609bfcb706",
        "attributes": {
            "measurementResultTemplateGUID": "08ebec3c-6627-4d5e-b4fc-9e52d0c32535",
            "isMandatory": false,
            "dataPath": ""
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "2dbf701a-9914-4d1f-bd44-cd6d1f858190",
        "attributes": {
            "name": "Analyzed Entity Name",
            "measurementTypeGUID": "92ed434e-8edb-4c6a-9e41-f0a611f316ce"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "fe8cf080-95aa-4170-907c-d40500810d88",
        "attributes": {
            "measurementResultTemplateGUID": "2dbf701a-9914-4d1f-bd44-cd6d1f858190",
            "isMandatory": true,
            "dataPath": [
                "Sample ID",
                "protein"
            ]
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "5aa19d4d-25f9-4f17-990d-ecab81ce1329",
        "attributes": {
            "name": "Antigen Name",
            "measurementTypeGUID": "92ed434e-8edb-4c6a-9e41-f0a611f316ce"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "8ce86eef-87b6-4e73-8e59-ad5f58ada607",
        "attributes": {
            "measurementResultTemplateGUID": "5aa19d4d-25f9-4f17-990d-ecab81ce1329",
            "isMandatory": true,
            "dataPath": [
                "Analyte",
                "antigen"
            ]
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "031c0c73-db55-4cb1-94df-0f248f3fd33a",
        "attributes": {
            "name": "Antigen Material Name",
            "measurementTypeGUID": "92ed434e-8edb-4c6a-9e41-f0a611f316ce"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "6c5eac5c-3020-411d-86d0-16488dc54dc1",
        "attributes": {
            "measurementResultTemplateGUID": "031c0c73-db55-4cb1-94df-0f248f3fd33a",
            "isMandatory": true,
            "dataPath": [
                "Analyte",
                "antigenMaterial"
            ]
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "1731d7a2-dc12-476a-b8fe-6d03b0bda5a0",
        "attributes": {
            "name": "koff",
            "measurementTypeGUID": "92ed434e-8edb-4c6a-9e41-f0a611f316ce"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "fc7e35f6-9af1-4360-8e27-466f9a8a387c",
        "attributes": {
            "measurementResultTemplateGUID": "1731d7a2-dc12-476a-b8fe-6d03b0bda5a0",
            "isMandatory": false,
            "dataPath": [
                "kd (1/s)"
            ]
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "4fc24722-0a80-409e-a744-7d9298cd7f74",
        "attributes": {
            "name": "koff CI",
            "measurementTypeGUID": "92ed434e-8edb-4c6a-9e41-f0a611f316ce"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "ab56ed77-52b7-4e3c-87a9-5949101def5f",
        "attributes": {
            "measurementResultTemplateGUID": "4fc24722-0a80-409e-a744-7d9298cd7f74",
            "isMandatory": false,
            "dataPath": ""
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "16c6a081-dbc7-4421-9aba-c861bb064532",
        "attributes": {
            "name": "kon",
            "measurementTypeGUID": "92ed434e-8edb-4c6a-9e41-f0a611f316ce"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "7c99e41f-fbe5-4353-80bf-05d9eb28c0ea",
        "attributes": {
            "measurementResultTemplateGUID": "16c6a081-dbc7-4421-9aba-c861bb064532",
            "isMandatory": false,
            "dataPath": [
                "ka (1/Ms)"
            ]
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "4b25f086-e370-4fc0-8e85-ad596d0f2a78",
        "attributes": {
            "name": "kon CI",
            "measurementTypeGUID": "92ed434e-8edb-4c6a-9e41-f0a611f316ce"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "4d219207-d7ca-4459-9f18-07cd1d8b9765",
        "attributes": {
            "measurementResultTemplateGUID": "4b25f086-e370-4fc0-8e85-ad596d0f2a78",
            "isMandatory": false,
            "dataPath": ""
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "135e7922-072d-4ae8-8a46-101c0d04b0a4",
        "attributes": {
            "name": "KD",
            "measurementTypeGUID": "92ed434e-8edb-4c6a-9e41-f0a611f316ce"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "bcce4fd5-fafa-4ebb-9ce6-caff827b8bda",
        "attributes": {
            "measurementResultTemplateGUID": "135e7922-072d-4ae8-8a46-101c0d04b0a4",
            "isMandatory": false,
            "dataPath": [
                "KD (nM)",
                "_: \"\" if not value else float(str(value) + \"e-9\")"
            ]
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "b6f9c077-36d8-414d-8ecd-684a6a91941b",
        "attributes": {
            "name": "KD CI",
            "measurementTypeGUID": "92ed434e-8edb-4c6a-9e41-f0a611f316ce"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "c9e6e42f-e3fd-4dbc-b787-4a0058cafe7b",
        "attributes": {
            "measurementResultTemplateGUID": "b6f9c077-36d8-414d-8ecd-684a6a91941b",
            "isMandatory": false,
            "dataPath": ""
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "1e8547b2-8ea0-4a7c-a2e0-f39f36d578c2",
        "attributes": {
            "name": "%Rmax",
            "measurementTypeGUID": "92ed434e-8edb-4c6a-9e41-f0a611f316ce"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "14094e28-4588-4855-9167-9e5908f13add",
        "attributes": {
            "measurementResultTemplateGUID": "1e8547b2-8ea0-4a7c-a2e0-f39f36d578c2",
            "isMandatory": false,
            "dataPath": ""
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "2bcbfb7d-570a-45e5-863e-6bbf348bfc6f",
        "attributes": {
            "name": "%Rmax CI",
            "measurementTypeGUID": "92ed434e-8edb-4c6a-9e41-f0a611f316ce"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "9ee74a9e-2dc2-449b-94e2-316024721621",
        "attributes": {
            "measurementResultTemplateGUID": "2bcbfb7d-570a-45e5-863e-6bbf348bfc6f",
            "isMandatory": false,
            "dataPath": ""
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "3a59a04d-4fc3-430e-80e5-3b578bc80ffa",
        "attributes": {
            "name": "%Active",
            "measurementTypeGUID": "92ed434e-8edb-4c6a-9e41-f0a611f316ce"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "096299ae-7f74-4a87-b03f-de9373491f42",
        "attributes": {
            "measurementResultTemplateGUID": "3a59a04d-4fc3-430e-80e5-3b578bc80ffa",
            "isMandatory": false,
            "dataPath": [
                "% Relative Activity",
                "amount"
            ]
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "e7d55850-3187-4d90-b550-1f10d50a5f8f",
        "attributes": {
            "name": "%Active CI",
            "measurementTypeGUID": "92ed434e-8edb-4c6a-9e41-f0a611f316ce"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "6ff20d66-3997-4b21-9ba9-41c354f0b5ee",
        "attributes": {
            "measurementResultTemplateGUID": "e7d55850-3187-4d90-b550-1f10d50a5f8f",
            "isMandatory": false,
            "dataPath": ""
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "acabee27-4dff-4095-9d96-09ad2684bc17",
        "attributes": {
            "name": "Comments",
            "measurementTypeGUID": "92ed434e-8edb-4c6a-9e41-f0a611f316ce"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "24445215-2c22-408a-b6ec-6a860d12ed51",
        "attributes": {
            "measurementResultTemplateGUID": "acabee27-4dff-4095-9d96-09ad2684bc17",
            "isMandatory": false,
            "dataPath": [
                [
                    "Analyte",
                    "KD (pM)",
                    "Affinity Range",
                    "Concentration (mg/mL)",
                    "Main Peak % Area"
                ]
            ]
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "bc409ab8-940d-466f-a0d1-5ff64a0630ea",
        "attributes": {
            "name": "Flag (kd outside of limits)",
            "measurementTypeGUID": "92ed434e-8edb-4c6a-9e41-f0a611f316ce"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "3ea29065-3be3-469d-a7a8-7f77a38b94b1",
        "attributes": {
            "measurementResultTemplateGUID": "bc409ab8-940d-466f-a0d1-5ff64a0630ea",
            "isMandatory": false,
            "dataPath": ""
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "e632632e-838c-4ff5-8ea8-810161920ca0",
        "attributes": {
            "name": "ELN",
            "measurementTypeGUID": "92ed434e-8edb-4c6a-9e41-f0a611f316ce"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "72439fe0-434b-4880-bd79-2e0509103199",
        "attributes": {
            "measurementResultTemplateGUID": "e632632e-838c-4ff5-8ea8-810161920ca0",
            "isMandatory": false,
            "dataPath": ""
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "3f254097-d147-426c-95da-81cd21619b9f",
        "attributes": {
            "name": "Screening Stage",
            "measurementTypeGUID": "92ed434e-8edb-4c6a-9e41-f0a611f316ce"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "33cb28f5-7fc7-4d5e-a3f0-a8ae340258e9",
        "attributes": {
            "measurementResultTemplateGUID": "3f254097-d147-426c-95da-81cd21619b9f",
            "isMandatory": false,
            "dataPath": "Secondary"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "07751620-c488-48d0-9467-bc4c20aa5156",
        "attributes": {
            "name": "Campaign ID",
            "measurementTypeGUID": "92ed434e-8edb-4c6a-9e41-f0a611f316ce"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "a4e4fa35-6d13-42bd-b59f-91c8e95d0e5a",
        "attributes": {
            "measurementResultTemplateGUID": "07751620-c488-48d0-9467-bc4c20aa5156",
            "isMandatory": false,
            "dataPath": ""
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "045ccfaf-f75b-41e3-80ed-38192616ec07",
        "attributes": {
            "name": "Campaign Name",
            "measurementTypeGUID": "92ed434e-8edb-4c6a-9e41-f0a611f316ce"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "df2781f1-15d0-4a82-9ec0-88cee80243de",
        "attributes": {
            "measurementResultTemplateGUID": "045ccfaf-f75b-41e3-80ed-38192616ec07",
            "isMandatory": false,
            "dataPath": ""
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementType",
        "GUID": "f3ee4f76-ab72-4210-b0f6-918601a4dff5",
        "attributes": {
            "name": "Functional Efficacy"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "d14a2d3a-8331-4dfb-a8c8-fbf11e507597",
        "attributes": {
            "name": "Analyzed Entity Type",
            "measurementTypeGUID": "f3ee4f76-ab72-4210-b0f6-918601a4dff5"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "b7c01c24-c8ed-4341-bbdd-89969215f35c",
        "attributes": {
            "measurementResultTemplateGUID": "d14a2d3a-8331-4dfb-a8c8-fbf11e507597",
            "isMandatory": true,
            "dataPath": "Drug"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "35b3c1fe-d711-4ba5-bece-5474c5e871fc",
        "attributes": {
            "name": "Analyzed Entity Name",
            "measurementTypeGUID": "f3ee4f76-ab72-4210-b0f6-918601a4dff5"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "a04b3b37-eec3-4188-8963-6a78fdd00ed6",
        "attributes": {
            "measurementResultTemplateGUID": "35b3c1fe-d711-4ba5-bece-5474c5e871fc",
            "isMandatory": true,
            "dataPath": [
                "Agent",
                "protein"
            ]
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "572ba4cd-0d54-4d1a-99a6-7815bf169fe7",
        "attributes": {
            "name": "Compound",
            "measurementTypeGUID": "f3ee4f76-ab72-4210-b0f6-918601a4dff5"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "a5ed1aab-6353-4880-a983-1eaad190b52c",
        "attributes": {
            "measurementResultTemplateGUID": "572ba4cd-0d54-4d1a-99a6-7815bf169fe7",
            "isMandatory": false,
            "dataPath": [
                "Agent",
                "protein"
            ]
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "7a2095a8-794e-47c2-ae63-10d4c6f3727a",
        "attributes": {
            "name": "HEK293/Human α7 nAChR EC50 Mean (nM)",
            "measurementTypeGUID": "f3ee4f76-ab72-4210-b0f6-918601a4dff5"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "d750f1f4-0bff-423e-8bfa-16d94bb7246a",
        "attributes": {
            "measurementResultTemplateGUID": "7a2095a8-794e-47c2-ae63-10d4c6f3727a",
            "isMandatory": false,
            "dataPath": [
                "HEK293/Human a7 nAChR Mean + SD ECzpo (nM)",
                "value"
            ]
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "14534045-5197-414b-9965-34ce6402988b",
        "attributes": {
            "name": "HEK293/Human α7 nAChR EC50 SD (nM)",
            "measurementTypeGUID": "f3ee4f76-ab72-4210-b0f6-918601a4dff5"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "d64d53a9-0d8d-4c01-b730-7570bb2db8e8",
        "attributes": {
            "measurementResultTemplateGUID": "14534045-5197-414b-9965-34ce6402988b",
            "isMandatory": false,
            "dataPath": [
                "HEK293/Human a7 nAChR Mean + SD ECzpo (nM)",
                "sd"
            ]
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "1eba4580-fc86-493b-b1d0-887b9276fbb9",
        "attributes": {
            "name": "HEK293/Human α7 nAChR Count",
            "measurementTypeGUID": "f3ee4f76-ab72-4210-b0f6-918601a4dff5"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "68122601-36cf-49d6-bbd2-9d193c709a49",
        "attributes": {
            "measurementResultTemplateGUID": "1eba4580-fc86-493b-b1d0-887b9276fbb9",
            "isMandatory": false,
            "dataPath": [
                "HEK293/Human a7 nAChR Mean + SD ECzpo (nM)",
                "amount"
            ]
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "4e6ad076-3da8-4742-a568-35100e33bbe2",
        "attributes": {
            "name": "HEK293/Human 5-HT3A IC50 Mean (nM)",
            "measurementTypeGUID": "f3ee4f76-ab72-4210-b0f6-918601a4dff5"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "5c679f67-52bb-4567-9a9d-eb1c95038fdf",
        "attributes": {
            "measurementResultTemplateGUID": "4e6ad076-3da8-4742-a568-35100e33bbe2",
            "isMandatory": false,
            "dataPath": [
                "HEK293/Human 5-HToa Mean # SD Cag (nM)",
                "value"
            ]
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "ee0f3b24-c0d3-4f4e-9b07-b6236d009b94",
        "attributes": {
            "name": "HEK293/Human 5-HT3A IC50 SD (nM)",
            "measurementTypeGUID": "f3ee4f76-ab72-4210-b0f6-918601a4dff5"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "8e7c89bc-c05b-4e1a-9d31-3c6f59f2af7e",
        "attributes": {
            "measurementResultTemplateGUID": "ee0f3b24-c0d3-4f4e-9b07-b6236d009b94",
            "isMandatory": false,
            "dataPath": [
                "HEK293/Human 5-HToa Mean # SD Cag (nM)",
                "sd"
            ]
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "babd8c22-a959-4a5f-80e0-68edd44e2706",
        "attributes": {
            "name": "HEK293/Human 5-HT3A Count",
            "measurementTypeGUID": "f3ee4f76-ab72-4210-b0f6-918601a4dff5"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "4aa85472-172a-4e1f-83f3-41a791c1337f",
        "attributes": {
            "measurementResultTemplateGUID": "babd8c22-a959-4a5f-80e0-68edd44e2706",
            "isMandatory": false,
            "dataPath": [
                "HEK293/Human 5-HToa Mean # SD Cag (nM)",
                "amount"
            ]
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultTemplate",
        "GUID": "327fe38e-75c1-4d90-a953-c0b8b9f1dc9d",
        "attributes": {
            "name": "Ratio",
            "measurementTypeGUID": "f3ee4f76-ab72-4210-b0f6-918601a4dff5"
        }
    }'::jsonb
);
SELECT reclada_object.create(
    '{
        "class": "MeasurementResultDataMapping",
        "GUID": "f536ee7c-00be-4dfc-b328-4dd457a3d5d0",
        "attributes": {
            "measurementResultTemplateGUID": "327fe38e-75c1-4d90-a953-c0b8b9f1dc9d",
            "isMandatory": false,
            "dataPath": [
                "Ratio"
            ]
        }
    }'::jsonb
);
*/
COMMIT;
