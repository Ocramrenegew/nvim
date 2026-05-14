local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.enable({
    "lua_ls",           -- LUA
    "pyright",          -- PYTHON
    "nil_ls",           -- NIX
    "clangd",           -- C/CPP
    "gopls",            -- Go
    "ts_ls",            -- JS/TS
    "rust_analyzer",    -- Rust
    "ols",              -- Odin
})

-- Lua
vim.lsp.config("lua_ls", {
    capabilities = capabilities,
    settings = {
        Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = {
                globals = { "vim" },
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
            },
            telemetry = { enable = false },
        },
    },
})

-- Python
vim.lsp.config("pyright", {
    capabilities = capabilities,
    settings = {
        python = {
            analysis = {
                typeCheckingMode = "basic",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace",
            },
        },
    },
})

-- JS/TS
vim.lsp.config("ts_ls", {
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
    },
    root_markers = {
        "package.json",
        "tsconfig.json",
        "jsconfig.json",
        ".git",
    },
    settings = {
        typescript = {
            inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayVariableTypeHints = true,
            },
        },
        javascript = {
            inlayHints = {
                includeInlayParameterNameHints = "all",
            },
        },
    },
})

--Rust
vim.lsp.config("rust_analyzer", {
    cmd = { "rust-analyzer" },
    filetype = { "rust" },
    root_markers = {
        "Cargo.toml",
        "rust-projects.json",
        ".git",
    },
    settings = {
        [ "rust-analyzer" ] = {
            cargo = {
                allFeatures = true,
            },
            checkOnSave = true,
            check = {
                command = "clippy",
            },
        },
    },
})

-- Nix
vim.lsp.config("nil_ls", {
    capabilites = capabilities,
    settings = {
        ["nil"] = {
            formatting = {
                command = { "nixpkgs-fmt" },
            },
            nix = {
                flake = {
                    autoArchive = true,
                },
            },
        },
    },
})

-- C/C++
vim.lsp.config("clangd", {
    cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--completion-style=detailed",
        "--header-insertion=iwyu",
    },
    filetype = { "c", "cpp", "objc", "objcpp" },
    root_markers = {
        ".git",
        "compile_commands.json",
        "compile_flags.txt",
    },
    capabilities = capabilities,
    on_attach = function(client, buffer)
        local opts = { buffer = buffnr }
	
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
	vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
	vim.keymap.set("n", "<leader>fm", function()
		vim.lsp.buf.format({ async = true })
	end, opts)
end,
})

-- Go
vim.lsp.config("gopls", {
    capabilities = capabilities,
    cmd = { "gopls" },
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    root_markers = { "go.work", "go.mod", ".git" },

    settings = {
        gopls = {
            completeUnimported = true,
            usePlaceholders = true,
            staticcheck = true,
            gofumpt = true,
        },
    },
})

-- Odin
vim.lsp.config("ols", {
    cmd = { "ols" },
    filetypes = { "odin" },
    root_markers = {
        "ols.json",
        ".git",
    },
    settings = {
        enable_semantic_tokens = true,
        enable_document_symbols = true,
        enable_hover = true,
        enable_snippets = true,
    },
})
