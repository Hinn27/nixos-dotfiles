return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true, -- Bật nền trong suốt
      styles = {
        sidebars = "transparent", -- Trong suốt cả thanh bên (file tree)
        floats = "transparent",   -- Trong suốt cả cửa sổ popup nổi
      },
    },
  },
}
