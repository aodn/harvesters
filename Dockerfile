#################################################################
# Dockerfile to build image for running Talend Open Studio 7.1.1
#################################################################

FROM ubuntu:16.04
MAINTAINER AODN

ARG BUILDER_UID=9999

# Add JAVA_HOME and add to path as required by TOS
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV PATH $JAVA_HOME/bin:$PATH

# Add custom talend env variables for use in this file and jenkins
ENV TALEND_VERSION TOS_DI-20181026_1147-V7.1.1
ENV TALEND_DIR /opt/$TALEND_VERSION
ENV TALEND_CUSTOM_COMPONENTS $TALEND_DIR/talend-components
ENV TALEND_EXEC $TALEND_DIR/TOS_DI-linux-gtk-x86_64
ENV TALEND_WORKSPACE /home/builder

# Install packages
RUN apt-get update && apt-get install -y --no-install-recommends \
  ca-certificates \
  git \
  openjdk-8-jdk \
  unzip \
  xvfb \
  wget \
  zip \
  && rm -rf /var/lib/apt/lists/*

RUN useradd --create-home --no-log-init --shell /bin/bash --uid $BUILDER_UID builder
RUN install -d -o builder -g builder $TALEND_DIR
USER builder
WORKDIR /tmp

# Download and install Talend Open Studio in /opt
RUN wget -q https://s3-ap-southeast-2.amazonaws.com/imos-binary/static/talend/$TALEND_VERSION.zip \
  && unzip -q -d /opt ./$TALEND_VERSION.zip \
  && rm ./$TALEND_VERSION.zip

# Download and install talend maven repo
RUN wget -q https://s3-ap-southeast-2.amazonaws.com/imos-binary/static/talend/talend-maven-repo-1.0.zip \
  && mkdir -p $TALEND_DIR/configuration/.m2 \
  && unzip -q -d $TALEND_DIR/configuration/.m2 ./talend-maven-repo-1.0.zip \
  && rm ./talend-maven-repo-1.0.zip

# Download and install TOS SDI
RUN wget -q https://s3-ap-southeast-2.amazonaws.com/imos-binary/static/talend/TOS-Spatial-7.1.1.zip \
  && unzip -q -d . ./TOS-Spatial-7.1.1.zip \
  && cp -r ./TOS-Spatial-7.1.1/plugins/* $TALEND_DIR/plugins \
  && rm ./TOS-Spatial-7.1.1.zip

# Download and install code generator plugin
RUN wget -q https://s3-ap-southeast-2.amazonaws.com/imos-binary/static/talend/au.org.emii.talend.codegen-7.1.1.jar \
    -O $TALEND_DIR/plugins/au.org.emii.talend.codegen-7.1.1.jar

# Download and install components
### HARD CODED VERSION: NEED TO SET UP A BUILD JOB FOR COMPONENTS SO WE CAN GET THE LATEST
RUN wget -q https://s3-ap-southeast-2.amazonaws.com/imos-binary/jobs/talend7_components_edge/2/components-1.0.0-SNAPSHOT.zip \
  && unzip -q -d $TALEND_DIR/talend-components ./components-1.0.0-SNAPSHOT.zip \
  && rm ./components-1.0.0-SNAPSHOT.zip

WORKDIR /home/builder
