vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") then
  vim.cmd("syntax reset")
end
vim.g.colors_name = "matugen"

local matugen_cache = vim.fn.expand("~/.cache/nvim/matugen.lua")
if vim.fn.filereadable(matugen_cache) == 1 then
  dofile(matugen_cache)
else
  require('base16-colorscheme').setup({
    base00 = '#1e1e2e',
    base01 = '#313244',
    base02 = '#3a3b50',
    base03 = '#65697e',
    base04 = '#9399b2',
    base05 = '#cdd6f4',
    base06 = '#cdd6f4',
    base07 = '#cdd6f4',
    base08 = '#f38ba8',
    base09 = '#cba6f7',
    base0A = '#f5c2e7',
    base0B = '#89b4fa',
    base0C = '#bb8af4',
    base0D = '#85b1fa',
    base0E = '#ed91d4',
    base0F = '#c8043a',
  })
end

-- Reload on SIGUSR1
local signal = vim.uv.new_signal()
signal:start(
  'sigusr1',
  vim.schedule_wrap(function()
    dofile(matugen_cache)
  end)
)
