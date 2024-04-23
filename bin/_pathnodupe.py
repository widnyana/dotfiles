#!/usr/bin/env python3
import os
paths = os.getenv('PATH').split(':')
paths = sorted(set(paths), reverse=True)
print(":".join(paths))
