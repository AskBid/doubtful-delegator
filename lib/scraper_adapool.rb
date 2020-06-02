require 'nokogiri'
require 'watir'

# html = open("https://pooltool.io/pool/c0285a4fe690d3aa9c0709f2f365e13f4ba83161e9219c8a10446aaa189e81d0/history")
browser = Watir::Browser.new :chrome, headless: true
# browser = Watir::Browser.new

# browser.goto 'https://pooltool.io/'
browser.goto 'https://itn.adapools.org/dashboard/full'
# Watir::Wait.until { browser.div(class: ['modal-modal-dialog', 'modal-lg']).present? }
# Watir::Wait.until {browser.div(class: ['modal-modal-dialog', 'modal-lg']).visible? }
# browser.send_keys(:escape)
# browser.button(text: 'X').when_present.click
# browser.select_list(name: 'DataTables_Table_0_length').option(value: '1000')
# puts browser.select_list(name: 'DataTables_Table_0_length').selected_options.map(&:text)

doc = Nokogiri::HTML.parse(browser.html)
doc = doc.css('.table.datatable')


File.write("log1.html", doc)