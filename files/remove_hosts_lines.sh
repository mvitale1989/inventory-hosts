#!/bin/bash
set -e

cd $(dirname $0)
IH_SIGNATURE=$(grep "ih_signature" ../defaults/main.yml | cut -d\" -f2)
ansible all --become-method=sudo -m raw -a "sed -i"_bak" '/${IH_SIGNATURE}/d' /etc/hosts"
