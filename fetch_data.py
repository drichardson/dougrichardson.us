#!/usr/bin/env python

import github
import gitlab
import os
import time
import yaml


def make_ueplugin_entry(name, description, url):
    return {
            'name': name,
            'description' : description,
            'url' : url
            }

def required_env(name):
    val = os.environ[name]
    if val is None:
        raise Exception(f'Environment variable {name} is not set')
    return val

def update_ueplugins():
    UEPLUGINS_INPUT = 'data.yml'
    UEPLUGINS_OUTPUT = 'site/_data/ueplugins.yml'

    GITHUB_TOKEN = required_env('GITHUB_TOKEN')
    GITLAB_TOKEN = required_env('GITLAB_TOKEN')

    print(f'Loading {UEPLUGINS_INPUT}')
    data = yaml.load(open(UEPLUGINS_INPUT, 'r'), Loader=yaml.FullLoader)
    ueplugins = []

    print('Processing github repos')
    gh = github.Github(GITHUB_TOKEN)
    for repo_name in data['ueplugins']['github']:
        print(f'Fetching github repo {repo_name}')
        repo = gh.get_repo(repo_name)
        entry = make_ueplugin_entry(repo.name, repo.description, repo.html_url)
        ueplugins.append(entry)

    print('Processing gitlab repos')
    gl = gitlab.Gitlab('https://gitlab.com', private_token=GITLAB_TOKEN)
    for repo_id in data['ueplugins']['gitlab']:
        print(f'Fetching gitlab repo {repo_id}')
        p = gl.projects.get(repo_id)
        entry = make_ueplugin_entry(p.name, p.description, p.web_url)
        ueplugins.append(entry)

    print(f'Writing to {UEPLUGINS_OUTPUT}')
    with open(UEPLUGINS_OUTPUT, 'w') as f:
        f.write(yaml.dump(data=ueplugins, default_flow_style=False, sort_keys=False))

    print('Finished')


update_ueplugins()
