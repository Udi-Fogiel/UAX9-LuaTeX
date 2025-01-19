#!/usr/bin/env texlua

-- Identify the bundle and module
bundle = ""
module = "unibidi-lua"

stdengine    = "luatex"
checkengines = {"luatex"}
checkruns = 1
sourcefiles = {"*.opm", "*.sty", "*.lua", "unibidi-lua.tex"}
installfiles = sourcefiles
textfiles = {"*.md", "COPYING"}
packtdszip = true
typesetexe = "optex"
typesetfiles = {"unibidi-lua.opm"}
ctanzip = module

checkconfigs = {"configfiles/config-optex", "configfiles/config-latex", "configfiles/config-plain"}
specialformats = specialformats or { }
specialformats.optex  = {luatex = {binary = "optex", format = ""}}
specialformats.plain  = {luatex = {binary = "luahbtex", format = ""}}

tdslocations =
  {
    "tex/optex/unibidi-lua/*.opm",
    "tex/lualatex/unibidi-lua/*.sty",
    "tex/luatex/unibidi-lua/*.tex",
    "tex/luatex/unibidi-lua/*.lua",
  }

specialtypesetting = specialtypesetting or {}
function optex_doc()
    local error  = run('.', "optex -jobname unibidi-lua-doc '\\docgen unibidi-lua'")
    return error
end
specialtypesetting["unibidi-lua.opm"] = {func = optex_doc}

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
      "{unibidi-lua} [%d%d%d%d-%d%d-%d%d v%d+.%d+.%d+",
      "{unibidi-lua} [" .. tagdate .. " v" .. tagname)
  elseif string.match(file, "%.tex$") then
    return string.gsub(content,
      "version %d+.%d+, %d%d%d%d-%d%d-%d%d",
      "version " .. tagname .. ", " .. tagdate)
  elseif string.match(file, "%.md$") then
    return string.gsub(content,
      "version %d+.%d+, %d%d%d%d-%d%d-%d%d",
      "version " .. tagname .. ", " .. tagdate)
  end
end

function pre_release()
    call({"."}, "tag")
    call({"."}, "ctan", {config = options['config']})
    rm(".", "*.tds.zip")
end

target_list["prerelease"] = { func = pre_release, 
			desc = "update tags, generate pdfs, build zip for ctan"}

