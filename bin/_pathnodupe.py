#!/usr/bin/env python
import os

paths = os.getenv("PATH", "").split(":")
print(":".join(list(set(paths))))
