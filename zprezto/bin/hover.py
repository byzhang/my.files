#!/usr/bin/env python

"""hover.py: Provides dynamic DNS functionality for Hover.com using their
   unofficial API.
   This script is based off one by Dan Krause:
   https://gist.github.com/dankrause/5585907"""

__author__ = "Benyu Zhang"
__credits__ = ["Andrew Barilla", "Dan Krause"]
__license__ = "GPL"
__version__ = "1.0"
__maintainer__ = "Benyu Zhang"
__email__ = ""
__status__ = "Production"

import os
import requests
import subprocess

# Your hover.com username and password
username = os.environ['HOVER_USERNAME']
password = os.environ['HOVER_PASSWORD']


class HoverException(Exception):
    pass


class HoverAPI(object):

    def __init__(self, username, password):
        params = {"username": username, "password": password}
        r = requests.post("https://www.hover.com/api/login", params=params)
        if not r.ok or "hoverauth" not in r.cookies:
            raise HoverException(r)
        self.cookies = {"hoverauth": r.cookies["hoverauth"]}

    def call(self, method, resource, data=None):
        url = "https://www.hover.com/api/{0}".format(resource)
        r = requests.request(method, url, data=data, cookies=self.cookies)
        if not r.ok:
            raise HoverException(r)
        if r.content:
            body = r.json()
            if "succeeded" not in body or body["succeeded"] is not True:
                raise HoverException(body)
            return body


try:
    ip = subprocess.check_output(
        ["/usr/bin/dig", "+short", "myip.opendns.com", "@resolver1.opendns.com"])
    current_ip = ip.strip()
    # connect to the API using your account
    client = HoverAPI(username, password)
    current = client.call("get", "dns")
    for domain in current.get("domains"):
        for entry in domain["entries"]:
            if entry["type"] == "A" and entry["content"] != current_ip:
                print "put", domain["domain_name"], ":", entry["name"], "->", ip
                client.call(
                    "put", "dns/" + entry["id"], {"content": current_ip})
except subprocess.CalledProcessError, e:
    print e
