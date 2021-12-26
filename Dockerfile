FROM levischuck/janet-sdk as builder

COPY project.janet /bread/
WORKDIR /bread/
RUN jpm deps
COPY . /bread/
ENV JOY_ENVIRONMENT production
RUN jpm build

FROM alpine as app
# COPY --from=builder /app/ /app/
COPY --from=builder /bread/build/bread /usr/local/bin/
COPY static /opt/static
WORKDIR /opt/
CMD ["bread"]