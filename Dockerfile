FROM 'madebytight/rude:3.0.3-14.18.2-alpine'

USER app

COPY --chown=app:app Gemfile* ./
RUN bundle install

COPY --chown=app:app package.json yarn.lock ./
RUN yarn install --production=false

RUN mkdir /app/input /app/output /app/tmp; \
    chown -R app:app /app/input /app/output /app/tmp;
COPY --chown=app:app . .

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["rake"]
