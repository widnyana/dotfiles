#!/usr/bin/env bash
#──────────────────────────────────────────────────────────────────────────────
# Damarseta · Infrastructure with Intent. Aligned. Reliable.
# Copyright (c) 2025 wid@damarseta.id · https://damarseta.id
#──────────────────────────────────────────────────────────────────────────────
# Context: Verification test
# Purpose: Testing gitignore support


kubectl get deployment $@ -o yaml | kubectl neat