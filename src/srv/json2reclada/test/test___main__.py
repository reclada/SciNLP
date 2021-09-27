import json
import os
from unittest import TestCase

from ..src.__main__ import JSONObjMapper


class TestJSONObjMapper(TestCase):

    def setUp(self):
        self.test_d_dictionary = {
            'types_by_fields': {
                'attributes': 'measurementType',
                'attribute': 'measurementResultTemplate',
                'isMandatory': 'measurementResultDataMapping'

            },
             'field_names': {
                 'measurementType': {'measurementType': 'name'},
                 'measurementResultTemplate': {'attribute': 'name'}
             }
        }

        self.test_obj_dictionary_with_type = {
            'type': "test_type"
        }

        self.test_dir_path = os.path.abspath(os.path.dirname(__file__))
        self.test_obj_path = os.path.join(self.test_dir_path, 'test_obj.json')
        self.test_json_path = os.path.join(self.test_dir_path, 'test.json')

        with open(self.test_obj_path) as inputfile:
            self.test_obj_dictionary = json.load(inputfile)

        self.test_json = json.dumps(self.test_d_dictionary)

        with open(self.test_json_path, "w") as file:
            json.dump(self.test_d_dictionary, file)

        self.test_JSONObjMapper = JSONObjMapper(self.test_d_dictionary)

    def tearDown(self):
        os.remove(self.test_json_path)

    def test_from_dict(self):
        test_output = JSONObjMapper.from_dict(self.test_d_dictionary)
        self.assertIsInstance(test_output, JSONObjMapper)

    def test_from_json(self):
        test_output = JSONObjMapper.from_json(self.test_json)
        self.assertIsInstance(test_output, JSONObjMapper)

    def test_from_json_file(self):
        test_output = JSONObjMapper.from_json_file(self.test_json_path)
        self.assertIsInstance(test_output, JSONObjMapper)

    def test_get_obj_type(self):
        test_type_output = self.test_JSONObjMapper.get_obj_type(self.test_obj_dictionary_with_type)
        self.assertEqual(test_type_output, 'testType')

    def test_snake2camel(self):
        test_input = [
            'test'
            'test_object',
            'another_test_object',
            'Camel_test_object',
            'snake_Case'
        ]
        test_output = list(map(JSONObjMapper.snake2camel, test_input))
        expected_output = [
            'test'
            'testObject',
            'anotherTestObject',
            'CamelTestObject',
            'snakeCase'
        ]
        error_message = "Should be СamelСase"
        self.assertEqual(test_output, expected_output, error_message)


class Test(TestCase):
    def test_main(self):
        self.fail()
