FROM levischuck/janet-sdk as builder

COPY project.janet /bread/
WORKDIR /bread/
RUN jpm deps
COPY . /bread/
# For whatever reason x86_64 builds wrong the first time
# The next few times are because dependencies
RUN jpm build && jpm clean && jpm build && jpm build && jpm build

FROM alpine as app
COPY --from=builder /bread/build/bread /usr/local/bin/
COPY static /opt/static
WORKDIR /opt/
CMD ["bread"]