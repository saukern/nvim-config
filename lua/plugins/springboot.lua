return {
	"JavaHello/spring-boot.nvim",
	ft = "java",
	config = function()
		require("spring_boot").init_lsp_commands()
	end,
}
