#!/usr/bin/env bash

kubectl get deployment $@ -o yaml | kubectl neat