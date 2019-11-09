FROM madhacking/gentoo-testrunner:latest

COPY smi.conf /etc/smi.conf
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
