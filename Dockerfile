FROM node:19

WORKDIR /app

# install browser
RUN apt-get update && apt install chromium -y

# clone rrweb
RUN git clone https://github.com/rrweb-io/rrweb.git
WORKDIR /app/rrweb
RUN yarn install
RUN npm run build:all
RUN chmod +x /app/rrweb/packages/rrvideo/build/cli.js

# add language support
# https://github.com/garris/BackstopJS/issues/932
RUN sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list
RUN apt-get update && apt-get -qqy --no-install-recommends install \
    libfontconfig \
    libfreetype6 \
    xfonts-cyrillic \
    xfonts-scalable \
    fonts-liberation \
    fonts-ipafont-gothic \
    fonts-wqy-zenhei \
    fonts-tlwg-loma-otf
RUN fc-cache -fv
ENV LANG=C.UTF-8

# copy example
RUN mkdir "/data"
COPY data/events.json /data/events.json

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/app/rrweb/packages/rrvideo/build/cli.js", "--input",  "/data/events.json", "--output", "/data/output.mp4"]
