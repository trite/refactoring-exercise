open Jest;

describe("Main", () => {
    open Main;
    open Expect;

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

    // testExpect([], [], "")


    
});