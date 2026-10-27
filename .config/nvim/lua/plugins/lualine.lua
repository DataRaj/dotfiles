-- Prepend the repo+worktree-marker component (provided by worktree.nvim) to
-- lualine's section_b so the statusline shows `repo │ branch`, with a
-- trailing `(wt)` when the cwd is a linked git worktree.

local function thorn_theme()
  local bg = "#040f13"
  return {
    normal = {
      a = { bg = "#88B497", fg = "#040f13", gui = "bold" },
      b = { bg = "#1B3030", fg = "#88B497" },
      c = { bg = bg, fg = "#dff7ef" },
      x = { bg = bg, fg = "#dff7ef" },
      y = { bg = "#1B3030", fg = "#9DCEE8" },
      z = { bg = "#F5A97A", fg = "#040f13", gui = "bold" },
    },
    insert = {
      a = { bg = "#F5A97A", fg = "#040f13", gui = "bold" },
      b = { bg = "#1B3030", fg = "#88B497" },
      c = { bg = bg, fg = "#dff7ef" },
      x = { bg = bg, fg = "#dff7ef" },
      y = { bg = "#1B3030", fg = "#9DCEE8" },
      z = { bg = "#F5A97A", fg = "#040f13", gui = "bold" },
    },
    visual = {
      a = { bg = "#9DCEE8", fg = "#040f13", gui = "bold" },
      b = { bg = "#1B3030", fg = "#88B497" },
      c = { bg = bg, fg = "#dff7ef" },
      x = { bg = bg, fg = "#dff7ef" },
      y = { bg = "#1B3030", fg = "#9DCEE8" },
      z = { bg = "#F5A97A", fg = "#040f13", gui = "bold" },
    },
    command = {
      a = { bg = "#BAD560", fg = "#040f13", gui = "bold" },
      b = { bg = "#1B3030", fg = "#88B497" },
      c = { bg = bg, fg = "#dff7ef" },
      x = { bg = bg, fg = "#dff7ef" },
      y = { bg = "#1B3030", fg = "#9DCEE8" },
      z = { bg = "#F5A97A", fg = "#040f13", gui = "bold" },
    },
    replace = {
      a = { bg = "#e07070", fg = "#040f13", gui = "bold" },
      b = { bg = "#1B3030", fg = "#88B497" },
      c = { bg = bg, fg = "#dff7ef" },
      x = { bg = bg, fg = "#dff7ef" },
      y = { bg = "#1B3030", fg = "#9DCEE8" },
      z = { bg = "#F5A97A", fg = "#040f13", gui = "bold" },
    },
    inactive = {
      a = { bg = bg, fg = "#568270" },
      b = { bg = bg, fg = "#568270" },
      c = { bg = bg, fg = "#568270" },
      x = { bg = bg, fg = "#568270" },
      y = { bg = bg, fg = "#568270" },
      z = { bg = bg, fg = "#568270" },
    },
  }
end

local function get_theme()
  local cs = vim.g.colors_name or ""
  if cs == "thorn" or cs:find("^thorn") then
    return thorn_theme()
  end
  return "auto"
end

return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.options = opts.options or {}
      opts.options.theme = get_theme()

      -- Worktree component on the left
      table.insert(opts.sections.lualine_b, 1, {
        require("worktree").lualine_component,
      })

      return opts
    end,
    config = function(_, opts)
      require("lualine").setup(opts)

      -- Dynamically update lualine theme when colorscheme changes
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("LualineThemeSync", { clear = true }),
        callback = function()
          local theme = get_theme()
          require("lualine").setup({ options = { theme = theme } })
        end,
      })
    end,
  },
}
