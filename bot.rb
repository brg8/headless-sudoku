require "selenium-webdriver"
require "opl"

class SudokuBot
  attr_accessor :driver
  attr_accessor :problem
  attr_accessor :solution

  def log(msg)
    puts "[bot] #{msg}"
  end

  def initialize
    @driver = Selenium::WebDriver.for :remote, url: "http://localhost:4444/wd/hub", desired_capabilities: :chrome

    site = "https://nine.websudoku.com/?level=4"
    log "navigating to #{site}"
    @driver.get site
  end

  def save
    log "saving problem..."
    @problem = parse
  end

  def parse
    driver.find_element(id: "puzzle_grid")
    driver.find_element(id: "puzzle_grid").find_elements(tag_name: "tr").map do |row|
      row.find_elements(tag_name: "td").map do |cell|
        value = cell.find_element(tag_name: "input").attribute("value")
        if value.empty?
          0
        else
          value.to_i
        end
      end
    end
  end

  def solve
    log "solving problem..."
    s = OPL::Sudoku.new(@problem)
    s.solve
    s.format_solution
    @solution = s.solution
  end

  def fill
    log "filling in solution..."
    driver.find_element(id: "puzzle_grid")
    rows = driver.find_element(id: "puzzle_grid").find_elements(tag_name: "tr")
    rows.each_index do |r|
      row = rows[r]
      cells = row.find_elements(tag_name: "td")
      cells.each_index do |c|
        cell = cells[c]
        input = cell.find_element(tag_name: "input")
        value = input.attribute("value")
        if value.empty?
          input.send_key(@solution[r][c])
        else
          value.to_i
        end
      end
    end
  end

  def submit
    log "submitting solution"
    @driver.find_element(name: "submit").click()
  end

  def finish
    log "closing browser - goodbye!"
    @driver.close
  end

  def check
    @driver.find_element(id: "message").text.include?("Congratulations! You solved this Sudoku")
  end

  def debug(filename)
    f = File.new(filename, "w")
    f.write(@driver.page_source)
    f.close
  end
end
