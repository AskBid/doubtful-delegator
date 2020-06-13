# Doubtful Delegator

Track the performance of your delegations in the [**Cardano**](https://www.cardano.org/) blockchain.

Users can select a group of pools to which they have delegated and a group of Pools they want to track. 
During the course of an epoch users can compare the performance of the actual delegations and the performance of "would be" delegations.

## Installation
Prerequisite: you have `ruby`,`gem` and `bundle` installed

Clone the gihub repository locally.

	$ git clone git@github.com:AskBid/doubtful-delegator.git

once in the project directory, install all the dependecies by executing:

	$ bundle install

If you wish to use the scraper that takes new data from the source [AdaPools](https://itn.adapools.org/), you will need to install ChromeDriver as an headless browser is used to scrape data.
To install ChromeDriver on MacOS:

	$ brew cask install chromedriver

## Usage

To populate the database I have supplied the file `db/concerns/data_daily.json`.
To simulate the updating during an epoch I have supplied the file`db/concerns/data_hourly.json`.
Or you can create you own database by using the `lib/scraper_adapool.rb`.

To support with the seeding of the databse and the simulation of the course of an epoch by `db/concerns/data_hourly.json`, I created a CLI script to guide you through the options:

	$ bin/update_db_cli

just follow the messages in the terminal for usage.

but first don't forget to migrate the database:

	$ rake db:migrate

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/AskBid/doubtful-delegator/. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.

## License

The repository is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT)
