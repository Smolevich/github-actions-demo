FROM gcr.io/cloud-builders/go

RUN apt-get update -y &&  \
    apt-get install zip && \
    rm -rf /var/lib/apt/lists/*

COPY "entrypoint.sh" "/entrypoint.sh"

RUN chmod +x /entrypoint.sh
COPY "entrypoint.sh" "/entrypoint.sh"
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]