require 'nokogiri'
require 'watir'

class ScraperAdapool


  def initialize(url = 'https://itn.adapools.org/dashboard/full')
    @hash = {
      ticker: nil,
      name: nil,
      address: nil,
      pool_size: nil,
      last_epoch: nil,
      blocks: nil,
      staker_reward: nil,
      live_stake: nil,
      tax: nil
    }

    browser = Watir::Browser.new :chrome, headless: true
    browser.goto(url)
    @doc = Nokogiri::HTML.parse(browser.html)
    @table = @doc.css('.table.datatable')
  end

  def col_values
    @table.css('thead').css('th').text
  end

  def table_headers_changed?
    !(col_values == "# Name Pool ID PoolSize BPELastEpoch Staker'sreward LiveStake Tax(%) Tax(fix/max) TaxAvg ROAAvg")
  end

  private

  def pool_rows
    @table.css('tbody').css('tr')
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
    row.css('td')[4].text.scan(/[0-9]*\.?[0-9]*/).join
  end

  def blocks_from_row(row)
    row.css('td')[5].text.scan(/[0-9]*\.?[0-9]*/).join
  end

  def last_epoch_size_from_row(row)
    row.css('td')[6].text.scan(/[0-9]*\.?[0-9]*/).join
  end

  def staker_reward_from_row(row)
    row.css('td')[7].text
  end

  def live_stake_from_row(row)
    row.css('td')[8].text
  end

  def tax_from_row(row)
    row.css('td')[9].text.gsub('%','').to_f
  end

end