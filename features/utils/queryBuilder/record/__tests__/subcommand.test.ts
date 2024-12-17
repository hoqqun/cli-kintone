import { getArgumentsListBySubcommand, SUBCOMMANDS } from "../subcommand";
import * as Arguments from "../../arguments";

describe("Record - Subcommand", () => {
  describe("getArgumentsListBySubcommand", () => {
    const patterns = [
      {
        subcommand: SUBCOMMANDS.IMPORT,
        expectedInstances: [
          Arguments.BaseUrl,
          Arguments.App,
          Arguments.FilePath,
          Arguments.Username,
          Arguments.Password,
          Arguments.ApiToken,
          Arguments.GuestSpaceId,
          Arguments.AttachmentsDir,
          Arguments.Encoding,
          Arguments.UpdateKey,
          Arguments.Fields,
          Arguments.Timeout,
        ],
      },
      {
        subcommand: SUBCOMMANDS.EXPORT,
        expectedInstances: [
          Arguments.BaseUrl,
          Arguments.App,
          Arguments.Username,
          Arguments.Password,
          Arguments.ApiToken,
          Arguments.GuestSpaceId,
          Arguments.AttachmentsDir,
          Arguments.Encoding,
          Arguments.Fields,
          Arguments.Condition,
          Arguments.OrderBy,
          Arguments.Timeout,
        ],
      },
      {
        subcommand: SUBCOMMANDS.DELETE,
        expectedInstances: [
          Arguments.BaseUrl,
          Arguments.App,
          Arguments.ApiToken,
          Arguments.GuestSpaceId,
          Arguments.FilePath,
          Arguments.Encoding,
          Arguments.Yes,
          Arguments.Timeout,
        ],
      },
    ];

    it.each(patterns)(
      "should return the arguments list of the record $subcommand correctly",
      ({ subcommand, expectedInstances }) => {
        const argsList = getArgumentsListBySubcommand({} as any, subcommand);
        argsList.forEach((arg) => {
          expect(
            expectedInstances.some(
              (expectedInstance) => arg instanceof expectedInstance,
            ),
          ).toBe(true);
        });
      },
    );
  });
});
