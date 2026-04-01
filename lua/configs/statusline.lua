local M = {}

local cache = {}
local ttl_ms = 2000

local function run(cmd)
  local output = vim.fn.system(cmd)
  if vim.v.shell_error ~= 0 then
    return nil
  end

  output = vim.trim(output or "")
  if output == "" then
    return nil
  end

  return output
end

local function jj_info()
  local cwd = vim.uv.cwd() or ""
  local now = vim.uv.now()
  local cached = cache[cwd]

  if cached and (now - cached.ts) < ttl_ms then
    return cached.text
  end

  local root = run { "jj", "root" }
  if not root then
    cache[cwd] = { ts = now, text = nil }
    return nil
  end

  local bookmark = run { "jj", "log", "-r", "@", "--no-graph", "-T", "bookmarks" }
  local marker = bookmark or run { "jj", "log", "-r", "@", "--no-graph", "-T", "change_id.shortest()" }

  if marker then
    marker = marker:gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
  end

  local text = marker and (" 󰘬 " .. marker) or " 󰘬 @"
  cache[cwd] = { ts = now, text = text }

  return text
end

function M.vcs()
  local jj = jj_info()
  if jj then
    return "%#St_gitIcons#" .. jj
  end

  local ok, utils = pcall(require, "nvchad.stl.utils")
  if not ok then
    return ""
  end

  return "%#St_gitIcons#" .. utils.git()
end

return M
