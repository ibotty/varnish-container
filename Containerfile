ARG PARENT_IMAGE=registry.access.redhat.com/ubi9
FROM $PARENT_IMAGE

VOLUME /var/lib/varnish

# this has to be specified again after "FROM"
ARG PARENT_IMAGE
ARG VARNISH_VERSION=6.0lts

EXPOSE 8080

LABEL io.k8s.description="Varnish" \
      io.k8s.display-name="Varnish" \
      io.openshift.expose-services="8080:http" \
      maintainer="Tobias Florek <tob@butter.sh>" \
      summary="Varnish" \
      description="Varnish caching proxy" \
      version="$VARNISH_VERSION" \
      name="quay.io/ibotty/varnish" \
      parent_image=$PARENT_IMAGE

ADD varnishcache_varnish-$VARNISH_VERSION.repo /etc/yum.repos.d

RUN dnf install -y varnish-${VARNISH_VERSION/lts}* \
 && dnf clean all

USER 993
WORKDIR /var/lib/varnish
ENTRYPOINT ["/usr/sbin/varnishd"]
CMD ["-F", "-a", ":8080", "-p", "feature=+http2", "-f", "/etc/varnish/default.vcl", "-s", "malloc,256m"]
