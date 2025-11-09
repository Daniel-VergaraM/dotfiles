return {
  -- The plugin repository
  "pandasoli/nekovim",
  -- Define an empty options table. The plugin will use its defaults.
  -- You can customize your Discord Rich Presence here if you want.
  opts = {
    -- example of a custom option:
    -- show_time_when_idle = true,
  },
  -- The config function is called after the plugin is installed and loaded.
  config = function(_, opts)
    require("nekovim").setup(opts, nil)
  end,
}
