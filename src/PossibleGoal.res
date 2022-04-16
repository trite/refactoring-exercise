// Can't really tell if the strange sorting behavior is intended.
// If the goal was simply to filter and sort then this would work.

let filterSort = (arr: array<string>, f: string => bool): array<string> => {
    arr
    -> Js.Array2.copy // to avoid mutating the original
    -> Js.Array2.filter(f)
    -> Js.Array2.sortInPlace
}

let filterSpaceAndSort = (arr: array<string>): array<string> => {
    arr
    -> filterSort(x => Js.String.includes(" ", x))
}

Js.log(filterSort(["   ", "foo", " ", "bar", "     "]))
Js.log(filterSort(["     ", " ", "   "]))
Js.log(filterSort(["1", " 2", "3 ", " 4 ", "  5", "6  ", "  7  ", "8 8 8", " 9 9 "]))
Js.log(filterSort([" 1", "2 "]))
Js.log(filterSort(["a", " b", "c ", "d", "eeeee", "f  f", "gg", "  "]))