@isolated
Feature: cli-kintone export command

  Scenario: CliKintoneTest-78 Should return the error message when the user has no privilege to view records.
    Given Load app ID of the app "app_for_export" as env var: "APP_ID"
    And Load username and password of the app "app_for_export" with exact permissions "add" as env vars: "USERNAME" and "PASSWORD"
    When I run the command with args "record export --base-url $$TEST_KINTONE_BASE_URL --app $APP_ID --username $USERNAME --password $PASSWORD"
    Then I should get the exit code is non-zero
    And The output error message should match with the pattern: "ERROR: \[403] \[CB_NO02] No privilege to proceed."

  Scenario: CliKintoneTest-79 Should return the record contents in CSV format of the app in a space.
    Given The app "app_in_space_for_export" has no records
    And The app "app_in_space_for_export" has some records as below:
      | Text  | Number |
      | Alice | 10     |
      | Bob   | 20     |
      | Jenny | 30     |
    And Load app ID of the app "app_in_space_for_export" as env var: "APP_ID"
    And Load app token of the app "app_in_space_for_export" with exact permissions "view" as env var: "API_TOKEN"
    When I run the command with args "record export --base-url $$TEST_KINTONE_BASE_URL --app $APP_ID --api-token $API_TOKEN"
    Then I should get the exit code is zero
    And The output message should match with the data below:
      | Record_number | Text  | Number |
      | \d+           | Alice | 10     |
      | \d+           | Bob   | 20     |
      | \d+           | Jenny | 30     |

  Scenario: CliKintoneTest-80 Should return the record contents in CSV format with an invalid --api-token and a valid --username/--password.
    Given The app "app_for_export" has no records
    And The app "app_for_export" has some records as below:
      | Text  | Number |
      | Alice | 10     |
      | Bob   | 20     |
      | Jenny | 30     |
    And Load app ID of the app "app_for_export" as env var: "APP_ID"
    And Load username and password of the app "app_for_export" with exact permissions "view" as env vars: "USERNAME" and "PASSWORD"
    When I run the command with args "record export --base-url $$TEST_KINTONE_BASE_URL --app $APP_ID --api-token INVALID_API_TOKEN --username $USERNAME --password $PASSWORD"
    Then I should get the exit code is zero
    And The output message should match with the data below:
      | Record_number | Text  | Number |
      | \d+           | Alice | 10     |
      | \d+           | Bob   | 20     |
      | \d+           | Jenny | 30     |

  Scenario: CliKintoneTest-81 Should return the record contents in CSV format.
    Given The app "app_for_export" has no records
    And The app "app_for_export" has some records as below:
      | Text  | Number |
      | Alice | 10     |
      | Bob   | 20     |
      | Jenny | 30     |
    And Load app ID of the app "app_for_export" as env var: "APP_ID"
    And Load app token of the app "app_for_export" with exact permissions "view" as env var: "API_TOKEN"
    When I run the command with args "record export --base-url $$TEST_KINTONE_BASE_URL --app $APP_ID --api-token $API_TOKEN"
    Then I should get the exit code is zero
    And The output message should match with the data below:
      | Record_number | Text  | Number |
      | \d+           | Alice | 10     |
      | \d+           | Bob   | 20     |
      | \d+           | Jenny | 30     |

  Scenario: CliKintoneTest-82 Should return the error message when exporting the record with a draft API Token.
    Given Load app ID of the app "app_for_draft_token" as env var: "APP_ID"
    And Load app token of the app "app_for_draft_token" with exact permissions "view" as env var: "DRAFT_API_TOKEN"
    When I run the command with args "record export --base-url $$TEST_KINTONE_BASE_URL --app $APP_ID --api-token $DRAFT_API_TOKEN"
    Then I should get the exit code is non-zero
    And The output error message should match with the pattern: "\[400] \[GAIA_IA02] The specified API token does not match the API token generated via an app."

  Scenario: CliKintoneTest-83 Should return the error message when exporting the record with a non-relevant API Token.
    Given Load app ID of the app "app_for_export" as env var: "APP_ID"
    And Load app token of the app "app_for_export" with exact permissions "add" as env var: "NON_RELEVANT_API_TOKEN"
    When I run the command with args "record export --base-url $$TEST_KINTONE_BASE_URL --app $APP_ID --api-token $NON_RELEVANT_API_TOKEN"
    Then I should get the exit code is non-zero
    And The output error message should match with the pattern: "\[403] \[GAIA_NO01] Using this API token, you cannot run the specified API."

  Scenario: CliKintoneTest-84 Should return the error message when exporting the record with duplicated API Tokens in same app.
    Given Load app ID of the app "app_for_export" as env var: "APP_ID"
    And Load app token of the app "app_for_export" with exact permissions "add" as env var: "API_TOKEN_1"
    And Load app token of the app "app_for_export" with exact permissions "view" as env var: "API_TOKEN_2"
    When I run the command with args "record export --base-url $$TEST_KINTONE_BASE_URL --app $APP_ID --api-token $API_TOKEN_1,$API_TOKEN_2"
    Then I should get the exit code is non-zero
    And The output error message should match with the pattern: "\[400] \[GAIA_DA03] You cannot specify a duplicate API token for the same app."

  Scenario: CliKintoneTest-85 Should return the record contents with two valid API tokens in different apps.
    Given The app "app_for_export" has no records
    And The app "app_for_export" has some records as below:
      | Text  | Number |
      | Alice | 10     |
      | Bob   | 20     |
      | Jenny | 30     |
    And Load app ID of the app "app_for_export" as env var: "APP_ID"
    And Load app token of the app "app_for_export" with exact permissions "view" as env var: "API_TOKEN_1"
    And Load app token of the app "app_for_import" with exact permissions "view,add" as env var: "API_TOKEN_2"
    When I run the command with args "record export --base-url $$TEST_KINTONE_BASE_URL --app $APP_ID --api-token $API_TOKEN_1,$API_TOKEN_2"
    Then I should get the exit code is zero
    And The output message should match with the data below:
      | Record_number | Text  | Number |
      | \d+           | Alice | 10     |
      | \d+           | Bob   | 20     |
      | \d+           | Jenny | 30     |

  Scenario: CliKintoneTest-86 Should return the error message when exporting the record with multiple API tokens, including a valid API token and an invalid API token.
    Given Load app ID of the app "app_for_export" as env var: "APP_ID"
    And Load app token of the app "app_for_export" with exact permissions "view" as env var: "API_TOKEN_1"
    When I run the command with args "record export --base-url $$TEST_KINTONE_BASE_URL --app $APP_ID --api-token $API_TOKEN_1,INVALID_API_TOKEN"
    Then I should get the exit code is non-zero
    And The output error message should match with the pattern: "\[400] \[GAIA_IA02] The specified API token does not match the API token generated via an app."

  Scenario: CliKintoneTest-87 Should return the record contents in CSV format with --username and --password options.
    Given The app "app_for_export" has no records
    And The app "app_for_export" has some records as below:
      | Text  | Number |
      | Alice | 10     |
      | Bob   | 20     |
      | Jenny | 30     |
    And Load app ID of the app "app_for_export" as env var: "APP_ID"
    And Load username and password of the app "app_for_export" with exact permissions "view" as env vars: "USERNAME" and "PASSWORD"
    When I run the command with args "record export --base-url $$TEST_KINTONE_BASE_URL --app $APP_ID --username $USERNAME --password $PASSWORD"
    Then I should get the exit code is zero
    And The output message should match with the data below:
      | Record_number | Text  | Number |
      | \d+           | Alice | 10     |
      | \d+           | Bob   | 20     |
      | \d+           | Jenny | 30     |

  Scenario: CliKintoneTest-88 Should return the record contents in CSV format with -u and --password options.
    Given The app "app_for_export" has no records
    And The app "app_for_export" has some records as below:
      | Text  | Number |
      | Alice | 10     |
      | Bob   | 20     |
      | Jenny | 30     |
    And Load app ID of the app "app_for_export" as env var: "APP_ID"
    And Load username and password of the app "app_for_export" with exact permissions "view" as env vars: "USERNAME" and "PASSWORD"
    When I run the command with args "record export --base-url $$TEST_KINTONE_BASE_URL --app $APP_ID -u $USERNAME --password $PASSWORD"
    Then I should get the exit code is zero
    And The output message should match with the data below:
      | Record_number | Text  | Number |
      | \d+           | Alice | 10     |
      | \d+           | Bob   | 20     |
      | \d+           | Jenny | 30     |

  Scenario: CliKintoneTest-89 Should return the record contents in CSV format with --username and -p options.
    Given The app "app_for_export" has no records
    And The app "app_for_export" has some records as below:
      | Text  | Number |
      | Alice | 10     |
      | Bob   | 20     |
      | Jenny | 30     |
    And Load app ID of the app "app_for_export" as env var: "APP_ID"
    And Load username and password of the app "app_for_export" with exact permissions "view" as env vars: "USERNAME" and "PASSWORD"
    When I run the command with args "record export --base-url $$TEST_KINTONE_BASE_URL --app $APP_ID --username $USERNAME -p $PASSWORD"
    Then I should get the exit code is zero
    And The output message should match with the data below:
      | Record_number | Text  | Number |
      | \d+           | Alice | 10     |
      | \d+           | Bob   | 20     |
      | \d+           | Jenny | 30     |

  Scenario: CliKintoneTest-90 Should return the record contents and download attachments successfully to an existing directory.
    Given The app "app_for_export_attachments" has no records
    And I have a file "attachments/file1.txt" with content: "123"
    And The app "app_for_export_attachments" has some records with attachments in directory "attachments" as below:
      | Text  | Attachment |
      | Alice | file1.txt  |
    And Load the record numbers of the app "app_for_export_attachments" as variable: "RECORD_NUMBERS"
    And Load app ID of the app "app_for_export_attachments" as env var: "APP_ID"
    And Load app token of the app "app_for_export_attachments" with exact permissions "view" as env var: "API_TOKEN"
    And I have a directory "exported-attachments"
    When I run the command with args "record export --base-url $$TEST_KINTONE_BASE_URL --app $APP_ID --api-token $API_TOKEN --attachments-dir exported-attachments"
    Then I should get the exit code is zero
    # [\/\\\\] is used to match both Windows and Unix path separators
    And The output message should match with the data below:
      | Record_number      | Text  | Attachment                                     |
      | $RECORD_NUMBERS[0] | Alice | Attachment-$RECORD_NUMBERS[0][\/\\\\]file1.txt |
    And The directory "exported-attachments" should contain files with filename and content as below:
      | FilePath                      | FileName  | Content |
      | Attachment-$RECORD_NUMBERS[0] | file1.txt | 123     |

  Scenario: CliKintoneTest-91 Should return the record contents and download attachments successfully to a non-existent directory.
    Given The app "app_for_export_attachments" has no records
    And I have a file "attachments/file1.txt" with content: "123"
    And The app "app_for_export_attachments" has some records with attachments in directory "attachments" as below:
      | Text  | Attachment |
      | Alice | file1.txt  |
    And Load the record numbers of the app "app_for_export_attachments" as variable: "RECORD_NUMBERS"
    And Load app ID of the app "app_for_export_attachments" as env var: "APP_ID"
    And Load app token of the app "app_for_export_attachments" with exact permissions "view" as env var: "API_TOKEN"
    When I run the command with args "record export --base-url $$TEST_KINTONE_BASE_URL --app $APP_ID --api-token $API_TOKEN --attachments-dir new-directory"
    Then I should get the exit code is zero
    And The output message should match with the data below:
      | Record_number      | Text  | Attachment                                     |
      | $RECORD_NUMBERS[0] | Alice | Attachment-$RECORD_NUMBERS[0][\/\\\\]file1.txt |
    And The directory "new-directory" should contain files with filename and content as below:
      | FilePath                      | FileName  | Content |
      | Attachment-$RECORD_NUMBERS[0] | file1.txt | 123     |

  Scenario: CliKintoneTest-92 Should return the record contents and download attachments successfully with attachments in different records.
    Given The app "app_for_export_attachments" has no records
    And I have a file in "attachments/file1.txt"
    And I have a file in "attachments/image1.png"
    And The app "app_for_export_attachments" has some records with attachments in directory "attachments" as below:
      | Text  | Attachment |
      | Alice | file1.txt  |
      | Bob   | image1.png |
    And Load the record numbers of the app "app_for_export_attachments" as variable: "RECORD_NUMBERS"
    And Load app ID of the app "app_for_export_attachments" as env var: "APP_ID"
    And Load app token of the app "app_for_export_attachments" with exact permissions "view" as env var: "API_TOKEN"
    When I run the command with args "record export --base-url $$TEST_KINTONE_BASE_URL --app $APP_ID --api-token $API_TOKEN --attachments-dir exported-attachments"
    Then I should get the exit code is zero
    And The output message should match with the data below:
      | Record_number      | Text  | Attachment                                      |
      | $RECORD_NUMBERS[0] | Alice | Attachment-$RECORD_NUMBERS[0][\/\\\\]file1.txt  |
      | $RECORD_NUMBERS[1] | Bob   | Attachment-$RECORD_NUMBERS[1][\/\\\\]image1.png |
    And The exported files should match as below:
      | Expected_FilePath      | Actual_FilePath                                               |
      | attachments/file1.txt  | exported-attachments/Attachment-$RECORD_NUMBERS[0]/file1.txt  |
      | attachments/image1.png | exported-attachments/Attachment-$RECORD_NUMBERS[1]/image1.png |

  Scenario: CliKintoneTest-93 Should return the record contents and download attachments successfully with attachments in a record.
    Given The app "app_for_export_attachments" has no records
    And I have a file in "attachments/file1.txt"
    And I have a file in "attachments/Image1.png"
    And The app "app_for_export_attachments" has some records with attachments in directory "attachments" as below:
      | Text  | Attachment            |
      | Alice | file1.txt\nImage1.png |
    And Load the record numbers of the app "app_for_export_attachments" as variable: "RECORD_NUMBERS"
    And Load app ID of the app "app_for_export_attachments" as env var: "APP_ID"
    And Load app token of the app "app_for_export_attachments" with exact permissions "view" as env var: "API_TOKEN"
    When I run the command with args "record export --base-url $$TEST_KINTONE_BASE_URL --app $APP_ID --api-token $API_TOKEN --attachments-dir exported-attachments"
    Then I should get the exit code is zero
    And The output message should match with the data below:
      | Record_number      | Text  | Attachment                                                                                      |
      | $RECORD_NUMBERS[0] | Alice | Attachment-$RECORD_NUMBERS[0][\/\\\\]file1.txt\nAttachment-$RECORD_NUMBERS[0][\/\\\\]Image1.png |
    And The exported files should match as below:
      | Expected_FilePath      | Actual_FilePath                                               |
      | attachments/file1.txt  | exported-attachments/Attachment-$RECORD_NUMBERS[0]/file1.txt  |
      | attachments/Image1.png | exported-attachments/Attachment-$RECORD_NUMBERS[0]/Image1.png |

  Scenario: CliKintoneTest-94 Should return the record contents and download attachments successfully with a TXT file.
    Given The app "app_for_export_attachments" has no records
    And I have a file "attachments/file1.txt" with content: "123"
    And The app "app_for_export_attachments" has some records with attachments in directory "attachments" as below:
      | Text  | Attachment |
      | Alice | file1.txt  |
    And Load the record numbers of the app "app_for_export_attachments" as variable: "RECORD_NUMBERS"
    And Load app ID of the app "app_for_export_attachments" as env var: "APP_ID"
    And Load app token of the app "app_for_export_attachments" with exact permissions "view" as env var: "API_TOKEN"
    When I run the command with args "record export --base-url $$TEST_KINTONE_BASE_URL --app $APP_ID --api-token $API_TOKEN --attachments-dir exported-attachments"
    Then I should get the exit code is zero
    And The output message should match with the data below:
      | Record_number      | Text  | Attachment                                     |
      | $RECORD_NUMBERS[0] | Alice | Attachment-$RECORD_NUMBERS[0][\/\\\\]file1.txt |
    And The directory "exported-attachments" should contain files with filename and content as below:
      | FilePath                      | FileName  | Content |
      | Attachment-$RECORD_NUMBERS[0] | file1.txt | 123     |

  Scenario: CliKintoneTest-95 Should return the record contents with valid condition query.
    Given The app "app_for_export" has no records
    And The app "app_for_export" has some records as below:
      | Text  | Number |
      | Alice | 10     |
      | Bob   | 20     |
      | Jenny | 30     |
    And Load app ID of the app "app_for_export" as env var: "APP_ID"
    And Load app token of the app "app_for_export" with exact permissions "view" as env var: "API_TOKEN"
    When I run the command with args "record export --base-url $$TEST_KINTONE_BASE_URL --app $APP_ID --api-token $API_TOKEN --condition Number>=20"
    Then I should get the exit code is zero
    And The output message should match with the data below:
      | Record_number | Text  | Number |
      | \d+           | Bob   | 20     |
      | \d+           | Jenny | 30     |

  Scenario: CliKintoneTest-96 Should return the error message when exporting the record with invalid condition query.
    Given The app "app_for_export" has no records
    And The app "app_for_export" has some records as below:
      | Text  | Number |
      | Alice | 10     |
    And Load app ID of the app "app_for_export" as env var: "APP_ID"
    And Load app token of the app "app_for_export" with exact permissions "view" as env var: "API_TOKEN"
    When I run the command with args "record export --base-url $$TEST_KINTONE_BASE_URL --app $APP_ID --api-token $API_TOKEN --condition Unknown_Field>=20"
    Then I should get the exit code is non-zero
    And The output error message should match with the pattern: "\[400] \[GAIA_IQ11] Specified field \(Unknown_Field\) not found."

  Scenario: CliKintoneTest-97 Should return the record contents with valid condition query (-c option).
    Given The app "app_for_export" has no records
    And The app "app_for_export" has some records as below:
      | Text  | Number |
      | Alice | 10     |
      | Bob   | 20     |
      | Jenny | 30     |
    And Load app ID of the app "app_for_export" as env var: "APP_ID"
    And Load app token of the app "app_for_export" with exact permissions "view" as env var: "API_TOKEN"
    When I run the command with args "record export --base-url $$TEST_KINTONE_BASE_URL --app $APP_ID --api-token $API_TOKEN -c Number>=20"
    Then I should get the exit code is zero
    And The output message should match with the data below:
      | Record_number | Text  | Number |
      | \d+           | Bob   | 20     |
      | \d+           | Jenny | 30     |

  Scenario: CliKintoneTest-98 Should return the record contents with valid --order-by option.
    Given The app "app_for_export" has no records
    And The app "app_for_export" has some records as below:
      | Text  | Number |
      | Alice | 20     |
      | Bob   | 10     |
      | Jenny | 30     |
    And Load app ID of the app "app_for_export" as env var: "APP_ID"
    And Load app token of the app "app_for_export" with exact permissions "view" as env var: "API_TOKEN"
    When I run the command with args "record export --base-url $$TEST_KINTONE_BASE_URL --app $APP_ID --api-token $API_TOKEN --order-by 'Number desc'"
    Then I should get the exit code is zero
    And The output message should match the data in the order as below:
      | Record_number | Text  | Number |
      | \d+           | Jenny | 30     |
      | \d+           | Alice | 20     |
      | \d+           | Bob   | 10     |

  Scenario: CliKintoneTest-99 Should return the error message when exporting the record with invalid order by query.
    Given The app "app_for_export" has no records
    And The app "app_for_export" has some records as below:
      | Text  | Number |
      | Alice | 10     |
    And Load app ID of the app "app_for_export" as env var: "APP_ID"
    And Load app token of the app "app_for_export" with exact permissions "view" as env var: "API_TOKEN"
    When I run the command with args "record export --base-url $$TEST_KINTONE_BASE_URL --app $APP_ID --api-token $API_TOKEN --order-by 'Unknown_Field desc'"
    Then I should get the exit code is non-zero
    And The output error message should match with the pattern: "\[400] \[GAIA_IQ11] Specified field \(Unknown_Field\) not found."

  Scenario: CliKintoneTest-100 Should return the record contents when exporting the record with --fields specified.
    Given The app "app_for_export" has no records
    And The app "app_for_export" has some records as below:
      | Text  | Number |
      | Alice | 10     |
      | Bob   | 20     |
      | Jenny | 30     |
    And Load app ID of the app "app_for_export" as env var: "APP_ID"
    And Load app token of the app "app_for_export" with exact permissions "view" as env var: "API_TOKEN"
    When I run the command with args "record export --base-url $$TEST_KINTONE_BASE_URL --app $APP_ID --api-token $API_TOKEN --fields Number"
    Then I should get the exit code is zero
    And The output message should match with the pattern: "\"Number\"\n\"10\"\n\"20\"\n\"30\""

  Scenario: CliKintoneTest-101 Should return the record contents when exporting the record with --fields specified, including multiple existent field codes.
    Given The app "app_for_export" has no records
    And The app "app_for_export" has some records as below:
      | Text  | Number |
      | Alice | 10     |
      | Bob   | 20     |
      | Jenny | 30     |
    And Load app ID of the app "app_for_export" as env var: "APP_ID"
    And Load app token of the app "app_for_export" with exact permissions "view" as env var: "API_TOKEN"
    When I run the command with args "record export --base-url $$TEST_KINTONE_BASE_URL --app $APP_ID --api-token $API_TOKEN --fields Record_number,Number"
    Then I should get the exit code is zero
    And The output message should match with the data below:
      | Record_number | Number |
      | \d+           | 10     |
      | \d+           | 20     |
      | \d+           | 30     |

  Scenario: CliKintoneTest-102 Should return the error message when exporting records with --fields specified, including existent and non-existent field codes.
    Given Load app ID of the app "app_for_export" as env var: "APP_ID"
    And Load app token of the app "app_for_export" with exact permissions "view" as env var: "API_TOKEN"
    When I run the command with args "record export --base-url $$TEST_KINTONE_BASE_URL --app $APP_ID --api-token $API_TOKEN --fields Number,Non_Existent_Field_Code"
    Then I should get the exit code is non-zero
    And The output error message should match with the pattern: "Error: The specified field \"Non_Existent_Field_Code\" does not exist on the app"

  Scenario: CliKintoneTest-103 Should return the error message when exporting records with --fields specified, including fields within a table.
    Given Load app ID of the app "app_for_export_table" as env var: "APP_ID"
    And Load app token of the app "app_for_export_table" with exact permissions "view" as env var: "API_TOKEN"
    When I run the command with args "record export --base-url $$TEST_KINTONE_BASE_URL --app $APP_ID --api-token $API_TOKEN --fields Text"
    Then I should get the exit code is non-zero
    And The output error message should match with the pattern: "Error: The field in a Table cannot be specified to the fields option \(\"Text\"\)"

  Scenario: CliKintoneTest-104 Should return the record contents when exporting the record with --fields specified, including field code of the table.
    Given The app "app_for_export_table" has no records
    And The app "app_for_export_table" has some records as below:
      | Text_0 | Table | Text  | Number |
      | Lisa   | 1     | Alice | 10     |
      | Rose   | 2     | Bob   | 20     |
      | Jenny  | 3     | Jenny | 30     |
    And Load app ID of the app "app_for_export_table" as env var: "APP_ID"
    And Load app token of the app "app_for_export_table" with exact permissions "view" as env var: "API_TOKEN"
    When I run the command with args "record export --base-url $$TEST_KINTONE_BASE_URL --app $APP_ID --api-token $API_TOKEN --fields Table"
    Then I should get the exit code is zero
    And The output message with table field should match the data below:
      | * | Table | Text  | Number |
      | * | \d+   | Alice | 10     |
      | * | \d+   | Bob   | 20     |
      | * | \d+   | Jenny | 30     |

  Scenario: CliKintoneTest-109 Should return the record contents when exporting the record with correct --guest-space-id specified
    Given The app "app_in_guest_space" has no records
    And The app "app_in_guest_space" has some records as below:
      | Text  | Number |
      | Alice | 10     |
      | Bob   | 20     |
      | Jenny | 30     |
    And Load app ID of the app "app_in_guest_space" as env var: "APP_ID"
    And Load guest space ID of the app "app_in_guest_space" as env var: "GUEST_SPACE_ID"
    And Load app token of the app "app_in_guest_space" with exact permissions "view" as env var: "API_TOKEN"
    When I run the command with args "record export --base-url $$TEST_KINTONE_BASE_URL --app $APP_ID --api-token $API_TOKEN --guest-space-id $GUEST_SPACE_ID"
    Then I should get the exit code is zero
    And The output message should match with the data below:
      | Record_number | Text  | Number |
      | \d+           | Alice | 10     |
      | \d+           | Bob   | 20     |
      | \d+           | Jenny | 30     |

  Scenario: CliKintoneTest-110 Should return the error message when exporting the record with incorrect --guest-space-id
    Given Load app ID of the app "app_in_guest_space" as env var: "APP_ID"
    And Load app token of the app "app_in_guest_space" with exact permissions "view" as env var: "API_TOKEN"
    When I run the command with args "record export --base-url $$TEST_KINTONE_BASE_URL --app $APP_ID --api-token $API_TOKEN --guest-space-id 9999999999999999999"
    Then I should get the exit code is non-zero
    And The output error message should match with the pattern: "\[403] \[CB_NO02] No privilege to proceed"

  Scenario: CliKintoneTest-111 Should return the record contents when exporting the record with --encoding option is utf8.
    Given The app "app_for_export" has no records
    And The app "app_for_export" has some records as below:
      | Text   | Number |
      | レコード番号 | 10     |
    And Load app ID of the app "app_for_export" as env var: "APP_ID"
    And Load app token of the app "app_for_export" with exact permissions "view" as env var: "API_TOKEN"
    When I run the command with args "record export --base-url $$TEST_KINTONE_BASE_URL --app $APP_ID --api-token $API_TOKEN --encoding utf8"
    Then I should get the exit code is zero
    And The output message with "utf8" encoded should match with the data below:
      | Record_number | Text   | Number |
      | \d+           | レコード番号 | 10     |

  Scenario: CliKintoneTest-112 Should return the record contents when exporting the record with --encoding option is sjis.
    Given The app "app_for_export" has no records
    And The app "app_for_export" has some records as below:
      | Text | Number |
      | 作成日時 | 10     |
    And Load app ID of the app "app_for_export" as env var: "APP_ID"
    And Load app token of the app "app_for_export" with exact permissions "view" as env var: "API_TOKEN"
    When I run the command with args "record export --base-url $$TEST_KINTONE_BASE_URL --app $APP_ID --api-token $API_TOKEN --encoding sjis"
    Then I should get the exit code is zero
    And The output message with "sjis" encoded should match with the data below:
      | Record_number | Text | Number |
      | \d+           | 作成日時 | 10     |

  Scenario: CliKintoneTest-113 Should return the error message when exporting the record with an unsupported character encoding.
    Given Load app ID of the app "app_for_export" as env var: "APP_ID"
    And Load app token of the app "app_for_export" with exact permissions "view" as env var: "API_TOKEN"
    When I run the command with args "record export --base-url $$TEST_KINTONE_BASE_URL --app $APP_ID --api-token $API_TOKEN --encoding unsupported_encoding"
    Then I should get the exit code is non-zero
    And The output error message should match with the pattern: "Argument: encoding, Given: \"unsupported_encoding\", Choices: \"utf8\", \"sjis\""

  Scenario: CliKintoneTest-124 Should return the record contents successfully, including table data, when exporting the records
    Given Load app ID of the app "app_for_export_table" as env var: "APP_ID"
    And Load app token of the app "app_for_export_table" with exact permissions "view" as env var: "API_TOKEN"
    And The app "app_for_export_table" has no records
    And The app "app_for_export_table" has some records as below:
      | * | Text_0 | Text          | Number |
      | * | Lisa   | Lisa Pink     | 10     |
      | * | Rose   | Rose Roseanne | 20     |
      | * | Bob    | Bob Dylan     | 30     |
      | * | Jenny  | Jenny_1       | 40     |
      |   | Jenny  | Jenny_2       | 50     |
    When I run the command with args "record export --base-url $$TEST_KINTONE_BASE_URL --app $APP_ID --api-token $API_TOKEN"
    Then I should get the exit code is zero
    And The app "app_for_export_table" with table field should have records as below:
      | * | Text_0 | Table | (Table.Text)  | (Table.Number) |
      | * | Lisa   | \d+   | Lisa Pink     | 10             |
      | * | Rose   | \d+   | Rose Roseanne | 20             |
      | * | Bob    | \d+   | Bob Dylan     | 30             |
      | * | Jenny  | \d+   | Jenny_1       | 40             |
      |   | Jenny  | \d+   | Jenny_2       | 50             |

  Scenario: CliKintoneTest-125 Should return only field codes when exporting the records of the app which no data
    Given Load app ID of the app "app_for_export_table" as env var: "APP_ID"
    And Load app token of the app "app_for_export_table" with exact permissions "view" as env var: "API_TOKEN"
    And The app "app_for_export_table" has no records
    When I run the command with args "record export --base-url $$TEST_KINTONE_BASE_URL --app $APP_ID --api-token $API_TOKEN"
    Then I should get the exit code is zero
    And The output message should match with the pattern: "\*,\"Record_number\",\"Text_0\",\"Table\",\"Text\",\"Number\"(.*)\n$"
