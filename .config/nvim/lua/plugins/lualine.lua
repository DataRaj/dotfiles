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

local function thorn_light_theme()
  local bg = "#F4F6EE"
  local pill_bg = "#E2EAD6"
  return {
    normal = {
      a = { bg = "#216849", fg = "#F4F6EE", gui = "bold" },
      b = { bg = pill_bg, fg = "#216849" },
      c = { bg = bg, fg = "#1A2B23" },
      x = { bg = bg, fg = "#1A2B23" },
      y = { bg = pill_bg, fg = "#1B5C87" },
      z = { bg = "#B84A27", fg = "#F4F6EE", gui = "bold" },
    },
    insert = {
      a = { bg = "#B84A27", fg = "#F4F6EE", gui = "bold" },
      b = { bg = pill_bg, fg = "#216849" },
      c = { bg = bg, fg = "#1A2B23" },
      x = { bg = bg, fg = "#1A2B23" },
      y = { bg = pill_bg, fg = "#1B5C87" },
      z = { bg = "#B84A27", fg = "#F4F6EE", gui = "bold" },
    },
    visual = {
      a = { bg = "#1B5C87", fg = "#F4F6EE", gui = "bold" },
      b = { bg = pill_bg, fg = "#216849" },
      c = { bg = bg, fg = "#1A2B23" },
      x = { bg = bg, fg = "#1A2B23" },
      y = { bg = pill_bg, fg = "#1B5C87" },
      z = { bg = "#B84A27", fg = "#F4F6EE", gui = "bold" },
    },
    command = {
      a = { bg = "#567510", fg = "#F4F6EE", gui = "bold" },
      b = { bg = pill_bg, fg = "#216849" },
      c = { bg = bg, fg = "#1A2B23" },
      x = { bg = bg, fg = "#1A2B23" },
      y = { bg = pill_bg, fg = "#1B5C87" },
      z = { bg = "#B84A27", fg = "#F4F6EE", gui = "bold" },
    },
    replace = {
      a = { bg = "#C62828", fg = "#F4F6EE", gui = "bold" },
      b = { bg = pill_bg, fg = "#216849" },
      c = { bg = bg, fg = "#1A2B23" },
      x = { bg = bg, fg = "#1A2B23" },
      y = { bg = pill_bg, fg = "#1B5C87" },
      z = { bg = "#B84A27", fg = "#F4F6EE", gui = "bold" },
    },
    inactive = {
      a = { bg = "#EEF1E5", fg = "#667F6D" },
      b = { bg = "#EEF1E5", fg = "#667F6D" },
      c = { bg = bg, fg = "#667F6D" },
      x = { bg = bg, fg = "#667F6D" },
      y = { bg = "#EEF1E5", fg = "#667F6D" },
      z = { bg = "#EEF1E5", fg = "#667F6D" },
    },
  }
end

local function thorn_violet_theme()
  local bg = "#120D18"
  local pill_bg = "#241930"
  return {
    normal = {
      a = { bg = "#C29BEA", fg = "#120D18", gui = "bold" },
      b = { bg = pill_bg, fg = "#C29BEA" },
      c = { bg = bg, fg = "#EAE3F2" },
      x = { bg = bg, fg = "#EAE3F2" },
      y = { bg = pill_bg, fg = "#A4B8E6" },
      z = { bg = "#F4AF6A", fg = "#120D18", gui = "bold" },
    },
    insert = {
      a = { bg = "#F4AF6A", fg = "#120D18", gui = "bold" },
      b = { bg = pill_bg, fg = "#C29BEA" },
      c = { bg = bg, fg = "#EAE3F2" },
      x = { bg = bg, fg = "#EAE3F2" },
      y = { bg = pill_bg, fg = "#A4B8E6" },
      z = { bg = "#F4AF6A", fg = "#120D18", gui = "bold" },
    },
    visual = {
      a = { bg = "#A4B8E6", fg = "#120D18", gui = "bold" },
      b = { bg = pill_bg, fg = "#C29BEA" },
      c = { bg = bg, fg = "#EAE3F2" },
      x = { bg = bg, fg = "#EAE3F2" },
      y = { bg = pill_bg, fg = "#A4B8E6" },
      z = { bg = "#F4AF6A", fg = "#120D18", gui = "bold" },
    },
    command = {
      a = { bg = "#EAA098", fg = "#120D18", gui = "bold" },
      b = { bg = pill_bg, fg = "#C29BEA" },
      c = { bg = bg, fg = "#EAE3F2" },
      x = { bg = bg, fg = "#EAE3F2" },
      y = { bg = pill_bg, fg = "#A4B8E6" },
      z = { bg = "#F4AF6A", fg = "#120D18", gui = "bold" },
    },
    replace = {
      a = { bg = "#F44E6A", fg = "#120D18", gui = "bold" },
      b = { bg = pill_bg, fg = "#C29BEA" },
      c = { bg = bg, fg = "#EAE3F2" },
      x = { bg = bg, fg = "#EAE3F2" },
      y = { bg = pill_bg, fg = "#A4B8E6" },
      z = { bg = "#F4AF6A", fg = "#120D18", gui = "bold" },
    },
    inactive = {
      a = { bg = bg, fg = "#826F98" },
      b = { bg = bg, fg = "#826F98" },
      c = { bg = bg, fg = "#826F98" },
      x = { bg = bg, fg = "#826F98" },
      y = { bg = bg, fg = "#826F98" },
      z = { bg = bg, fg = "#826F98" },
    },
  }
end

local function get_theme()
  local cs = vim.g.colors_name or ""
  if cs == "thorn-light" or cs == "thorn-field" then
    return thorn_light_theme()
  elseif cs == "thorn-violet" then
    return thorn_violet_theme()
  elseif cs == "thorn" or cs:find("^thorn") then
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
