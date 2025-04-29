#!/usr/bin/env python3
# Copyright (c) 2025 Damien Boisvert (AlphaGameDeveloper)
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

# Utility script to update my dotfiles!
# -- configuration --
GITHUB_REPO = "AlphaGameDeveloper/Dotfiles"
GITHUB_BRANCH = "master"


try:
    import os
    import requests
    import sys
    from pathlib import Path
except ImportError as e:
    print(f"update_dotfiles.py: Dotfiles cannot be updated, because the required packages were not found.")
    print(f"update_dotfiles.py: {e}")
    exit(1)

def printNoNewline(msg, useStderr=False):
    print(msg, end="", flush=True, file=sys.stderr if useStderr else sys.stdout)

# chdir to the script directory
printNoNewline("Getting script directory...  ")
script_dir = Path(__file__).parent.resolve()
os.chdir(script_dir)
print(script_dir)

printNoNewline("Getting current Git commit hash...  ")
try:
    current_commit = os.popen("git rev-parse HEAD").read().strip()
    print(current_commit)
except Exception as e:
    print(f"update_dotfiles.py: Error getting current commit hash: {e}")
    exit(1)

printNoNewline("Getting latest commit hash...  ")
try:
    # Get the latest commit hash from the GitHub repository
    url = f"https://api.github.com/repos/{GITHUB_REPO}/commits/{GITHUB_BRANCH}"
    response = requests.get(url)
    response.raise_for_status()  # Raise an error for bad responses
    latest_commit = response.json()["sha"]
    print(latest_commit)
except requests.RequestException as e:
    print(f"update_dotfiles.py: Error getting latest commit hash: {e}")
    exit(1)

printNoNewline("Do we need to update?  ")
if current_commit == latest_commit:
    print("No. (Script exiting)")
    exit(0)
else:
    print("Yes!")

printNoNewline("An update is available!  Downloading the latest version...\n", useStderr=True)
printNoNewline("Running 'git pull'...  ")
try:
    os.system("git pull 2>&1 > /dev/null")
    print("Done.")
except Exception as e:
    print(f"update_dotfiles.py: Error running 'git pull': {e}")
    exit(1)

printNoNewline("Checking if 'git pull' was successful...  ")
try:
    # Check if the current commit hash has changed
    new_commit = os.popen("git rev-parse HEAD").read().strip()
    if new_commit == current_commit:
        print("No changes detected.")
        exit(0)
    else:
        print("Changes detected.")
except Exception as e:
    print(f"update_dotfiles.py: Error checking for changes: {e}")
    exit(1)

printNoNewline("You're all set!  Have fun!\n", useStderr=True)