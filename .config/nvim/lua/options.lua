vim.o.syntax = 'on'
vim.o.number = true
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.encoding = 'utf-8'
vim.o.mouse = 'a'
--vim.g.polyglot_disabled = {'ansible', 'python'}

if os.getenv('VIRTUAL_ENV') ~= nil then
    vim.g.python3_host_prog=vim.fn.substitute(vim.fn.system('which -a python3 | head -n2 | tail -n1'), '\n', '', 'g')
else
    vim.g.python3_host_prog=vim.fn.substitute(vim.fn.system('which python3'), '\n', '', 'g')
end
