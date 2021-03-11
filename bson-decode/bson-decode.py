#!/usr/bin/env python3

import bsonjs
import os
import sys
import json

if len(sys.argv) < 2:
    print("Missing argument")
    print(f"Usage : {os.path.basename(sys.argv[0])} <bson_file>")
    exit(-1)

bson_file_path = sys.argv[1]
#json_file_path = bson_file_path.split('.')[0]+".json"
print(f"Converting {bson_file_path}\n")

with open(bson_file_path, "rb") as bson_file:
    #print(f"opening{bson_file_path}\n")
    bson_bytes=bson_file.read()

beson_string=bsonjs.dumps(bson_bytes)
# beson_string.replace("\'","\"")
# print(beson_string)
json_formatted = json.loads(beson_string)
json_formatted["pcap"]["$binary"]="<REMOVED>"

print(str(json_formatted))