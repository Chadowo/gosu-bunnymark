require 'gosu'

# Main window
class BunnyMarkWindow < Gosu::Window
  MAX_BUNNIES = 50_000
  # Create all the sprites here
  VARIANTS_BUNNIES = [Gosu::Image.new('sprites/rabbitv3.png'),
                      Gosu::Image.new('sprites/rabbitv3_ash.png'),
                      Gosu::Image.new('sprites/rabbitv3_batman.png'),
                      Gosu::Image.new('sprites/rabbitv3_bb8.png'),
                      Gosu::Image.new('sprites/rabbitv3_frankenstein.png'),
                      Gosu::Image.new('sprites/rabbitv3_neo.png'),
                      Gosu::Image.new('sprites/rabbitv3_sonic.png'),
                      Gosu::Image.new('sprites/rabbitv3_spidey.png'),
                      Gosu::Image.new('sprites/rabbitv3_stormtrooper.png'),
                      Gosu::Image.new('sprites/rabbitv3_superman.png'),
                      Gosu::Image.new('sprites/rabbitv3_tron.png'),
                      Gosu::Image.new('sprites/rabbitv3_wolverine.png')].freeze

  Bunny = Struct.new(:sprite, :x, :y, :speed_x, :speed_y)

  def initialize
    super(800, 600)
    self.caption = 'BunnyMark'

    @font = Gosu::Font.new(18)
    @bunnies = []
  end

  def update
    @bunnies.each do |bunny|
      bunny.x += bunny.speed_x
      bunny.y += bunny.speed_y

      if bunny.x + bunny.sprite.width >= 800
        bunny.speed_x = -bunny.speed_x
        bunny.x = 800 - bunny.sprite.width # Prevents stucking
      elsif bunny.x <= 0
        bunny.speed_x = -bunny.speed_x
        bunny.x = 0 # Ditto
      end

      # Leave some space when checking for the top and bottom
      # so the bunnies don't go over the text
      if bunny.y + bunny.sprite.height >= 570
        bunny.speed_y = -bunny.speed_y
        bunny.y = 570 - bunny.sprite.height # Prevents stucking too
      elsif bunny.y <= 30
        bunny.speed_y = -bunny.speed_y
        bunny.y = 30 # Ditto
      end
    end

    close if Gosu.button_down?(Gosu::KB_ESCAPE)
  end

  def button_down(id)
    10.times { add_bunny } if id == Gosu::MS_WHEEL_UP && @bunnies.count + 10 <= MAX_BUNNIES
    10.times { remove_bunny } if id == Gosu::MS_WHEEL_DOWN
    @bunnies.clear if id == Gosu::KB_0
  end

  def add_bunny
    srand
    @bunnies << Bunny.new(VARIANTS_BUNNIES.sample,
                          self.mouse_x, self.mouse_y,
                          rand(-10..10), rand(-10..10))
  end

  def remove_bunny
    @bunnies.shift
  end

  def draw
    @bunnies.each do |bunny|
      bunny.sprite.draw(bunny.x, bunny.y, 0)
    end

    # Adjust the color of the FPS counter based on how many FPS we're getting
    color = if Gosu.fps < 20
              Gosu::Color::RED
            elsif Gosu.fps < 40
              Gosu::Color::YELLOW
            else
              Gosu::Color::GREEN
            end
    @font.draw_text("FPS: #{Gosu.fps}", 10, 10, 0, 1, 1, color)
    @font.draw_text("Bunnies: #{@bunnies.count}", 75, 10, 0)
    @font.draw_text('Use the mouse wheel to add or remove bunnies', 10, 575, 0)
  end
end

BunnyMarkWindow.new.show
