class NestRunService
  def create(manufacturing_job:, parts:)
    # set up materials array
    materials = []
    # get unique materials from parts
    parts.each do |part|
      # if part is manufactured, change is_manufactured to false
      if part.is_manufactured
        part.update_attributes(is_manufactured: false)
        part.panel.update_attributes(is_manufactured: false) if part.panel.is_manufactured
      end
      # if materials already includes material or material type is 'count'
      # do absolutely nothing
      next if materials.include?(part.material) || part.material.material_type == 'count'
      # if materials doesn't include material and material type isn't count
      # push material to materials
      materials << part.material
    end
    # for each unique materials
    materials.each do |material|
      # create a nest run for that material
      manufacturing_job.nest_runs.create!(material_id: material.id)
    end
  end

  def build_nests(nest_run:)
    material = nest_run.material
    material_type = material.material_type
    mfg_job_id = nest_run.manufacturing_job_id
    case material_type
    when 'length'
      # find this material's parts where part's manufacturing job
      #   is this manufacturing job ordered by LENGTH
      parts = material.parts.joins(:manufacturing_jobs)
                      .where('manufacturing_jobs.id' => mfg_job_id)
                      .order('length DESC')
                      .to_a
      return length_nests(nest_run: nest_run, material: material, parts: parts)
    when 'area'
      # find this material's parts where part's manufacturing job is this
      #   manufacturing job ordered by WIDTH
      parts = material.parts.joins(:manufacturing_jobs)
                      .where('manufacturing_jobs.id' => mfg_job_id)
                      .to_a
      return area_nests(nest_run: nest_run, material: material, parts: parts)
    end
  end

  private

  # get smallest width TODO: gotta be a better way to do this
  def get_smallest_width(array)
    smallest = 1000
    array.each do |part|
      smallest = part.width if part && part.width < smallest
    end
    smallest.to_f
  end

  # get smallest height TODO: gotta be a better way to do this
  def get_smallest_height(array)
    smallest = 100
    array.each do |part|
      smallest = part.height if part && part.height < smallest
    end
    smallest.to_f
  end

  def length_nests(nest_run:, material:, parts:)
    # define blade/bit spacing between parts
    spacing = material.cut_spacing
    # available array
    available = parts
    # track parts left
    parts_left = available.length

    # while "available" array has objects
    while parts_left > 0
      # set material lengths
      material_lengths = material.length_options.to_a

      best_length = 0
      best_length_waste = 144

      # getting best length to use
      material_lengths.each do |material_length|
        test_length = material_length.to_f
        # for each available part
        available.each do |part|
          # if part is not nil
          # if part length is less than material_length
          if part && part.length.to_f <= test_length
            # subtract part length + spacing from length
            test_length -= part.length.to_f + spacing.to_f
          end # end if not nil

          if test_length <= best_length_waste
            best_length_waste = test_length
            best_length = material_length.to_i
          end
        end # end for each available part
      end # for each material_length

      # create nest for nest run
      nest = nest_run.nests.create(length: best_length)
      # set initial x & y
      x = y = 0

      # for each available part
      available.each_with_index do |part, index|
        # if part is not nil
        # if part length is less than material_length
        next unless part && part.length.to_f <= best_length
        # create new nest object with current x & y
        nest.nest_objects.create(part_id: part.id, x: x, y: y)
        # subtract part length + spacing from length
        best_length -= part.length.to_f + spacing.to_f
        # set new x & y + spacing only x changed
        x = x.to_f + part.length.to_f + spacing.to_f
        # remove part from "available" array
        available[index] = nil
        # subtract parts_left
        parts_left -= 1
      end # end for each available part

      #
      # draw svg for the nest here, not in the nest's after_create
      #

      nest.draw_svg
    end # end while "available" array has objects
  end

  def area_nests(nest_run:, material:, parts:)
    # define blade/bit spacing between parts
    spacing = material.cut_spacing
    # sort by area
    parts.sort! { |b, a| a.area <=> b.area }

    # available array
    available = parts
    # track parts left
    parts_left = available.length

    smallest_height = get_smallest_height(available)
    smallest_width = get_smallest_width(available)

    # while "available" array has objects
    while parts_left > 0

      # create nest for nest run
      nest = nest_run.nests.create
      # set initial x & y
      x = y = 0
      # set material width
      material_width = material.width.to_f
      # set material height
      material_height = material.height.to_f

      # for each available part
      available.each_with_index do |part, index|
        # if part is not nil
        next unless part
        # if part width is less than material_width && part height is less than material_height
        if part.width.to_f <= material_width && part.height.to_f <= material_height

          # create new nest object with current x & y
          nest.nest_objects.create(part_id: part.id, x: x, y: y)
          # update smallest dimensions when something gets used
          smallest_height = get_smallest_height(available)
          smallest_width = get_smallest_width(available)

          # subtract part width + spacing from width
          material_width -= part.width.to_f + spacing.to_f

          #
          # initiate a column
          #

          # set column width to part's width
          col_w = part.width.to_f
          # set remaining column height to material's height - (part's height + spacing)
          col_h = material_height - (part.height.to_f + spacing)
          # set col x and col y
          col_x = x
          col_y = y + part.height.to_f + spacing

          # set new x & y + spacing for next iteration
          x = x.to_f + part.width.to_f + spacing.to_f

          # remove part from "available" array
          available[index] = nil
          # subtract parts_left
          parts_left -= 1

          # no part fits
          no_part_fits = false

          #
          # create rows until remaining column height is less than smallest
          #   height or until no more objects
          #

          until col_h <= smallest_height.to_f || no_part_fits || available.count(nil) == available.length
            # for each available col_part
            available.each_with_index do |col_part, index_lvl_2|
              # if col_part is not nil
              next unless col_part

              # if col_part width is less than column width && col_part height
              #   is less than remaining column height
              if col_part.width.to_f <= col_w.to_f && col_part.height.to_f <= col_h.to_f
                # create new nest object with current x & y
                nest.nest_objects.create(part_id: col_part.id, x: col_x, y: col_y)

                # update smallest dimensions when something gets used
                smallest_height = get_smallest_height(available)
                smallest_width = get_smallest_width(available)

                #
                # do a row
                #

                # set row x and y
                row_x = col_x
                row_y = col_y
                # subtract col_part width plus spacing from row width
                row_w = col_w - (col_part.width + spacing)
                # set row height to col_part height
                row_h = col_part.height
                # add its width and spacing to row x
                row_x += (col_part.width + spacing)

                # update remaining column height to subtract (col_part's height + spacing)
                col_h -= (col_part.height + spacing)
                # update col_y to add (col_part's height + spacing)
                col_y += (col_part.height + spacing)

                # find any parts with same height as the col_part
                same_h = col_part.height

                # remove col_part from "available" array
                available[index_lvl_2] = nil
                # subtract parts_left
                parts_left -= 1

                # for each with same height
                available.each_with_index do |row_part, index_lvl_3|
                  # if the row part exists and its height is the same height as the col_part
                  # if row_part can fit in the row
                  next unless row_part && row_part.height == same_h && row_part.width < row_w
                  # create new nest object with current x & y
                  nest.nest_objects.create(part_id: row_part.id, x: row_x, y: row_y)
                  # update smallest dimensions when something gets used
                  smallest_height = get_smallest_height(available)
                  smallest_width = get_smallest_width(available)

                  # subtract its width from row width
                  row_w -= (row_part.width + spacing)
                  # add its width and spacing to row x
                  row_x += (row_part.width + spacing)

                  # remove row_part from "available" array
                  available[index_lvl_3] = nil
                  # subtract parts_left
                  parts_left -= 1
                end # end each row_part

                # detect if last column
                if material.width - row_x < smallest_width || available.count(nil) == available.length - 1
                  # detect if last row & last column
                  if material_height - (row_y + row_h) < smallest_height
                    # see if any part with same height fits in the remaining material width
                    available.each_with_index do |row_part, index_lvl_4|
                      next unless row_part && row_part.height == same_h && row_part.width < material.width.to_f - row_x
                      # create new nest object with current x & y
                      nest.nest_objects.create(part_id: row_part.id, x: row_x, y: row_y)
                      # update smallest dimensions when something gets used
                      smallest_height = get_smallest_height(available)
                      smallest_width = get_smallest_width(available)

                      # add row_part width and spacing to col x
                      col_x += row_part.width + spacing
                      # subtract its width from row width
                      row_w -= (row_part.width + spacing)
                      # add its width and spacing to row x
                      row_x += (row_part.width + spacing + 200)

                      # remove row_part from "available" array
                      available[index_lvl_4] = nil
                      # subtract parts_left
                      parts_left -= 1
                    end # end each row_part
                  end # end if last row and last column

                end # end if last column

              # col_part width can't fit, check for rotation
              # if col_part height is less than column width && col_part width
              #   is less than remaining column height
              elsif col_part.height.to_f <= col_w.to_f && col_part.width.to_f <= col_h.to_f

                # create new nest object with current x & y
                nest.nest_objects.create(part_id: col_part.id, x: col_x, y: col_y, rotated: true)
                # update smallest dimensions when something gets used
                smallest_height = get_smallest_height(available)
                smallest_width = get_smallest_width(available)

                #
                # do a row
                #

                # set row x and y
                row_x = col_x
                row_y = col_y
                # subtract col_part width plus spacing from row width
                row_w = col_w - (col_part.height + spacing)
                # set row height to col_part height
                row_h = col_part.width
                # add its width and spacing to row x
                row_x += (col_part.height + spacing)

                # update remaining column height to subtract (col_part's width + spacing)
                col_h -= (col_part.width + spacing)
                # update remaining column y to add (col_part's width + spacing)
                col_y += (col_part.width + spacing)

                # remove col_part from "available" array
                available[index_lvl_2] = nil
                # subtract parts_left
                parts_left -= 1

                # for each with same height
                available.each_with_index do |row_part, index_lvl_3|
                  next unless row_part && row_part.width < row_h && row_part.height < row_w
                  # create new nest object with current x & y
                  nest.nest_objects.create(part_id: row_part.id, x: row_x, y: row_y, rotated: true)
                  # update smallest dimensions when something gets used
                  smallest_height = get_smallest_height(available)
                  smallest_width = get_smallest_width(available)

                  # subtract its height from row width
                  row_w -= (row_part.height + spacing)
                  # add its height and spacing to row x
                  row_x += (row_part.height + spacing)

                  # remove row_part from "available" array
                  available[index_lvl_3] = nil
                  # subtract parts_left
                  parts_left -= 1
                end # end each row_part

                # for each with same height
                available.each_with_index do |row_part, index_lvl_3|
                  # if the row part exists and its height is the same height as the col_part
                  # if row_part can fit in the row
                  next unless row_part && row_part.width < row_w && row_part.height <= row_h
                  # create new nest object with current x & y
                  nest.nest_objects.create(part_id: row_part.id, x: row_x, y: row_y)
                  # update smallest dimensions when something gets used
                  smallest_height = get_smallest_height(available)
                  smallest_width = get_smallest_width(available)

                  # subtract its width from row width
                  row_w -= (row_part.width + spacing)
                  # add its width and spacing to row x
                  row_x += (row_part.width + spacing)

                  # remove row_part from "available" array
                  available[index_lvl_3] = nil
                  # subtract parts_left
                  parts_left -= 1
                end # end each row_part

              end # if usable
            end # other available parts
            # no part fits
            no_part_fits = true
          end # end until remaining height is less than smallest height or until no more objects

        # check for rotation
        # if part height is less than material_width && part width is less than material_height
        elsif part.height.to_f <= material_width && part.width.to_f <= material_height

          # create new nest object with current x & y
          nest.nest_objects.create(part_id: part.id, x: x, y: y, rotated: true)
          # update smallest dimensions when something gets used
          smallest_height = get_smallest_height(available)
          smallest_width = get_smallest_width(available)

          # subtract part height + spacing from width
          material_width -= part.height.to_f + spacing.to_f

          #
          # do a column
          #

          # set column width to part's height
          col_w = part.height.to_f
          # set remaining column height to material's width - (part's height + spacing)
          col_h = material_height - (part.width.to_f + spacing)
          # set col x and col y
          col_x = x
          col_y = y + part.width.to_f + spacing

          # set new x & y + spacing for next iteration
          x = x.to_f + part.height.to_f + spacing.to_f

          # remove col_part from "available" array
          available[index] = nil
          # subtract parts_left
          parts_left -= 1

          # no part fits
          no_part_fits = true

          quit_rotation_run = false
          # until remaining height is less than smallest width or until no more objects
          until col_h <= smallest_width.to_f || no_part_fits || available.count(nil) == available.length || quit_rotation_run
            # for each available col_part
            available.each_with_index do |col_part, index_lvl_2|
              # if col_part is not nil
              # if col_part height is less than column width && col_part width
              #   is less than remaining column height
              next unless col_part && col_part.height <= col_w && col_part.width <= col_h

              # create new nest object with current x & y
              nest.nest_objects.create(part_id: col_part.id, x: col_x, y: col_y, rotated: true)
              # update smallest dimensions when something gets used
              smallest_height = get_smallest_height(available)
              smallest_width = get_smallest_width(available)

              #
              # do a row
              #

              # set row x and y
              row_x = col_x
              row_y = col_y
              # subtract col_part height plus spacing from row width
              row_w = col_w - (col_part.height + spacing)
              # add its height and spacing to row x
              row_x += (col_part.height + spacing)

              # update remaining column height to subtract (col_part's width + spacing)
              col_h -= (col_part.width + spacing)
              # update row y to add (col_part's width + spacing)
              row_y += (col_part.width + spacing)

              # find any parts with same height
              same_h = col_part.height

              # remove col_part from "available" array
              available[index_lvl_2] = nil
              # subtract parts_left
              parts_left -= 1

              # for each with same height
              available.each_with_index do |row_part, index_lvl_3|
                next unless row_part && row_part.height == same_h && row_part.height < row_w
                # create new nest object with current x & y
                nest.nest_objects.create(part_id: col_part.id, x: row_x, y: row_y, rotated: true)
                # update smallest dimensions when something gets used
                smallest_height = get_smallest_height(available)
                smallest_width = get_smallest_width(available)

                # subtract its width from row width
                row_w -= (row_part.width + spacing)
                # add its width and spacing to row x
                row_x += (row_part.width + spacing)

                # remove row_part from "available" array
                available[index_lvl_3] = nil
                # subtract parts_left
                parts_left -= 1
              end # end each row_part

              quit_rotation_run = true
            end # other available parts
            # no part fits
            no_part_fits = true
          end # end until remaining height is less than smallest height or until no more objects

        end # end good part
      end # end for each available part

      #
      # do another loop here to see if rotated parts can fit in empty space
      #

      #
      # draw svg for the nest here, not in the nest's after_create
      #

      nest.draw_svg

    end # end while "available" array has objects
  end
end
