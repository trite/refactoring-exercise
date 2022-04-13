// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Jest = require("@glennsl/rescript-jest/src/jest.bs.js");
var Main = require("../src/Main.bs.js");

Jest.describe("Main", (function (param) {
        var x = [
          "asdf",
          " ",
          "asdf2"
        ];
        Main.doThingsAndStuff(x);
        Jest.test("return 1 set of spaces in array", (function (param) {
                return Jest.Expect.toEqual(Jest.Expect.expect(x), [" "]);
              }));
        var x$1 = [
          "   ",
          "asdf",
          " ",
          "asdf2",
          "     "
        ];
        Main.doThingsAndStuff(x$1);
        return Jest.test("multiple sets of spaces are returned in reverse order", (function (param) {
                      return Jest.Expect.toEqual(Jest.Expect.expect(x$1), [
                                  "     ",
                                  " ",
                                  "   "
                                ]);
                    }));
      }));

/*  Not a pure module */
