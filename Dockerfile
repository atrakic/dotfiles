FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=xterm-256color
ENV EDITOR=/usr/bin/vim

# Base packages
RUN apt-get update -yqq \
  && apt-get install -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confnew" \
  --no-install-recommends --no-install-suggests -yq \
  apt-transport-https \
  ca-certificates \
  gnupg \
  gnupg-agent \
  software-properties-common \
  gettext-base \
  openssl \
  wget \
  curl \
  locales 

ENV LANG="en_GB.UTF-8" LC_ALL="en_GB.UTF-8" LANGUAGE="en_GB.UTF-8"
RUN echo "en_GB.UTF-8 UTF-8" > /etc/locale.gen && \
  locale-gen --purge $LANG && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=$LANG LC_ALL=$LC_ALL LANGUAGE=$LANGUAGE

ENV TZ 'Europe/Copenhagen'
RUN echo $TZ > /etc/timezone && \
    rm /etc/localtime && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
  apt-get install -y nodejs && \
  npm install -g typescript aws-cdk --force

RUN curl -sL https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add && \
  apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"

# Common packages
ADD ubuntu/packages.txt /tmp/packages.txt
RUN cat /tmp/packages.txt | xargs apt-get install \
  -o Dpkg::Options::="--force-confdef" \
  -o Dpkg::Options::="--force-confnew" \
  --no-install-recommends --no-install-suggests -yq \
  && rm -rf /var/lib/apt/lists/* 

# Install go
ENV GOVERSION 1.14.4
ENV GOROOT /opt/go
ENV GOPATH /root/.go
RUN cd /opt && wget --quiet https://storage.googleapis.com/golang/go${GOVERSION}.linux-amd64.tar.gz && \
  tar zxf go${GOVERSION}.linux-amd64.tar.gz && rm go${GOVERSION}.linux-amd64.tar.gz && \
  ln -s /opt/go/bin/go /usr/bin/ && \
  mkdir $GOPATH

# Enable unbuffered logging
ENV PYTHONUNBUFFERED 1
ADD requirements/requirements.txt /tmp/requirements.txt
RUN pip3 install --upgrade pip setuptools wheel \
  && pip3 install --no-cache-dir -r /tmp/requirements.txt \
  && rm -rf /root/.cache/pip

# ADD ansible/requirements.yml /tmp/requirements.yml
# RUN ansible-galaxy install --force -r ansible/requirements.yml --roles-path /etc/ansible/roles
#  && curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python

RUN chsh -s /usr/bin/zsh && curl -sL http://install.ohmyz.sh | sh || true

# # install vim-plug
RUN curl -sfLo /root/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
  && nvim +PlugInstall +qa

WORKDIR /root

COPY . .

# Set up volumes
WORKDIR /projects

VOLUME /projects
VOLUME /root
VOLUME /keys

CMD ["tmux"]
