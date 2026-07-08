local M = {}

M.add = function(packages)
  local urls = {}
  local setups = {}
  local requirements = {}

  for _, p in ipairs(packages) do
    table.insert(urls, { src = "https://github.com/" .. p[1], name = p.name, version = p.version })

    if p.setup then
      table.insert(setups, {
        path = string.match(p[1], "[^/]+/(.*)"),
        opts = type(p.setup) == "table" and p.setup or {},
      })
    end

    if p.require then
      table.insert(requirements, p.require)
    end
  end

  vim.pack.add(urls)

  for _, s in ipairs(setups) do
    local ok, mod = pcall(require, s.path)
    if not ok then
      ok, mod = pcall(require, string.gsub(s.path, "[.-]nvim$", ""))
    end

    if ok then
      mod.setup(s.opts)
    else
      vim.notify("Failed to load package" .. s.path, vim.log.levels.ERROR)
    end
  end

  for _, r in ipairs(requirements) do
    require("packages." .. r)
  end
end

M.clean = function()
  local inactive_packages = vim.iter(vim.pack.get())
      :filter(function(x) return not x.active end)
      :map(function(x) return x.spec.name end)
      :totable()
  vim.pack.del(inactive_packages)
end

M.update = function(packages)
  if #packages == 0 then
    vim.pack.update()
  else
    vim.pack.update(vim.iter(string.gmatch(packages, "%S+")):totable())
  end
end

return M
