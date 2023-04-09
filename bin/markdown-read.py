#!/usr/bin/env python3

"""
pip3 install rich
"""

import argparse
import sys
from rich.console import Console
from rich.markdown import Markdown

console = Console()

def display_md():
    parser = argparse.ArgumentParser(description='Read MD file')
    parser.add_argument('-m','--markdown', help='md file name',required=True)
    args = parser.parse_args()
    markdown = args.markdown
    with open(markdown, "r+") as mfile:
        console.print(Markdown(mfile.read()))
    sys.exit(0)
   

if __name__ == "__main__":
    display_md()
