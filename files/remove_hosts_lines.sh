#!/bin/bash
set -e

cd $(dirname $0)
IH_SIGNATURE=$(tail -n1 ../defaults/main.yml | cut -d\" -f2)
ansible all -m raw -a "sed -i"_bak" '/${IH_SIGNATURE}/d' /etc/hosts"
