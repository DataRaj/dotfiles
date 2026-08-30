-- lua/plugins/takatime.lua
return {
  "Rtarun3606k/TakaTime",
  lazy = false,
  config = function()
    require("taka-time").setup({
      debug = false, -- set true if troubleshooting
    })
  end,
}
