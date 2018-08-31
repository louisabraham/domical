let () =
  JsooTop.initialize ()


let print_to_element name s : unit =
  let iodide_output = Js.Unsafe.js_expr "window.iodide.output" in
  let el = iodide_output##element name in
  el##.innerText := s; ()


let () = begin
  Sys_js.set_channel_flusher stdout (print_to_element "stdout");
  Sys_js.set_channel_flusher stderr (print_to_element "stderr")
end


let execute code =
  let code = String.concat "" [Js.to_string code ; ";;"]  in
  let buffer = Buffer.create 100 in
  let formatter = Format.formatter_of_buffer buffer in
  JsooTop.execute true formatter code;
  let ans = Buffer.contents buffer in
  print_to_element "eval" ans; Js.undefined


let () =
  Js.export "evaluator" (
    object%js
      val execute = execute
    end)
