return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "jbyuki/one-small-step-for-vimkind",
  },
  lazy = false,
  config = function()
    local dap = require"dap"
    dap.configurations.lua = {
        name = "Launch",
        type = "codelldb",
        request = "launch",
        program = "${workspaceFolder}/zig-out/bin/${workspaceFolderBasename}",
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        args = {},
    }
  end,
}
