module DrawNestObject
  class DrawMap < Base
    def length(nest_svg:, scale:)
      # get the part type
      part_type = part.part_type.name

      #
      # draw it
      #

      nest_x = nest_object.x * scale
      nest_y = 0
      width = part.length * scale
      height = 4 * scale
      sm_text_size = height / 3
      sm_text_y = nest_y + sm_text_size + (height / 3)
      # panel shape
      nest_svg.rectangle(nest_x, nest_y, width, height, fill: '#222', stroke: 'none')
      # panel name and letter
      panel_name = "#{panel.structure.name} #{panel.panel_letter}"
      nest_svg.text(nest_x + 4, sm_text_y, text_style(sm_text_size, 'left')) do
        raw panel_name
      end
      # part type
      if width > 30 * scale
        nest_svg.text(nest_x + (width / 2), sm_text_y, text_style(sm_text_size, 'middle')) do
          raw part_type
        end
      else
        nest_svg.text(
          nest_x + (width / 2), sm_text_y,
          text_style(sm_text_size, 'middle').merge(display: 'none')
        ) do
          raw part_type
        end
      end
      # part size
      part_size = "#{part.length}in"
      nest_svg.text(nest_x + width - 4, sm_text_y, text_style(sm_text_size, 'end')) do
        raw part_size
      end

      nest_svg
    end

    def area(nest_svg:, scale:)
      # get the part type
      part_type = part.part_type.name

      #
      # draw it
      #

      if nest_object.rotated
        nest_x = nest_object.x * scale
        nest_y = nest_object.y * scale
        height = part.width * scale
        width = part.height * scale
      else
        nest_x = nest_object.x * scale
        nest_y = nest_object.y * scale
        width = part.width * scale
        height = part.height * scale
      end

      text_size = scale
      text_center = nest_y + (height / 2)
      text_y_1 = text_center - (text_size / 2) - 2
      text_y_2 = text_center + (text_size / 2)
      text_y_3 = text_center + (text_size + (text_size / 2)) + 2

      # panel shape
      nest_svg.rectangle(nest_x, nest_y, width, height, fill: '#222', stroke: 'none')
      # panel name and letter
      panel_name = "#{panel.structure.name} #{panel.panel_letter}"
      nest_svg.text(nest_x + (width / 2), text_y_1, text_style(text_size, 'middle')) do
        raw panel_name
      end
      # part type
      if width > 10 * scale
        nest_svg.text(nest_x + (width / 2), text_y_2, text_style(text_size, 'middle')) do
          raw part_type
        end
      end
      # part size
      part_size = "#{part.width}in #{part.height}in"
      nest_svg.text(nest_x + (width / 2), text_y_3, text_style(text_size, 'middle')) do
        raw part_size
      end

      nest_svg
    end

    def text_style(size, anchor)
      {
        fill: 'white',
        'font-family' => 'Helvetica',
        'font-size' => "#{size}pt",
        'text-anchor' => anchor
      }
    end
  end
end
