return {
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.linters_by_ft = opts.linters_by_ft or {}
      for _, ft in ipairs({ "python", "go", "rust", "yaml", "hcl", "terraform", "typescript", "typescriptreact" }) do
        local linters = opts.linters_by_ft[ft] or {}
        table.insert(linters, "cspell")
        opts.linters_by_ft[ft] = linters
      end
    end,
  },
}
