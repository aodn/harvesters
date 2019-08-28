#################################################################
# Dockerfile to build image for running Talend Open Studio 7.1.1
#################################################################

FROM ubuntu:16.04
MAINTAINER AODN

ARG BUILDER_UID=9999
RUN useradd --create-home --no-log-init --shell /bin/bash --uid $BUILDER_UID builder

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
RUN \
  apt-get update \
  && apt-get install -y --no-install-recommends \
  curl  \
  git \
  openjdk-8-jdk \
  unzip \
  xvfb \
  zip \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /opt
WORKDIR /tmp

# Download and install Talend Open Studio in /opt
RUN curl -SL https://s3-ap-southeast-2.amazonaws.com/imos-binary/static/talend/$TALEND_VERSION.zip -O \
  && unzip -d /opt ./$TALEND_VERSION.zip \
  && chown -R $BUILDER_UID:$BUILDER_UID $TALEND_DIR \
  && rm ./$TALEND_VERSION.zip

USER $BUILDER_UID

# Download and install talend maven repo
RUN curl -SL  https://s3-ap-southeast-2.amazonaws.com/imos-binary/static/talend/talend-maven-repo-1.0.zip -O \
  && mkdir -p $TALEND_DIR/configuration/.m2 \
  && unzip -d $TALEND_DIR/configuration/.m2 /tmp/talend-maven-repo-1.0.zip \
  && rm ./talend-maven-repo-1.0.zip
 
# Download and install TOS SDI
RUN curl -SL https://s3-ap-southeast-2.amazonaws.com/imos-binary/static/talend/TOS-Spatial-7.1.1.zip -O \
  && unzip -d . ./TOS-Spatial-7.1.1.zip \
  && cp -r ./TOS-Spatial-7.1.1/plugins/* $TALEND_DIR/plugins \
  && rm -rf ./TOS-Spatial-7.1.1.zip ./target

# Download and install code generator plugin
RUN curl -SL https://s3-ap-southeast-2.amazonaws.com/imos-binary/static/talend/au.org.emii.talend.codegen-7.1.1.jar -O \
  && cp -r ./au.org.emii.talend.codegen-7.1.1.jar $TALEND_DIR/plugins \
  && rm -rf ./au.org.emii.talend.codegen-7.1.1.jar /tmp/target
  
# Download and install components
### HARD CODED VERSION: NEED TO SET UP A BUILD JOB FOR COMPONENTS SO WE CAN GET THE LATEST
RUN curl -SL https://s3-ap-southeast-2.amazonaws.com/imos-binary/jobs/talend7_components_edge/2/components-1.0.0-SNAPSHOT.zip -O \
  && unzip ./components-1.0.0-SNAPSHOT.zip -d $TALEND_DIR/talend-components \
  && rm -rf ./components-1.0.0-SNAPSHOT.zip ./target

WORKDIR $TALEND_WORKSPACE
