-------------------------
--- Custom statusline ---
-------------------------

--- Custom icons using Nerd Font icons
local icons = {
    --- General
    normal_mode = "\u{f02d}",   --- nf-fa-book
    insert_mode = "\u{f040}",   --- nf-fa-pencil
    visual_mode = "\u{f06e}",   --- nf-fa-eye
    command_mode = "\u{f120}",  --- nf-fa-terminal
    select_mode = "\u{f0c5}",   --- nf-fa-files
    replace_mode = "\u{f044}",  --- nf-fa-edit
    shell_mode = "\u{f489}",    --- nf-oct-terminal
    question_mark = "\u{f059}", --- nf-fa-question_circle
    file_empty = "\u{f016}",    --- nf-fa-file_o
    file_filled = "\u{f15b}",   --- nf-fa-file
    divider = "\u{e0b1}",       --- nf-pl-left_soft_divider
    clock = "\u{f017}",         --- nf-fa-clock
    git_branch = "\u{e725}",    --- nf-dev-git_branch
    
    --- Misc & config
    xml = "\u{f05c0}",          --- nf-md-xml
    yaml = "\u{e8eb}",          --- nf-dev-yaml
    toml = "\u{e6b2}",          --- nf-custom-toml
    dockerfile = "\u{f21f}",    --- nf-fa-docker
    gitcommit = "\u{e729}",     --- nf-dev-git_commit
    gitconfig = "\u{e702}",     --- nf-dev-git
    markdown = "\u{e73e}",      --- nf-dev-markdown
    vim = "\u{e7c5}",           --- nf-dev-vim
    json = "\u{e60b}",          --- nf-seti-json

    --- Languages
    lua = "\u{e620}",           --- nf-seti-lua
    python = "\u{e73c}",         --- nf-dev-python
    javascript = "\u{e781}",    --- nf-dev-javascript
    typescript = "\u{e8ca}",    --- nf-dev-typescript
    ruby = "\u{e605}",          --- nf-seti-rubi
    php = "\u{e608}",           --- nf-seti-php
    perl = "\u{e67e}",          --- nf-seti-perl
    java = "\u{e738}",          --- nf-dev-java
    kotlin = "\u{e81b}",        --- nf-dev-kotlin
    go = "\u{e627}",            --- nf-dev-go
    rust = "\u{e7a8}",          --- nf-dev-rust
    c = "\u{e61e}",             --- nf-custom-c
    cpp = "\u{e61d}",           --- nf-custom-cpp
    cs = "\u{e7b2}",            --- nf-dev-csharp
    zig = "\u{e8ef}",           --- nf-dev-zig
    swift = "\u{e755}",         --- nf-dev-swift
    haskell = "\u{e777}",       --- nf-dev-haskell
    nix = "\u{e843}",           --- nf-dev-nixos


    --- Webdev
    html = "\u{e736}",          --- nf-dev-html5
    css = "\u{e749}",           --- nf-dev-css3
    react = "\u{e7ba}",         --- nf-dev-react
    vue = "\u{e6a0}",           --- nf-seti-vue

    --- Shell
    sh = "\u{f489}",            --- nf-oct-terminal
    bash = "\u{f489}",          --- nf-oct-terminal
    zsh = "\u{f489}",           --- nf-oct-terminal
}

local modes = {
    n = "\u{f02d} NORMAL",              --- nf-fa-book
    i = "\u{f040} INSTERT",             --- nf-fa-pencil
    v = "\u{f06e} VISUAL",              --- nf-fa-eye
    V = "\u{f06e} VISUAL-LINE",         --- nf-fa-eye
    ["\22"] = "\u{f06e} VISUAL-BLOCK",  --- nf-fa-eye
    c = "\u{f120} COMMAND",             --- nf-fa-terminal
    s = "\u{f0c5} SELECT",              --- nf-fa-files
    S = "\u{f0c5} SELECT-LINE",         --- nf-fa-files
    ["\19"] = "\u{f0c5} SELECT-BLOCK",  --- nf-fa-files
    r = "\u{f044} REPLACE",             --- nf-fa-edit
    R = "\u{f044} REPLACE",             --- nf-fa-edit
    ["!"] = "\u{f120} SHELL",           --- nf-oct-terminal
    t = "\u{f120} TERMINAL",            --- nf-oct-terminal
}

local uv = vim.loop
local cached_branch = ""
local last_check = 0
local is_checking = false
local UPDATE_INTERVAL = 5000    --- ms

local function update_git_branch()
    if is_checking then
        return
    end
    is_checking = true

    vim.system(
        { "git", "rev-parse", "--abbrev-ref", "HEAD" },
        { text = true },
        function(obj)
            if obj.code == 0 then
                local branch = (obj.stdout or ""):gsub("%s+", "")
                cashed_branch = branch ~= "" and branch or ""
            else
                cached_branch = false --- not a repository
            end
            is_checking = false

            vim.schedule(function()
                vim.cmd("redrawstatus")
            end)
        end
    )
end

local function git_branch()
    local now = uv.now()

    if now - last_check > UPDATE_INTERVAL then
        last_check = now
        update_git_branch()
    end

    if cached_branch == false then
        return " (Not a git repository) "
    elseif cached_branch ~= "" then
        return " " .. icons.git_branch .. " " .. cashed_branch .. " "
    else
        return ""
    end
end

local function file_type()
    local ft = vim.bo.filetype

    if ft == "" then
        return " " .. icons.file_filled .. " "
    end

    local icon = icons[ft] or icons.file_filled

    return " " .. icon .. " " .. ft .. " "
end

local function file_size()
    local size = vim.fn.getfsize(vim.fn.expand("%"))
    if size < 0 then
        return ""
    end
    local size_str

    if size < 1024 then
        size_str = size .. "B"
    elseif size < 1024 * 1024 then
        size_str = string.format("%.1fK", size / 1024)
    else
        size_str = string.format("%.1fM", size / 1024 / 1024)
    end

    return " " .. icons.file_empty .. " " .. size_str .. " "
end

local function mode_icon()
    local mode = vim.fn.mode()

    local mode_icon = modes[mode] or (icons.question_mark .. mode:upper())

    return " " .. mode_icon
end

_G.mode_icon = mode_icon
_G.git_branch = git_branch
_G.file_type = file_type
_G.file_size = file_size

vim.cmd([[ highlight StatusLineBold gui=bold cterm=bold ]])

local function setup_dynamic_statusline()
    vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter"}, {
        callback = function()
            vim.opt_local.statusline = table.concat {
                "  ",
                "%#StatusLineBold#",
                "%{v:lua.mode_icon()}",
                "%#StatusLine#",
                " " .. icons.divider .. " %f %h%m%r",
                "%{v:lua.git_branch()}",
                icons.divider .. " ",
                "%{v:lua.file_type()}",
                icons.divider .. " ",
                "%{v:lua.file_size()}",
                "%=",
                " " .. icons.clock .. " %l:%c  %P ",
            }
        end
    })

    vim.api.nvim_set_hl(0, "StatusLineBold", { bold = true })

    vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
        callback = function()
            vim.opt_local.statusline = "  %f %h%m%r " .. icons.divider .. "%{v:lua.file_type()} %=  %l:%c  %P "
        end
    })
end

setup_dynamic_statusline()
