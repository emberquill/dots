require('nvim-treesitter.configs').setup({
    ensure_installed = {'bash', 'css', 'dockerfile', 'go', 'gomod', 'hcl',
        'html', 'java', 'javascript', 'json', 'jsonc', 'lua', 'markdown',
        'python', 'toml', 'typescript', 'yaml'},
    sync_install = false,
    highlight = {
        enable = true,
        custom_captures = {
            -- ["<capture group>"] = "<highlight group>",
            -- ["keyword"] = "TSString"
        },
        additional_vim_regex_highlighting = true
    },

    indent = {
        enable = true
    }
})
