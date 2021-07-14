FROM 'madebytight/rude:3.0.1-14.17.0-alpine'

USER root
RUN mkdir /input; \
    chown -R app:app /input; \
    mkdir /output; \
    chown -R app:app /output;
USER app

COPY --chown=app:app Gemfile* ./
RUN bundle install

COPY --chown=app:app package.json yarn.lock ./
RUN yarn install --production=false

COPY --chown=app:app . .

# COPY docker-entrypoint.sh /usr/local/bin/
# ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["echo", "hei"]
