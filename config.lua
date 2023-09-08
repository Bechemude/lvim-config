--[[
--require("lspconfig").gopls.setup {
--    on_attach = function(client, bufnr)
--            navbuddy.attach(client, bufnr)
--                end
--                }
lvim is the global options object

Linters should be
filled in as strings with either
a global executable or a path to
an executable
]]
-- THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT

vim.opt.termguicolors                  = true
vim.opt.relativenumber                 = true
vim.opt.timeoutlen                     = 100
-- lvim.builtin.lualine.style = "default"

-- general
lvim.log.level                         = "warn"
lvim.format_on_save.enabled            = true
lvim.colorscheme                       = "kanagawa"
lvim.builtin.treesitter.rainbow.enable = true

-- to disable icons and use a minimalist setup, uncomment the following
-- lvim.use_icons = false

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader                            = "space"
-- add your own keymapping
lvim.keys.normal_mode["<C-s>"]         = ":w<cr>"
lvim.keys.normal_mode["<Tab>"]         = "%"
lvim.keys.visual_mode["<Tab>"]         = "%"
-- lvim.keys.deleting["<Tab>"]    = "%"
lvim.keys.normal_mode["<S-l>"]         = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-h>"]         = ":BufferLineCyclePrev<CR>"
-- unmap a default keymapping
-- vim.keymap.del("n", "<C-Up>")
-- override a default keymapping
-- lvim.keys.normal_mode["<C-q>"] = ":q<cr>" -- or vim.keymap.set("n", "<C-q>", ":q<cr>" )


lvim.builtin.telescope.defaults.file_ignore_patterns = { "node%_modules", ".shadow%-cljs", ".clj%-kondo" }

-- lvim.builtin.telescope.
-- Change Telescope navigation to use j and k for navigation and n and p for history in both input and normal mode.
-- we use protected-mode (pcall) just in case the plugin wasn't loaded yet.
-- local _, actions = pcall(require, "telescope.actions")
-- lvim.builtin.telescope.defaults.mappings = {
--   -- for input mode
--   i = {
--     ["<C-j>"] = actions.move_selection_next,
--     ["<C-k>"] = actions.move_selection_previous,
--     ["<C-n>"] = actions.cycle_history_next,
--     ["<C-p>"] = actions.cycle_history_prev,
--   },
--   -- for normal mode
--   n = {
--     ["<C-j>"] = actions.move_selection_next,
--     ["<C-k>"] = actions.move_selection_previous,
--   },
-- }

-- Change theme settings
-- lvim.builtin.theme.options.dim_inactive = true
-- lvim.builtin.theme.options.style = "storm"

-- Use which-key to add extra bindings with the leader-key prefix
lvim.builtin.which_key.mappings["S"] = { "<cmd>SymbolsOutline<CR>", "Symbols" }
lvim.builtin.which_key.mappings[";"] = { "<cmd>Telescope projects<CR>", "REPL" }
lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
lvim.builtin.which_key.mappings["t"] = {
  name = "+Trouble",
  r = { "<cmd>Trouble lsp_references<cr>", "References" },
  f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
  d = { "<cmd>Trouble document_diagnostics<cr>", "Diagnostics" },
  q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
  l = { "<cmd>Trouble loclist<cr>", "LocationList" },
  w = { "<cmd>Trouble workspace_diagnostics<cr>", "Workspace Diagnostics" },
}

-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "c",
  "clojure",
  "javascript",
  "json",
  "lua",
  "go",
  "gomod",
  "python",
  "typescript",
  "tsx",
  "css",
  "rust",
  "java",
  "yaml",
}

lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enable = true

-- local navbuddy = require("nvim-navbuddy")
-- local actions = require("nvim-navbuddy.actions")

-- local navbuddy = pcall(require, "nvim-navbuddy")

------------------------
-- Dap
------------------------
local dap_ok, dapgo = pcall(require, "dap-go")
if not dap_ok then
  return
end

dapgo.setup()

------------------------
-- LSP GO
------------------------
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "gopls" })

local lsp_manager = require "lvim.lsp.manager"
lsp_manager.setup("golangci_lint_ls", {
  on_init = require("lvim.lsp").common_on_init,
  capabilities = require("lvim.lsp").common_capabilities(),
  -- require("lspconfig").gopls.setup {
  --   on_attach = function(client, bufnr)
  --     navbuddy.attach(client, bufnr)
  --   end
  -- }
})

lvim.builtin.which_key.mappings[";"] = {
  name = "+GO",
  -- r = { "<cmd>Trouble lsp_references<cr>", "References" },
  -- f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
  -- d = { "<cmd>Trouble document_diagnostics<cr>", "Diagnostics" },
  -- q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
  -- l = { "<cmd>Trouble loclist<cr>", "LocationList" },
  -- w = { "<cmd>Trouble workspace_diagnostics<cr>", "Workspace Diagnostics" },
}
lsp_manager.setup("gopls", {
  on_attach = function(client, bufnr)
    require("lvim.lsp").common_on_attach(client, bufnr)
    local _, _ = pcall(vim.lsp.codelens.refresh)
    local map = function(mode, lhs, rhs, desc)
      if desc then
        desc = desc
      end

      vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc, buffer = bufnr, noremap = true })
    end
    map("n", "<leader>;i", "<cmd>GoInstallDeps<Cr>", "Install Go Dependencies")
    map("n", "<leader>;t", "<cmd>GoMod tidy<cr>", "Tidy")
    map("n", "<leader>;a", "<cmd>GoTestAdd<Cr>", "Add Test")
    map("n", "<leader>;A", "<cmd>GoTestsAll<Cr>", "Add All Tests")
    map("n", "<leader>;e", "<cmd>GoTestsExp<Cr>", "Add Exported Tests")
    map("n", "<leader>;g", "<cmd>GoGenerate<Cr>", "Go Generate")
    map("n", "<leader>;f", "<cmd>GoGenerate %<Cr>", "Go Generate File")
    map("n", "<leader>;c", "<cmd>GoCmt<Cr>", "Generate Comment")
    map("n", "<leader>DT", "<cmd>lua require('dap-go').debug_test()<cr>", "Debug Test")
  end,
  on_init = require("lvim.lsp").common_on_init,
  capabilities = require("lvim.lsp").common_capabilities(),
  settings = {
    gopls = {
      usePlaceholders = true,
      gofumpt = true,
      codelenses = {
        generate = false,
        gc_details = true,
        test = true,
        tidy = true,
      },
    },
  },
})

local status_ok, gopher = pcall(require, "gopher")
if not status_ok then
  return
end

gopher.setup {
  commands = {
    go = "go",
    gomodifytags = "gomodifytags",
    gotests = "gotests",
    impl = "impl",
    iferr = "iferr",
  },
}


-- generic LSP settings

-- -- make sure server will always be installed even if the server is in skipped_servers list
-- lvim.lsp.installer.setup.ensure_installed = {
--     "sumneko_lua",
--     "jsonls",
-- }
-- -- change UI setting of `LspInstallInfo`
-- -- see <https://github.com/williamboman/nvim-lsp-installer#default-configuration>
-- lvim.lsp.installer.setup.ui.check_outdated_servers_on_open = false
-- lvim.lsp.installer.setup.ui.border = "rounded"
-- lvim.lsp.installer.setup.ui.keymaps = {
--     uninstall_server = "d",
--     toggle_server_expand = "o",
-- }

-- ---@usage disable automatic installation of servers
-- lvim.lsp.installer.setup.automatic_installation = false

-- ---configure a server manually. !!Requires `:LvimCacheReset` to take effect!!
-- ---see the full default list `:lua print(vim.inspect(lvim.lsp.automatic_configuration.skipped_servers))`
-- vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "pyright" })
-- local opts = {} -- check the lspconfig documentation for a list of all possible options
-- require("lvim.lsp.manager").setup("tsserver", {
--   handlers = {
--     ["textDocument/publishDiagnostics"] = function(
--       _,
--       result,
--       ctx,
--       config
--     )
--       if result.diagnostics == nil then
--         return
--       end

--       -- ignore some tsserver diagnostics
--       local idx = 1
--       while idx <= #result.diagnostics do
--         local entry = result.diagnostics[idx]

--         local formatter = require('format-ts-errors')[entry.code]
--         entry.message = formatter and formatter(entry.message) or entry.message

--         -- codes: https://github.com/microsoft/TypeScript/blob/main/src/compiler/diagnosticMessages.json
--         if entry.code == 80001 then
--           -- { message = "File is a CommonJS module; it may be converted to an ES module.", }
--           table.remove(result.diagnostics, idx)
--         else
--           idx = idx + 1
--         end
--       end

--       vim.lsp.diagnostic.on_publish_diagnostics(
--         _,
--         result,
--         ctx,
--         config
--       )
--     end,
--   },
-- })


-- ---remove a server from the skipped list, e.g. eslint, or emmet_ls. !!Requires `:LvimCacheReset` to take effect!!
-- ---`:LvimInfo` lists which server(s) are skipped for the current filetype
-- lvim.lsp.automatic_configuration.skipped_servers = vim.tbl_filter(function(server)
--   return server ~= "emmet_ls"
-- end, lvim.lsp.automatic_configuration.skipped_servers)

-- -- you can set a custom on_attach function that will be used for all the language servers
-- -- See <https://github.com/ua require("nvim-navbuddy").open()ovim/nvim-lspconfig#keybindings-and-completion>
-- lvim.lsp.on_attach_callback = function(client, bufnr)
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end
--   --Enable completion triggered by <c-x><c-o>
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- end
--

-- lvim.lsp.on_attach_callback = function(client, bufnr)
--   navbuddy.attach(client, bufnr)
-- end



-- local null_ls_status_ok, null_ls = pcall(require, "null-ls")
-- if not null_ls_status_ok then
-- 	return
-- end


-- -- set a formatter, this will override the language server formatting capabilities (if it exists)
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { command = "goimports", filetypes = { "go" } },
  { command = "gofumpt",   filetypes = { "go" } },
  {
    -- each formatter accepts a list of options identical to https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
    command = "prettier",
    ---@usage arguments to pass to the formatter
    -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
    -- extra_args = { "--print-with", "100" },
    ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
    filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact", "vue", "svelte" },
  },
}

-- -- set additional linters
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  {
    command = "eslint",
    ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
    filetypes = { "css", "typescript", "typescriptreact", "javascript", "javascriptreact", "vue", "svelte" },
  },
  -- { command = "flake8", filetypes = { "python" } },
  -- {
  --   -- each linter accepts a list of options identical to https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
  --   command = "shellcheck",
  --   ---@usage arguments to pass to the formatter
  --   -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
  --   extra_args = { "--severity", "warning" },
  -- },
  -- {
  --   command = "codespell",
  --   ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
  --   filetypes = { "javascript", "python" },
  -- },
}


-- Additional Plugins
lvim.plugins = {
  {
    "rebelot/kanagawa.nvim",
    --     config = function()
    --       require('kanagawa').setup({
    -- })
  },
  {
    "Pocco81/true-zen.nvim",
    config = function()
      require("true-zen").setup {
        -- your config goes here
        -- or just leave it empty :)
      }
    end,
  },
  {
    'michaelb/sniprun',
    run = 'sh ./install.sh',
    config = function()
      require 'sniprun'.setup({
        interpreter_options = {
          Go_original = {
            compiler = "gccgo"
          }
        }
      })
    end
  },
  {
    "rmagatti/goto-preview",
    config = function()
      require('goto-preview').setup {
        width = 120,              -- Width of the floating window
        height = 25,              -- Height of the floating window
        default_mappings = false, -- Bind default mappings
        debug = false,            -- Print debug information
        opacity = nil,            -- 0-100 opacity level of the floating window where 100 is fully transparent.
        post_open_hook = nil      -- A function taking two arguments, a buffer and a window to be ran as a hook.
        -- You can use "default_mappings = true" setup option
        -- Or explicitly set keybindings
        -- vim.cmd("nnoremap gpd <cmd>lua require('goto-preview').goto_preview_definition()<CR>")
        -- vim.cmd("nnoremap gpi <cmd>lua require('goto-preview').goto_preview_implementation()<CR>")
        -- vim.cmd("nnoremap gP <cmd>lua require('goto-preview').close_all_win()<CR>")
      }
    end
  },
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function() require "lsp_signature".on_attach() end,
  },
  {
    "simrat39/symbols-outline.nvim",
    config = function()
      require('symbols-outline').setup()
    end
  },
  {
    'anuvyklack/fold-preview.nvim',
    requires = 'anuvyklack/keymap-amend.nvim',
    config = function()
      require('fold-preview').setup({
        auto = 400
        -- Your configuration goes here.
      })
    end
  },
  {
    'anuvyklack/pretty-fold.nvim',
    config = function()
      require('pretty-fold').setup()
    end
  },
  'smolck/command-completion.nvim',
  {
    "sindrets/diffview.nvim",
    event = "BufRead",
  },

  {
    'ray-x/navigator.lua',
    requires = {
      { 'ray-x/guihua.lua',     run = 'cd lua/fzy && make' },
      { 'neovim/nvim-lspconfig' },
    },
  },
  {
    "Fildo7525/pretty_hover",
    config = function()
      require("pretty_hover").setup(options)
    end
  },
  "davidosomething/format-ts-errors.nvim",
  {
    "windwp/nvim-spectre",
    event = "BufRead",
    config = function()
      require("spectre").setup()
    end,
  },
  -- { 'rose-pine/neovim', as = 'rose-pine' },
  'mg979/vim-visual-multi',
  "olexsmir/gopher.nvim",
  "leoluz/nvim-dap-go",
  -- { 'ray-x/go.nvim' },

  { 'vimwiki/vimwiki' },
  -- { 'Olical/conjure' },

  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
  },

  { "gpanders/editorconfig.nvim" },

  {
    "ggandor/lightspeed.nvim",
    event = "BufRead",
  },

  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    event = "BufRead",
    -- config = {
    --   clojure = ";; %s",
    --   clj = ";; %s"
    -- }
  },
  {
    "p00f/nvim-ts-rainbow",
  },
  {
    "itchyny/vim-cursorword",
    event = { "BufEnter", "BufNewFile" },
    config = function()
      vim.api.nvim_command("augroup user_plugin_cursorword")
      vim.api.nvim_command("autocmd!")
      vim.api.nvim_command("autocmd FileType NvimTree,lspsagafinder,dashboard,vista let b:cursorword = 0")
      vim.api.nvim_command("autocmd WinEnter * if &diff || &pvw | let b:cursorword = 0 | endif")
      vim.api.nvim_command("autocmd InsertEnter * let b:cursorword = 0")
      vim.api.nvim_command("autocmd InsertLeave * let b:cursorword = 1")
      vim.api.nvim_command("augroup END")
    end
  },

  {
    "tpope/vim-surround",

    -- make sure to change the value of `timeoutlen` if it's not triggering correctly, see https://github.com/tpope/vim-surround/issues/117
    -- setup = function()
    --  vim.o.timeoutlen = 500
    -- end
  },

  {
    "kevinhwang91/nvim-bqf",
    event = { "BufRead", "BufNew" },
    config = function()
      require("bqf").setup({
        auto_enable = true,
        preview = {
          win_height = 12,
          win_vheight = 12,
          delay_syntax = 80,
          border_chars = { "┃", "┃", "━", "━", "┏", "┓", "┗", "┛", "█" },
        },
        func_map = {
          vsplit = "",
          ptogglemode = "z,",
          stoggleup = "",
        },
        filter = {
          fzf = {
            action_for = { ["ctrl-s"] = "split" },
            extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " },
          },
        },
      })
    end,
  },

  {
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },

  {
    "romgrk/nvim-treesitter-context",
    config = function()
      require("treesitter-context").setup {
        enable = true,   -- Enable this plugin (Can be enabled/disabled later via commands)
        throttle = true, -- Throttles plugin updates (may improve performance)
        max_lines = 0,   -- How many lines the window should span. Values <= 0 mean no limit.
        patterns = {     -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
          -- For all filetypes
          -- Note that setting an entry here replaces all other patterns for this entry.
          -- By setting the 'default' entry below, you can control which nodes you want to
          -- appear in the context window.
          default = {
            'class',
            'function',
            'method',
          },
        },
      }
    end
  },
}

-- Autocommands (https://neovim.io/doc/user/autocmd.html)
-- vim.api.nvim_create_autocmd("BufEnter", {
--   pattern = { "*.json", "*.jsonc" },
--   -- enable wrap mode for json files only
--   command = "setlocal wrap",
-- })
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "zsh",
--   callback = function()
--     -- let treesitter use bash highlight for zsh files as well
--     require("nvim-treesitter.highlight").attach(0, "bash")
--   end,
-- })
