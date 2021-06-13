#!/usr/bin/python3

import json
import urllib.request
import yaml
import time

data = yaml.load(open('data.yml', 'r'))
ueplugins = []
github_user = 'drichardson'
github_access_token = None

def github_authenticate():
    print("Authenticating with github")
    # https://docs.github.com/en/developers/apps/building-oauth-apps/authorizing-oauth-apps#device-flow
    post_data = json.dumps({
        'client_id': github_user,
        # https://docs.github.com/en/developers/apps/building-oauth-apps/scopes-for-oauth-apps
        'scope': 'public_repo'
        }).encode('utf-8')
    print('posting: ' + str(post_data))
    r = urllib.request.Request('https://github.com/login/device/code', data=post_data)
    with urllib.request.urlopen(r) as f:
        res=json.load(f.read().decode('utf-8'))
        print('Goto URL and enter verification code')
        print('    URL: ' + res['verification_uri'])
        print('   code: ' + res['verification_code'])
        interval=res['interval']

        # Poll for result
        access_token = None
        while access_token is None:
            print('sleeping for {} seconds before checking...'.format(interval))
            time.sleep(interval)
            poll_data = json.dump({
                'client_id': github_user,
                'device_code': res['verification_code'],
                'grant_type': 'urn:ietf:params:oauth:grant-type:device_code'
                }).encode('utf-8')
            r = urllib.request.Request('https://github.com/login/oauth/access_token', data=poll_data)
            print('checking for token')
            with urllib.request.urlopen(r) as f:
                token=json.load(f.read().decode('utf-8'))
                access_token=token['access_token']

        print('Got access token {}'.format(access_token))
        return access_token

def add_ueplugin(name, description, url):
    entry = {
        'name': name,
        'description' : description,
        'url' : url }
    print('Adding plugin ' + name)
    ueplugins.append(entry)

def fetch_github_repos():
    for repo_name in data['ueplugins']['github']:
        url = 'https://api.github.com/repos/' + repo_name
        print("Repo is {}, url={}".format(repo_name, url))
        req = urllib.request.Request(url)
        req.add_header('Accept', 'application/vnd.github.v3+json')
        req.add_header('Authorization', github_access_token)
        with urllib.request.urlopen(req) as f:
            body = f.read()
            repo = json.loads(body.decode('utf-8'))
            if repo['fork']:
                raise Exception('Repository is a fork. Only use sources. ' + repo_name)
            add_ueplugin(repo['name'], repo['description'], repo['html_url'])

def fetch_gitlab_repos():
    print('gitlab not implemented')

def update_ueplugin_data_file():
    with open('site/_data/ueplugins.yml', 'w') as f:
        f.write(yaml.dump(ueplugins))


github_access_token = github_authenticate()
fetch_github_repos()
fetch_gitlab_repos()
update_ueplugin_data_file()
