-- Loaded by scripts/verify.py with isolated state/config and installed dependencies.
local config = vim.env.NVIM_TEST_CONFIG
assert(config and vim.fn.isdirectory(config) == 1, "NVIM_TEST_CONFIG is required")
vim.opt.rtp:prepend(config)
dofile(config .. "/init.lua")
