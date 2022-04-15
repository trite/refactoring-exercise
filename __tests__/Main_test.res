open Jest;

describe("Main - doThingsAndStuff", () => {
    open Main;
    open Expect;

    // doThingsAndStuff tests
    let testExpect = (toSort, expectedResult, msg) => {
        doThingsAndStuff(toSort) |> ignore
        test(msg, () => expect(toSort) -> toEqual(expectedResult))
    }

    testExpect(["foo", " ", "bar"], [" "], "single space string")

    // Verify multiple iterations proceed as expected
    testExpect(["   ", "foo", " ", "bar", "     "],
               ["     ", " ", "   "],
               "removes strings without spaces and partially orders")
    testExpect(["     ", " ", "   "],
               ["     ", "   ", " "],
               "finishes ordering")
    testExpect(["     ", "   ", " "],
               ["     ", "   ", " "],
               "no more changes to order")

    testExpect(["1", " 2", "3 ", " 4 ", "  5", "6  ", "  7  ", "8 8 8", " 9 9 "],
               [" 2", " 4 ", " 9 9 ", "8 8 8", "  7  ", "6  ", "  5", "3 "],
               "removes '1' and begins ordering the rest ")
    testExpect([" 2", " 4 ", " 9 9 ", "8 8 8", "  7  ", "6  ", "  5", "3 "],
               [" 2", " 4 ", " 9 9 ", "8 8 8", "  7  ", "  5", "3 ", "6  "],
               "continues ordering")
    testExpect([" 2", " 4 ", " 9 9 ", "8 8 8", "  7  ", "  5", "3 ", "6  "],
               [" 2", " 4 ", " 9 9 ", "8 8 8", "  7  ", "  5", "6  ", "3 "],
               "finishes ordering")
    testExpect([" 2", " 4 ", " 9 9 ", "8 8 8", "  7  ", "  5", "6  ", "3 "],
               [" 2", " 4 ", " 9 9 ", "8 8 8", "  7  ", "  5", "6  ", "3 "],
               "no more changes to order")

    testExpect([" 1", "2 "], [" 1", "2 "], "simple pairing that stays the same")

    testExpect(["2 ", " 1"], [" 1", "2 "], "simple pairing that reverse positions")

    testExpect(["a", " b", "c ", "d", "eeeee", "f  f", "gg", "  "],
               [" b", "f  f", "  ", "c "],
               "remove items and fully sort")
    testExpect([" b", "f  f", "  ", "c "],
               [" b", "f  f", "  ", "c "],
               "no more sorting to be done")

    testExpect([" ", "   ", "     "],
               ["     ", "   ", " "],
               "only spaces being reordered")
    testExpect(["     ", "   ", " "],
               ["     ", "   ", " "],
               "spaces that are already sorted")

    testExpect(["   ", " ", "     "],
               ["     ", " ", "   "],
               "spaces that partially reorder on first run")
    testExpect(["     ", " ", "   "],
               ["     ", "   ", " "],
               "spaces that finish reordering on second run")
});

describe("Main - insertAt", () => {
    open Main;
    open Expect;

    // insertAt tests
    test("insertAt 0 inserts at start", () =>
        expect(insertAt(0, "foo", ["bar", "baz"])) -> toEqual(["foo", "bar", "baz"]))

    test("insertAt 1 inserts at position 1", () =>
        expect(insertAt(1, "foo", ["bar", "baz"])) -> toEqual(["bar", "foo", "baz"]))

    test("insertAt 2 inserts at position 2", () =>
        expect(insertAt(2, "foo", ["bar", "baz"])) -> toEqual(["bar", "baz", "foo"]))

    test("insertAt beyond array range inserts at last position", () =>
        expect(insertAt(3, "foo", ["bar", "baz"])) -> toEqual(["bar", "baz", "foo"]))

    test("insertAt with negative value inserts at 0", () =>
        expect(insertAt(-1, "foo", ["bar", "baz"])) -> toEqual(["foo", "bar", "baz"]))
});

describe("Main - advanceState1", () => {
    open Main;
    open Expect;

    test("move last element into examining, examPosition set to 0", () =>
        expect(
            advanceState1(
                {
                    pullFrom: [" foo", "bar ", "a", "b"],
                    pushTo: []
                }
            )
        )
        -> toEqual(
            State2({
                pullFrom: [ " foo", "bar ", "a" ],
                pushTo: [],
                examining: "b",
                examPosition: 0,
                spaceInExam: false
            })
        ))
});

describe("Main - compare doThingsAndStuff with newVersion", () => {
    open Main;
    open Expect;
    open Js.Array;

    let compareTest = (msg, arr) => {
        let left = newVersion(copy(arr))
        let right = copy(arr)
        doThingsAndStuff(right) |> ignore

        test(msg, () => expect(left) -> toEqual(right))
    }

    compareTest("2 kepts strings", [" foo", "bar "])
    compareTest("1 kept, 2 dropped", ["foo", " ", "bar"])
    compareTest("3 kept, 2 dropped", ["   ", "foo", " ", "bar", "     "])
    compareTest("ordering of only spaces", ["     ", " ", "   "])
    compareTest("ordering of only spaces slightly different order", ["     ", "   ", " "])
    compareTest("lots of strings with numbers", ["1", " 2", "3 ", " 4 ", "  5", "6  ", "  7  ", "8 8 8", " 9 9 "])
    compareTest("lots of string with letters", ["a", " b", "c ", "d", "eeeee", "f  f", "gg", "  "])
});