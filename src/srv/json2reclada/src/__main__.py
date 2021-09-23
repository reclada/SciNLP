from __future__ import annotations
import json
import csv
import sys
import uuid

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
    mapper = JSONObjMapper.from_json_file(sys.argv[1])
    with open(sys.argv[2]) as inputfile:
        inputobj = json.load(inputfile)
    objects = []
    if isinstance(inputobj, list):
        queue = [x for x in inputobj]
    else:
        queue = [inputobj]

    for obj in queue:
        obj['GUID'] = str(uuid.uuid4())
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
    with open(sys.argv[3], 'w') as outfile:
        writer = csv.writer(outfile, quotechar='\'')
        for obj in objects:
            writer.writerow([json.dumps(obj, indent=4, ensure_ascii=False)])


if __name__ == '__main__':
    main()
