FROM ruby:2.7.1

RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    && curl -sL https://deb.nodesource.com/setup_14.x | bash \
    && apt-get install nodejs -y

RUN npm install -g yarn

ENV APP_DIR /k8s-app
ENV BUNDLE_PATH /k8s-app/bundle

RUN mkdir $APP_DIR

WORKDIR $APP_DIR

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . .

RUN yarn install

RUN EDITOR="mate --wait" bundle exec rails credentials:edit

RUN chmod u+x $APP_DIR/scripts/*

RUN ./bin/webpack

EXPOSE 3000

ENTRYPOINT ["./scripts/server.sh"]
