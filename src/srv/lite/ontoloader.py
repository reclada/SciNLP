from lxml import etree
import sys
import pickle

onto = {}
byword = {}
for path in sys.argv[1:]:
    for concept in etree.parse(path).iter('concept'):
        name = concept.get('name')
        attrs = []
        for attr in concept.iter('attr'):
            attrs.append({'rel': attr.get('rel'), 'obj': attr.get('obj')})
        onto[name] = attrs
        if '[' in name and '(' not in name:
            byword.setdefault(name.split(' ', 1)[0], []).append(name)
            
with open('onto.pickle', 'wb') as f:
    pickle.dump({'onto': onto, 'byword': byword}, f)
