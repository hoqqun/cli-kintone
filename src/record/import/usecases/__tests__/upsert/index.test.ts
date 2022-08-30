import type { KintoneRecord } from "../../../types/record";
import type { RecordSchema } from "../../../types/schema";

import { KintoneRestAPIClient } from "@kintone/rest-api-client";
import { upsertRecords } from "../../upsert";

import { pattern as upsertBySingleLineText } from "./fixtures/upsertBySingleLineText";
import { pattern as upsertByNumber } from "./fixtures/upsertByNumber";
import { pattern as upsertByNonUniqueKey } from "./fixtures/upsertByNonUniqueKey";
import { pattern as upsertByUnsupportedField } from "./fixtures/upsertByUnsupportedField";
import { pattern as upsertByNonExistentField } from "./fixtures/upsertByNonExistentField";
import { pattern as upsertWithMissingKeyFromRecord } from "./fixtures/upsertWithMissingKeyFromRecord";
import { pattern as upsertWithMissingFieldFromRecord } from "./fixtures/upsertWithMissingFieldFromRecord";
import { pattern as upsertWithMissingFieldInTableFromRecord } from "./fixtures/upsertWithMissingFieldInTableFromRecord";

export type TestPattern = {
  description: string;
  input: {
    records: KintoneRecord[];
    schema: RecordSchema;
    updateKey: string;
    options: {
      attachmentsDir?: string;
      skipMissingFields?: boolean;
    };
  };
  recordsOnKintone: Awaited<
    ReturnType<KintoneRestAPIClient["record"]["getAllRecords"]>
  >;
  expected: {
    success?: {
      forUpdate: Parameters<
        KintoneRestAPIClient["record"]["updateAllRecords"]
      >[0];
      forAdd: Parameters<KintoneRestAPIClient["record"]["addAllRecords"]>[0];
    };
    failure?: {
      errorMessage: string;
    };
  };
};

describe("upsertRecords", () => {
  let apiClient: KintoneRestAPIClient;
  beforeEach(() => {
    apiClient = new KintoneRestAPIClient({
      baseUrl: "https://localhost/",
      auth: { apiToken: "dummy" },
    });
  });

  const patterns = [
    upsertBySingleLineText,
    upsertByNumber,
    upsertByNonUniqueKey,
    upsertByUnsupportedField,
    upsertByNonExistentField,
    upsertWithMissingKeyFromRecord,
    upsertWithMissingFieldFromRecord,
    upsertWithMissingFieldInTableFromRecord,
  ];

  it.each(patterns)(
    "$description",
    async ({ input, recordsOnKintone, expected }) => {
      const getAllRecordsMockFn = jest.fn().mockResolvedValue(recordsOnKintone);
      apiClient.record.getAllRecords = getAllRecordsMockFn;
      const updateAllRecordsMockFn = jest.fn().mockResolvedValue({
        records: [
          {
            id: "1",
            revision: "2",
          },
        ],
      });
      apiClient.record.updateAllRecords = updateAllRecordsMockFn;
      const addAllRecordsMockFn = jest.fn().mockResolvedValue({});
      apiClient.record.addAllRecords = addAllRecordsMockFn;

      const APP_ID = "1";

      if (expected.success !== undefined) {
        await upsertRecords(
          apiClient,
          APP_ID,
          input.records,
          input.schema,
          input.updateKey,
          input.options
        );
        expect(updateAllRecordsMockFn).toBeCalledWith(
          expected.success.forUpdate
        );
        expect(addAllRecordsMockFn).toBeCalledWith(expected.success.forAdd);
      }
      if (expected.failure !== undefined) {
        await expect(
          upsertRecords(
            apiClient,
            APP_ID,
            input.records,
            input.schema,
            input.updateKey,
            input.options
          )
        ).rejects.toThrow(expected.failure.errorMessage);
      }
    }
  );
});
