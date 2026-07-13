return {
  {
    "b0o/SchemaStore.nvim",
    lazy = true,
    version = false, -- last release is way too old
  },
  {
    "cwrau/yaml-schema-detect.nvim",
    lazy = true,
    config = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    ft = { "yaml" },
  },
}
