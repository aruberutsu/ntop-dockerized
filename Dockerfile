FROM almalinux/almalinux:8 as builder
COPY entrypoint.sh /entrypoint.sh
COPY src /src
RUN dnf -y update && \
    dnf -y groupinstall "Development tools" && \
    dnf -y config-manager --set-enabled powertools && \
    dnf -y install epel-release && \
    dnf -y install patch libtool automake autoconf python2-devel libpcap-devel gdbm-devel zlib-devel geoip-devel graphviz-devel rrdtool rrdtool-devel openssl-devel subversion wget && \
    alternatives --set python /usr/bin/python2 && \
    ln -s /usr/bin/python2-config /usr/bin/python-config && \
    ln -s /usr/lib64/librrd.so /usr/lib64/librrd_th.so && \
    cd /src/ntop-5.0.1 && \
    patch -p1 < ../ntop_configure_in.patch && \
    patch -p1 < ../ntop_init.patch && \
    patch -p1 < ../ntop_webInterface.patch && \
    patch -p1 < ../ntop_configure_in_net_snmp_config_exist.patch && \
    patch -p1 < ../use-static-inline.patch && \
    patch -p1 < ../0001-nDPI-Include-sys-types.h.patch && \
    patch -p1 < ../0001-plugins-Makefile.am-fix-for-automake-1.16.1.patch && \
    patch -p1 < ../fix-missing-return-from-non-void-function.patch && \
    patch -p1 < ../embed-libs.patch && \
    patch -p1 < ../9998-ntop-3.3-verchk.patch && \
    patch -p1 < ../9999-python-config.patch && \
    ldconfig && cd /src/ntop-5.0.1 && cat MANIFESTO && ./autogen.sh && \
    make && \
    make install && \
    dnf -y grouperase "Development tools" && \
    dnf clean all && \
    rm -rf /src && chmod +x /entrypoint.sh && chown root:nobody /usr/local/var/ntop && chmod 775 /usr/local/var/ntop

FROM almalinux/8-minimal
RUN microdnf -y update && \
    microdnf -y install epel-release && \
    microdnf -y install python2 libpcap gdbm zlib geoip graphviz rrdtool openssl wget && \
    alternatives --set python /usr/bin/python2 && \
    ln -s /usr/bin/python2-config /usr/bin/python-config && \
    ln -s /usr/lib64/librrd.so /usr/lib64/librrd_th.so && \
    microdnf clean all

COPY --from=builder /usr/local /usr/local
COPY --from=builder /entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
