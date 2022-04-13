open Jest;

describe("Main", () => {
    open Main;
    open Expect;


    let x = ["asdf", " ", "asdf2"]
    doThingsAndStuff(x) |> ignore

    test("return 1 set of spaces in array", () =>
        expect(x) -> toEqual([" "]));


    let x = ["   ", "asdf", " ", "asdf2", "     "]
    doThingsAndStuff(x) |> ignore

    test("multiple sets of spaces are returned in reverse order", () =>
        expect(x) -> toEqual(["     ", " ", "   "]));
    
});