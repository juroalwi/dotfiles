local M = {}

M.add = function(packages)
  local urls = {}
  local setups = {}
  local requirements = {}

  for _, v in ipairs(packages) do
    table.insert(urls, { src = "https://github.com/" .. v[1], name = v.name, version = v.version })

    if v.setup then
      table.insert(setups, {
        path = string.match(v[1], "[^/]+/(.*)"),
        opts = type(v.setup) == "table" and v.setup or {},
      })
    end

    if v.require then
      table.insert(requirements, v.require)
    end
  end

  vim.pack.add(urls)

  for _, v in ipairs(setups) do
    local ok, mod = pcall(require, v.path)
    if not ok then
      ok, mod = pcall(require, string.gsub(v.path, "[.-]nvim$", ""))
    end

    if ok then
      mod.setup(v.opts)
    else
      vim.notify("Failed to load package" .. v.path, vim.log.levels.ERROR)
    end
  end

  for _, v in ipairs(requirements) do
    require(v)
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
