vim.o.showmode = false

return require('lualine').setup({
    options = {
        icons_enabled = false,
        theme = 'onedark',
        component_separators = '|',
        section_separators = ''
    }
})
