require("batch_rename").setup()
require("clipboard").setup()
require("fzf").setup()
require("preview").setup()
require("trash_cli").setup()
require("zoxide").setup()

xlpr.config.general.show_hidden = true
xplr.config.general.initial_sorting = { { sorter = "ByIsDir", reverse = false } }

xplr.config.general.panel_ui.default.border_type = "Rounded"
