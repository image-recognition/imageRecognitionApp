from requests import exceptions
import requests
import argparse
import cv2
import os

argument_parser = argparse.ArgumentParser()
argument_parser.add_argument('-o', '--output',
                             required=True,
                             help="response to search using the Bing Search API")
argument_parser.add_argument('-q', '--query',
                             required=True,
                             help="query to search using the Bing Search API")
parser = vars(argument_parser.parse_args())

API_KEY = "67c5fc9c7eff4705a55807f0edc8b355"
MAX_RESULTS = 500
GROUP_SIZE = 50
URL = "https://api.cognitive.microsoft.com/bing/v7.0/images/search"

EXCEPTIONS = {IOError, FileNotFoundError, exceptions.RequestException, exceptions.HTTPError, exceptions.ConnectionError,
              exceptions.Timeout}

term = parser["query"]
headers = {"Ocp-Apim-Subscription-Key": API_KEY}
params = {"q": term, "offset": 0, "count": GROUP_SIZE}

print("Searching Using the BING API for '{}'".format(term))
search = requests.get(URL, headers=headers, params=params)
search.raise_for_status()

result = search.json()
number_of_results = min(result["totalEstimatedMatches"], MAX_RESULTS)
print("Total results: {} for query '{}'".format(number_of_results, term))

total_results = 0
for offset in range(0, number_of_results, GROUP_SIZE):
    print("Request for group {}-{}........".format(offset, offset + GROUP_SIZE))
    params["offset"] = offset
    search = requests.get(URL, headers=headers, params=params)
    search.raise_for_status()
    result = search.json()
    print("Saving results for group {}-{}........".format(offset, offset + GROUP_SIZE))
    for value in result["value"]:
        try:
            print("Fetching {}.......".format(value["contentUrl"]))
            req_result = requests.get(value["contentUrl"], timeout=30)

            ext = value["contentUrl"][value["contentUrl"].rfind("."):]
            path = os.path.sep.join([parser["output"], "{}{}".format(
                str(total_results).zfill(8), ext)])

            f = open(path, "wb")
            f.write(req_result.content)
            f.close()

        except Exception as exception:
            if type(exception) in EXCEPTIONS:
                print("Skipping {}.......".format(value['contentUrl']))
                continue
        image = cv2.imread(path)
        if image is None:
            print("Deleting Image: {}".format(path))
            os.remove(path)
            continue
        total_results += 1
