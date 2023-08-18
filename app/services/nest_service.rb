class NestService
  def draw_map(nest:)
    nest_objects = nest.nest_objects
    return nil if nest_objects.empty?

    nest_run = nest.nest_run
    material = nest_run.material
    scale = 10
    material_type = material.material_type

    case material_type
    when 'length'
      # the nest
      nest_svg = Rasem::SVGImage.new(
        width: nest.length.to_f * scale, height: 4 * scale,
        viewBox: "0 0 #{nest.length.to_f * scale} #{4 * scale}"
      )
      # the material background
      nest_svg.rectangle(
        0, 0, nest.length.to_f * scale, 4 * scale, fill: '#e9e9e9'
      )
    when 'area'
      # the nest
      nest_svg = Rasem::SVGImage.new(
        width: material.width * scale, height: material.height * scale,
        viewBox: "0 0 #{material.width * scale} #{material.height * scale}"
      )
      # the material background
      nest_svg.rectangle(
        0, 0, material.width * scale, material.height * scale, fill: '#f9f9f9'
      )
    end

    # each nest_object
    nest_objects.each do |nest_obj|
      nest_svg = nest_obj.draw_service.draw_map(
        scale: scale, nest_svg: nest_svg
      )
    end # end each nest object
    #
    # output
    #
    nest_svg
  end

  def draw(nest:)
    #
    # drawing
    #

    nest_objects = nest.nest_objects
    return nil if nest_objects.empty?

    nest_run = nest.nest_run
    material = nest_run.material
    scale = 72

    # the nest
    nest_svg = Rasem::SVGImage.new(
      width: material.width * scale, height: material.height * scale,
      viewBox: "0 0 #{material.width * scale} #{material.height * scale}"
    )

    scores_group = Rasem::SVGTag.new('g', id: 'scores')
    holes_group = Rasem::SVGTag.new('g', id: 'holes')
    cuts_group = Rasem::SVGTag.new('g', id: 'cuts')

    nest_objects.each do |nest_obj|
      #
      # exterior cut group
      #

      cuts_ext = nest_obj.draw_service.draw_body(
        nest_svg: nest_svg, scale: scale
      )
      cuts_group.append_child cuts_ext if cuts_ext

      #
      # non-exterior cut group
      #
      cuts_int = nest_obj.draw_service.draw_cuts(
        nest_svg: nest_svg, scale: scale
      )
      cuts_group.append_child cuts_int if cuts_int

      #
      # score group
      #

      scores = nest_obj.draw_service.draw_scores(
        nest_svg: nest_svg, scale: scale
      )
      scores_group.append_child scores if scores

      #
      # holes group
      #

      holes = nest_obj.draw_service.draw_holes(
        nest_svg: nest_svg, scale: scale
      )
      holes_group.append_child holes if holes
    end

    nest_svg.append_child scores_group
    nest_svg.append_child holes_group
    nest_svg.append_child cuts_group

    #
    # output
    #
    nest_svg
  end
end
