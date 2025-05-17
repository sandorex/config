-- contains helper functions for running LSPs in containers

local M = {}

---Returns first container manager, podman or docker
---@return string?
function M.find_manager()
	if M.is_available("podman") then
		return "podman"
	elseif M.is_available("docker") then
		return "docker"
	end
end

---Check if command is available in PATH
---@param command string
---@return boolean
function M.is_available(command)
	return vim.fn.executable(command) == 1
end

---@class CommandOptions
---@field image string Container image to use
---@field command string[] Command to run in the container
---@field manager string? Container manager to use
---@field network boolean? Should network be enabled (defaults to false)
---@field home_readonly boolean? Should home be mounted readonly, if nil then home is not mounted (defaults to nil)
---@field manager_args string[]? Args passed to container manager (defaults to {})

---Generates command to launch LSP
---@param options CommandOptions
---@return string[]?
function M.command(options)
	if options == nil then
		error("Invalid options nil")
		return nil
	end

	if options.image == nil or options.command == nil then
		error("Invalid options, image and command are required arguments")
		return nil
	end

	if options.manager == nil then
		options.manager = M.find_manager()
	end

	if options.network == nil then
		options.network = false
	end

	if options.manager_args == nil then
		options.manager_args = {}
	end

	local cmd = {
		options.manager,
		-- if options ~= nil and options.manager ~= nil then options.manager else M.find_manager() end,
		"run",
		"--rm",
		-- "--pull=never", -- maybe it can pull automatically?
		"-i",
		"--security-opt=label=disable", -- selinux trouble
		-- "--entrypoint=", -- TODO does not work for some reason?
	}

	-- network is enabled by default in podman
	if options.network ~= true then
		table.insert(cmd, "--network=none")
	end

	-- mounting the home means all paths within the home stay the same and work fine,
	-- except anything that requires modifications to file like formatting
	local mount_home_arg = vim.fn.expand("--volume=$HOME:$HOME")
	if options.home_readonly == true then
		table.insert(cmd, mount_home_arg .. ":ro")
	elseif options.home_readonly == false then
		table.insert(cmd, mount_home_arg)
	end

	-- add supplied extra arguments
	for i = 1, #options.manager_args do
		table.insert(cmd, options.manager_args[i])
	end

	table.insert(cmd, options.image)
	-- the actual command
	for i = 1, #options.command do
		table.insert(cmd, options.command[i])
	end

	return cmd
end

return M

