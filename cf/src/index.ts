import { asset } from "./assets";
import { Env } from "./environment";

const breadFrom = [
  '-burner',
  '-cendyne',
  '-lewis',
  '-nic',
  '-sparky',
  '-zenith',
  '' // nican
];
const textExtensions = [
  'c',
  'cpp',
  'csv',
  'py',
  'rs',
  'sh',
  'sql',
  'toml'
]

function littleAnalytics(env: Env, ctx: ExecutionContext, request: Request) {
  let {hostname, pathname} = new URL(request.url);
  ctx.waitUntil((async () => {
    try {
      env.ANALYTICS.fetch(`https://analytics/l/${hostname}/${pathname}`, {
        headers: new Headers([
          ['cf-connecting-ip', request.headers.get('cf-connecting-ip') || ''],
          ['user-agent', request.headers.get('user-agent') || ''],
          ['cf-ipcountry', request.headers.get('cf-ipcountry') || ''],
        ])
      })
    } catch (e) {
      console.log(e);
    }
  })());
}

function wrapHtml(request: Request, body: string) : string {
  let {hostname} = new URL(request.url);
  let userAgent = request.headers.get('user-agent') || '';
  return `<!DOCTYPE HTML><html><head>
  <title>Feed Glitch Bread</title>
  <meta content="website" property="og:type" />
  <meta content="Feed Glitch Bread" property="og:title" />
  <meta content="It's dangerous to go alone! Take this baguette." property="og:description" />
  <meta content="https://${hostname}/" property="og:url" />
  <meta content="https://${hostname}/bread.gif" property="og:image" />
  <meta content="https://${hostname}/bread.gif" property="og:image:secure_url" />
  <meta content="512" property="og:image:width" />
  <meta content="512" property="og:image:height" />
  <meta content="https://${hostname}/bread.mp4" property="og:video" />
  <meta content="https://${hostname}/bread.mp4" property="og:video:secure_url" />
  <meta content="video/mp4" property="og:video:type" />
  <meta content="512" property="og:video:width" />
  <meta content="512" property="og:video:height" />
  ${userAgent.includes('Twitterbot') ? (`
  <meta content="${hostname}" name="twitter:domain" />
  <meta content="https://${hostname}" name="twitter:url" />
  <meta content="player" name="twitter:card" />
  <meta content="Feed Glitch Bread" name="twitter:title" />
  <meta content="It's dangerous to go alone! Take this baguette." name="twitter:description" />
  <meta content="https://${hostname}/bread.gif" name="twitter:image" />
  <meta content="https://${hostname}/video" name="twitter:player" />
  <meta content="512" name="twitter:player:width" />
  <meta content="512" name="twitter:player:height" />
  <meta content="https://${hostname}/bread.mp4" name="twitter:player:stream" />
  <meta content="video/mp4" name="twitter:player:stream:content_type" />
  <meta content="@CendyneNaga" name="twitter:creator" />`) : ''}
  <meta content="#ff7700" name="theme-color" />
  <link rel="stylesheet" href="/style.css" />
</head>
<body>
  <div class="container">
    <div class="content">
      ${body}
    </div>
  </div>
</body></html>`
}

async function rootResponse(request: Request) : Promise<Response> {
  // TODO Little analytics
  let randIndex = Math.floor(Math.random() * breadFrom.length);
  let variant = breadFrom[randIndex];
  return new Response(wrapHtml(request, `
      <picture>
        <source srcset="bread${variant}.avif" type="image/avif" />
        <source srcset="bread${variant}.wp2" type="image/wp2" />
        <source srcset="bread${variant}.jxl" type="image/jxl" />
        <source srcset="bread${variant}.webp" type="image/webp" />
        <img width="512" alt="baguette" src="bread${variant}.gif" height="512" />
      </picture>
      <hr />
      Other formats:
      <a href="/audio">audio</a>
      <a href="/video">video</a>
      <a href="/lottie">lottie</a>
      <a href="/bread.svg">SVG</a>
      <a href="/bread.json">JSON</a>
      <a href="/bread.rs">Rust</a>
      and more`), {
    headers: new Headers([
      ['content-type', 'text/html']
    ])
  })
}

async function audioResponse(request: Request) : Promise<Response> {
  return new Response(wrapHtml(request, `
    <audio controls autoplay loop>
      <source src="bread.m4a" type="audio/m4a" />
      <source src="bread.ogg" type="audio/ogg" />
      <source src="bread.aac" type="audio/aac" />
      <source src="bread.mp3" type="audio/mpeg" />
      <img width="512" alt="baguette" src="bread.gif" height="512" />
    </audio>
    <hr />
    Other formats:
    <a href="/">image</a>
    <a href="/video">video</a>
    <a href="/lottie">lottie</a>
    <a href="/bread.svg">SVG</a>
    <a href="/bread.json">JSON</a>
    <a href="/bread.rs">Rust</a>
    and more`), {
    headers: new Headers([
      ['content-type', 'text/html']
    ])
  })
}

async function lottieResponse(request: Request) : Promise<Response> {
  return new Response(wrapHtml(request, `
  <div id="sticker"></div>
  <script src="lottie.min.js"></script>
  <script src="bread.lottie.js"></script>
  <hr />
  Other formats:
  <a href="/">image</a>
  <a href="/audio">audio</a>
  <a href="/video">video</a>
  <a href="/bread.svg">SVG</a>
  <a href="/bread.json">JSON</a>
  <a href="/bread.rs">Rust</a>
  and more`), {
    headers: new Headers([
      ['content-type', 'text/html']
    ])
  })
}

async function videoResponse(request: Request) : Promise<Response> {
  return new Response(wrapHtml(request, `
    <video autoplay width="512" controls height="512" loop>
      <source src="bread.webm" type="video/webm" />
      <source src="bread.mp4" type="video/mp4" />
      <source src="bread.ogv" type="video/ogv" />
      <img width="512" alt="baguette" src="bread.gif" height="512" />
    </video>
    <hr />
    Other formats:
    <a href="/">image</a>
    <a href="/audio">audio</a>
    <a href="/lottie">lottie</a>
    <a href="/bread.svg">SVG</a>
    <a href="/bread.json">JSON</a>
    <a href="/bread.rs">Rust</a>
    and more`), {
    headers: new Headers([
      ['content-type', 'text/html']
    ])
  })
}

export default {
  async fetch(
    request: Request,
    env: Env,
    ctx: ExecutionContext
  ): Promise<Response> {
    if (request.method == 'GET' || request.method == 'HEAD') {
      let {pathname} = new URL(request.url);
      try {
        let response : Response = await asset(request, env, ctx);
        if ((response.headers.get('content-type') || '').startsWith('application/')) {
          for (let ext of textExtensions) {
            if (pathname.endsWith(`.${ext}`)) {
              response = new Response(response.body, response);
              response.headers.set('content-type', 'text/plain');
            }
          }
        }
        return response;
      } catch (e) {
        // File not found
        // console.error(e);
      }
      if (pathname == '/') {
        littleAnalytics(env, ctx, request);
        return await rootResponse(request);
      } else if (pathname == '/audio') {
        littleAnalytics(env, ctx, request);
        return await audioResponse(request);
      } else if (pathname == '/lottie') {
        littleAnalytics(env, ctx, request);
        return await lottieResponse(request);
      } else if (pathname == '/video') {
        littleAnalytics(env, ctx, request);
        return await videoResponse(request);
      }
    }
    return new Response('', {
      status: 404
    });
  },
};
