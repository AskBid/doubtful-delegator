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

    main_menu
  end

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
    puts "type the .json file path:".colorize(:light_yellow)
    file_path = gets.strip
    file = File.read(file_path)
    hash_of_days = JSON.parse(file)

    hash_of_days.each {|key, array_of_pools|
      puts "populating DB with: #{key}"
      Populate.new(array_of_pools)
    }
  end

  def html_update
  end

  def adapools_update
  end

  def clear_db
  end

end