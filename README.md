# cli-kintone

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

A kintone record importer and exporter.

**THIS IS EXPERIMENTAL, AND THESE FEATURES ARE NOT SUPPORTED YET.**

---

- [Installation](#installation)
- [Usage](#usage)
  - [import](#import)
    - [Options](#options)
  - [export](#export)
    - [Options](#options-1)
- [Supported file formats](#supported-file-formats)
  - [CSV format](#csv-format)
- [LICENSE](#license)

## Installation

// TODO: Write installation guide

## Usage

### import

`import` command allows you to import record data into a specified kintone app.

```
$ cli-kintone record import \
--base-url https://${yourDomain} \
--username ${yourLoginName} \
--password ${yourPassword} \
--app ${kintoneAppId} \
--file-path ${filepath}
```

#### Options

Some options use environment variables starting `KINTONE_` as default values.

```
Options:
      --version              Show version number                       [boolean]
      --help                 Show help                                 [boolean]
      --base-url             Kintone Base Url
                                 [string] [required] [default: KINTONE_BASE_URL]
  -u, --username             Kintone Username
                                            [string] [default: KINTONE_USERNAME]
  -p, --password             Kintone Password
                                            [string] [default: KINTONE_PASSWORD]
      --api-token            App's API token[array] [default: KINTONE_API_TOKEN]
      --basic-auth-username  Kintone Basic Auth Username
                                 [string] [default: KINTONE_BASIC_AUTH_USERNAME]
      --basic-auth-password  Kintone Basic Auth Password
                                 [string] [default: KINTONE_BASIC_AUTH_PASSWORD]
      --app                  The ID of the app               [string] [required]
      --guest-space-id       The ID of guest space
                                      [string] [default: KINTONE_GUEST_SPACE_ID]
      --attachments-dir      Attachment file directory                  [string]
      --file-path            The path to source file.
                             The file extension should be ".csv"
                                                             [string] [required]
      --encoding             Character encoding
                                     [choices: "utf8", "sjis"] [default: "utf8"]
      --update-key           The key to Bulk Update                     [string]
      --fields               The fields to be imported in comma-separated
                                                                        [string]
      --pfx-file-path        The path to client certificate file        [string]
      --pfx-file-password    The password of client certificate file    [string]
      --proxy                The URL of a proxy server
                                                 [string] [default: HTTPS_PROXY]
```

#### Import Attachment field

If records contains Attachment field, `--attachments-dir` option is required.

- the local file path in record is treated as relative path from `--attachments-dir`
  - upload the file there
- file name on kintone is same as local

#### Upsert records

When `--update-key` option is set, the option value is used as “Key to Bulk Update” to import (upsert) records.

"Upsert" means updating and/or inserting records at the same time. Data containing keys that match existing record values is used to update those records accordingly, and the remaining data is added to the specified app as new records.

The field specified as "Key to Bulk Update" should meet the following requirements:

- be Record Number field
- be one of the following field types with "Prohibit duplicate values" enabled
  - Text
  - Number

NOTE: When the field specified as "Key to Bulk Update" is Record Number, the value of the field may have app code of the target app.

### export

`export` command allows you to export record data from a specified kintone app.

```
$ cli-kintone record export \
--base-url https://${yourDomain} \
--username ${yourLoginName} \
--password ${yourPassword} \
--app ${kintoneAppId} \
> ${filepath}
```

#### Options

Some options use environment variables starting `KINTONE_` as default values.

```
Options:
      --version              Show version number                       [boolean]
      --help                 Show help                                 [boolean]
      --base-url             Kintone Base Url
                                 [string] [required] [default: KINTONE_BASE_URL]
  -u, --username             Kintone Username
                                            [string] [default: KINTONE_USERNAME]
  -p, --password             Kintone Password
                                            [string] [default: KINTONE_PASSWORD]
      --api-token            App's API token[array] [default: KINTONE_API_TOKEN]
      --basic-auth-username  Kintone Basic Auth Username
                                 [string] [default: KINTONE_BASIC_AUTH_USERNAME]
      --basic-auth-password  Kintone Basic Auth Password
                                 [string] [default: KINTONE_BASIC_AUTH_PASSWORD]
      --app                  The ID of the app               [string] [required]
      --guest-space-id       The ID of guest space
                                      [string] [default: KINTONE_GUEST_SPACE_ID]
      --attachments-dir      Attachment file directory                  [string]
      --encoding             Character encoding
                                     [choices: "utf8", "sjis"] [default: "utf8"]
  -c, --condition            The query string                           [string]
      --order-by             The sort order as a query                  [string]
      --fields               The fields to be exported in comma-separated
                                                                        [string]
      --pfx-file-path        The path to client certificate file        [string]
      --pfx-file-password    The password of client certificate file    [string]
      --proxy                The URL of a proxy server
                                                 [string] [default: HTTPS_PROXY]
```

#### Download attachment files

If set `--attachments-dir` option, attachment files will be downloaded to local directory.

- the file path is `<attachmentsDir>/<fieldCode>-<recordId>/<filename>`
  - as for attachments in Table, the file path is `<attachmentsDir>/<fieldCode>-<recordId>-<tableRowIndex>/<filename>`
- if same name files exist in same Attachment field, renamed to `<filename> (<index>).<ext>`

## Supported file formats

cli-kintone supports following formats for both import/export commands.

- CSV

When importing, it determines the format automatically by the extension of the file (specified by `--file-path` option).

The detailed formats are as follows:

### CSV format

The first row (header row) lists the **field codes** of each field.  
Each subsequent row corresponds to a record. Each value represents the value of the field.

```csv
"Record_number","FieldCode1","FieldCode2"
"1","foo","bar"
"2","baz","qux"
```

Here are considerations for some field types:

#### Text area

If the value contains line break, enclose the value in double quotes.

```csv
"TextAreaField"
"multi
line
text"
```

#### Check box, Multi-choice

Specify multiple values divided by line break (\n).

```csv
"CheckboxField"
"value1
value2"
```

#### User Selection, Department Selection, Group Selection

If multiple value is selected, separated with line break (\n). (equivalent to `value.code` in REST API).

```csv
"userSelectionField","departmentSelectionField","groupSelectionField"
"John
Bob","Development Div","Administrators"
```

#### Created by, Updated by

Specify the user's login name (equivalent to `value.code` in REST API).

```csv
"Created_by"
"John"
```

#### Attachment

Files in same Attachment field (in same Table row) are separated with line break (\n).

```csv
"file"
"file-9/test.txt
file-9/test (1).txt"
```

```csv
"fileInTable"
"fileInTable-1-0/test.txt
fileInTable-1-0/test (1).txt"
```

When export, if NOT set `--attachments-dir` option, only the file name will be output.

```csv
"fileFieldCode"
"test.txt
test.txt"
```

## LICENSE

- [MIT](https://github.com/kintone/cli-kintone/blob/main/LICENSE)
