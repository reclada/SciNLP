def get_obj_type(obj):
    if 'doc_name' in obj:
        return 'document'
    if 'page_num' in obj:
        return 'page'
    if 'left' in obj:
        return 'bBox'
    if 'type' in obj:
        obj_type = obj.pop('type')
        if obj_type == 'text_block':
            return 'textBlock'
        if obj_type == 'table':
            for cell in obj['header']:
                cell['cellType'] = 'header'
            for cell in obj['cells']:
                cell['cellType'] = 'data'
            return 'table'
        raise TypeError(f'Unknown BadgerDoc type {obj_type}')
    if 'row' in obj:
        return 'cell'

field_names = {
    ('document', 'doc_name'): 'name',
    ('page', 'page_num'): 'number',
}
