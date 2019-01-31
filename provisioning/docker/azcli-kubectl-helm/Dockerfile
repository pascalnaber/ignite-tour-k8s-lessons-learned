FROM microsoft/azure-cli

ENV KUBECTL_VERSION="v1.13.1"
ENV HELM_VERSION="v2.12.1"

RUN apk add --update ca-certificates \
&& apk add --update -t deps curl \
&& curl -L https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl \
&& chmod +x /usr/local/bin/kubectl \
&& apk del --purge deps \
&& rm /var/cache/apk/* \
&& wget -q https://storage.googleapis.com/kubernetes-helm/helm-${HELM_VERSION}-linux-amd64.tar.gz -O - | tar -xzO linux-amd64/helm > /usr/local/bin/helm \
&& chmod +x /usr/local/bin/helm

CMD bash