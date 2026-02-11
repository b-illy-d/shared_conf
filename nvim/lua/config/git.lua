local function open_remote(opts)
	local branch = opts.args
	-- vertical split with fugitive's Gsplit, same file from origin/<branch>
	vim.cmd('vert Gsplit origin/' .. branch .. ':%')
end

-- Long name
vim.api.nvim_create_user_command(
	'OpenRemote',
	open_remote,
	{ nargs = 1 }
)

-- Short alias: :or (commands are case-insensitive)
vim.api.nvim_create_user_command(
	'Orem',
	open_remote,
	{ nargs = 1 }
)
