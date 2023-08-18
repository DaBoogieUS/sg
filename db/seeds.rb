if Rails.env.test?
  Material.destroy_all
  PanelModel.destroy_all
  PartType.destroy_all
end

Material.create!(
  [
    {
      name: 'HDPE', width: '96.0', height: '48.0',
      material_type: 'area', cut_spacing: '0.25', length_options: []
    },
    {
      name: 'L Channel PVC', width: '96.0', height: '96.0',
      material_type: 'length', cut_spacing: '0.125', length_options: ['96']
    },
    {
      name: 'Square Tube PVC', width: '96.0', height: '96.0',
      material_type: 'length', cut_spacing: '0.125', length_options: ['96']
    },
    {
      name: 'U Channel PVC', width: '96.0', height: '96.0',
      material_type: 'length', cut_spacing: '0.125', length_options: ['96']
    },
    {
      name: '2⨉4 Lumber', width: '96.0', height: '96.0',
      material_type: 'length', cut_spacing: '0.125', length_options: %w(96 120 144)
    }
  ]
)
PanelModel.create!(
  [
    {
      name: 'Standard Panel v1',
      description: '',
      panel_model_image_file_name: 'structure_guides_standard.png',
      panel_model_image_content_type: 'image/png',
      panel_model_image_file_size: 81116,
      panel_model_image_updated_at: '2013-12-11 19:48:27'
    },
    {
      name: 'Removable Door v1',
      description: '',
      panel_model_image_file_name: 'structure_guides_removable.png',
      panel_model_image_content_type: 'image/png',
      panel_model_image_file_size: 119060,
      panel_model_image_updated_at: '2013-12-11 19:48:29'
    },
    {
      name: 'Dropdown Full Door v1',
      description: '',
      panel_model_image_file_name: 'structure_guides_full_width.png',
      panel_model_image_content_type: 'image/png',
      panel_model_image_file_size: 82726,
      panel_model_image_updated_at: '2013-12-11 19:48:31'
    },
    {
      name: 'Dropdown Inset Door v1',
      description: '',
      panel_model_image_file_name: 'structure_guides_full_inset.png',
      panel_model_image_content_type: 'image/png',
      panel_model_image_file_size: 126865,
      panel_model_image_updated_at: '2013-12-11 19:48:32'
    },
    {
      name: 'Dropdown Left Door v1',
      description: '',
      panel_model_image_file_name: 'structure_guides_flush_left.png',
      panel_model_image_content_type: 'image/png',
      panel_model_image_file_size: 91479,
      panel_model_image_updated_at: '2013-12-11 19:48:34'
    },
    {
      name: 'Dropdown Right Door v1',
      description: '',
      panel_model_image_file_name: 'structure_guides_flush_right.png',
      panel_model_image_content_type: 'image/png',
      panel_model_image_file_size: 91053,
      panel_model_image_updated_at: '2013-12-11 19:48:35'
    }
  ]
)


Material.find_by(name: 'HDPE').part_types.create!(
  [
    {
      name: 'Standard Surface',
      description: 'Occurs on Standard panels.',
      image: '', version: 1, nestable: true,
      part_type_image_file_name: 'structure_guides_standard_surface.png',
      part_type_image_content_type: 'image/png',
      part_type_image_file_size: 61466,
      part_type_image_updated_at: '2013-12-11 19:55:49'
    },
    {
      name: 'Dropdown Full Surface',
      description: 'Occurs on Dropdown Full panels.',
      image: '', version: 1, nestable: true,
      part_type_image_file_name: 'structure_guides_full_width_surface.png',
      part_type_image_content_type: 'image/png',
      part_type_image_file_size: 63317,
      part_type_image_updated_at: '2013-12-11 19:55:50'
    },
    {
      name: 'Dropdown Inset Surface',
      description: 'Occurs on Dropdown Inset panels.',
      image: '', version: 1, nestable: true,
      part_type_image_file_name: 'structure_guides_full_inset_surface.png',
      part_type_image_content_type: 'image/png',
      part_type_image_file_size: 95947,
      part_type_image_updated_at: '2013-12-11 19:55:51'
    },
    {
      name: 'Dropdown Left Surface',
      description: 'Occurs on Dropdown Left panels.',
      image: '', version: 1, nestable: true,
      part_type_image_file_name: 'structure_guides_flush_left_surface.png',
      part_type_image_content_type: 'image/png',
      part_type_image_file_size: 72721,
      part_type_image_updated_at: '2013-12-11 19:55:53'
    },
    {
      name: 'Dropdown Right Surface',
      description: 'Occurs on Dropdown Right panels.',
      image: '', version: 1, nestable: true,
      part_type_image_file_name: 'structure_guides_flush_right_surface.png',
      part_type_image_content_type: 'image/png',
      part_type_image_file_size: 70696,
      part_type_image_updated_at: '2013-12-11 19:55:54'
    },
    {
      name: 'Removable Surface Left',
      description: 'Occurs on Removable Left panels.',
      image: '', version: 1, nestable: true,
      part_type_image_file_name: 'structure_guides_removable_left_surface.png',
      part_type_image_content_type: 'image/png',
      part_type_image_file_size: 58772,
      part_type_image_updated_at: '2013-12-11 19:55:55'
    },
    {
      name: 'Removable Surface Right',
      description: 'Occurs on Removable Right panels.',
      image: '', version: 1, nestable: true,
      part_type_image_file_name: 'structure_guides_removable_right_surface.png',
      part_type_image_content_type: 'image/png',
      part_type_image_file_size: 58818,
      part_type_image_updated_at: '2013-12-11 19:55:56'
    },
    {
      name: 'Deflector',
      description: 'Occurs on Standard and Drodown Full panels.',
      image: '', version: 1, nestable: true,
      part_type_image_file_name: 'structure_guides_deflector.png',
      part_type_image_content_type: 'image/png',
      part_type_image_file_size: 14475,
      part_type_image_updated_at: '2013-12-11 19:55:47'
    },
    {
      name: 'Deflector Left',
      description: 'Occurs on Removable, Dropdown Left, Dropdown Right, and Drodown Inset panels.',
      image: '', version: 1, nestable: true,
      part_type_image_file_name: 'structure_guides_deflector_left.png',
      part_type_image_content_type: 'image/png',
      part_type_image_file_size: 12857,
      part_type_image_updated_at: '2013-12-11 19:55:48'
    },
    {
      name: 'Deflector Right',
      description: 'Occurs on Removable, Dropdown Left, Dropdown Right, and Drodown Inset panels',
      image: '', version: 1, nestable: true,
      part_type_image_file_name: 'structure_guides_deflector_right.png',
      part_type_image_content_type: 'image/png',
      part_type_image_file_size: 12767,
      part_type_image_updated_at: '2013-12-11 19:55:48'
    },
    {
      name: 'Deflector Bare',
      description: 'Occurs on Drodown Inset panels.',
      image: '', version: 1, nestable: true,
      part_type_image_file_name: 'structure_guides_deflector_bare.png',
      part_type_image_content_type: 'image/png',
      part_type_image_file_size: 10833,
      part_type_image_updated_at: '2013-12-11 19:55:48'
    }
  ]
)

Material.find_by(name: 'L Channel PVC').part_types.create!(
  [
    {
      name: 'Standard Top',
      description: 'The standard top part for a panel. Inward 45 degree slanted cuts on both the left and right top sides. Length is the full width of the panel.  On the top side, the hole pattern is 2\' inset from left to center and 2\' inset from right to center. On the sheet side, hole pattern is left to right with a 1/2\' inset.',
      image: '', version: 1, nestable: true
    },
    {
      name: 'Standard Bottom',
      description: 'Standard bottom for a panel. Length is width of panel minus an inch on either side. Sheet side, the hole pattern is right to left with 1/2\' inset. Bottom side is right to left with 1/2\' inset.',
      image: '', version: 1, nestable: true
    },
    {
      name: 'Standard Left Side',
      description: 'Standard left side for a panel. Length is the panel height minus one inch off the top. Hole pattern is bottom to top with 1/2\' inset on sheet side and 3/4\' inset on non sheet side.',
      image: '', version: 1, nestable: true
    },
    {
      name: 'Removable Top Left',
      description: 'The top part for the removable panel\'s left half. Length is half of the width of the panel (or full width of the half panel). On the top side, the hole pattern is 2\' inset from left to right with a 45 degree inward slanted cut on left side. On the sheet side, hole pattern is left to right with a 1/2\' inset.',
      image: '', version: 1, nestable: true
    },
    {
      name: 'Removable Top Right',
      description: 'The top part for the removable panel\'s right half. Length is half of the width of the panel (or full width of the half panel). On the top side, the hole pattern is 2\' inset from left to right with a 45 degree inward slanted cut on right side. On the sheet side, hole pattern is left to right with a 1/2\' inset.',
      image: '', version: 1, nestable: true
    },
    {
      name: 'Removable Inner Side',
      description: 'The inner vertical sides for a removable panel. Length is the height of the panel minus 3\' to account for the top part of the half panel and the bottom 2\' tall U Channel. On the sheet side, the hole pattern is 1/2\' inset from bottom to top.',
      image: '', version: 1, nestable: true
    },
    {
      name: 'Dropdown Door Top',
      description: 'The top part for a dropdown door. Length varies depending on the door\'s left inset. If the door width is the full panel width, this piece\'s length is the door width. If the door is flush with either the left or right side of the panel, this piece\'s length is the door width plus 1\'. If the door is fully inset on either side of the panel, this piece\'s length is the door width plus 2\'. On the top side, the hole pattern runs left to right with a 1/2\' inset. on the sheet side, the hole pattern runs left to right with a 1 1/2\' inset to account for a 1\' square cut off on either side.',
      image: '', version: 1, nestable: true
    },
    {
      name: 'Dropdown Door Side',
      description: 'The inner verticals on either side of a dropdown door. Length is the door height minus 1\'. It is positioned flush with the bottom of the door. Hole pattern is bottom to top with a 1/2\' inset.',
      image: '', version: 1, nestable: true
    },
    {
      name: 'Dropdown Door Bottom',
      description: 'The bottom part for a dropdown door. Length varies depending on the door\'s left inset. If the door width is the full panel width, this piece\'s length is the door width minus 4\'. If the door is flush with either the left or right side of the panel, this piece\'s length is the door width minus 3\'. If the door is fully inset on either side of the panel, this piece\'s length is the door width minus 2\'. On the sheet side, the hole pattern runs right to left with a 1/2\' inset.',
      image: '', version: 1, nestable: true
    },
    {
      name: 'Dropdown Top Left',
      description: 'The top left part for a dropdown panel. This part only exists when the door is inset from the left. Length is the door left inset minus 1\' to account for the vertical support on the left side of the door. On the top side, the hole pattern is 2\' inset from left to right with a 45 degree inward slanted cut on left side. On the sheet side, hole pattern is left to right with a 1/2\' inset.',
      image: '', version: 1, nestable: true
    },
    {
      name: 'Dropdown Top Right',
      description: 'The top right part for a dropdown panel. This part only exists when the door is inset from the right. Length is the width of the panel minus the door left inset, minus the door width, minus 1\' to account for the vertical support on the right side of the door. On the top side, the hole pattern is 2\' inset from left to right with a 45 degree inward slanted cut on right side. On the sheet side, hole pattern is left to right with a 1/2\' inset.',
      image: '', version: 1, nestable: true
    }
  ]
)

Material.find_by(name: 'Square Tube PVC').part_types.create!(
  [
    {
      name: 'Removable Runner',
      description: 'The bottom runner for each of the removable panel\'s halves. Length is half of the width of the panel (or full width of the half panel) minus two inches to account for the vertical sides of the half panel. This piece is drilled into either the concrete or wooden base.',
      image: '', version: 1, nestable: true
    },

    {
      name: 'Dropdown Horizontal Support',
      description: 'The horizontal support for a dropdown door. Length is the width of the panel minus 2\' to account for the vertical sides of the panel. If the door is inset, this piece gets 1\' notches to butt up with each Vertical Support. The position of the notches vary based on the placement of the door. The hole pattern on the sheet side is right to left with a 1/2\' inset.',
      image: '', version: 1, nestable: true
    },
    {
      name: 'Dropdown Vertical Support',
      description: 'The vertical support part for a dropdown panel. This part only exists when the door is inset from a side. Length is the height of the panel minus 1/4\' to account for it sitting on top of the 1/8\' thickness of the bottom part and nesting under 1/8\' thickness of the door\'s top piece. This piece has a 1\' notch that butts up to the horizontal support. The hole pattern is bottom to top with a 1/2\' inset.',
      image: '', version: 1, nestable: true
    },
    {
      name: 'Dropdown Vertical Support Side Left',
      description: 'The vertical support part for a dropdown panel when it is on the left side of a panel. This part only exists when the door is flush with the left side. Length is the height of the panel minus 1/8\' to account for it nesting under 1/8\' thickness of the door\'s top piece. The sheet side hole pattern is bottom to top minus door height. This is so that the door can be free of the support and open. The hole pattern on the sheet side has a 1/2\' inset. The hole pattern on the non-sheet side is bottom to top with a 3/4\' inset.',
      image: '', version: 1, nestable: true
    },
    {
      name: 'Dropdown Vertical Support Side Right',
      description: 'The vertical support part for a dropdown panel when it is on the right side of a panel. This part only exists when the door is flush with the right side. Length is the height of the panel minus 1/8\' to account for it nesting under 1/8\' thickness of the door\'s top piece. The sheet side hole pattern is bottom to top minus door height. This is so that the door can be free of the support and open. The hole pattern on the sheet side has a 3/4\' inset. The hole pattern on the non-sheet side is bottom to top with a 1/2\' inset.',
      image: '', version: 1, nestable: true
    }
  ]
)

Material.find_by(name: 'U Channel PVC').part_types.create!(
  [
    {
      name: 'Removable Bottom',
      description: 'The bottom part for each of the removable panel\'s halves. Length is half of the width of the panel (or full width of the half panel) minus 1\' to account for the out side of the half panel. On the sheet side, the hole pattern is 1/2\' inset from right to left.',
      image: '', version: 1, nestable: true
    }
  ]
)

Material.find_by(name: '2⨉4 Lumber').part_types.create!(
  [
    {
      name: 'Offset Buried 2⨉4',
      description: 'A buried 2⨉4 piece for a buried panel when a neighboring side of the panel is also buried. This piece\'s length is the width of the panel. This piece is then offset 3 1/2.\' longways and screwed together with it\'s partner piece (either the same type or a Full Buried 2⨉4).',
      image: '', version: 1, nestable: true
    },
    {
      name: 'Full Buried 2⨉4',
      description: 'A buried 2⨉4 piece for a buried panel when a neighboring side of the panel is not buried. This piece\'s length is the width of the panel plus 3 1/2\'. This piece is then flush longways and screwed together with it\'s partner piece (either the same type or an Offset Buried 2⨉4).',
      image: '', version: 1, nestable: true
    }
  ]
)