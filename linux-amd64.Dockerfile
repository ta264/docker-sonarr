FROM ghcr.io/hotio/base@sha256:029cd66161bb2f8ce8a845f108f2d43872f4b4c290e8122eed7e51d76a6a6b8e

ARG DEBIAN_FRONTEND="noninteractive"

EXPOSE 8989

# install packages
RUN apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
    libmediainfo0v5 libicu66 && \
    # clean up
    apt autoremove -y && \
    apt clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

ARG VERSION
ARG PACKAGE_VERSION=${VERSION}
    RUN mkdir "${APP_DIR}/bin" && \
    curl -fsSL "https://sonarr.servarr.com/v1/update/widowmaker/updatefile?version=${VERSION}&os=linux&runtime=netcore&arch=x64" | tar xzf - -C "${APP_DIR}/bin" --strip-components=1 && \
    rm -rf "${APP_DIR}/bin/Sonarr.Update" && \
    echo "PackageVersion=${PACKAGE_VERSION}\nPackageAuthor=[hotio](https://github.com/hotio)\nUpdateMethod=Docker\nBranch=widowmaker" > "${APP_DIR}/package_info" && \
    chmod -R u=rwX,go=rX "${APP_DIR}"

ARG ARR_DISCORD_NOTIFIER_VERSION
RUN curl -fsSL "https://raw.githubusercontent.com/hotio/arr-discord-notifier/${ARR_DISCORD_NOTIFIER_VERSION}/arr-discord-notifier.sh" > "${APP_DIR}/arr-discord-notifier.sh" && \
    chmod u=rwx,go=rx "${APP_DIR}/arr-discord-notifier.sh"

COPY root/ /
