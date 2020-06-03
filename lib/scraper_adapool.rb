require 'nokogiri'
require 'watir'

class ScraperAdapool
  include NumberAbbreviation

  def initialize(url = 'https://itn.adapools.org/dashboard/full')

    browser = Watir::Browser.new :chrome, headless: true
    browser.goto(url)
    @doc = Nokogiri::HTML.parse(browser.html)
    @table = @doc.css('.table.datatable')
  end

  def hash(row)
    populate_hash_with_row(row)
  end

  def col_values
    @table.css('thead').css('th').text
  end

  def table_headers_changed?
    !(col_values == "# Name Pool ID PoolSize BPELastEpoch Staker'sreward LiveStake Tax(%) Tax(fix/max) TaxAvg ROAAvg")
  end

  # private

  def pool_rows
    @table.css('tbody').css('tr')
  end

  def populate_hash_with_row(row)
    @hash = {
      ticker: ticker_from_row(row),
      name: name_from_row(row),
      address: address_from_row(row),
      pool_size: pool_size_from_row(row),
      last_epoch: last_epoch_from_row(row),
      blocks: blocks_from_row(row),
      staker_reward: staker_reward_from_row(row),
      live_stake: live_stake_from_row(row),
      tax: tax_from_row(row)
    }
  end

  def ticker_from_row(row)
    str = row.css('td')[2].text
    str.split(']')[0].gsub('  [','')
  end

  def name_from_row(row)
    str = row.css('td')[2].text
    str = str.split(']')[1]
    str = str.scan(/^(.*).$/).join
    str.scan(/^.(.*)$/).join
  end

  def address_from_row(row)
    row.css('td')[3].attributes['data-search'].value
  end

  def pool_size_from_row(row)
    str = row.css('td')[4].text.scan(/[0-9]*\.?[0-9]*/).join
    str.to_f
  end

  def blocks_from_row(row)
    str = row.css('td')[5].text.scan(/[0-9]*\.?[0-9]*/).join
    str.to_i
  end

  def last_epoch_from_row(row)
    str = row.css('td')[6].text.scan(/[0-9]*\.?[0-9]*/).join
    str.to_i
  end

  def staker_reward_from_row(row)
    str = row.css('td')[7].text
    reverse_abbreviation(str)
  end

  def live_stake_from_row(row)
    str = row.css('td')[8].text
    reverse_abbreviation(str)
  end

  def tax_from_row(row)
    str = row.css('td')[9].text.gsub('%','').to_f
    str.to_f
  end

end