#!/usr/bin/env python
import argparse
import sys
import base64
import json

import yaml


def decode_secret(secret, secret_format="yaml"):
    secret_decoders = {
        "json": json_decode_data_fields,
        "yaml": yaml_decode_data_fields,
        "yml": yaml_decode_data_fields,
    }
    return secret_decoders[secret_format.lower()](secret)


def deduce_secret_format(secret):
    if secret.startswith("{"):
        return "json"
    elif secret.startswith("apiVersion: "):
        return "yaml"


def json_decode_data_fields(secret_json):
    return json.dumps(decode_data_fields(json.loads(secret_json)), indent=2)


def yaml_decode_data_fields(secret_yaml):
    return yaml.safe_dump(decode_data_fields(yaml.safe_load(secret_yaml)), indent=2)


def decode_data_fields(secret):
    decoded_secret = secret.copy()
    if secret.get("data"):
        decoded_data = {}
        for key, value in secret["data"].items():
            decoded_data[key] = decode_data_value(value)
        decoded_secret["data"] = decoded_data
    return decoded_secret


def decode_data_value(encoded_value):
    decoded_value = base64.b64decode(encoded_value).decode()
    try:
        return json.loads(decoded_value)
    except ValueError:
        return decoded_value


def main():
    parser = argparse.ArgumentParser(
        description="Take a kubernetes secret and decode the data fields"
    )
    args = parse_arguments(parser)
    if args.secret:
        secret_string = args.secret.read()
    elif not sys.stdin.isatty():
        secret_string = sys.stdin.read()
    else:
        parser.print_help()
        return 1
    secret_format = args.format or deduce_secret_format(secret_string)
    print(decode_secret(secret_string, secret_format=secret_format))


def parse_arguments(parser: argparse.ArgumentParser):
    parser.add_argument(
        "secret", nargs="?", type=argparse.FileType("r"), default=sys.stdin
    )
    parser.add_argument(
        "--outfile", "-o", nargs="?", type=argparse.FileType("w"), default=sys.stdout
    )
    parser.add_argument(
        "--format", "-f", type=str, help="Format of the secret", required=False
    )
    return parser.parse_args()


if __name__ == "__main__":
    exit(main())
