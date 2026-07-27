local M = {}

function M.run()
  if vim.fn.executable('git') ~= 1 then
    vim.notify('git executable not found – some plugins may fail to install', vim.log.levels.WARN)
  end
  if vim.fn.has('nvim-0.12') ~= 1 then
    vim.notify('Neovim 0.12 or newer is required', vim.log.levels.ERROR)
  end
end

return M
