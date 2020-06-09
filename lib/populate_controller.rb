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
    puts "Update DB from .json :: ALL records".colorize(:yellow)

    print "3: ".colorize(:light_yellow)
    puts "Update DB from .json :: SELECT a record".colorize(:yellow)

    print "4: ".colorize(:light_yellow)
    puts "Update DB from https://itn.adapools.org/".colorize(:yellow)

    print "5: ".colorize(:light_yellow)
    puts "Seed_Users".colorize(:yellow)

    print "8: ".colorize(:light_yellow)
    puts "quit! (your job?)".colorize(:yellow)
    puts "...".colorize(:light_blue)

    action = gets.strip

    case action
      when '1'
        json_update('all')
        main_menu      
      when '3'
        json_update('call')
        main_menu
      when '4'
        adapools_update
        main_menu
      when '5'
        Seed.new
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

  def json_update(all_or_call)
    puts "type the .json file path:".colorize(:light_yellow)
    file_path = gets.strip
    file = File.read(file_path)
    hash_of_records = JSON.parse(file)

    if all_or_call == 'all'
      hash_of_records.each {|key, array_of_pools|
        puts "day #{key}...".colorize(:magenta)
        puts "populating DB...".colorize(:magenta)
        Populate.new(array_of_pools)
      }
    else
      loop_menu(hash_of_records)
    end
    puts "population ended sucessfully.".colorize(:magenta)
  end

  def loop_menu(hash_of_records)
      puts "Enter the key of the record you want to use to populate...".colorize(:light_yellow)
      puts 'Or enter "..." to list all possible records.'.colorize(:light_yellow)
      puts 'Or enter "q" quit command.'.colorize(:light_yellow)
      entry = gets.strip
      if entry == '...'
        hash_of_records.each {|key, array_of_pools| puts key}
        loop_menu(hash_of_records)
      elsif entry == 'q'
        nil
      else
        Populate.new(hash_of_records["#{entry}"])
      end
  end

  def adapools_update
    puts "scraping web...".colorize(:magenta)
    scrape = ScraperAdapool.new
    puts "scraping successful.".colorize(:magenta)
    puts "...".colorize(:magenta)
    puts "populating DB...".colorize(:magenta)
    Populate.new(scrape.get_data)
    puts "population ended sucessfully.".colorize(:magenta)
  end

end