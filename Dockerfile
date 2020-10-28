FROM ruby:2.6.3

# throw errors if Gemfile in the docker image has been modified since Gemfile.lock
RUN bundle config --global frozen 1

# install some standard stuff
RUN apt-get -y update
RUN apt-get -y install sudo
RUN apt-get -y install dialog apt-utils
RUN apt-get -y install curl
RUN apt-get -y install build-essential
RUN apt-get -y install manpages-dev
RUN apt-get -y install wget

# install glpk version 4.44
RUN apt-get -y install gnupg
RUN wget ftp://ftp.gnu.org/gnu/glpk/glpk-4.44.tar.gz
RUN wget ftp://ftp.gnu.org/gnu/glpk/glpk-4.44.tar.gz.sig
RUN gpg --keyserver keys.gnupg.net --recv-keys 5981E818
RUN gpg --verify glpk-4.44.tar.gz.sig glpk-4.44.tar.gz
RUN tar -xzvf glpk-4.44.tar.gz

# configure and finalize glpk
RUN cd glpk-4.44 && ./configure && make check && examples/glpsol --version
RUN cd glpk-4.44 && make uninstall
RUN cd glpk-4.44 && make install
RUN which glpsol

# do ruby things
RUN gem install bundler

# now get the gemfile from our app directory
COPY Gemfile Gemfile.lock ./
RUN bundle install

# get docker dependencies
RUN apt update
RUN apt-get -y install apt-transport-https ca-certificates gnupg-agent software-properties-common
# add docker gpg key
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
RUN apt-key fingerprint 0EBFCD88
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
RUN apt update
RUN apt-cache policy docker-ce
RUN apt-get -y install docker-ce docker-ce-cli containerd.io
# WE ARE HERE -- NEED TO GIVE DOCKER ROOT PERMISSION
RUN dockerd
RUN systemctl status docker
RUN docker run hello-world

# RUN apt-cache policy docker-ce
# RUN apt-get install docker-ce docker-ce-cli containerd.io

# we are going to need docker to run the selenium server
#RUN curl -fsSLO https://get.docker.com/builds/Linux/x86_64/docker-17.04.0-ce.tgz \
# && tar xzvf docker-17.04.0-ce.tgz
#RUN ls
#RUN docker/dockerd
#RUN docker/docker run -d -p 4444:4444 -v /dev/shm:/dev/shm selenium/standalone-chrome:latest

# copy the rest of our app
COPY script.rb .

# run the ruby script
RUN bundle exec ruby script.rb