FROM salma22/jenkinswithdocker
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg |  apt-key add -
RUN echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" |  tee -a /etc/apt/sources.list.d/kubernetes.list
RUN  apt-get update
RUN  apt-get install -y kubectl