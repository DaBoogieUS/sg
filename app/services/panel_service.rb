class PanelService
  attr_accessor :panel

  def initialize(panel:)
    @panel = panel
  end

  def position_panels
    # for each panel in structure
    panels = panel.structure.panels
    # current panel position
    panel_position = panel.side_position
    # detect if same position
    same_position = panel.structure.panels
                         .where(side_position: panel_position)
                         .where.not(id: panel.id).first

    return unless same_position
    positions = panels.map(&:side_position)
    positions.sort
    i = 0
    while i < positions.length
      new_position = i + 1 if positions[i] != i + 1
      i += 1
    end
    # update same position's position to new position
    same_position.update_attribute(:side_position, new_position)
  end

  def generate_sides
    # side part types
    std_left_side = PartType.where(name: 'Standard Left Side', version: 1).last.id

    # for each panel in structure
    panels = panel.structure.panels
    # panel count
    panel_count = panels.length

    # maybe this helps?
    # at least it reduces the load when multiple panels created at once
    if panel_count >= 4

      # each panel
      panels.each do |panel|
        # get the panel model name
        panel_model = panel.panel_model.name

        # get the panel's position
        panel_position = panel.side_position
        # get the panel's left neighbor's position
        # the panel's left neighbor's position is last
        # the panel's left neighbor's position is previous
        neighbor_position = panel_position == 1 ? panel_count : panel_position.to_i - 1

        # get the panel's left neighbor
        panel_neighbor = panels.find_by(side_position: neighbor_position)

        # if panel has a neighbor
        unless panel_neighbor.nil?
          # get the panel's left neighbor model name
          panel_neighbor_model = panel_neighbor.panel_model.name
        end

        # adding standard sides
        standard_names = [
          'Standard Panel v1', 'Dropdown Inset Door v1',
          'Removable Door v1', 'Dropdown Right Door v1'
        ]
        next unless standard_names.include? panel_model
        # remove existing standard side
        exist_std_side = panel.parts.find_by(part_type_id: std_left_side)
        exist_std_side.destroy if exist_std_side

        # check panel left neighbor for type
        next if ['Dropdown Full Door v1', 'Dropdown Right Door v1'].include? panel_neighbor_model
        # add a standard left side
        panel.parts.create(
          part_type_id: std_left_side, panel_id: panel.id, length: (panel.height - 1)
        )
      end # end each panel
    end # end if panel count >= 4
  end

  def generate_buried
    offset_buried = PartType.where(name: 'Offset Buried 2⨉4', version: 1).last.id
    full_buried = PartType.where(name: 'Full Buried 2⨉4', version: 1).last.id

    # for each panel in structure
    structure = panel.structure
    panels = structure.panels
    # panel count
    panel_count = panels.length

    # maybe this helps?
    # at least it reduces the load when multiple panels created at once
    if panel_count < 4
      # each panel
      panels.each do |p|
        p.parts.where(part_type_id: offset_buried).destroy_all
        p.parts.where(part_type_id: full_buried).destroy_all
      end
      return
    end

    # each panel
    panels.each do |p|
      p.parts.where(part_type_id: offset_buried).destroy_all
      p.parts.where(part_type_id: full_buried).destroy_all
      # buried
      next unless p.buried

      # get the panel's position
      panel_position = p.side_position
      # panel count
      panel_count = p.structure.panels.length

      # get the panel's left neighbor's position
      if panel_position == 1
        # the panel's left neighbor's position is last
        neighbor_left_position = panel_count
        # the panel's right neighbor's position is next
        neighbor_right_position = panel_position.to_i + 1

      elsif panel_position == panel_count
        # the panel's left neighbor's position is previous
        neighbor_left_position = panel_position.to_i - 1
        # the panel's right neighbor's position is first
        neighbor_right_position = 1

      else
        # the panel's left neighbor's position is previous
        neighbor_left_position = panel_position.to_i - 1
        # the panel's right neighbor's position is next
        neighbor_right_position = panel_position.to_i + 1
      end

      # get the panel's left neighbor
      panel_left_neighbor = panels.find_by(side_position: neighbor_left_position)
      # get the panel's left neighbor
      panel_right_neighbor = panels.find_by(side_position: neighbor_right_position)

      if panel_left_neighbor && panel_left_neighbor.buried
        # offset buried 2x4 (width)
        p.parts.create(part_type_id: offset_buried, length: p.width)
      else
        # full buried 2x4 (width + 3.5)
        p.parts.create(part_type_id: full_buried, length: (p.width + 3.5))
      end
      if panel_right_neighbor && panel_right_neighbor.buried
        # offset buried 2x4 (width)
        p.parts.create(part_type_id: offset_buried, length: p.width)
      else
        # full buried 2x4 (width + 3.5)
        p.parts.create(part_type_id: full_buried, length: (p.width + 3.5))
      end
    end # each panel
  end

  def create_new_parts
    # parts mapping name to id
    pt = PartType.where(version: 1)
    # lengths
    std_top                         = pt.find_by(name: 'Standard Top').id
    std_bottom                      = pt.find_by(name: 'Standard Bottom').id
    rem_top_left                    = pt.find_by(name: 'Removable Top Left').id
    rem_top_right                   = pt.find_by(name: 'Removable Top Right').id
    rem_bottom                      = pt.find_by(name: 'Removable Bottom').id
    rem_runner                      = pt.find_by(name: 'Removable Runner').id
    rem_inner_side                  = pt.find_by(name: 'Removable Inner Side').id
    drp_door_top                    = pt.find_by(name: 'Dropdown Door Top').id
    drp_door_side                   = pt.find_by(name: 'Dropdown Door Side').id
    drp_door_bottom                 = pt.find_by(name: 'Dropdown Door Bottom').id
    drp_top_left                    = pt.find_by(name: 'Dropdown Top Left').id
    drp_top_right                   = pt.find_by(name: 'Dropdown Top Right').id
    drp_horizontal_support          = pt.find_by(name: 'Dropdown Horizontal Support').id
    drp_vertical_support            = pt.find_by(name: 'Dropdown Vertical Support').id
    drp_vertical_support_side_left  = pt.find_by(name: 'Dropdown Vertical Support Side Left').id
    drp_vertical_support_side_right = pt.find_by(name: 'Dropdown Vertical Support Side Right').id
    # areas
    deflector         = pt.find_by(name: 'Deflector').id
    deflector_left    = pt.find_by(name: 'Deflector Left').id
    deflector_right   = pt.find_by(name: 'Deflector Right').id
    deflector_bare    = pt.find_by(name: 'Deflector Bare').id
    std_surface       = pt.find_by(name: 'Standard Surface').id
    drp_full_surface  = pt.find_by(name: 'Dropdown Full Surface').id
    drp_inset_surface = pt.find_by(name: 'Dropdown Inset Surface').id
    drp_left_surface  = pt.find_by(name: 'Dropdown Left Surface').id
    drp_right_surface = pt.find_by(name: 'Dropdown Right Surface').id
    rem_surface_left  = pt.find_by(name: 'Removable Surface Left').id
    rem_surface_right = pt.find_by(name: 'Removable Surface Right').id
    # variables
    deflector_height = 11

    # get the panel model name
    panel_model = panel.panel_model.name

    standard_panel = panel_model == 'Standard Panel v1'
    dropdown_full_panel = panel_model == 'Dropdown Full Door v1'
    dropdown_left_or_right_panel =  ['Dropdown Left Door v1', 'Dropdown Right Door v1']
                                    .include? panel_model
    dropdown_inset_panel = panel_model == 'Dropdown Inset Door v1'
    dropdown_panel = dropdown_full_panel || dropdown_left_or_right_panel || dropdown_inset_panel
    removable_panel = panel_model == 'Removable Door v1'

    width = panel.width
    height = panel.height
    door_height = panel.door_height
    door_width = panel.door_width
    door_inset_left = panel.door_inset_left

    # create standard panel parts
    if standard_panel

      # standard top (width)
      panel.parts.create(part_type_id: std_top, length: width)
      # standard bottom (width - 2")
      panel.parts.create(part_type_id: std_bottom, length: width - 2)
      # standard surface (width and height)
      panel.parts.create(part_type_id: std_surface, height: height, width: width)
      # standard deflector (width and 11")
      return unless panel.deflector
      panel.parts.create(part_type_id: deflector, height: deflector_height, width: width)

    # create dropdown door parts
    elsif dropdown_panel
      # dropdown door sides (door height - 1")
      panel.parts.create(part_type_id: drp_door_side, length: door_height - 1)
      panel.parts.create(part_type_id: drp_door_side, length: door_height - 1)
      # dropdown door horizontal support (panel width - 2")
      panel.parts.create(part_type_id: drp_horizontal_support, length: width - 2)

      # dropdown full door parts
      if dropdown_full_panel
        # dropdown door top (door width)
        panel.parts.create(part_type_id: drp_door_top, length: door_width)
        # dropdown door bottom (door width - 4")
        panel.parts.create(part_type_id: drp_door_bottom, length: door_width - 4)

        # dropdown full surface (width and height)
        panel.parts.create(part_type_id: drp_full_surface, height: height, width: width)

        # dropdown vertical support side left (height - 0.125")
        panel.parts.create(part_type_id: drp_vertical_support_side_left, length: height - 0.125)
        # dropdown vertical support side right (height - 0.125")
        panel.parts.create(part_type_id: drp_vertical_support_side_right, length: height - 0.125)

        # bare deflector (width and 11")
        return unless panel.deflector
        panel.parts.create(part_type_id: deflector_bare, height: deflector_height, width: width)

      # dropdown inset door parts
      elsif dropdown_inset_panel
        # dropdown top left (door inset - 1")
        panel.parts.create(part_type_id: drp_top_left, length: door_inset_left - 1)
        # dropdown door top (door width + 2")
        panel.parts.create(part_type_id: drp_door_top, length: door_width + 2)
        # dropdown top right (width - door width - door inset - 1")
        panel.parts.create(
          part_type_id: drp_top_right, length: width - door_width - door_inset_left - 1
        )

        # dropdown door bottom (door width - 2")
        panel.parts.create(part_type_id: drp_door_bottom, length: door_width - 2)

        # dropdown vertical supports (height - 0.25")
        panel.parts.create(part_type_id: drp_vertical_support, length: height - 0.25)
        panel.parts.create(part_type_id: drp_vertical_support, length: height - 0.25)

        # dropdown inset surface (width and height)
        panel.parts.create(part_type_id: drp_inset_surface, height: height, width: width)

        return unless deflector
        # left deflector (door_inset - 1" and 11")
        panel.parts.create(
          part_type_id: deflector_left,
          height: deflector_height, width: door_inset_left - 1
        )
        # bare middle deflector (door_width + 2" and 11")
        panel.parts.create(
          part_type_id: deflector_bare,
          height: deflector_height, width: door_width + 2
        )
        # right deflector (width - (door_inset + door_width) - 1" and 11")
        panel.parts.create(
          part_type_id: deflector_right,
          height: deflector_height, width: width - (door_inset_left + door_width) - 1
        )

      # dropdown left door parts
      elsif dropdown_left_or_right_panel
        # dropdown door top (door width + 1")
        panel.parts.create(part_type_id: drp_door_top, length: door_width + 1)
        # dropdown door bottom (door width - 3")
        panel.parts.create(part_type_id: drp_door_bottom, length: door_width - 2)
        # dropdown vertical support (height - 0.25")
        panel.parts.create(part_type_id: drp_vertical_support, length: height - 0.25)

        # left door only
        if panel_model == 'Dropdown Left Door v1'
          # dropdown top right (width - door width - 1")
          panel.parts.create(part_type_id: drp_top_right, length: width - door_width - 1)
          # dropdown vertical support side left (height - 0.125")
          panel.parts.create(part_type_id: drp_vertical_support_side_left, length: height - 0.125)
          # dropdown left surface (width and height)
          panel.parts.create(part_type_id: drp_left_surface, height: height, width: width)

          return unless deflector
          # left deflector (door_width + 1" and 11")
          panel.parts.create(
            part_type_id: deflector_left, height: deflector_height, width: door_width + 1
          )
          # right deflector (width - (door_width + 1) and 11")
          panel.parts.create(
            part_type_id: deflector_right, height: deflector_height,
            width: width - (door_width + 1)
          )

        # right door only
        else
          # dropdown top left (door inset left - 1")
          panel.parts.create(part_type_id: drp_top_left, length: door_inset_left - 1)
          # dropdown vertical support side right (height - 0.125")
          panel.parts.create(part_type_id: drp_vertical_support_side_right, length: height - 0.125)
          # dropdown right surface (width and height)
          panel.parts.create(part_type_id: drp_right_surface, height: height, width: width)

          return unless deflector
          # left deflector (door_inset - 1" and 11")
          panel.parts.create(
            part_type_id: deflector_left, height: deflector_height, width: door_inset_left - 1
          )
          # right deflector (door_width + 1 and 11")
          panel.parts.create(
            part_type_id: deflector_right, height: deflector_height, width: door_width + 1
          )
        end

      end # dropdown panels

    # create removable door parts
    elsif removable_panel
      # removable top left (width / 2)
      panel.parts.create(part_type_id: rem_top_left, length: width / 2)
      # removable top right (width / 2)
      panel.parts.create(part_type_id: rem_top_right, length: width / 2)

      # removable bottoms ((width / 2) - 1")
      panel.parts.create(part_type_id: rem_bottom, length: ((width / 2) - 1))
      panel.parts.create(part_type_id: rem_bottom, length: ((width / 2) - 1))

      # removable runner (width - 2")
      panel.parts.create(part_type_id: rem_runner, length: width - 2)

      # removable inner sides (height - 3")
      panel.parts.create(part_type_id: rem_inner_side, length: height - 3)
      panel.parts.create(part_type_id: rem_inner_side, length: height - 3)

      # removable surface left (width / 2 and height)
      panel.parts.create(part_type_id: rem_surface_left, height: height, width: width / 2)

      # removable surface right (width / 2 and height)
      panel.parts.create(part_type_id: rem_surface_right, height: height, width: width / 2)

      return unless deflector
      # left deflector (width / 2 and 11")
      panel.parts.create(
        part_type_id: deflector_left, height: deflector_height, width: width / 2
      )
      # right deflector (width / 2 and 11")
      panel.parts.create(
        part_type_id: deflector_right, height: deflector_height, width: width / 2
      )
    end # end panel type checks
  end
end
