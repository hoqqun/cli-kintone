import type { KintoneRecord } from "../../../../../types/record";

export const records: KintoneRecord[] = [
  {
    singleLineText: {
      value: "value1",
    },
    number: {
      value: "1",
    },
    table: {
      value: [
        {
          id: "123",
          value: {
            singleLineTextInTable: { value: "value1" },
          },
        },
      ],
    },
  },
  {
    singleLineText: {
      value: "value3",
    },
    number: {
      value: "3",
    },
    table: {
      value: [
        {
          id: "123",
          value: {
            singleLineTextInTable: { value: "value1" },
          },
        },
      ],
    },
  },
];
