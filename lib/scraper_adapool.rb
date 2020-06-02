require 'nokogiri'
require 'watir'

class ScraperAdapool

  def initialize(url = 'https://itn.adapools.org/dashboard/full')
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

  def pool_rows
    @table.css('tbody').css('tr')
  end

  def values_from_row(row)
    row.css('td')[0].text
  end

end