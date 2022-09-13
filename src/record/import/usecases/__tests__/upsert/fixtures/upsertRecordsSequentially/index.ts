import { TestPattern } from "../../index.test";
import { records } from "./records";
import { schema } from "./schema";
import { expected } from "./expected";
import { recordsOnKintone } from "./recordsOnKintone";

export const pattern: TestPattern = {
  description: "should upsert records with correct order",
  input: {
    records: records,
    schema: schema,
    updateKey: "recordNumber",
    options: {
      attachmentsDir: "",
      skipMissingFields: true,
    },
  },
  recordsOnKintone: recordsOnKintone,
  expected: expected,
};