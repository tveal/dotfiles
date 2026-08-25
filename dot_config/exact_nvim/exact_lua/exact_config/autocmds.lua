vim.filetype.add({
  pattern = {
    [".*zshrc%.tmpl"] = "zsh",
    [".*bashrc%.tmpl"] = "bash",
    [".*profile%.tmpl"] = "sh",
    [".*tmux%.conf%.tmpl"] = "tmux",
    [".*%.toml%.tmpl"] = "toml",
    [".*%.ya?ml%.tmpl"] = "yaml",
    [".*%.sh%.tmpl"] = "bash",
    [".*%.lua%.tmpl"] = "lua",
    [".*gitconfig%.tmpl"] = "gitconfig",
    [".*gitconfig"] = "gitconfig",
  },
})
