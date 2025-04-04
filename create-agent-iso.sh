#!/bin/bash

mkdir -p /home/cmirror/cluster-config
cp install-config.yaml /home/cmirror/cluster-config/
cp agent-config.yaml /home/cmirror/cluster-config/

ansible-playbook -i ./inventory ./ansible/create-agent.yaml
