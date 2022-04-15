let sort = (x: array<string>): array<string> => {
    Js.Array.sortInPlace(Js.Array.copy(x))
}

let filterSort = (x: array<string>): array<string> => {
    x
    |> Js.Array.filter(x => Js.String.includes(" ", x))
    |> sort
}

Js.log(filterSort(["   ", "foo", " ", "bar", "     "]))
Js.log(filterSort(["     ", " ", "   "]))
Js.log(filterSort(["1", " 2", "3 ", " 4 ", "  5", "6  ", "  7  ", "8 8 8", " 9 9 "]))
Js.log(filterSort([" 1", "2 "]))
Js.log(filterSort(["a", " b", "c ", "d", "eeeee", "f  f", "gg", "  "]))