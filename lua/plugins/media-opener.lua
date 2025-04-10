-- image_viewer.lua

local M = {}

M.setup = function(viewer_command)
  if viewer_command == nil then
    viewer_command = 'xdg-open' -- Default viewer command
  end

  local function open_image(filename)
    local command = viewer_command .. ' ' .. vim.fn.shellescape(filename)
    local job_options = {
      detached = true,
      stdout_closed = true,
      stderr_closed = true,
    }
    vim.fn.jobstart(command, job_options)
    vim.cmd 'bdelete' -- Close the buffer
  end

  vim.api.nvim_create_autocmd({ 'BufRead' }, {
    pattern = { '*.png', '*.jpg', '*.jpeg', '*.gif', '*.bmp', '*.PNG', '*.JPG', '*.JPEG', '*.GIF', '*.BMP' },
    callback = function(args)
      if vim.api.nvim_buf_get_name(args.buf) ~= '' then -- Check if the buffer has a name
        open_image(args.file)
      end
    end,
  })

  vim.g.netrw_browsex_viewer = viewer_command
end

return M
