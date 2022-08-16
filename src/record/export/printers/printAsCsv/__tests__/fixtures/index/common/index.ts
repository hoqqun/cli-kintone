import { TestPattern } from "../../../index.test";
import { expectedCsv } from "./expected";
import { input } from "./input";
import { fieldsJson } from "./fields";

export const pattern: TestPattern = {
  description: "should convert kintone records to csv string correctly",
  fieldsJson: fieldsJson,
  input: input,
  useLocalFilePath: true,
  expected: expectedCsv,
};
