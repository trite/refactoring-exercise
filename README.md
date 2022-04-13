# Refactoring exercise
This is for a prospective employer, refactoring some interesting-yet-painful javascript into hopefully-less-bad ReasonML/ReScript.

## Installation

```sh
npm install
```

## Build

- Build: `npm run build`
- Clean: `npm run clean`
- Build & watch: `npm run start`
- Test: `npm run test`
- Test file watch: `npm run testwatch`

## Run

```sh
node src/Main.bs.js
```

# TODO
## Important
* Need enough unit tests to feel reasonably confident the behavior isn't changing
* Still need to work out a lot of what is going on

## Nice to have
* Create an `npm run [something]` command that does build and test on file save