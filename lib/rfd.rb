module Rfd
  VERSION = Gem.loaded_specs['rfd'].version.to_s

  class Window
    def draw(contents)
      @win.setpos 0, 0
      @win.addstr contents
      @win.refresh
    end
  end

  # bordered Window
  class SubWindow < Window
    def initialize(*)
      border_window = Curses.stdscr.subwin @win.maxy + 2, @win.maxx + 2, @win.begy - 1, @win.begx - 1
      border_window.box ?|, ?-
    end
  end

  class BaseWindow < Window
    def initialize(dir = '.')
      @win = Curses.stdscr
      @win.box ?|, ?-
      @header = HeaderWindow.new
      @main = MainWindow.new base: self, dir: dir
      @main.move_cursor 0
    end

    def move_cursor(row)
      @win.setpos row, 1
    end

    def debug(str)
      @header.draw str
    end

    def q
      raise StopIteration
    end
  end

  class HeaderWindow < SubWindow
    def initialize
      @win = Curses.stdscr.subwin 6, Curses.stdscr.maxx - 2, 1, 1
      super
    end
  end

  class MainWindow < SubWindow
    def initialize(base: nil, dir: nil)
      @base = base
      @win = Curses.stdscr.subwin Curses.stdscr.maxy - 9, Curses.stdscr.maxx - 2, 8, 1
      super
      @files = Dir.foreach(dir).to_a
      draw %Q!#{@files.join("\n")}\n!
    end

    def move_cursor(row)
      @base.move_cursor @win.begy + row
    end
  end
end
