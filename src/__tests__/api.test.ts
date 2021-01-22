import { buildRestAPIClient } from "../api";

import { KintoneRestAPIClient } from "@kintone/rest-api-client";

jest.mock("@kintone/rest-api-client");

describe("api", () => {
  const USERNAME = "username";
  const PASSWORD = "password";
  const BASE_URL = "https://localhost";

  it("should pass username and password to the apiClient correctly", () => {
    const apiClient = buildRestAPIClient({
      baseUrl: BASE_URL,
      username: USERNAME,
      password: PASSWORD,
    });
    expect(apiClient).toBeInstanceOf(KintoneRestAPIClient);
    expect(KintoneRestAPIClient).toHaveBeenCalledWith({
      baseUrl: BASE_URL,
      auth: {
        username: USERNAME,
        password: PASSWORD,
      },
    });
  });

  it("should pass guestSpaceId to the apiClient correctly", () => {
    const GUEST_SPACE_ID = 1;

    const apiClient = buildRestAPIClient({
      baseUrl: BASE_URL,
      username: USERNAME,
      password: PASSWORD,
      guestSpaceId: GUEST_SPACE_ID,
    });
    expect(apiClient).toBeInstanceOf(KintoneRestAPIClient);
    expect(KintoneRestAPIClient).toHaveBeenCalledWith({
      baseUrl: BASE_URL,
      auth: {
        username: USERNAME,
        password: PASSWORD,
      },
      guestSpaceId: GUEST_SPACE_ID,
    });
  });

  it("should pass basic auth params to the apiClient correctly", () => {
    const BASIC_AUTH_USERNAME = "basic_auth_username";
    const BASIC_AUTH_PASSWORD = "basic_auth_password";
    const apiClient = buildRestAPIClient({
      baseUrl: BASE_URL,
      username: USERNAME,
      password: PASSWORD,
      basicAuthUsername: BASIC_AUTH_USERNAME,
      basicAuthPassword: BASIC_AUTH_PASSWORD,
    });
    expect(apiClient).toBeInstanceOf(KintoneRestAPIClient);
    expect(KintoneRestAPIClient).toHaveBeenCalledWith({
      baseUrl: BASE_URL,
      auth: {
        username: USERNAME,
        password: PASSWORD,
      },
      basicAuth: {
        username: BASIC_AUTH_USERNAME,
        password: BASIC_AUTH_PASSWORD,
      },
    });
  });
});