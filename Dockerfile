FROM alpine:3.9

LABEL maintainer="adm@tty.se"

ARG HUGO_VERSION
ARG HUGO_DOWNLOAD_URL

RUN apk add --no-cache \
		bash \
		curl \
		openssh-client \
		rsync \
		wget \
        lftp \
        py-pip && \
        pip install awscli && \
        apk -v --purge del py-pip

RUN wget "$HUGO_DOWNLOAD_URL" && \
	tar xzf hugo_extended_${HUGO_VERSION}_Linux-64bit.tar.gz && \
	mv hugo /usr/bin/hugo && \
	rm hugo_extended_${HUGO_VERSION}_Linux-64bit.tar.gz LICENSE README.md

CMD ["hugo","--help"]

EXPOSE 1313

