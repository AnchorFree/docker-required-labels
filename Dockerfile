FROM alpine:3.7

COPY . /usr/local/bin/required-labels
WORKDIR /usr/local/bin/required-labels

RUN apk add py3-pip py3-gunicorn
RUN pip3 install -r requirements.txt
CMD ["gunicorn", "main:app"]
