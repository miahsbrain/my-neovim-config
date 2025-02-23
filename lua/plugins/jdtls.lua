return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      setup = {
        -- disable jdtls config from lspconfig
        jdtls = function()
          return true
        end,
      },
    },
  },
  {
    'mfussenegger/nvim-jdtls',
    ft = 'java',
    config = function()
      local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
      local workspace_dir = vim.fn.stdpath 'data' .. '/site/java/workspace-root/' .. project_name
      local install_path = require('mason-registry').get_package('jdtls'):get_install_path()

      local config = {
        cmd = {
          install_path .. '/bin/jdtls',
          '-data',
          workspace_dir,
        },
        root_dir = vim.fs.dirname(vim.fs.find({ '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' }, { upward = true })[1]),
      }

      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'java',
        callback = function()
          require('jdtls').start_or_attach(config)
        end,
      })
    end,
  },
}
