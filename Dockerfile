FROM alpine:3.7

COPY . /usr/local/bin/required-labels
WORKDIR /usr/local/bin/required-labels

RUN apk add --no-cache py3-pip py3-gunicorn jq curl
RUN pip3 install -r requirements.txt
CMD ["sh", "entrypoint.sh"]
