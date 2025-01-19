#!/usr/bin/env texlua

-- Identify the bundle and module
bundle = ""
module = "uax9"

stdengine    = "luatex"
checkengines = {"luatex"}
checkruns = 1
sourcefiles = {"*.opm", "*.sty", "*.lua", "uax9.tex"}
installfiles = sourcefiles
textfiles = {"*.md", "COPYING"}
packtdszip = true
typesetexe = "optex"
typesetfiles = {"uax9.opm"}
ctanzip = module

checkconfigs = {"configfiles/config-optex", "configfiles/config-latex", "configfiles/config-plain"}
specialformats = specialformats or { }
specialformats.optex  = {luatex = {binary = "optex", format = ""}}
specialformats.plain  = {luatex = {binary = "luahbtex", format = ""}}

tdslocations =
  {
    "tex/optex/uax9/*.opm",
    "tex/lualatex/uax9/*.sty",
    "tex/luatex/uax9/*.tex",
    "tex/luatex/uax9/*.lua",
  }

specialtypesetting = specialtypesetting or {}
function optex_doc()
    local error  = run('.', "optex -jobname uax9-doc '\\docgen uax9'")
    return error
end
specialtypesetting["uax9.opm"] = {func = optex_doc}

tagfiles = sourcefiles
function update_tag(file,content,tagname,tagdate)
  if string.match(file, "%.opm$") then
    return string.gsub(content,
      "Unicode Bidi Algorithm for OpTeX <%d+.%d+, %d%d%d%d-%d%d-%d%d",
      "Unicode Bidi Algorithm for OpTeX <" .. tagname .. ", " .. tagdate)
  elseif string.match(file, "%.lua$") then
    return string.gsub(content,
      "version   = %d+.%d+, %d%d%d%d-%d%d-%d%d",
      "version   = " .. tagname .. ", " .. tagdate)
  elseif string.match(file, "%.sty$") then
    return string.gsub(content,
      "{uax9} [%d%d%d%d-%d%d-%d%d v%d+.%d+.%d+",
      "{uax9} [" .. tagdate .. " v" .. tagname)
  elseif string.match(file, "%.tex$") then
    return string.gsub(content,
      "version %d+.%d+, %d%d%d%d-%d%d-%d%d",
      "version " .. tagname .. ", " .. tagdate)
  elseif string.match(file, "%.md$") then
    return content
  end
end

function pre_release()
    call({"."}, "tag")
    call({"."}, "ctan", {config = options['config']})
    rm(".", "*.tds.zip")
end

target_list["prerelease"] = { func = pre_release, 
			desc = "update tags, generate pdfs, build zip for ctan"}

