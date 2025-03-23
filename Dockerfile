FROM ubuntu 

RUN apt-get update && apt-get install -y \
    sudo \
    openssh-server 

RUN useradd -m ctfuser && echo 'ctfuser:password' | chpasswd
RUN echo 'ctfuser ALL=(ALL) SETENV: NOPASSWD: /usr/bin/python3 /opt/scripts/vulnerable_script.py' >> /etc/sudoers

RUN service ssh start
RUN mkdir -p /opt/scripts

COPY vulnerable_script.py /opt/scripts/vulnerable_script.py

EXPOSE 22

RUN echo "CTF{this_is_the_flag}" > /root/flag.txt

CMD ["/usr/sbin/sshd", "-D"]

