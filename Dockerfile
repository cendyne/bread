FROM levischuck/janet-sdk as builder

COPY project.janet /bread/
WORKDIR /bread/
RUN jpm deps
COPY . /bread/
RUN jpm build && jpm build

FROM alpine as app
COPY --from=builder /bread/build/bread /usr/local/bin/
COPY static /opt/static
WORKDIR /opt/
CMD ["bread"]