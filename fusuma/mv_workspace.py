#!/usr/bin/python

import os,sys

if __name__ == "__main__":
    current_workspace = os.popen("wmctrl -d | grep '*' | cut -d ' ' -f1").read()

    if sys.argv[1] == "left":
        os.popen(f"wmctrl -s {int(current_workspace) - 1}")
    elif sys.argv[1] == "right":
        os.popen(f"wmctrl -s {int(current_workspace) + 1}")
    else:
        print("ERROOOOR!!!!")
