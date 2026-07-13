#!/usr/bin/env python3
import os

paths = os.getenv("PATH", "").split(":")
print(":".join(dict.fromkeys(paths)))
