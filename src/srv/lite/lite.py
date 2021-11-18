import csv
import json
import sys
import pickle
import re
import uuid
import os
import psycopg2

with open(os.path.dirname(__file__) + os.sep + 'onto.pickle', 'rb') as f:
    onto = pickle.load(f)

reclada_con = psycopg2.connect(sys.argv[3])
cursor = reclada_con.cursor()
cursor.callproc('api.reclada_object_list', [json.dumps(
    {'class': 'NLPattern'}
)])
patterns_by_guid = {}
patterns_order = []
for row in next(cursor)[0]['objects']:
    patterns_by_guid[row["GUID"]] = pattern = row["attributes"]
    pattern['attributes'] = {}
    patterns_order.append(pattern)
cursor = reclada_con.cursor()
cursor.callproc('api.reclada_object_list', [json.dumps(
    {'class': 'NLPatternAttribute'}
)])
for row in next(cursor)[0]['objects']:
    attr = row['attributes']
    patterns_by_guid[attr["NLPatternGUID"]]["attributes"][attr['attribute']] = eval(
        'lambda match: ' + attr['evaluation']
    )
res = []
for p in patterns_order:
    res.append((re.compile(p['pattern']), p['attributes']))


def search(t):
    for re, tpl in res:
        for match in re.finditer(t):
            obj = {}
            for k, v in tpl.items():
                obj[k] = v(match)
            yield obj
        t = re.sub('', t)


def concept_inherits(concname, clnames):
    hier = [concname]
    if not isinstance(clnames, set):
        clnames = {clnames}
    for c in hier:
        if c in clnames:
            return True
        conc = onto['onto'].get(c, [])
        for attr in conc:
            if attr['rel'] == 'inheritance':
                hier.append(attr['obj'])


def get_meanings(concs):
    for c in concs:
        conc = onto['onto'][c]
        for attr in conc:
            if attr['rel'] == 'Coding':
                yield attr['obj']


class TableSolver(object):
    def __init__(self):
        self.cells = []
        self.horiz_header = {}
        self.vert_header = {}

    def add_cell(self, cell):
        self.cells.append(cell)
        if cell['cellType'] == 'header':
            if cell['row'] == 0:
                self.horiz_header[cell['column']] = cell
            if cell['column'] == 0:
                self.vert_header[cell['row']] = cell

    def iter_data_dicts(self):
        yield from self.build_table().iter_data_dicts()

    def build_table(self):
        tclass = self.determine_table_class()
        t = tclass()
        for cell in self.cells:
            t.add_cell(cell)
        return t

    def determine_table_class(self):
        if len(self.vert_header) > len(self.horiz_header):
            return VertTable
        # Fallback
        return Table


class Table(object):
    def __init__(self):
        self.header = {}
        self.data = {}

    def add_cell(self, cell):
        tp = cell['cellType']
        if tp == 'header':
            self.add_header(cell)
        else:
            self.add_data(cell)

    def add_header(self, cell):
        col = cell['column']
        colspan = cell['colspan']
        for i in range(col, col + colspan):
            if i not in self.header:
                self.header[i] = cell['text'].strip()
            else:
                if self.header[i].strip():
                    self.header[i] += ' -> ' + cell['text'].strip()
                else:
                    self.header[i] = cell['text'].strip()

    def add_data(self, cell):
        row = self.data.setdefault(cell['row'], {})
        row[cell['column']] = cell['text'].strip()

    def iter_data_dicts(self):
        for rownum in sorted(self.data):
            row = self.data[rownum]
            obj = []
            for colnum in sorted(row):
                value = row[colnum]
                header_text = self.header.get(colnum, f'column #{colnum}')
                entities = []
                for mobj in search(header_text):
                    entities.append(mobj)
                ventities = []
                for mobj in search(value):
                    ventities.append(mobj)
                obj.append({'attribute': header_text, 'value': value, 'attributeEntities': entities, 'valueEntities': ventities})
            yield obj

class VertTable(Table):

    def add_header(self, cell):
        col = cell['row']
        colspan = cell['rowspan']
        for i in range(col, col + colspan):
            if i not in self.header:
                self.header[i] = cell['text'].strip()
            else:
                if self.header[i].strip():
                    self.header[i] += ' -> ' + cell['text'].strip()
                else:
                    self.header[i] = cell['text'].strip()

    def add_data(self, cell):
        row = self.data.setdefault(cell['column'], {})
        row[cell['row']] = cell['text'].strip()


by_ids = {}
tables = {}
taborder = []
cursor = reclada_con.cursor()
cursor.callproc('api.reclada_object_list', [json.dumps(
    {'class': 'HeaderTerm'}
)])
data2headers = set()
for row in next(cursor)[0]['objects']:
    data2headers.add(row['attributes']['name'])

for row in csv.reader(open(sys.argv[1]), quotechar='\''):
    obj = json.loads(row[0])
    by_ids[obj['GUID']] = obj
    if obj['class'] == 'Table':
        tables[obj['GUID']] = TableSolver()
        taborder.append(obj['GUID'])
    elif obj['class'] == 'Cell':
        table = tables[obj['attributes']['table']]
        obj['attributes']['text'] = obj['attributes']['text'].strip('| \n').strip().strip('| \n')
        if obj['attributes']['text'] in data2headers and obj['attributes']['cellType'] != 'header' and not table.data:
            obj['attributes']['cellType'] = 'header'
        tables[obj['attributes']['table']].add_cell(obj['attributes'])

with open(sys.argv[2], 'w') as outfile:
    writer = csv.writer(outfile, quotechar='\'')

    for tableid in taborder:
        table = tables[tableid]
        for i, dd in enumerate(table.iter_data_dicts()):
            obj = {}
            obj['table'] = tableid
            obj['row'] = i
            objid = str(uuid.uuid4())
            # writer.writerow([json.dumps({'class': 'Data', 'attributes': obj, 'GUID': objid}, indent=4)])
            datarow = {}
            datarow['table'] = tableid
            datarow['row'] = i
            for attr in dd:
                key = attr['attributeEntities']
                if not key:
                    key = [{'name': attr['attribute']}]
                key = key[0]
                if 'concept' in key:
                    key = key['concept']
                elif 'name' in key:
                    key = key['name']
                elif 'dividedByUnit' in key:
                    key = attr['attribute']
                elif 'feature' in key and 'unit' in key:
                    key = attr['attribute']
                    # key = f'{"/".join(key["feature"])} ({"/".join(key["unit"])})'
                else:
                    continue
                value = attr['valueEntities']
                if not value:
                    value = [{'text': attr['value']}]
                value = value[0]
                if 'unit' in value and not value['unit'] and 'amount' in value:
                    value = {'number': value['amount']}
                if attr['attributeEntities']:
                    value['header'] = attr['attributeEntities']
                datarow[key.strip()] = value
                if 'value' not in value:
                    value['value'] = attr['value']
                value['headerText'] = attr['attribute']
                # attr['object'] = objid
                # writer.writerow([json.dumps({'class': 'Attribute', 'GUID': str(uuid.uuid4()), 'attributes': attr}, indent=4, ensure_ascii=False)])
            writer.writerow([json.dumps({'class': 'DataRow', 'attributes': datarow, 'GUID': str(uuid.uuid4())}, indent=4, ensure_ascii=False)])

