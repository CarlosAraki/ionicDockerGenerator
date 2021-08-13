FROM ubuntu:20.04

ARG IONIC_VERSION="5.4.16"
ARG ANDROID_SDK_VERSION="7583922_latest"
ARG ANDROID_HOME="/opt/android-sdk"
ARG ANDROID_BUILD_TOOLS_VERSION="30.0.3"
ARG DEBIAN_FRONTEND=noninteractive

# 1) Install system package dependencies
# 2) Install Nodejs/NPM/Ionic-Cli
# 3) Install Android SDK
# 4) Install SDK tool for support ionic build command
# 5) Cleanup
# 6) Add and set user for use by ionic and set work folder

ENV NODE_VERSION=12.6.0
ENV ANDROID_HOME "${ANDROID_HOME}"
RUN apt-get update \
    && apt-get install -y \
       build-essential \
       openjdk-8-jre \
       openjdk-8-jdk \
       curl \
       unzip \
       git \
       gradle 
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash
ENV NVM_DIR=/root/.nvm
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"
RUN node --version
RUN npm --version
RUN apt-get update \
    && npm install -g cordova ionic@${IONIC_VERSION} \
    && cd /tmp \
    && curl -fSLk https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_SDK_VERSION}.zip -o sdk-tools-linux-${ANDROID_SDK_VERSION}.zip \
    && unzip sdk-tools-linux-${ANDROID_SDK_VERSION}.zip \
    && mkdir /opt/android-sdk\
    && mv cmdline-tools /opt/android-sdk/ \
    && chmod -R 777 /opt/

RUN (while sleep 3; do echo "y"; done) | $ANDROID_HOME/cmdline-tools/bin/sdkmanager --licenses  --sdk_root='/opt/android-sdk'  
RUN echo 'AQUII4'
RUN     $ANDROID_HOME/cmdline-tools/bin/sdkmanager "platform-tools" --sdk_root='/opt/android-sdk'   --verbose --channel=3 
RUN echo 'AQUII5'
RUN $ANDROID_HOME/cmdline-tools/bin/sdkmanager "platforms;android-27"  --sdk_root='/opt/android-sdk' --verbose --channel=3 
RUN $ANDROID_HOME/cmdline-tools/bin/sdkmanager "cmdline-tools;5.0"  --sdk_root='/opt/android-sdk' --verbose --channel=3 
#RUN $ANDROID_HOME/cmdline-tools/bin/sdkmanager "build-tools;30.0.3"  --sdk_root='/opt/android-sdk' --verbose --channel=3 
RUN chmod -R 777 /opt/
RUN apt-get autoremove -y \
    && rm -rf /tmp/sdk-tools-linux-${ANDROID_SDK_VERSION}.zip \ 
    && mkdir /ionicapp

RUN npm rebuild node-sass
WORKDIR /ionicapp
