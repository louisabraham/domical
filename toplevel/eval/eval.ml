type output_type = Eval | Stdout | Stderr
type output_element = output_type * string

let output_queue : output_element list ref = ref []

let () = begin
  Sys_js.set_channel_flusher stdout 
    (fun s -> output_queue :=
        (Stdout, s) :: !output_queue);
  Sys_js.set_channel_flusher stderr
    (fun s -> output_queue := 
        (Stderr, s) :: !output_queue)
end


let replacements = [
  '&', "&amp;";
  '<', "&lt;";
  '>', "&gt;"
]

let replace s (pattern, replacement) = 
  String.concat replacement (String.split_on_char pattern s)

let escape s =
  List.fold_left replace s replacements

let make_eval_el s = 
  String.concat "" [
    "<pre style=\"
    display: block;
    unicode-bidi: embed;
    font-family: monospace;
    white-space: pre;
    color: #777777;
    \">";
    escape s;
    "</pre>"]

let make_out_el s = 
  String.concat "" [
    "<pre style=\"
    display: block;
    unicode-bidi: embed;
    font-family: monospace;
    white-space: pre;
    overflow-x: auto;
    \">";
    escape s;
    "</pre>"
  ]

let make_err_el s = 
  String.concat "" [
    "<pre style=\"
    display: block;
    unicode-bidi: embed;
    font-family: monospace;
    white-space: pre;  
    background: #fff1f4;
    color: #a41c1c;
    overflow-x: auto;
    \">";
    escape s;
    "</pre>"
  ]

let output_element_to_string = function
  | (Eval, s) -> make_eval_el s
  | (Stdout, s) -> make_out_el s
  | (Stderr, s) -> make_err_el s

let make_iodide_renderer value =
  let queue = (List.rev ((Eval, value) :: !output_queue)) in
  let ans =  String.concat "" (List.map output_element_to_string queue)
  in
  output_queue := [];
  object%js
    val iodideRender = fun () -> Js.string ans
  end


let execute code =
  let code = String.concat "" [Js.to_string code ; ";;"]  in
  let buffer = Buffer.create 100 in
  let formatter = Format.formatter_of_buffer buffer in
  JsooTop.execute true formatter code;
  let ans = Buffer.contents buffer in
  make_iodide_renderer ans


let () =
  JsooTop.initialize ();
  Js.export "evaluator" (
    object%js
      val execute = execute
    end)
