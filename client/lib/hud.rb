module HUD
  def draw_text_info(font, lines)
    lines.each_with_index do |line, index|
      text_surface = font.render_utf8 line, false, default_color
      text_bounds = text_surface.make_rect
      text_bounds.topleft = [8, 8 + index * 12]

      text_surface.blit self, text_bounds
    end
  end
end
