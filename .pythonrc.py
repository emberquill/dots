import json

def pprint(dictionary, indent=4):
    print(json.dumps(dictionary, indent=indent, default=str))
