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
