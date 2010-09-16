module HUD
  def draw_text_info(font, text)
    text_surface = font.render_utf8 text, false, default_color
    text_bounds = text_surface.make_rect
    text_bounds.topleft = [8, 8]

    text_surface.blit self, text_bounds
  end  
end
