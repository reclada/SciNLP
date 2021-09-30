from __future__ import annotations

import argparse
import json
import csv
import uuid


def create_parser():
    """
    The argparse module makes it easy to write user-friendly command-line interfaces.
    The program defines what arguments it requires, and argparse will figure out how
    to parse those out of sys.argv. The argparse module also automatically generates
    help and usage messages and issues errors when users give the program invalid arguments.
    https://docs.python.org/3/library/argparse.html#required

    Automatically checks for file existence and type of input parameters.

    :return: argparse.ArgumentParser
    """
    parser = argparse.ArgumentParser()
    parser.add_argument(
        'mapping',
        type=argparse.FileType('r', encoding='utf-8'),
        help='Path to the JSON file containing Mapping'
    )
    parser.add_argument(
        'input',
        type=argparse.FileType('r', encoding='utf-8'),
        help='Path to the Input JSON file'
    )
    parser.add_argument(
        'output',
        type=argparse.FileType('w', encoding='utf-8'),
        help='Path to the Output CSV file'
    )
    parser.add_argument(
        '-t',
        '--transactionId',
        default=None,
        type=int,
        help='ID of transaction'
    )
    parser.add_argument(
        '-g',
        '--guid',
        default=None,
        type=str,
        help='GUID of object'
    )

    return parser


class JSONObjMapper:

    def __init__(self, types_by_fields:dict=None, field_names:dict=None):
        self.types_by_fields = types_by_fields
        self.field_names = field_names

    @classmethod
    def from_dict(cls, d:dict) -> JSONObjMapper:
        return cls(**d)

    @classmethod
    def from_json(cls, json_str:str) -> JSONObjMapper:
        return cls.from_dict(json.loads(json_str))

    @classmethod
    def from_json_file(cls, json_path:str) -> JSONObjMapper:
        with open(json_path) as input_file:
            return cls.from_dict(json.load(input_file))

    def get_obj_type(self, obj:dict) -> str:
        if 'type' in obj:
            return self.snake2camel(obj.pop('type'))
        for field in self.types_by_fields:
            if field in obj:
                return self.types_by_fields[field]
        raise TypeError(f'Unknown object type {obj}')

    @staticmethod
    def snake2camel(s:str) -> str:
        components = s.split('_')
        # We capitalize the first letter of each component except the first one
        # with the 'title' method and join them together.
        return components[0] + ''.join(x.title() for x in components[1:])

        
def main():
    # Create argument parser object and defines arguments
    parser = create_parser()
    args = parser.parse_args()

    transaction_id = args.transactionId
    file_GUID = args.guid

    mapper = JSONObjMapper.from_json_file(args.mapping.name)
    with open(args.input.name) as inputfile:
        inputobj = json.load(inputfile)

    if isinstance(inputobj, list):
        queue = [x for x in inputobj]
    else:
        queue = [inputobj]

    doc_GUID = str(uuid.uuid4())
    for obj in queue:
        obj['GUID'] = str(uuid.uuid4())
        obj['documentGUID'] = doc_GUID
    objects = [
        {
            'class': 'Document',
            'GUID': doc_GUID,
            'transactionID': transaction_id,
            'attributes': {'fileGUID': file_GUID, 'name': file_GUID}
        }
    ]
    while queue:
        obj = queue.pop(0)
        qpos = 0
        if not isinstance(obj, dict):
            continue
        obj_type = mapper.get_obj_type(obj)
        robj = {}
        if obj_type is not None:
            robj['class'] = obj_type[0].upper() + obj_type[1:]
        _ = lambda f: mapper.field_names.get(obj_type, {}).get(f, f)
        objects.append(robj)
        robj['GUID'] = obj['GUID']
        if transaction_id is not None:
            robj['transactionID'] = transaction_id
        robj = robj.setdefault('attributes', {})
        for k, v in obj.items():
            if k == 'GUID':
                continue
            if isinstance(v, list):
                if obj_type is None or any(not isinstance(item, dict) for item in v):
                    robj[_(k)] = rlist = []
                for item in v:
                    if isinstance(item, dict):
                        queue.insert(qpos, item)
                        qpos += 1
                        item['GUID'] = str(uuid.uuid4())
    
                        if obj_type is None:
                            rlist.append(item['GUID'])
                        else:
                            item[obj_type + "GUID"] = obj['GUID']
                    else:
                        rlist.append(item)
            elif isinstance(v, dict):
                v['GUID'] = str(uuid.uuid4())
                queue.insert(qpos, v)
                qpos += 1
                robj[_(k)] = v['GUID']
            else:
                robj[_(k)] = v
    with open(args.output.name, 'w') as outfile:
        writer = csv.writer(outfile, quotechar='\'')
        for obj in objects:
            writer.writerow([json.dumps(obj, indent=4, ensure_ascii=False)])


if __name__ == '__main__':
    main()
