(function ($) {
    $.fn.draw_sheet = function (sheet_objs, options) {

        // example sheet objs
        // var sheet_objs = [[[0,0,32,48,'standard'],[32.5,0,32,48,'standard']],[[0,0,32,48,'standard'],[32.5,0,32,48,'standard']];

        var default_vals = {
            h: 48, // sheet height
            w: 96, // sheet width
            bit: 0.25, // cutting bit diameter
            hole: 0.25, // hole size
            scale: 10, // default scale of rendering (%)
            image: false, // create an image
            view: 'all' // view ('all', 'cuts', 'holes', 'scores')
        };

        // hole variables
        var holes = {
            pn_l_in: 0.5, // panel left vertical inset
            pn_r_in: 0.75, // panel right vertical inset
            pn_sides_top: 1, // panel left and right sides distance from top
            pn_t_in: 1, // panel top side inset
            pn_b_in: 1.5, // panel bottom side inset
            df_t_in: 2, // deflector top side inset
            df_sides_top: 2, // deflector sides top inset
            df_line: 1, // deflector score y
            dd_in: 0.5, // dropdown pieces inset
            pvc: 1, // pvc size
            spacing: 4 // hole spacing
        };

        // master options, given opts override defaults
        var master = $.extend(default_vals, options);
        // pixel to inch scale
        var px_scale = 72 * (master.scale * 0.01);
        // padding in on the sheet
        var padding = 1 * px_scale;

        // converting default option values to scale
        default_vals.h *= px_scale;
        default_vals.w *= px_scale;
        default_vals.bit *= px_scale;
        default_vals.hole *= px_scale;
        holes.pn_l_in *= px_scale;
        holes.pn_r_in *= px_scale;
        holes.pn_sides_top *= px_scale;
        holes.pn_t_in *= px_scale;
        holes.pn_b_in *= px_scale;
        holes.dd_in *= px_scale;
        holes.pvc *= px_scale;
        holes.df_t_in *= px_scale;
        holes.df_sides_top *= px_scale;
        holes.df_line *= px_scale;
        holes.spacing *= px_scale;
        // converting overridden option values to scale
        if(options) {
            options.h *= px_scale;
            options.w *= px_scale;
            options.bit *= px_scale;
            options.hole *= px_scale;
        }


        return this.each(function () {
            var uid = '',
                canvas = '',
                canvas_dom = '',
                context = '',
                cs = '';
            // selecting this
            var sel_obj = $(this);

            function new_canvas() {
                // unique id for the sheet
                uid = 'sheet_'+Math.floor((Math.random()*100)*(Math.random()*100)*(Math.random()*100));
                // a canvas object for the sheet
                canvas = '<canvas id="'+uid+'" class="sheet" width="'+(master.w+(padding*2))+'" height="'+(master.h+(padding*2))+'"></canvas>';
                // append canvas to this
                sel_obj.append(canvas);
                // get dom-level element of canvas
                canvas_dom = $('#'+uid)[0];
                // create canvas context
                context = canvas_dom.getContext("2d");
                // redefine context based on padded sheet
                context.translate(padding,padding);
                // style constants
                context.lineWidth = 0.5;
            }


            // drawing panels
            function draw_panel(x,y,w,h) {
                // checking the view
                if (master.view === 'all' || master.view === 'cuts') {
                    context.strokeStyle = '#000';
                    context.strokeRect(x, y, w, h);
                }
            }
            // drawing holes
            function draw_hole(hole_x,hole_y, radius) {
                // checking the view
                if (master.view === 'all' || master.view === 'holes') {
                    // divide diameter given into radius
                    radius /= 2;
                    context.beginPath();
                    context.arc(hole_x, hole_y, radius, 0, Math.PI * 2, false);
                    context.closePath();
                    context.strokeStyle = "#000";
                    context.stroke();
                }
            }
            // drawing cuts
            function draw_cut(s_x,s_y,e_x,e_y) {
                // checking the view
                if (master.view === 'all' || master.view === 'cuts') {
                    context.beginPath();
                    context.moveTo(s_x, s_y);
                    context.lineTo(e_x, e_y);
                    context.stroke();
                }
            }
            // drawing scores
            function draw_score(s_x,s_y,e_x,e_y) {
                // checking the view
                if (master.view === 'all' || master.view === 'scores') {
                    context.beginPath();
                    context.moveTo(s_x, s_y);
                    context.lineTo(e_x, e_y);
                    context.stroke();
                }
            }
            // bringing it all together
            function draw_details(x,y,w,h, radius,panel_type,door_w,door_h,door_in_left) {
                // hole inset from edge
                var hole_inset = holes.pvc/2;

                // standard panels
                if (panel_type === 'standard' ) {
                    // left top inset
                    draw_hole(x + hole_inset,holes.pn_l_in + holes.pn_sides_top, radius);
                    // left side
                    for (var i = 0; i < (h - holes.pn_sides_top - holes.pn_l_in); i += holes.spacing) {
                        var hole_x = x + hole_inset,
                            hole_y = y + h - (i + holes.pn_l_in);
                        draw_hole(hole_x, hole_y, radius);
                    }
                    // right top inset
                    draw_hole(x + w - hole_inset,holes.pn_r_in + holes.pn_sides_top, radius);
                    // right side
                    for (var i = 0; i < (h - holes.pn_sides_top); i += holes.spacing) {
                        var hole_x = x + w - hole_inset,
                            hole_y = y + h - (i + holes.pn_r_in);
                        draw_hole(hole_x, hole_y, radius);
                    }
                    // top right inset
                    draw_hole((x + w - holes.pn_t_in),(y + hole_inset), radius);
                    // top
                    for (var i = 0; i < w; i += holes.spacing) {
                        var hole_x = x + (i + holes.pn_t_in),
                            hole_y = y + hole_inset;
                        draw_hole(hole_x, hole_y, radius);
                    }
                    // bottom right inset
                    draw_hole((x + holes.pn_b_in),(y + h - hole_inset), radius);
                    // bottom
                    for (var i = 0; i < w; i += holes.spacing) {
                        var hole_x = x + w - (i + holes.pn_b_in),
                            hole_y = y + h - hole_inset;
                        draw_hole(hole_x, hole_y, radius);
                    }
                }

                // deflectors
                if (panel_type === 'deflector_horizontal' ) {
                    // top left
                    draw_hole(x + holes.df_t_in, y + hole_inset, radius);
                    draw_hole(x + holes.df_t_in + holes.spacing, y + hole_inset, radius);
                    // top right
                    draw_hole(x + w - holes.df_t_in, y + hole_inset, radius);
                    draw_hole(x + w - holes.df_t_in - holes.spacing, y + hole_inset, radius);
                    // draw score line
                    draw_score(x, y + holes.df_line, x + w, y + holes.df_line);
                    // left side
                    for (var i = 0; i < (h - holes.df_sides_top); i += holes.spacing) {
                        var hole_x = x + hole_inset,
                            hole_y = y + (i + holes.df_t_in);
                        draw_hole(hole_x, hole_y, radius);
                    }
                    // right side
                    for (var i = 0; i < (h - holes.df_sides_top); i += holes.spacing) {
                        var hole_x = x + w - hole_inset,
                            hole_y = y + (i + holes.df_t_in);
                        draw_hole(hole_x, hole_y, radius);
                    }
                }
                if (panel_type === 'deflector_vertical' ) {
                    // top left
                    draw_hole(x + hole_inset, y + holes.df_t_in, radius);
                    draw_hole(x + hole_inset, y + holes.df_t_in + holes.spacing, radius);
                    // top right
                    draw_hole(x + hole_inset, y + h - holes.df_t_in, radius);
                    draw_hole(x + hole_inset, y + h - holes.df_t_in - holes.spacing, radius);
                    // draw score line
                    draw_score(x + holes.df_line, y, x + holes.df_line, y + h);
                    // left side
                    for (var i = 0; i < (w - holes.df_sides_top); i += holes.spacing) {
                        var hole_x = x + (i + holes.df_t_in),
                            hole_y = y + hole_inset;
                        draw_hole(hole_x, hole_y, radius);
                    }
                    // right side
                    for (var i = 0; i < (w - holes.df_sides_top); i += holes.spacing) {
                        var hole_x = x + (i + holes.df_t_in),
                            hole_y = y + h - hole_inset;
                        draw_hole(hole_x, hole_y, radius);
                    }
                }

                // dropdown panels
                if (panel_type === 'dropdown' ) {
                    // left side
                    for (var i = 0; i < (h - holes.pn_sides_top); i += holes.spacing) {
                        var hole_x = x + hole_inset,
                            hole_y = y + h - (i + holes.pn_l_in);
                        draw_hole(hole_x, hole_y, radius);
                    }
                    // left side top inset
                    draw_hole(x + hole_inset,holes.pn_l_in + holes.pn_sides_top, radius);

                    // right side
                    for (var i = 0; i < (h - holes.pn_sides_top); i += holes.spacing) {
                        var hole_x = x + w - hole_inset,
                            hole_y = y + h - (i + holes.pn_r_in);
                        draw_hole(hole_x, hole_y, radius);
                    }
                    // right side top inset
                    draw_hole(x + w - hole_inset,holes.pn_r_in + holes.pn_sides_top, radius);

                    // top left
                    for (var i = 0; i < door_in_left - holes.pn_t_in; i += holes.spacing) {
                        var hole_x = x + (i + holes.pn_t_in),
                            hole_y = y + hole_inset;
                        draw_hole(hole_x, hole_y, radius);
                    }

                    // top door
                    for (var i = 0; i < door_w - holes.dd_in; i += holes.spacing) {
                        var hole_x = x + door_in_left + (i + holes.dd_in),
                            hole_y = y + hole_inset;
                        draw_hole(hole_x, hole_y, radius);
                    }
                    // top door inset right
                    draw_hole(x + door_in_left + door_w - holes.dd_in, y + hole_inset, radius);

                    // top right
                    for (var i = 0; i < w - door_in_left - door_w - holes.pn_t_in; i += holes.spacing) {
                        var hole_x = x + w - (i + holes.pn_t_in),
                            hole_y = y + hole_inset;
                        draw_hole(hole_x, hole_y, radius);
                    }
                    // bottom
                    for (var i = 0; i < w; i += holes.spacing) {
                        var hole_x = x + w - (i + holes.pn_b_in),
                            hole_y = y + h - hole_inset;
                        draw_hole(hole_x, hole_y, radius);
                    }
                    // bottom inset right
                    draw_hole((x + holes.pn_b_in), (y + h - hole_inset), radius);

                    // door left side
                    for (var i = 0; i < (door_h - holes.pvc); i += holes.spacing) {
                        var hole_x = x + door_in_left + hole_inset,
                            hole_y = y + holes.dd_in + (i + holes.pvc);
                        draw_hole(hole_x, hole_y, radius);
                    }
                    // door left side top inset
                    draw_hole(x + door_in_left + hole_inset, y + door_h - holes.dd_in, radius);

                    // door right side
                    for (var i = 0; i < (door_h - holes.pvc); i += holes.spacing) {
                        var hole_x = x + door_w + door_in_left - hole_inset,
                            hole_y = y + holes.dd_in + (i + holes.pvc);
                        draw_hole(hole_x, hole_y, radius);
                    }
                    // door right side top inset
                    draw_hole(x + door_w + door_in_left - hole_inset, y + door_h - holes.dd_in, radius);

                    // door bottom
                    for (var i = 0; i < (door_w - (2*holes.pvc)); i += holes.spacing) {
                        var hole_x = x + door_w + door_in_left - hole_inset - (i+(holes.pvc*2)),
                            hole_y = y + door_h - holes.dd_in;
                        draw_hole(hole_x, hole_y, radius);
                    }
                    // door bottom right inset
                    draw_hole(x + door_w + door_in_left - hole_inset - holes.pvc, y + door_h - holes.dd_in, radius);

                    // door base
                    for (var i = 0; i < w; i += holes.spacing) {
                        var hole_x = x + (i + holes.pn_t_in),
                            hole_y = y + door_h + hole_inset;
                        draw_hole(hole_x, hole_y, radius);
                    }
                    // door base inset
                    draw_hole((x + w - holes.pn_t_in),y + door_h + hole_inset, radius);


                    // door cuts
                    draw_cut(x + door_in_left, y, x + door_in_left, y + door_h);
                    draw_cut(x + door_in_left + door_w, y, x + door_in_left + door_w, y + door_h);


                    // door scores
                    draw_score(x + door_in_left, y + door_h, x + door_in_left + door_w, y + door_h);
                }

            }

            // drawing sheets
            for (var i = 0; i < sheet_objs.length; i++) {
                new_canvas();
                for (var ii = 0; ii < sheet_objs[i].length; ii++) {
                    var this_sheet = sheet_objs[i][ii];
                    var x = this_sheet[0]*px_scale,
                        y = this_sheet[1]*px_scale,
                        w = this_sheet[2]*px_scale,
                        h = this_sheet[3]*px_scale,
                        panel_type = this_sheet[4],
                        dd_w = this_sheet[5]*px_scale,
                        dd_h = this_sheet[6]*px_scale,
                        dd_in = this_sheet[7]*px_scale;

                    draw_panel(x,y,w,h);

                    if (panel_type === 'dropdown') {
                        draw_details(x,y,w,h,master.hole,panel_type,dd_w,dd_h,dd_in);
                    } else {
                        draw_details(x,y,w,h,master.hole,panel_type);
                    }
                }
                // if (master.image) {
                //     // storing as image??
                //     var the_canvas = document.getElementById(uid);
                //     var img = the_canvas.toDataURL("image/png");
                //     $(this).prepend('<a download="sheet_'+i+'" href="'+img+'">Sheet '+i+'</a> ');
                    // $(this).prepend('<a download="" href="'+img+'">Download</a>');
                    // $(this).append('<img src="'+img+'" />');
                    // console.log(img);

                }
            }

        });

    };
})(jQuery);