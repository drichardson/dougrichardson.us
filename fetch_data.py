#!/usr/bin/python3

import yaml
import time
import os
from github import Github


def make_ueplugin_entry(name, description, url):
    return {
            'name': name,
            'description' : description,
            'url' : url
            }

def update_ueplugins():
    UEPLUGINS_INPUT = 'data.yml'
    UEPLUGINS_OUTPUT = 'site/_data/ueplugins.yml'

    print(f"Loading {UEPLUGINS_INPUT}")
    data = yaml.load(open(UEPLUGINS_INPUT, 'r'))
    ueplugins = []

    github_username = os.environ['GITHUB_USERNAME']
    github_token = os.environ['GITHUB_TOKEN']

    if github_username is None:
        raise Exception("GITHUB_USERNAME environment variable unset.")

    if github_token is None:
        raise Exception("GITHUB_TOKEN environment variable unset")

    gh = Github(github_token)

    print("Processing github repos")
    for repo_name in data['ueplugins']['github']:
        print(f"Fetching github repo {repo_name}")
        repo = gh.get_repo(repo_name)
        print(f"repo is {repo}")
        print(f"Repo is {repo_name}, url={repo.html_url}")
        entry = make_ueplugin_entry(repo.name, repo.description, repo.html_url)
        ueplugins.append(entry)

    print(f'Writing to {UEPLUGINS_OUTPUT}')
    with open(UEPLUGINS_OUTPUT, 'w') as f:
        f.write(yaml.dump(data=ueplugins, default_flow_style=False, sort_keys=False))

    print('Finished')


update_ueplugins()
