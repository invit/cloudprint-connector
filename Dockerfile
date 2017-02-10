FROM ubuntu:16.04

MAINTAINER Toni Rudolf <toni.rudolf@weekend4two.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y \
    && apt-get install -y \
    build-essential \
    cups \
    cups-pdf \
    libcups2 \
    libcups2-dev \
    libavahi-client3 \
    libavahi-client-dev \
    avahi-daemon \
    libsnmp30 \
    libsnmp-dev \
    git \
    bzr \
    golang \
    whois \
    supervisor \
    wget \
    printer-driver-dymo \
    hplip

RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# install needed evolis print driver
RUN wget http://us.evolis.com/sites/default/files/atoms/files/evolisprinter-4.12.8.8.amd64.deb && \
    dpkg -i evolisprinter-4.12.8.8.amd64.deb && \
    rm evolisprinter-4.12.8.8.amd64.deb

COPY Unified_Zebra_ZXP3_Series_Card_Printer_Driver-1.0.0.0-Ubuntu_Linux-x86_64-Install.tar.gz /root/Unified_Zebra_ZXP3_Series_Card_Printer_Driver-1.0.0.0-Ubuntu_Linux-x86_64-Install.tar.gz

RUN tar -xvf /root/Unified_Zebra_ZXP3_Series_Card_Printer_Driver-1.0.0.0-Ubuntu_Linux-x86_64-Install.tar.gz --directory /root
RUN chmod +x /root/Unified_Zebra_ZXP3_Series_Card_Printer_Driver-1.0.0.0-Ubuntu_Linux-x86_64-Install
RUN /root/Unified_Zebra_ZXP3_Series_Card_Printer_Driver-1.0.0.0-Ubuntu_Linux-x86_64-Install --mode silent

ENV GOPATH /root/go
RUN go get github.com/google/cups-connector/...

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY start.sh /start.sh

EXPOSE 631

ENTRYPOINT ["/start.sh"]

CMD ["/usr/bin/supervisord", "--nodaemon"]
