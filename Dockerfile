FROM debian:sid
MAINTAINER Alexandre De Dommelin "adedommelin@tuxz.net"


ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update


# Install python deps
RUN apt-get install -y python-pip python-usb python-requests wget

WORKDIR /tmp
RUN wget -qO - https://github.com/walac/pyusb/archive/1.0.0b1.tar.gz | tar xz
RUN cd pyusb-1.0.0b1; python setup.py install


# Download galileo
WORKDIR /tmp
RUN wget -qO - https://bitbucket.org/benallard/galileo/get/dc995eee36b4.tar.gz | tar xz

# Fix issue #41 until pyusb 1.0.0b2
WORKDIR /tmp/benallard-galileo-dc995eee36b4
RUN sed -i 's/data = self.dev.read(0x82, length, self.CtrlIF.bInterfaceNumber,/data = self.dev.read(0x82, length,/' galileo/dongle.py
RUN sed -i 's/data = self.dev.read(0x81, DM.LENGTH, self.DataIF.bInterfaceNumber,/data = self.dev.read(0x81, DM.LENGTH,/' galileo/dongle.py
RUN sed -i 's/self.dev.write(0x02, msg.asList(), self.CtrlIF.bInterfaceNumber,/self.dev.write(0x02, msg.asList(),/' galileo/dongle.py
RUN sed -i 's/self.dev.write(0x01, msg.asList(), self.CtrlIF.bInterfaceNumber,/self.dev.write(0x01, msg.asList(),/' galileo/dongle.py

# Install galileo
RUN python setup.py install

