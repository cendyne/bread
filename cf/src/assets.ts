import { getAssetFromKV } from "@cloudflare/kv-asset-handler";
import manifestJSON from '__STATIC_CONTENT_MANIFEST'
import { Env } from './environment';
// I wish that this were provided through environment
// variable or hidden away in cloudflare's own library instead.
const manifest = JSON.parse(manifestJSON)


export async function asset(request: Request, env: Env, ctx: ExecutionContext) : Promise<Response> {
  // The UX for getAssetFromKV is poor for ES Module workers
  return await getAssetFromKV({request, waitUntil: function(promise) {
    ctx.waitUntil(promise)
  }}, {
    ASSET_NAMESPACE: env.__STATIC_CONTENT,
    ASSET_MANIFEST: manifest,
  });
}

