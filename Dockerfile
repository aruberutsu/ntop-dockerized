FROM quay.io/almalinuxorg/8-minimal as builder
COPY src /src
RUN microdnf -y update && \
    sed -z -i 's/enabled=0/enabled=1/' /etc/yum.repos.d/almalinux-powertools.repo && \
    curl -o /dev/shm/epel-release-latest-8.noarch.rpm \
        https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm && \
    rpm -ivh /dev/shm/epel-release-latest-8.noarch.rpm && \
    microdnf -y install gcc make patch libtool automake autoconf python2-devel libpcap-devel gdbm-devel zlib-devel geoip-devel graphviz-devel rrdtool rrdtool-devel openssl-devel && \
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
    patch -p1 < ../9994-no-wget-svn.patch && \
    patch -p1 < ../9995-no-version-check.patch && \
    patch -p1 < ../9996-no-version-check.patch && \
    patch -p1 < ../9997-nDPI-make-j.patch && \
    patch -p1 < ../9998-ntop-3.3-verchk.patch && \
    ldconfig && cd /src/ntop-5.0.1 && cat MANIFESTO && ./autogen.sh && \
    make -j$(nproc) && \
    make install && \
    mv /usr/local/etc/ntop/GeoIPASNum.dat /usr/local/var/ntop && \
    mv /usr/local/etc/ntop/GeoLiteCity.dat /usr/local/var/ntop && \
    ln -s /usr/local/var/ntop/GeoIPASNum.dat /usr/local/etc/ntop/GeoIPASNum.dat && \
    ln -s /usr/local/var/ntop/GeoLiteCity.dat /usr/local/etc/ntop/GeoLiteCity.dat && \
    microdnf clean all && \
    rm -rf /src && chown root:nobody /usr/local/var/ntop && chmod 775 /usr/local/var/ntop

FROM quay.io/almalinuxorg/8-minimal
RUN microdnf -y update && \
    curl -o /dev/shm/epel-release-latest-8.noarch.rpm \
        https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm && \
    rpm -ivh /dev/shm/epel-release-latest-8.noarch.rpm && \
    microdnf -y install python2 libpcap gdbm zlib geoip graphviz rrdtool openssl && \
    alternatives --set python /usr/bin/python2 && \
    ln -s /usr/bin/python2-config /usr/bin/python-config && \
    ln -s /usr/lib64/librrd.so /usr/lib64/librrd_th.so && \
    microdnf clean all

COPY --from=builder /usr/local /usr/local
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
