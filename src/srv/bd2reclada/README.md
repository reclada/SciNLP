# bd2reclada

BadgerDoc JSON to Reclada objects converter

## Installation
```python3 setup.py install```

## Usage
```python3 -m bd2reclada /path/to/document.json /path/to/output.csv```

Then, it can be safely imported to reclada database:
```psql reclada reclada -c "COPY reclada.object FROM '/path/to/output.csv' WITH CSV QUOTE ''''"```
