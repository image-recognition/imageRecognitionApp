from requests import exceptions
import requests
import argparse
import cv2
import os

# Building an argument parser that will enable us to specify all the requirements by using the termainal window
# -o --output: It is used to specify the path to the dataset folder from where the images will be saved
# -q --query: It is used to specify the query that needs to be searched
argument_parser = argparse.ArgumentParser()
argument_parser.add_argument('-o', '--output',
                             required=True,
                             help="response to search using the Bing Search API")
argument_parser.add_argument('-q', '--query',
                             required=True,
                             help="query to search using the Bing Search API")
parser = vars(argument_parser.parse_args())

# API_KEY: key for bing search api not included because of privacy reasons
# MAX_RESULTS: maximum number of results that need to be parsed
# GROUP_SIZE: size of each page that will be loaded
# URL: URL of the api to be used for search
API_KEY = "Super Secret API KEY"
MAX_RESULTS = 500
GROUP_SIZE = 50
URL = "https://api.cognitive.microsoft.com/bing/v7.0/images/search"

# Defining all exceptions that might occur while parsing these requests and making sure they are handeled gracefully
EXCEPTIONS = {IOError, FileNotFoundError, exceptions.RequestException, exceptions.HTTPError, exceptions.ConnectionError,
              exceptions.Timeout}

# saving the contants into local variables 
term = parser["query"]
headers = {"Ocp-Apim-Subscription-Key": API_KEY}
params = {"q": term, "offset": 0, "count": GROUP_SIZE}

# requesting results on the query
print("Searching Using the BING API for '{}'".format(term))
search = requests.get(URL, headers=headers, params=params)
search.raise_for_status()

# reciving resuts and parising only MAX_RESULTS number of images
result = search.json()
number_of_results = min(result["totalEstimatedMatches"], MAX_RESULTS)
print("Total results: {} for query '{}'".format(number_of_results, term))

total_results = 0
# gracefully taking the query results and saving them into the folder that was specified in the query
# Any files that were corrupt were deleted
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
