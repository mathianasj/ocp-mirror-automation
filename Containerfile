FROM registry.access.redhat.com/ubi9/ubi

WORKDIR /home/cmirror


COPY ansible /home/cmirror/ansible
COPY create-agent-iso.sh /usr/bin

CMD ["ansible-playbook", "-i", "./inventory", "./ansible/configure-mirror.yaml"]
