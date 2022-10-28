import { KintoneRestAPIClient } from "@kintone/rest-api-client";
const packageJson = require("../../package.json");
import HttpsProxyAgent from "https-proxy-agent";
import * as https from "https";
import fs from "fs";

export type RestAPIClientOptions = {
  baseUrl: string;
  username?: string;
  password?: string;
  basicAuthUsername?: string;
  basicAuthPassword?: string;
  apiToken?: string | string[];
  guestSpaceId?: string;
  pfxFilePath?: string;
  pfxFilePassword?: string;
  userAgent?: string;
  httpsProxy?: string;
};

const buildAuthParam = (options: RestAPIClientOptions) => {
  const passwordAuthParam = {
    username: options.username,
    password: options.password,
  };

  if (options.username) {
    return passwordAuthParam;
  }
  if (options.apiToken) {
    return { apiToken: options.apiToken };
  }
  return passwordAuthParam;
};

const buildBasicAuthParam = (options: RestAPIClientOptions) => {
  return options.basicAuthUsername && options.basicAuthPassword
    ? {
        basicAuth: {
          username: options.basicAuthUsername,
          password: options.basicAuthPassword,
        },
      }
    : {};
};

const buildHttpsAgent = (options: {
  proxy?: string;
  pfxFilePath?: string;
  pfxFilePassword?: string;
}): https.Agent => {
  let pfx: string | Buffer | undefined;
  if (options.pfxFilePath !== undefined) {
    pfx = fs.readFileSync(options.pfxFilePath);
  }
  const clientAuth =
    pfx && options.pfxFilePassword
      ? { pfx, passphrase: options.pfxFilePassword }
      : {};
  if (!options.proxy) {
    return new https.Agent({ ...clientAuth });
  }

  const { protocol, hostname, port } = new URL(options.proxy);
  return HttpsProxyAgent({
    protocol: protocol,
    host: hostname,
    port: port,
    ...clientAuth,
  });
};

export const buildRestAPIClient = (options: RestAPIClientOptions) => {
  return new KintoneRestAPIClient({
    baseUrl: options.baseUrl,
    auth: buildAuthParam(options),
    ...buildBasicAuthParam(options),
    ...(options.guestSpaceId ? { guestSpaceId: options.guestSpaceId } : {}),
    userAgent: `${packageJson.name}@${packageJson.version}`,
    // TODO: fix type definition of @kintone/rest-api-client
    // Currently, the proxy property doesn't accept false
    proxy: false as any,
    httpsAgent: buildHttpsAgent({
      proxy: options.httpsProxy,
      pfxFilePath: options.pfxFilePath,
      pfxFilePassword: options.pfxFilePassword,
    }),
  });
};
