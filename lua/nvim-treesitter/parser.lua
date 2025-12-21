local ts = vim.treesitter

for ft, lang in pairs {
  automake = "make",
  javascriptreact = "javascript",
  ecma = "javascript",
  jsx = "javascript",
  gyp = "python",
  html_tags = "html",
  ["typescript.tsx"] = "tsx",
  ["terraform-vars"] = "terraform",
  ["terraform"] = "opentofu",
  ["html.handlebars"] = "glimmer",
  systemverilog = "verilog",
  dosini = "ini",
  confini = "ini",
  svg = "xml",
  xsd = "xml",
  xslt = "xml",
  expect = "tcl",
  mysql = "sql",
  sbt = "scala",
  neomuttrc = "muttrc",
  clientscript = "runescript",
  --- short-hand list from https://github.com/helix-editor/helix/blob/master/languages.toml
  rs = "rust",
  ex = "elixir",
  js = "javascript",
  ts = "typescript",
  ["c-sharp"] = "csharp",
  hs = "haskell",
  py = "python",
  erl = "erlang",
  typ = "typst",
  pl = "perl",
  uxn = "uxntal",
} do
  ts.language.register(lang, ft)
end
