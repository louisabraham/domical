# Domical

Add OCaml support to <https://iodide.io/>

Demo: <https://louisabraham.github.io/domical/>

## How to use

In a iodide notebook, add a plugin cell:

``` json

{
  "languageId": "ml",
  "displayName": "ocaml",
  "codeMirrorMode": "mllike",
  "keybinding": "o",
  "url": "https://louisabraham.github.io/domical/eval.js",
  "module": "evaluator",
  "evaluator": "execute",
  "pluginType": "language"
}
```

and an external resource cell

    https://louisabraham.github.io/domical/style.css

## Build requirements

To recompile the
[`eval.js`](https://louisabraham.github.io/domical/eval.js) script, you
need:

  - ocaml
  - jbuilder
  - [js\_of\_ocaml](https://github.com/ocsigen/js_of_ocaml)

## Build

    make
