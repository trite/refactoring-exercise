let doThingsAndStuff = %raw(`
    function(x) {
        var temp = [];
        var temp2;
        var tmep3;
        var temp4;

        while(x.length) { // while there are items left in x
            temp2 = x.pop(); // pop the end off x and set temp2 to it, mutates x
            if (!temp2) continue; // skip to end of iteration if pop() returned undefined
            for (tmep3 = 0; tmep3 < temp2.length; tmep3++) // iterate the length of temp2 via temp3
                if (temp2 && temp2.charCodeAt(tmep3) == 32) { // is the character at this point a space?
                    var start = tmep3++ + 1; // increment tmep3 by 1, set start to that same value in a terrible way
                    var doBreak = false; // break clause to skip additional iterations in some situations
                    var isFound = false; // whether the thing we're looking for was found -- looks like this makes the comparison happen if a space has occurred in the string previously
                    for (temp4 = 0; temp4 < temp.length; temp4++) { // iterate through items in temp (shouldn't be anything on the first pass)
                        if (doBreak) {
                            break;
                        }
                        tmep3 = start; // tmep3 can be incremented below potentially, so this might matter
                        isFound = false; 
                        for (var y = 0; y < temp[temp4].length; y++) { // iterate through the string currently being looked at from temp array

                            // If the string contains a space, then the code after this can run
                            // Otherwise this will skip the rest of the for loop
                            if (!isFound && temp[temp4].charCodeAt(y) == 32) {
                                isFound = true;
                                continue;
                            } else if (!isFound) {
                                continue;
                            }

                            // first part skips the compare if there's no character at tmep3, which is possible since it increments at line 12 and cound again at line 42
                            if (!temp2.charCodeAt(tmep3) || temp2.charCodeAt(tmep3) < temp[temp4].charCodeAt(y)) {
                                temp4--; 
                                if (temp4 < 0) {
                                    temp4 = 0;
                                }
                                temp.splice(temp4, 0, temp2); // insert temp2 at index temp4
                                /*
                                    const months = ['Jan', 'March', 'April', 'June'];
                                    months.splice(1, 0, 'Feb');
                                    // inserts at index 1
                                    console.log(months);
                                    // expected output: Array ["Jan", "Feb", "March", "April", "June"]
                                */
                                doBreak = true;
                                break;
                            } else if (temp2.charCodeAt(tmep3) == temp[temp4].charCodeAt(y)) {
                                tmep3++; // every other scenario breaks, this is the only one that continues iterating on tmep3
                                continue;
                            } else {
                                doBreak = true;
                                break;
                            }
                        }
                    }
                    isFound = false;

                    // Only add items that aren't already added, hence why the same amount of spaces are only added once
                    for (temp4 = 0; temp4 < temp.length; temp4++) // this also shouldn't run on first pass
                        if (temp2 === temp[temp4]) {
                            isFound = true;
                            break;
                        }

                    // If item isn't previously in temp add it to the end of the array
                    if (!isFound) {
                        temp.push(temp2);
                    }
                    break
                }
        };
        while(temp.length) {
            var newThing = temp.pop();
            x.push(newThing);
        };
    }
`)

let insertAt = (start: int, toInsert: 'a, arr: array<'a>): array<'a> => {
    let safeStart = Js.Math.max_int(0, start)

    let arrStart = Belt.Array.slice(arr, ~offset=0, ~len=safeStart)
    let arrEnd = Belt.Array.slice(arr, ~offset=safeStart, ~len=Belt.Array.length(arr)-start)
    Belt.Array.concatMany([arrStart, [toInsert], arrEnd])
}

// type state<'a> =
// {
//     pullFrom: array<'a>,
//     pushTo: array<'a>

// }

type action<'a> =
    | InsertAt(int, 'a, array<'a>)
    | Drop

// let nextAction = ()

type state1<'a> =
{
    pullFrom: array<'a>,
    pushTo: array<'a>
}

type state2<'a> =
{
    pullFrom: array<'a>,
    pushTo: array<'a>,
    examining: 'a,
    examPosition: int,
    spaceInExam: bool
}

type state3<'a> =
{
    pullFrom: array<'a>,
    pushTo: array<'a>,

    examining: 'a,
    examPositionReset: int,
    examPosition: int,
    spaceInExam: bool,

    comparing: 'a,
    comparingSource: int,
    comparePosition: int,
    spaceInCompare: bool
}

// type state4<'a> =
// {

// }

type doneState<'a> =
    array<'a>

type anyState<'a> =
    State1(state1<'a>)
    | State2(state2<'a>)
    | State3(state3<'a>)
    | DoneState(doneState<'a>)

type workingStates<'a> =
    State1(state1<'a>)
    | State2(state2<'a>)
    | State3(state3<'a>)

type state2orDone<'a> =
    State2(state2<'a>)
    | DoneState(doneState<'a>)

type state1or3<'a> =
    State1(state1<'a>)
    | State3(state3<'a>)

// let advanceState1 = (state: state1<'a>): state2orDone<'a> => {
let advanceState1 = (state: state1<'a>): anyState<'a> => {
    open Belt.Array

    let len =
        state.pullFrom
        |> length

    if (len > 0) {
        // pop the end element off and pass it to be examined
        let rest =
            slice(state.pullFrom, ~offset=0, ~len=len-1)

        let pop =
            state.pullFrom[len-1]

        State2({
            pullFrom: rest,
            pushTo: state.pushTo,

            examining: pop,
            examPosition: 0,
            spaceInExam: false
        })
    } else {
        // nothing to do, return the original
        DoneState(state.pushTo)
    }
}

// Js.log(advanceState1(
//     {
//         pullFrom: [" foo", "bar ", "a", "b"],
//         pushTo: []
//     }
// ))

let arrContains = (lookFor: string, arr: array<string>): bool => {
    Belt.Option.isSome(Js.Array.find(x => x == lookFor, arr))
}

// let advanceState2 = (state: state2<string>): workingStates<string> => {
let advanceState2 = (state: state2<string>): anyState<string> => {
    // if (Js.Array.length(state.pushTo) > 0) {


    let charTest =
        state.examining
        |> Js.String.charCodeAt(state.examPosition)

    let nextPosition = state.examPosition + 1

    if (charTest == 32.0) {
        Js.log("as2 path 1")
        if (Js.Array.length(state.pushTo) > 0) {
            Js.log("as2 path 1.1")
            // Character being tested is a space, begin comparing the position after it with values in the "pushTo" field
            State3({
                pullFrom: state.pullFrom,
                pushTo: state.pushTo,

                examining: state.examining,
                examPositionReset: nextPosition,
                examPosition: nextPosition,
                spaceInExam: true,

                comparing: state.pushTo[0],
                comparingSource: 0,
                comparePosition: 0,
                spaceInCompare: false
            })
        } else {
            Js.log("as2 path 1.2")
            State2({
                ...state,
                spaceInExam: true,
                examPosition: nextPosition
            })
            // let pushTo =
            //     // if (state.spaceInExam && Belt.Option.isNone(Js.Array.find(x => x == state.examining, state.pushTo))) {
            //     if (state.spaceInExam && arrContains(state.examining, state.pushTo)) {
            //         Belt.Array.concat(state.pushTo, [state.examining])
            //     } else {
            //         state.pushTo
            //     }

            // State1({
            //     pullFrom: state.pullFrom,
            //     pushTo: pushTo
            // })
        }
    } else if (Js.Float.isNaN(charTest)) {
        Js.log("as2 path 2")
        // End of the string, add the item to "pushTo" if it contained a space
        let pushTo =
            // if (state.spaceInExam && Belt.Option.isNone(Js.Array.find(x => x == state.examining, state.pushTo))) {
            if (state.spaceInExam && !arrContains(state.examining, state.pushTo)) {
                Js.log("as2 path 2.1")
                Belt.Array.concat(state.pushTo, [state.examining])
            } else {
                Js.log("as2 path 2.1")
                state.pushTo
            }

        State1({
            pullFrom: state.pullFrom,
            pushTo: pushTo
        })
    } else {
        Js.log("as2 path 3")
        // Not a space but not the end of the string, just advance the pointer
        State2({
            ...state,
            examPosition: nextPosition
        })
    }
    // } else {

    // }

}

// let advanceState3 = (state: state3<string>): state1or3<string> => {
let advanceState3 = (state: state3<string>): anyState<string> => {
    open Js.String
    open Js.Float
    Js.log("as3 open")

    if (state.spaceInCompare) {
        Js.log("top of if")
        // do comparison for where to insert

        let examCharCode =
            state.examining
            |> charCodeAt(state.examPosition)

        let compareCharCode =
            state.comparing
            |> charCodeAt(state.comparePosition)

        if (isNaN(examCharCode) || examCharCode < compareCharCode ) {
            Js.log("as3 path 1")
            
            State1({
                pullFrom: state.pullFrom,
                pushTo: state.pushTo |> insertAt(state.comparingSource - 1, state.examining)
            })
        } else if (examCharCode == compareCharCode) {
            Js.log("as3 path 2")

            State3({
                ...state,
                examPosition: state.examPosition + 1,
            })
        } else {
            Js.log("as3 path 3")

            let pushTo =
                if (arrContains(state.examining, state.pushTo)) {
                    state.pushTo
                } else {
                    Belt.Array.concat(state.pushTo, [state.examining])
                }

            State1({
                pullFrom: state.pullFrom,
                pushTo: pushTo
            })
        }
    } else {
        Js.log("bottom of if")

        // checking for spaces still
        let examCharTest =
            state.examining
            |> charCodeAt(state.examPosition)

        let compareCharTest =
            state.comparing
            |> charCodeAt(state.comparePosition)

        // Js.log(charTest)
        if (isNaN(examCharTest)) {
            Js.log("=====================")
            // let pushTo =
            //     (state.spaceInExam && (compareCharTest != 32.0))
            //         ? Belt.Array.concat([state.examining], state.pushTo)
            //         : Belt.Array.concat(state.pushTo, [state.examining])
            let pushTo =
                if state.spaceInExam {
                    if compareCharTest == 32.0 {
                        Belt.Array.concat(state.pushTo, [state.examining])
                    } else {
                        Belt.Array.concat([state.examining], state.pushTo)
                    }
                } else {
                    state.pushTo

                }

            State1({
                pullFrom: state.pullFrom,
                pushTo: pushTo
            })
        } else {
            Js.log("===else===")
            let spaces = examCharTest == 32.0

            State3({
                ...state,
                examPosition: state.examPosition + 1,
                spaceInCompare: spaces || state.spaceInCompare
            })
        }
    }
}

let rec newVersionInner = (outerState: anyState<string>): array<string> => {
    Js.log(outerState)
    switch outerState {
        | State1(state) =>
            state
            |> advanceState1
            |> newVersionInner
            // newVersionInner(advanceState1(state))
        | State2(state) =>
            state
            |> advanceState2
            |> newVersionInner
        | State3(state) =>
            state
            |> advanceState3
            |> newVersionInner
        | DoneState(result) =>
            result
            |> Belt.Array.reverse
    }
}

let newVersion = (arr: array<string>): array<string> => {
    newVersionInner(State1({
        pullFrom: arr,
        pushTo: []
    }))
}

// Js.log(newVersion({
//     pullFrom: [" foo", "bar "],
//     pushTo: []
// }))

// Js.log(newVersion([" foo", "bar "]))

let checking = (arr: array<string>) => {
    let left = newVersion(Js.Array.copy(arr))
    let right = Js.Array.copy(arr)
    doThingsAndStuff(right) |> ignore

    // if (left == right) {

    // }

    Js.log("===================")
    Js.log(left)
    Js.log(right)
    Js.log("")
}

checking([" foo", "bar "])
checking(["foo", " ", "bar"])
checking(["   ", "foo", " ", "bar", "     "])
checking(["     ", " ", "   "])
checking(["     ", "   ", " "])
checking(["1", " 2", "3 ", " 4 ", "  5", "6  ", "  7  ", "8 8 8", " 9 9 "])
checking(["a", " b", "c ", "d", "eeeee", "f  f", "gg", "  "])
