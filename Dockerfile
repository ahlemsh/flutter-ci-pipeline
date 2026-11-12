FROM ghcr.io/cirruslabs/android-sdk:36

USER root

ARG FLUTTER_VERSION=3.47.2

ENV FLUTTER_HOME=/opt/flutter
ENV FLUTTER_ROOT=/opt/flutter
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64

ENV PATH="${JAVA_HOME}/bin:${FLUTTER_HOME}/bin:${FLUTTER_HOME}/bin/cache/dart-sdk/bin:${PATH}"

RUN apt-get update && \
    apt-get install -y \
        openjdk-17-jdk \
        git \
        curl \
        unzip \
        xz-utils \
        zip \
        libglu1-mesa && \
    rm -rf /var/lib/apt/lists/*

RUN sdkmanager \
        "platforms;android-34" \
        "platforms;android-35" \
        "build-tools;34.0.0" \
        "ndk;27.0.12077973" \
        "cmake;3.22.1"

RUN git clone --depth 1 \
    --branch ${FLUTTER_VERSION} \
    https://github.com/flutter/flutter.git \
    ${FLUTTER_HOME}

RUN flutter config --no-analytics && \
    flutter precache --android

WORKDIR /workspace

CMD ["flutter", "--version"]