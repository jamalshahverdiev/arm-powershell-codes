#!/bin/bash

if [ $# != 1 ]
then
    echo "Usage: ./$(basename $0) domain.name"
    exit 122
fi

cat <<EOF >> /etc/named.conf
zone "$1" IN {
        type slave;
        masters {10.234.100.58;};
        file "/var/named/slaves/db.$1.zone";
};
EOF

systemctl restart named