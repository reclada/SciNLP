import argparse
import csv
import json
import uuid

from .bdtypes import get_obj_type, field_names


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
        'input',
        type=argparse.FileType('r', encoding='utf-8'),
        help='Path to the Input JSON file. This document.json file is output of Badgerdoc.'
    )
    parser.add_argument(
        'output',
        type=argparse.FileType('w', encoding='utf-8'),
        help='Path to the Output CSV file. This file will be use as lite.py input.'
    )
    parser.add_argument(
        '-g',
        '--guid',
        default=None,
        type=str,
        help='GUID of file'
    )

    return parser


def main():
    parser = create_parser()
    args = parser.parse_args()

    file_GUID = args.guid

    with open(args.input.name) as inputfile:
        inputobj = json.load(inputfile)
    objects = []
    queue = [inputobj]
    inputobj['GUID'] = str(uuid.uuid4())
    while queue:
        obj = queue.pop(0)
        qpos = 0
        if not isinstance(obj, dict):
            continue
        obj_type = get_obj_type(obj)
        robj = {}
        if obj_type is not None:
            robj['class'] = obj_type[0].upper() + obj_type[1:]
        _ = lambda f: field_names.get((obj_type, f), f)
        objects.append(robj)
        robj['GUID'] = obj['GUID']
        robj = robj.setdefault('attributes', {})
        for k, v in obj.items():
            if k == 'GUID':
                continue
            if isinstance(v, list):
                if obj_type is None or any(not isinstance(item, dict) for item in v):
                    robj[_(k)] = rlist = []
                if all(isinstance(item, dict) for item in v):
                    if k in ('header', 'cells'):
                        v.sort(key=lambda c: (c['row'], c['column']))
                for item in v:
                    if isinstance(item, dict):
                        queue.insert(qpos, item)
                        qpos += 1
                        item['GUID'] = str(uuid.uuid4())

                        if obj_type is None:
                            rlist.append(item['GUID'])
                        else:
                            item[obj_type] = obj['GUID']
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
        if file_GUID:
            objects[0]['attributes']['fileGUID'] = file_GUID
        for obj in objects:
            writer.writerow([json.dumps(obj, indent=4)])


if __name__ == '__main__':
    main()
