import { FieldsJson } from "../../../../../../../../kintone/types";

export const fieldsJson: FieldsJson = {
  revision: "29",
  properties: {
    recordNumber: {
      type: "RECORD_NUMBER",
      code: "recordNumber",
      label: "recordNumber",
      noLabel: false,
    },
    updatedTime: {
      type: "UPDATED_TIME",
      code: "updatedTime",
      label: "updatedTime",
      noLabel: false,
    },
    dropDown: {
      type: "DROP_DOWN",
      code: "dropDown",
      label: "dropDown",
      noLabel: false,
      required: false,
      options: {
        sample1: {
          label: "sample1",
          index: "0",
        },
        sample2: {
          label: "sample2",
          index: "1",
        },
      },
      defaultValue: "",
    },
    creator: {
      type: "CREATOR",
      code: "creator",
      label: "creator",
      noLabel: false,
    },
    Assignee: {
      type: "STATUS_ASSIGNEE",
      code: "Assignee",
      label: "Assignee",
      enabled: false,
    },
    modifier: {
      type: "MODIFIER",
      code: "modifier",
      label: "modifier",
      noLabel: false,
    },
    Status: {
      type: "STATUS",
      code: "Status",
      label: "Status",
      enabled: false,
    },
    richText: {
      type: "RICH_TEXT",
      code: "richText",
      label: "richText",
      noLabel: false,
      required: false,
      defaultValue: "",
    },
    singleLineText: {
      type: "SINGLE_LINE_TEXT",
      code: "singleLineText",
      label: "singleLineText",
      noLabel: false,
      required: false,
      minLength: "",
      maxLength: "",
      expression: "",
      hideExpression: false,
      unique: false,
      defaultValue: "",
    },
    Categories: {
      type: "CATEGORY",
      code: "Categories",
      label: "Categories",
      enabled: false,
    },
    number: {
      type: "NUMBER",
      code: "number",
      label: "number",
      noLabel: false,
      required: false,
      minValue: "",
      maxValue: "",
      digit: false,
      unique: false,
      defaultValue: "",
      displayScale: "",
      unit: "",
      unitPosition: "BEFORE",
    },
    radioButton: {
      type: "RADIO_BUTTON",
      code: "radioButton",
      label: "radioButton",
      noLabel: false,
      required: true,
      options: {
        sample1: {
          label: "sample1",
          index: "0",
        },
        sample2: {
          label: "sample2",
          index: "1",
        },
      },
      defaultValue: "sample1",
      align: "HORIZONTAL",
    },
    multiLineText: {
      type: "MULTI_LINE_TEXT",
      code: "multiLineText",
      label: "multiLineText",
      noLabel: false,
      required: false,
      defaultValue: "",
    },
    createdTime: {
      type: "CREATED_TIME",
      code: "createdTime",
      label: "createdTime",
      noLabel: false,
    },
    checkBox: {
      type: "CHECK_BOX",
      code: "checkBox",
      label: "checkBox",
      noLabel: false,
      required: false,
      options: {
        '"sample1"': {
          label: '"sample1"',
          index: "0",
        },
        '"sample2"': {
          label: '"sample2"',
          index: "1",
        },
      },
      defaultValue: [],
      align: "HORIZONTAL",
    },
    calc: {
      type: "CALC",
      code: "calc",
      label: "calc",
      noLabel: false,
      required: false,
      expression: "number + number",
      format: "NUMBER",
      displayScale: "",
      hideExpression: false,
      unit: "",
      unitPosition: "BEFORE",
    },
    multiSelect: {
      type: "MULTI_SELECT",
      code: "multiSelect",
      label: "multiSelect",
      noLabel: false,
      required: false,
      options: {
        sample1: {
          label: "sample1",
          index: "0",
        },
        "tab\ttab": {
          label: "tab\ttab",
          index: "4",
        },
        '"sample2"': {
          label: '"sample2"',
          index: "1",
        },
        "sample4,sample5": {
          label: "sample4,sample5",
          index: "3",
        },
        '"sample3"': {
          label: '"sample3"',
          index: "2",
        },
      },
      defaultValue: [],
    },
    file: {
      type: "FILE",
      code: "file",
      label: "file",
      noLabel: false,
      required: false,
      thumbnailSize: "150",
    },
  },
};
