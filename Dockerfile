FROM node:12

ARG IONIC_VERSION="5.4.16"
ARG ANDROID_SDK_VERSION="7583922_latest"
ARG ANDROID_HOME="/opt/android-sdk"
ARG ANDROID_BUILD_TOOLS_VERSION="30.0.3"

# 1) Install system package dependencies
# 2) Install Nodejs/NPM/Ionic-Cli
# 3) Install Android SDK
# 4) Install SDK tool for support ionic build command
# 5) Cleanup
# 6) Add and set user for use by ionic and set work folder

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

RUN apt-get update \
    && npm install -g cordova ionic@${IONIC_VERSION} \
    && cd /tmp \
    && curl -fSLk https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_SDK_VERSION}.zip -o sdk-tools-linux-${ANDROID_SDK_VERSION}.zip \
    && unzip sdk-tools-linux-${ANDROID_SDK_VERSION}.zip \
    && mkdir /opt/android-sdk\
    && mv cmdline-tools /opt/android-sdk/ 

RUN cd /opt/android-sdk/cmdline-tools/
RUN (while sleep 3; do echo "y"; done) | $ANDROID_HOME/cmdline-tools/bin/sdkmanager --licenses  --sdk_root='.' \ 
    && $ANDROID_HOME/cmdline-tools/bin/sdkmanager "platform-tools" --sdk_root='.'  \
    && $ANDROID_HOME/cmdline-tools/bin/sdkmanager --install "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" --sdk_root='.' 
RUN echo 'AQUII3'

RUN apt-get autoremove -y \
    && rm -rf /tmp/sdk-tools-linux-${ANDROID_SDK_VERSION}.zip \ 
    && mkdir /ionicapp

RUN npm rebuild node-sass
WORKDIR /ionicapp