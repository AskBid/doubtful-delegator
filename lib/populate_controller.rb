class PopulateController

  def initialize
		String.disable_colorization = false

		puts ""
		puts ""
		puts ""
		puts "------------------------------------------------------------".colorize(:light_blue)
    puts "          Welcome to Dubious-Delegator Database CLI         ".colorize(:light_blue)
    puts "------------------------------------------------------------".colorize(:light_blue)
    puts ""
    puts ""

  def main_menu
    puts ""
    print "Choose an action:".colorize(:light_yellow)
    puts " (enter number)".colorize(:light_black)
    puts ""

    print "1: ".colorize(:light_yellow)
    puts "Update DB from .json".colorize(:yellow)

    print "2: ".colorize(:light_yellow)
    puts "Update DB from .html raw page".colorize(:yellow)

    print "3: ".colorize(:light_yellow)
    puts "Update DB from https://itn.adapools.org/".colorize(:yellow)

    print "8: ".colorize(:light_yellow)
    puts "quit! (your job?)".colorize(:yellow)
    puts "...".colorize(:light_blue)

    action = gets.strip

    case action
      when '1'
        json_update
        main_menu
      when '2'
        html_update
        main_menu
      when '2'
        adapools_update
        main_menu
        
      when '8'
        puts "--------------------------------------".colorize(:light_blue)
        puts "!!!                                !!!".colorize(:light_blue)
        puts "!!!            the end             !!!".colorize(:light_blue)
        puts "--------------------------------------".colorize(:light_blue)
      else
        wrong_input_msg
        puts 'please choose between one of the listed numbers:'.colorize(:light_magenta)
        main_menu
    end
  end

  def json_update
  end

  def html_update
  end

  def adapools_update
  end
end