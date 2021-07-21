import csv
import json
import sys
import pickle
import re
import uuid
import os


with open(os.path.dirname(__file__) + os.sep + 'onto.pickle', 'rb') as f:
    onto = pickle.load(f)

res = [
    (re.compile('onset ?#(?P<no>\d+) for (?P<target>\w+)'), {'concept': lambda match: 'Tonset [Entity] (protein unfolding onset temperature)', 'number': lambda match: int(match.group('no')), 'target': lambda match: match.group('target')}),
    (re.compile('(?P<amount>\d+\.*\d+) *°c'), {'amount': lambda match: float(match.group('amount')), 'unit': lambda match: 'celsius [Entity] (The degree Celsius is a unit of temperature on the Celsius scale.)'}),
    (re.compile('(?P<amount>\d+) +\((?P<percamount>\d+) *%\)'), {'amount': lambda match: int(match.group('amount')), 'unit': lambda match: 'item [Entity] (a distinct object)', 'percents': lambda match: int(match.group('percamount'))}),
    (re.compile('^(?P<amount>\d+)$'), {'amount': lambda match: int(match.group('amount')), 'unit': lambda match: 'item [Entity] (a distinct object)'}),
    (re.compile('^(?P<value>\d+\.\d+)$'), {'value': lambda match: float(match.group('value'))}),
    (re.compile('^(?P<value>\d+,[\d+, ]+)$'), {'value': lambda match: map(int, match.group('value').split(','))}),
    (re.compile('(?P<amount>\d+) +\((?P<percamount>\d\.\d+) *%\)'), {'amount': lambda match: int(match.group('amount')), 'unit': lambda match: 'item [Entity] (a distinct object)', 'percents': lambda match: float(match.group('percamount'))}),
    (re.compile('(?P<amount>\d+) +%'), {'amount': lambda match: int(match.group('amount')), 'unit': lambda match: 'percent [Entity] (one hundredth part)'}),
    (re.compile('^(?P<amount>\d+) *(?P<unit>\w+)$'), {'amount': lambda match: int(match.group('amount')), 'unit': lambda match: list(get_meanings(onto['byword'].get(match.group('unit'), ''))) or [match.group('unit')]}),
    (re.compile('(?P<name>\w+) +\(*(?P<unit>\w+)\)'), {'feature': lambda match: list(get_meanings(onto['byword'].get(match.group('name'), ''))), 'unit': lambda match: list(get_meanings(onto['byword'].get(match.group('unit'), '')))}),
    (re.compile('\(*(?P<unit1>\w+)\/(?P<unit2>\w+)\)'), {'baseUnit': lambda match: list(get_meanings(onto['byword'].get(match.group('unit1'), ''))) or match.group('unit1'), 'dividedByUnit': lambda match: list(get_meanings(onto['byword'].get(match.group('unit2'), ''))) or match.group('unit2')}),
    (re.compile('annotations -> sample id'), {'concept': lambda match: 'protein id (protein or sample identifier)'}),
    (re.compile('capillary'), {'concept': lambda match: 'capillary [Entity] (capillary)'}),
    (re.compile('capillaries'), {'concept': lambda match: 'capillary [Entity] (capillary)'}),
    (re.compile('^(?P<protein>\w\w\w\w\w*\d+\.\d\d\d)$'), {'protein': lambda match: match.group('protein').upper()}),
    (re.compile('ratio ↗ -> ip #(?P<no>\d) -> ⌀'), {'concept': lambda match: 'Tm%(no)s [Entity] (value of Tm%(no)s)' % match.groupdict()}),
    (re.compile('ratio ↗ -> ip #(?P<no>\d) -> σ'), {'concept': lambda match: 'Tm%(no)s σ (deviation of Tm%(no)s)' % match.groupdict()}),
    (re.compile('ratio ↗ -> on -> ⌀'), {'concept': lambda match: 'Tonset [Entity] (protein unfolding onset temperature)' % match.groupdict()}),
    (re.compile('ratio ↗ -> on -> σ'), {'concept': lambda match: 'Tonset σ (protein unfolding onset temperature deviation)' % match.groupdict()}),
    (re.compile('ratio ↗ -> initialvalue -> ⌀'), {'concept': lambda match: 'start [Entity] (initial value)' % match.groupdict()}),
    (re.compile('ratio ↗ -> initialvalue -> σ'), {'concept': lambda match: 'start σ (initial value deviation)' % match.groupdict()}),
    (re.compile('(?P<name>scattering ↗ -> .*)'), {'name': lambda match: match.group('name').replace(' ↗', '').replace(' -> ', ' ')}),
]

#Start	Capillary	Tonset	Tm1	Tm2
def search(t):
    t = t.lower()
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
                header_text = self.header.get(colnum, '?')
                entities = []
                for mobj in search(header_text):
                    entities.append(mobj)
                ventities = []
                for mobj in search(value):
                    ventities.append(mobj)
                obj.append({'attribute': header_text, 'value': value, 'attributeEntities': entities, 'valueEntities': ventities})
            yield obj

by_ids = {}
tables = {}
taborder = []
data2headers = {
    'Sample ID',
    'Analyzed Entity Name',
    'Grouping Criterion',
    'Stress Protocol',
    'Retention Time',
    'Peak Width',
    'PeakRT',
    'PctMain',
    'PctAggregate',
    'PctFragment',
    'Ratio',
    'Risk',
    'StdFile',
    'Signal',
    'Width',
    'PeakHeight',
    'Matrix',
    'SampName',
    'Sample',
    'DataFile',
    'DataPath',
    'ShortSignal',
    'ResulTable',
    u'\u26a0',
    u'\u2300',
    u'\u03c3',
}

for row in csv.reader(open(sys.argv[1]), quotechar='\''):
    obj = json.loads(row[0])
    by_ids[obj['id']] = obj
    if obj['class'] == 'Table':
        tables[obj['id']] = Table()
        taborder.append(obj['id'])
    elif obj['class'] == 'Cell':
        if obj['attrs']['text'].strip() in data2headers and obj['attrs']['row'] == 0:
            obj['attrs']['cellType'] = 'header'
        tables[obj['attrs']['table']].add_cell(obj['attrs'])

with open(sys.argv[2], 'w') as outfile:
    writer = csv.writer(outfile, quotechar='\'')

    for tableid in taborder:
        table = tables[tableid]
        for i, dd in enumerate(table.iter_data_dicts()):
            obj = {}
            obj['table'] = tableid
            obj['row'] = i
            objid = str(uuid.uuid4())
            # writer.writerow([json.dumps({'class': 'Data', 'attrs': obj, 'id': objid}, indent=4)])
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
                else:
                    continue
                value = attr['valueEntities']
                if not value:
                    value = [{'text': attr['value']}]
                value = value[0]
                if 'unit' in value and not value['unit'] and 'amount' in value:
                    value = {'number': value['amount']}
                datarow[key.strip()] = value
                # attr['object'] = objid
                # writer.writerow([json.dumps({'class': 'Attribute', 'id': str(uuid.uuid4()), 'attrs': attr}, indent=4, ensure_ascii=False)])
            writer.writerow([json.dumps({'class': 'DataRow', 'attrs': datarow, 'id': str(uuid.uuid4())}, indent=4, ensure_ascii=False)])

