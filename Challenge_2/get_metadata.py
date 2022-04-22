import requests
import json

metadata_url = 'http://169.254.169.254/latest/'


def instance_metadata(url, form_url):
    output = {}
    for item in form_url:
        full_url = url + item
        r = requests.get(full_url)
        text = r.text
        if item[-1] == "/":
            list_of_values = r.text.splitlines()
            output[item[:-1]] = instance_metadata(full_url, list_of_values)
        elif is_json(text):
            output[item] = json.loads(text)
        else:
            output[item] = text
    return output


def get_metadata():
    path = ["meta-data/"]
    result = instance_metadata(metadata_url, path)
    return result


def get_metadata_json():
    metadata = get_metadata()
    metadata_json = json.dumps(metadata, indent=4, sort_keys=True)
    return metadata_json


def is_json(myjson):
    try:
        json.loads(myjson)
    except ValueError:
        return False
    return True


if __name__ == '__main__':
    print(get_metadata_json())