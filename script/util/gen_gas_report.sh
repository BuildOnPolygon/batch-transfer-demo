#!/bin/bash

###############################################################
# This script generates a gas report for the simulation tests.
# Logs are decoded and saved in a JSON file.
###############################################################

set -ex

JSON_FILE="gas-report.json"

forge test --isolate --json | jq '.["test/Simulation.t.sol:Simulation"].test_results | map_values(.decoded_logs)' >$JSON_FILE
