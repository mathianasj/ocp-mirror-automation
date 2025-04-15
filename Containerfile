FROM registry.access.redhat.com/ubi9/ubi

WORKDIR /home/cmirror

RUN curl -LO https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/stable/openshift-client-linux-amd64-rhel9.tar.gz && \
	curl -LO https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/latest/oc-mirror.rhel9.tar.gz && \
	curl -LO https://mirror.openshift.com/pub/cgw/mirror-registry/latest/mirror-registry-amd64.tar.gz && \
        curl -LO https://github.com/mikefarah/yq/releases/download/v4.45.1/yq_linux_amd64.tar.gz && \
        tar -xvzf yq_linux_amd64.tar.gz && \
        mv yq_linux_amd64 /usr/bin/yq

RUN tar -xvzf openshift-client-linux-amd64-rhel9.tar.gz && \
	tar -xvzf oc-mirror.rhel9.tar.gz && \
	mv kubectl /usr/bin && \
	mv oc /usr/bin && \
	mv oc-mirror /usr/bin && chmod +x /usr/bin/oc-mirror

RUN dnf install -y ansible-core nmstate

ENV HOME=/home/cmirror

COPY imagesetconfig.yaml /home/cmirror/

RUN oc mirror -c /home/cmirror/imagesetconfig.yaml file:///home/cmirror/oc-mirrors --v2 && \
	rm -rf oc-mirrors/working-dir && \
	rm -rf /home/cmirror/oc-mirrors/working-dir && \
	rm -rf /home/cmirror/.oc-mirror && \
	rm -rf /var/lib/containers

RUN export RELEASE_IMAGE=$(curl -Ls https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/4.18.2/release.txt | grep 'Pull From: quay.io' | awk -F ' ' '{print $3}') && \
	oc adm release extract --registry-config /home/cmirror/.docker/config.json --command=openshift-install --to "/usr/bin" ${RELEASE_IMAGE}

RUN curl -LO https://github.com/mikefarah/yq/releases/download/v4.45.1/yq_linux_amd64.tar.gz && \
	tar -xvzf yq_linux_amd64.tar.gz && \
	mv yq_linux_amd64 /usr/bin/yq

COPY ansible /home/cmirror/ansible
COPY create-agent-iso.sh /usr/bin

CMD ["ansible-playbook", "-i", "./inventory", "./ansible/configure-mirror.yaml"]
