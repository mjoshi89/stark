FROM centos:centos6

#Create a few env variable to make dockerfile configurable.
ENV PYTHON_MAJOR=2.7 \
    PYTHON_VERSION=2.7.13 \
    JAVA_HOME=/usr/ \
    CATALINA_HOME=/opt/tomcat \
    TOMCAT_MAJOR=7 \
    TOMCAT_VERSION=7.0.82


EXPOSE 27017 8080

# update the system applications; install gcc and download the required python version, install and clean up
#Put in place echo commands for steps.
RUN \
  yum -y update && \
  yum -y install epel-release && \
  echo "==> Installing some required packages" && \
  yum install -y gcc; yum install -y wget && \
  echo "==> Downloading Python package" && \
  cd /usr/src; wget https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz && \
  tar xzf Python-${PYTHON_VERSION}.tgz; cd Python-${PYTHON_VERSION} && \
  ./configure; make altinstall && \
  echo "==> Creating a softlink so that python command can be used efffectively" && \
  ln -s /usr/local/bin/python${PYTHON_MAJOR} /usr/local/bin/python && \
  echo "==> Clean up" && \
  rm -rf Python-${PYTHON_VERSION}.tgz Python-${PYTHON_VERSION} && \
  echo "==> Installing pip as well" && \
  yum -y install python-pip

#Install MongoDB server
RUN \
  echo "==> Installing mongodb-server" && \
  yum -y install mongodb-server

#Install Java and Tomcat
RUN \
  echo "==> Installing Java" && \
  yum install -y java && \
  echo "==> Downloading tomcat package" && \
  cd /tmp;wget http://apache.mirrors.pair.com/tomcat/tomcat-${TOMCAT_MAJOR}/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz && \
  tar xvf apache-tomcat-${TOMCAT_VERSION}.tar.gz && \
  mv apache-tomcat-${TOMCAT_VERSION} ${CATALINA_HOME} && \
  chmod -R 755 ${CATALINA_HOME}

CMD ${CATALINA_HOME}/bin/catalina.sh run
