import json
import csv
import sys
import uuid
from .bdtypes import get_obj_type, field_names


with open(sys.argv[1]) as inputfile:
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
with open(sys.argv[2], 'w') as outfile:
    writer = csv.writer(outfile, quotechar='\'')
    if len(sys.argv) > 3:
        objects[0]['attributes']['fileGUID'] = sys.argv[3]
    for obj in objects:
        writer.writerow([json.dumps(obj, indent=4)])
