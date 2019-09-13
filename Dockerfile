FROM alpine:latest

# docker build -t vanessa/discourse-rankings .
# docker run -e DISOURSE_API_KEY=xxxx -e DISCOURSE_API_USER=vsoch \
#     -v $PWD/data:/code/data vanessa/discourse-rankings 

LABEL MAINTAINER vsoch

ENV BUILD_PACKAGES bash curl-dev ruby-dev build-base
ENV RUBY_PACKAGES ruby ruby-io-console ruby-bundler

# Update and install all of the required packages.
# At the end, remove the apk cache
RUN apk update && \
    apk upgrade && \
    apk add $BUILD_PACKAGES && \
    apk add $RUBY_PACKAGES && \
    rm -rf /var/cache/apk/*

WORKDIR /code

COPY Gemfile /code
COPY user-ranking.rb /code
RUN bundle install
ENTRYPOINT ["ruby", "/code/user-ranking.rb"]
