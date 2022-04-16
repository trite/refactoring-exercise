open Jest

describe("PossibleGoal - filterSort", () => {
    open PossibleGoal
    open Expect

    let testExpect = (toSort, expectedResult, msg) => {
        test(msg, () =>
            toSort
            -> filterSpaceAndSort
            -> expect
            -> toEqual(expectedResult))
    }

    testExpect(
        ["   ", "foo", " ", "bar", "     "],
        [" ", "   ", "     "],
        "removes entries without spaces and fully sorts"
    )

    testExpect(
        [" ", "   ", "     "],
        [" ", "   ", "     "],
        "already sorted spaces stay sorted"
    )

    testExpect(
        ["   ", "     ", " "],
        [" ", "   ", "     "],
        "unsorted spaces become sorted"
    )

    testExpect(
        [" 1", "2 "],
        [" 1", "2 "],
        "already correct order remains unchanged in small list"
    )

    testExpect(
        ["2 ", " 1"],
        [" 1", "2 "],
        "sorts correctly if unsorted in small list"
    )

    testExpect(
        ["a", " b", "c ", "d", "eeeee", "f  f", "gg", "  "],
        ["  ", " b", "c ", "f  f"],
        "longer list with letters"
    )

    testExpect(
        ["1", " 2", "3 ", " 4 ", "  5", "6  ", "  7  ", "8 8 8", " 9 9 "],
        [ "  5", "  7  ", " 2", " 4 ", " 9 9 ", "3 ", "6  ", "8 8 8" ],
        "longer list with numbers"
    )
})