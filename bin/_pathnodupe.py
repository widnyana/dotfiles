#!/usr/bin/env python
import os

paths = os.getenv("PATH").split(":")
paths = sorted(set(paths), reverse=False)
print(":".join(paths))
