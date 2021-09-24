# json2reclada

Hierarchical JSON to Reclada objects converter

## Installation
```python3 setup.py install```

## Usage
```python3 -m json2reclada /path/to/mapping.json /path/to/document.json /path/to/output.csv [transactionId]```

Then, it can be safely imported to reclada database:
```psql reclada reclada -c "COPY reclada.staging FROM '/path/to/output.csv' WITH CSV QUOTE ''''"```
