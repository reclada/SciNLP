# json2reclada

Hierarchical JSON to Reclada objects converter

## Installation
```python3 setup.py install```

## Usage
```python3 -m json2reclada /path/to/mapping.json /path/to/document.json /path/to/output.csv  [-h] [-t TRANSACTIONID] [-g GUID]```
```
positional arguments:
  mapping               Path to the JSON file containing Mapping
  input                 Path to the Input JSON file
  output                Path to the Output CSV file

optional arguments:

  -h, --help            show this help message and exit
  -t TRANSACTIONID, --transactionId TRANSACTIONID
                        ID of transaction
  -g GUID, --guid GUID  GUID of object
```

Then, it can be safely imported to reclada database:
```psql reclada reclada -c "COPY reclada.staging FROM '/path/to/output.csv' WITH CSV QUOTE ''''"```
