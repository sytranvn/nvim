
if false then
return {

  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      { "rcasia/neotest-java" },
    },
    opts = {
      adapters = {
        ["neotest-java"] = {
          -- Here we can set options for neotest-java, e.g.
          -- jvm_args = { "-Xmx512m" }, -- custom JVM arguments
        },
      },
    },
  },
  {
    "oclay1st/gradle.nvim",
    cmd = { "Gradle", "GradleExec", "GradleInit", "GradleFavorites" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    opts = {}, -- options, see default configuration
    keys = {
      { "<leader>G", desc = "+Gradle", mode = { "n", "v" } },
      { "<leader>Gg", "<cmd>Gradle<cr>", desc = "Gradle Projects" },
      { "<leader>Gf", "<cmd>GradleFavorites<cr>", desc = "Gradle Favorite Commands" },
    },
  },
  }
else


local java_filetypes = { "java" }
local function get_java_runtimes()
  local runtimes = {}

  -- Helper to extract java.home from command output
  local function extract_java_home(output)
    for line in output:gmatch("[^\r\n]+") do
      local home = line:match("java%.home = (.+)")
      if home then return home end
    end
    return nil
  end

  -- Check SDKMAN_DIR for installed Java versions
  local sdkman_dir = os.getenv("SDKMAN_DIR")
  if sdkman_dir then
    local handle = io.popen("ls -1 " .. sdkman_dir .. "/candidates/java")
    if handle then
      for version in handle:lines() do
        local java_bin = sdkman_dir .. "/candidates/java/" .. version .. "/bin/java"
        local f = io.open(java_bin, "r")
        if f then
          f:close()
          local cmd = java_bin .. " -XshowSettings:properties -version 2>&1"
          local output = io.popen(cmd):read("*a")
          local java_home = extract_java_home(output)
          if java_home then
            table.insert(runtimes, {
              name = "JavaSE-" .. version,
              path = java_home,
            })
          end
        end
      end
      handle:close()
    end
  end

  -- Also check system java
  local sys_java = "/bin/java"
  local f = io.open(sys_java, "r")
  if f then
    f:close()
    local output = io.popen(sys_java .. " -XshowSettings:properties -version 2>&1"):read("*a")
    local java_home = extract_java_home(output)
    if java_home then
      table.insert(runtimes, {
        name = "System",
        path = java_home,
      })
    end
  end

  -- Fallback defaults if none found
  if #runtimes == 0 then
    runtimes = {}
  end

  return runtimes
end
-- Utility function to extend or override a config table, similar to the way
-- that Plugin.opts works.
---@param config table
---@param custom function | table | nil
local function extend_or_override(config, custom, ...)
  if type(custom) == "function" then
    config = custom(config, ...) or config
  elseif custom then
    config = vim.tbl_deep_extend("force", config, custom) --[[@as table]]
  end
  return config
end
return {
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      { "rcasia/neotest-java" },
    },
    opts = {
      adapters = {
        ["neotest-java"] = {
          -- Here we can set options for neotest-java, e.g.
          -- jvm_args = { "-Xmx512m" }, -- custom JVM arguments
        },
      },
    },
  },
  {
    "oclay1st/gradle.nvim",
    cmd = { "Gradle", "GradleExec", "GradleInit", "GradleFavorites" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    opts = {}, -- options, see default configuration
    keys = {
      { "<leader>G", desc = "+Gradle", mode = { "n", "v" } },
      { "<leader>Gg", "<cmd>Gradle<cr>", desc = "Gradle Projects" },
      { "<leader>Gf", "<cmd>GradleFavorites<cr>", desc = "Gradle Favorite Commands" },
    },
  },
  -- {
  --   "elmcgill/springboot-nvim",
  --   event = "VeryLazy",
  --   dependencies = {
  --     "neovim/nvim-lspconfig",
  --     "mfussenegger/nvim-jdtls",
  --   },
  --   config = function()
  --     local springboot_nvim = require("springboot-nvim")
  --     vim.keymap.set("n", "<leader>Jr", springboot_nvim.boot_run, { desc = "Spring Boot Run Project" })
  --     vim.keymap.set("n", "<leader>Jc", springboot_nvim.generate_class, { desc = "Java Create Class" })
  --     vim.keymap.set("n", "<leader>Ji", springboot_nvim.generate_interface, { desc = "Java Create Interface" })
  --     vim.keymap.set("n", "<leader>Je", springboot_nvim.generate_enum, { desc = "Java Create Enum" })
  --     springboot_nvim.setup({})
  --   end,
  -- },
  {
    "mfussenegger/nvim-jdtls",
    opts = function()
      local cmd = { vim.fn.exepath("jdtls") }

      local sys_java = "/bin/java"

      if os.execute("test -x " .. sys_java) then
        table.insert(cmd, "--java-executable=" .. sys_java)
      end

      if LazyVim.has("mason.nvim") then
        local lombok_jar = vim.fn.expand("$MASON/share/jdtls/lombok.jar")
        table.insert(cmd, string.format("--jvm-arg=-javaagent:%s", lombok_jar))
      end
      return {
        root_dir = function(path)
          return vim.fs.root(path, vim.lsp.config.jdtls.root_markers)
        end,

        -- How to find the project name for a given root dir.
        project_name = function(root_dir)
          return root_dir and vim.fs.basename(root_dir)
        end,

        -- Where are the config and workspace dirs for a project?
        jdtls_config_dir = function(project_name)
          return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/config"
        end,
        jdtls_workspace_dir = function(project_name)
          return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/workspace"
        end,

        -- How to run jdtls. This can be overridden to a full java command-line
        -- if the Python wrapper script doesn't suffice.
        cmd = cmd,
        full_cmd = function(opts)
          local fname = vim.api.nvim_buf_get_name(0)
          local root_dir = opts.root_dir(fname)
          local project_name = opts.project_name(root_dir)
          local cmd = vim.deepcopy(opts.cmd)
          if project_name then
            vim.list_extend(cmd, {
              "-configuration",
              opts.jdtls_config_dir(project_name),
              "-data",
              opts.jdtls_workspace_dir(project_name),
            })
          end
          return cmd
        end,

        -- These depend on nvim-dap, but can additionally be disabled by setting false here.
        dap = { hotcodereplace = "auto", config_overrides = {} },
        -- Can set this to false to disable main class scan, which is a performance killer for large project
        dap_main = {},
        test = true,
        settings = {
          java = {
            inlayHints = {
              parameterNames = {
                enabled = "all",
              },
            },
            configurations = {
              runtimes = get_java_runtimes(),
              updateBuildConfiguration = "automatic", -- or "interactive"
            }
          },
        },
      }
    end,
  },
}

end
