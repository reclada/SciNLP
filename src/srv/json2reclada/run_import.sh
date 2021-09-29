#!/bin/sh

# SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
# pushd ${SCRIPT_DIR}
# python3 setup.py install
# popd
# Do NOT set _FSROOT if you have /mnt at your filesystem root
_INPUT_DIR="${_FSROOT}/mnt/input/"
_OUTPUT_DIR="${_FSROOT}/mnt/output/"
mappings_path="${_INPUT_DIR}`basename "$2"`"
echo "Mappings JSON file path set to: ${mappings_path}"
json_src_name=`basename "$3"`
json_src_path="${_INPUT_DIR}${json_src_name}";
echo "JSON source file path set to: ${json_src_path}"
json_out_path="${_OUTPUT_DIR}`basename "${json_src_path%.*}_reclada.csv"`"
echo "JSON CSV output file path set to: ${json_out_path}"
file_url=`python3 -c 'import sys,pathlib; print(pathlib.Path(sys.argv[1]).resolve().as_uri())' "$json_src_path"`
echo "JSON file URL set to: ${file_url}"
json_src_checksum=($(shasum "$json_src_path"))
echo "JSON file checksum: ${json_src_checksum}"
json_src_mimetype=`file -b --mime-type ${json_src_path}`
echo "JSON file MIME type: ${json_src_mimetype}"
DB_URI_QUOTED=`python3 -c "import urllib.parse; parsed = urllib.parse.urlparse('$DB_URI'); print('$DB_URI'.replace(parsed.password, urllib.parse.quote(parsed.password)))"`
file_guid=`psql ${DB_URI_QUOTED} -t -c '
    select api.reclada_object_create(
        '"'"'{
            "class": "File",
            "attributes": {
                "name": "'"${json_src_name}"'",
                "uri": "'"${file_url}"'",
                "checksum": "'"${json_src_checksum}"'",
                "mimeType": "'"${json_src_mimetype}"'"
            }
        }'"'"'
    )
' | python3 -c 'import sys, json; print(json.load(sys.stdin)["GUID"])'`
echo "JSON file db object GUID: ${file_guid}"
transaction_id=`psql ${DB_URI_QUOTED} -t -c '
    select reclada.get_transaction_id_for_import('"'"${file_guid}"'"')
' | python3 -c 'import sys; print(int(sys.stdin.read()))'
`
echo "Transaction id: ${transaction_id}"

python3 -m json2reclada ${mappings_path} ${json_src_path} ${json_out_path} ${transaction_id} ${file_guid}
echo "JSON2Reclada finished converting, output file saved to ${json_out_path}"
cat "${json_out_path}" | psql ${DB_URI_QUOTED} -v "ON_ERROR_STOP=1" -c "\COPY reclada.staging FROM STDIN WITH CSV QUOTE ''''"
if [ $? -ne 0 ]; then
    echo 'COPY to reclada db succeeded';
else
    echo 'COPY to reclada db failed, performing rollback';
    psql ${DB_URI_QUOTED} -t -c 'select reclada.rollback_import('"'"${file_guid}"'"')'
fi;
