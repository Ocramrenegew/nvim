-----------------------------
--- Marco's Neovim config ---
-----------------------------

--- packages
require("packages.packages")
require("packages.treesitter")
require("packages.cmp")

--- lsp
require("lsp")

require("config.options")
require("config.keymaps")
require("config.statusline")
