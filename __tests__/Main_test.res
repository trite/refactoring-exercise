open Jest;

describe("Main", () => {
    open Main;
    open Expect;

    let testExpect = (toSort, expectedResult, msg) => {
        doThingsAndStuff(toSort) |> ignore
        test(msg, () => expect(toSort) -> toEqual(expectedResult))
    }

    // let x = ["asdf", " ", "asdf2"]
    // doThingsAndStuff(x) |> ignore
    // test("single space string", () => expect(x) -> toEqual([" "]));

    testExpect(["asdf", " ", "asdf2"], [" "], "single space string")

    testExpect(["   ", "asdf", " ", "asdf2", "     "], ["     ", " ", "   "], "multiple spaces, order partially fixed")
    testExpect(["     ", " ", "   "], ["     ", "   ", " "], "multiple spaces, order partially fixed")


    // let x = ["   ", "asdf", " ", "asdf2", "     "]
    // doThingsAndStuff(x) |> ignore

    // test("multiple sets of spaces are returned in reverse order", () =>
    //     expect(x) -> toEqual(["     ", " ", "   "]));
    
});