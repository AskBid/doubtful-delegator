class PopulateController

  def initialize
		String.disable_colorization = false

		puts ""
		puts ""
		puts ""
		puts "------------------------------------------------------------".colorize(:light_blue)
    puts "           Welcome Dubious-Delegator Database CLI  ".colorize(:light_blue)
    puts "------------------------------------------------------------".colorize(:light_blue)
    puts ""
    puts ""

    new_search
    list_searches

    main_menu
  end