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

// let test = [1,2,3,4,5]
// let test2 = test

let insertAt = (start: int, toInsert: 'a, arr: array<'a>): array<'a> => {
    let arrStart = Belt.Array.slice(arr, ~offset=0, ~len=start)
    let arrEnd = Belt.Array.slice(arr, ~offset=start, ~len=Belt.Array.length(arr)-start)
    Belt.Array.concatMany([arrStart, [toInsert], arrEnd])
}

Js.log(insertAt(0, "blah", ["asdf", "asdf2"]))
Js.log(insertAt(1, "blah", ["asdf", "asdf2"]))
Js.log(insertAt(2, "blah", ["asdf", "asdf2"]))
// Js.log(Js.Array.concat(["blah"], ["asdf", "asdf2"]))
// Js.log([1,2,3][range(0,1)])

// Js.log(doThingsAndStuff(["some", " ", "text"]))

// let x = ["some", "    ", "text", "    ", "blah", "    "];
// doThingsAndStuff(x);
// Js.log(x);
