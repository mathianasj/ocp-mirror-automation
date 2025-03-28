FROM registry.access.redhat.com/ubi9/ubi

WORKDIR /home/cmirror

RUN curl -LO https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/stable/openshift-client-linux-amd64-rhel9.tar.gz && \
	curl -LO https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/latest/oc-mirror.rhel9.tar.gz && \
	curl -LO https://mirror.openshift.com/pub/cgw/mirror-registry/latest/mirror-registry-amd64.tar.gz

RUN tar -xvzf openshift-client-linux-amd64-rhel9.tar.gz && \
	tar -xvzf oc-mirror.rhel9.tar.gz && \
	mv kubectl /usr/bin && \
	mv oc /usr/bin && \
	mv oc-mirror /usr/bin && chmod +x /usr/bin/oc-mirror

RUN oc mirror -c /home/cmirror/imagesetconfig.yaml file:///home/cmirror/oc-mirrors --v2 && \
	rm -rf oc-mirrors/working-dir && \
	rm -rf /home/cmirror/oc-mirrors/working-dir && \
	rm -rf /root/.oc-mirror && \
	rm -rf /var/lib/containers

RUN dnf install -y ansible-core

ENV HOME=/home/cmirror

RUN curl -LO https://www.rpmfind.net/linux/fedora/linux/releases/41/Everything/x86_64/os/Packages/a/acl-2.3.2-2.fc41.x86_64.rpm

COPY ansible /home/cmirror/ansible
COPY imagesetconfig.yaml /home/cmirror

CMD ["ansible-playbook", "-i", "./inventory", "./ansible/configure-mirror.yaml"]
