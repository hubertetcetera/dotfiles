-- Auto-open Snacks Explorer *after* choosing a project from the dashboard/picker.
return {
  "folke/snacks.nvim",
  opts = {
    session = { autoload = false }, -- keep your clean dashboard on plain `nvim`
    picker = {
      hidden = true,
    },
  },
  keys = {
    {
      "<leader>fa",
      function()
        require("snacks").picker.files({
          cwd = require("lazyvim.util").root.get(), -- project root
          hidden = true,
          respect_gitignore = false,
          title = "All Files",
        })
      end,
      desc = "Find All Files (root)",
    },
    {
      "<leader>fA",
      function()
        require("snacks").picker.files({
          cwd = vim.loop.cwd(), -- current working dir
          hidden = true,
          respect_gitignore = false,
          title = "All Files",
        })
      end,
      desc = "Find All Files (cwd)",
    },
  },
  init = function()
    local ok, Snacks = pcall(require, "snacks")
    if not ok then
      return
    end

    -- Preferred: Snacks emits this when a project is opened via the picker/dashboard.
    vim.api.nvim_create_autocmd("User", {
      pattern = "SnacksProjectOpened",
      callback = function()
        Snacks.explorer.open({ focus = true, reveal = true })
      end,
    })

    -- Fallback: if that event doesn't fire (older Snacks), open on cwd change
    -- only when coming from the dashboard.
    vim.api.nvim_create_autocmd("DirChanged", {
      callback = function()
        -- only trigger if the current buffer is (or was) the dashboard
        local ft = vim.bo.filetype
        local was_dashboard = (ft == "snacks_dashboard") or (vim.g.__came_from_dashboard == true)

        if was_dashboard then
          -- mark we’ve reacted once to avoid re-opening repeatedly
          vim.g.__came_from_dashboard = false
          Snacks.explorer.open({ focus = true, reveal = true })
        end
      end,
    })

    -- Track when we’re on the dashboard so the DirChanged fallback knows
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "snacks_dashboard",
      callback = function()
        vim.g.__came_from_dashboard = true
      end,
    })
  end,
}
