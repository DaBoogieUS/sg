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
            view: 'all' // view ('all', 'cuts', 'holes', 'scores')
        };

        // hole variables
        var holes = {
            pn_l_in: 0.5, // panel left vertical inset
            pn_r_in: 0.75, // panel right vertical inset
            pn_sides_top: 1, // panel left and right sides distance from top
            pn_t_in: 1, // panel top side inset
            pn_b_in: 0.5, // panel bottom side inset
            df_t_in: 2, // deflector top side inset
            df_sides_top: 1, // deflector sides top inset (from groove)
            df_line: 1, // deflector score y
            dd_in: 0.5, // dropdown pieces inset
            pvc: 1, // pvc size
            spacing: 4, // hole spacing
            lc_thick: 0.125 // l-channel thickness
        };

        // master options, given opts override defaults
        var master = $.extend(default_vals, options);
        // pixel to inch scale
        var px_scale = 72 * (master.scale * 0.01);
        // padding in on the sheet
        var padding = 0 * px_scale;

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
        holes.lc_thick *= px_scale;
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
                paper ='',
                cs = '';

            // selecting this
            var sel_obj = $(this);

            function new_canvas() {
                // unique id for the sheet
                uid = 'sheet_'+Math.floor((Math.random()*100)*(Math.random()*100)*(Math.random()*100));
                sel_obj.append('<div id="'+uid+'" class="drawn_sheet"></div>');
                paper = Raphael(document.getElementById(uid), (master.w+(padding*2)), (master.h+(padding*2)));
                var the_canvas = $('#'+uid).find('svg');
                var mockup_cont = $('<g id="mockup_'+uid+'"></g>').appendTo(the_canvas);
                var holes_cont = $('<g id="holes_'+uid+'"></g>').appendTo(the_canvas);
                var scores_cont = $('<g id="scores_'+uid+'"></g>').appendTo(the_canvas);
                var cuts_cont = $('<g id="cuts_'+uid+'"></g>').appendTo(the_canvas);
            }

            // drawing mockup
            function draw_pvc(x,y,w,h) {
                var prevent_mockup = true;
                // checking the view
                if (master.view === 'all' && prevent_mockup === false) {
                    var c = paper.rect(x, y, w, h);
                    c.attr('fill', '#ccc');
                    c.attr('stroke-width', 0.5);
                    c.attr('stroke', '#595959');
                    $('#mockup_'+uid).append(c);
                }
            }
            // drawing grid
            function draw_grid(s_x,s_y,e_x,e_y) {
                // checking the view
                if (master.view === 'all' || master.view === 'cuts') {
                    var c = paper.path('M'+s_x+' '+s_y+'L'+e_x+' '+e_y+'');
                    c.attr('stroke-width',0.5);
                    c.attr('stroke','#d9d9d9');
                    $('#mockup'+uid).append(c);
                }
            }

            // drawing surface
            function draw_surface(x,y,w,h) {
                // checking the view
                if (master.view === 'all' || master.view === 'cuts') {
                    var c = paper.rect(x, y, w, h);
                    c.attr('stroke-width', 0.5);
                    $('#cuts_'+uid).append(c);
                }
            }
            // drawing a hole
            function draw_hole(hole_x,hole_y, radius) {
                // checking the view
                if (master.view === 'all' || master.view === 'holes') {
                    // divide diameter given into radius
                    radius /= 2;
                    var c = paper.circle(hole_x, hole_y, radius);
                    c.attr('stroke-width',0.5);
                    $('#holes_'+uid).append(c);
                }
            }
            // drawing a line of holes
            function hole_line(piece_x,piece_y,length,inset,direction,prevent_mockup,no_cap) {
                // hole inset from edge
                var pvc_center = holes.pvc/2,
                    radius = master.hole,
                    spacing = holes.spacing,
                    i = 0,
                    hole_x = 0,
                    hole_y = 0;

                switch(direction) {
                    case 'l2r':
                        // mock it up
                        if (!prevent_mockup) { draw_pvc(piece_x,piece_y,length,holes.pvc); }

                        // path
                        for (i = 0; i + piece_x < (piece_x + length - (inset*2)); i += spacing) {
                            hole_x = piece_x + (i + inset);
                            hole_y = piece_y + pvc_center;
                            draw_hole(hole_x, hole_y, radius);
                        }
                        // right inset
                        if (!no_cap) { draw_hole(piece_x+length-inset, piece_y+pvc_center, radius); }
                    break;
                    case 'r2l':
                        // mock it up
                        if (!prevent_mockup) { draw_pvc(piece_x,piece_y,length,holes.pvc); }
                        // path
                        for (i = 0; i + piece_x < (piece_x + length - (inset*2)); i += spacing) {
                            hole_x = piece_x + length - (i + inset);
                            hole_y = piece_y + pvc_center;
                            draw_hole(hole_x, hole_y, radius);
                        }
                        // right inset
                        if (!no_cap) { draw_hole(piece_x+inset, piece_y+pvc_center, radius); }
                    break;
                    case 't2b':
                        // mock it up
                        if (!prevent_mockup) { draw_pvc(piece_x,piece_y,holes.pvc,length); }
                        // path
                        for (i = 0; i + piece_y < (piece_y + length - (inset*2)); i += spacing) {
                            hole_x = piece_x + pvc_center;
                            hole_y = piece_y + (i + inset);
                            draw_hole(hole_x, hole_y, radius);
                        }
                        // top inset
                        if (!no_cap) { draw_hole(piece_x+pvc_center, piece_y+length-inset, radius); }
                    break;
                    case 'b2t':
                        // mock it up
                        if (!prevent_mockup) { draw_pvc(piece_x,piece_y,holes.pvc,length); }
                        // path
                        for (i = 0; i + piece_y < (piece_y + length - (inset*2)); i += spacing) {
                            hole_x = piece_x + pvc_center;
                            hole_y = piece_y + length - (i + inset);
                            draw_hole(hole_x, hole_y, radius);
                        }
                        // top inset
                        if (!no_cap) { draw_hole(piece_x+pvc_center, piece_y+inset, radius); }
                    break;
                    default:
                        // alert('wrong direction');
                }
            }

            // drawing cuts
            function draw_cut(s_x,s_y,e_x,e_y) {
                // checking the view
                if (master.view === 'all' || master.view === 'cuts') {
                    var c = paper.path('M'+s_x+' '+s_y+'L'+e_x+' '+e_y+'');
                    c.attr('stroke-width',1);
                    $('#cuts_'+uid).append(c);
                }
            }
            // drawing scores
            function draw_score(s_x,s_y,e_x,e_y) {
                // checking the view
                if (master.view === 'all' || master.view === 'scores') {
                    var c = paper.path('M'+s_x+' '+s_y+'L'+e_x+' '+e_y+'');
                    c.attr('stroke-width',1);
                    $('#scores_'+uid).append(c);
                }
            }
            // bringing it all together
            function draw_panel(x,y,w,h,radius,panel_type,door_w,door_h,door_in_left,deflector_type) {
                // draw the surface
                draw_surface(x,y,w,h);

                // hole inset from edge
                var pvc_center = holes.pvc/2;

                /*
                 * standard panel
                 */

                if (panel_type === 'standard' ) {

                    /*
                     * holes
                     */

                    // left side
                    hole_line(x, y+holes.pvc, h-holes.pvc, holes.pn_l_in, 'b2t');
                    // right side
                    hole_line(x+w-holes.pvc, y+holes.pvc, h-holes.pvc, holes.pn_r_in, 'b2t');
                    // top
                    hole_line(x, y, w, holes.pn_t_in, 'l2r');
                    // bottom
                    hole_line(x+holes.pvc, y+h-holes.pvc, w-(holes.pvc*2), holes.pn_b_in, 'r2l');

                }

                /*
                 * dropdown panel
                 */

                if (panel_type === 'dropdown' ) {

                    // door base (sq)
                    hole_line(x+holes.pvc, y+door_h, w-(holes.pvc*2), holes.pn_b_in, 'r2l');
                    // bottom
                    hole_line(x+holes.pvc, y+h-holes.pvc, w-(holes.pvc*2), holes.pn_b_in, 'r2l');

                    if (door_in_left === 0) {

                        /*
                         * no inset left door
                         */

                        // left side (sq)
                        hole_line(x, y+door_h+holes.lc_thick, h-holes.lc_thick-door_h, holes.pn_l_in, 'b2t');
                        // door left side (lc)
                        hole_line(x+door_in_left+holes.pvc, y+holes.pvc, door_h-holes.pvc, holes.dd_in, 't2b');

                        // left side remaining top pvc
                        draw_pvc(x, y+holes.lc_thick, holes.pvc, door_h-(holes.lc_thick*2));

                        if (door_w === w) {

                            /*
                             * full width door
                             */

                            // right side (sq)
                            hole_line(x+w-holes.pvc, y+door_h+holes.lc_thick, h-door_h-holes.lc_thick, holes.pn_r_in, 'b2t');
                            // door right side (lc)
                            hole_line(x+door_w+door_in_left-(holes.pvc*2), y+holes.pvc, door_h-holes.pvc, holes.dd_in, 't2b');
                            // door bottom (lc)
                            hole_line(x+door_in_left+(holes.pvc*2), y+door_h-holes.pvc, door_w-(holes.pvc*4), holes.pn_b_in, 'r2l');
                            // door top (lc)
                            hole_line(x+holes.pvc, y, door_w-(holes.pvc*2), holes.dd_in, 'l2r');

                            // door bottom fold
                            draw_score(x + door_in_left, y + door_h, x + door_in_left + door_w, y + door_h);

                            // right side remaining top pvc
                            draw_pvc(x+w-holes.pvc, y+holes.lc_thick, holes.pvc, door_h-(holes.lc_thick*2));

                        } else {

                            /*
                             * flush left door
                             */

                            // right side (lc)
                            hole_line(x+w-holes.pvc, y+holes.pvc, h-holes.pvc, holes.pn_r_in, 'b2t');
                            // right door support (sq)
                            hole_line(x+door_w, y+holes.lc_thick, h-(holes.lc_thick*2), holes.dd_in, 'b2t');
                            // door top right (lc)
                            hole_line(x+door_in_left+door_w+holes.pvc, y, w-door_in_left-door_w-holes.pvc, holes.dd_in, 'l2r');
                            // door right side (lc)
                            hole_line(x+door_w+door_in_left-holes.pvc, y+holes.pvc, door_h-holes.pvc, holes.dd_in, 't2b');
                            // door bottom (lc)
                            hole_line(x+door_in_left+(holes.pvc*2), y+door_h-holes.pvc, door_w-(holes.pvc*3), holes.pn_b_in, 'r2l');
                            // door top (lc)
                            hole_line(x+holes.pvc, y, door_w-holes.pvc, holes.dd_in, 'l2r');

                            // door bottom fold
                            draw_score(x + door_in_left, y + door_h, x + door_in_left + door_w, y + door_h);
                            // door right cut
                            draw_cut(x+door_in_left+door_w, y, x+door_in_left+door_w, y+door_h);

                        }


                    } else {

                        /*
                         * left inset door
                         */

                        // left side (lc)
                        hole_line(x, y+holes.pvc, h-holes.pvc, holes.pn_l_in, 'b2t');

                        // left door support (sq)
                        hole_line(x+door_in_left-holes.pvc, y+holes.lc_thick, h-(holes.lc_thick*2), holes.dd_in, 'b2t');
                        // door left side (lc)
                        hole_line(x+door_in_left, y+holes.pvc, door_h-holes.pvc, holes.dd_in, 't2b');

                        // door left cut
                        draw_cut(x+door_in_left, y, x+door_in_left, y+door_h);

                        if (door_w + door_in_left === w) {

                            /*
                             * flush right door
                             */

                            // right side (sq)
                            hole_line(x+w-holes.pvc, y+door_h+holes.lc_thick, h-door_h-holes.lc_thick, holes.pn_r_in, 'b2t');
                            // door bottom (lc)
                            hole_line(x+door_in_left+holes.pvc, y+door_h-holes.pvc, door_w-(holes.pvc*3), holes.pn_b_in, 'r2l');
                            // door right side (lc)
                            hole_line(x+door_w+door_in_left-(holes.pvc*2), y+holes.pvc, door_h-holes.pvc, holes.dd_in, 't2b');
                            // door top left (lc)
                            hole_line(x, y, door_in_left-(holes.pvc), holes.dd_in, 'l2r');
                            // door top (lc)
                            hole_line(x+door_in_left, y, door_w-(holes.pvc), holes.dd_in, 'l2r');

                            // door bottom fold
                            draw_score(x + door_in_left, y + door_h, x + door_in_left + door_w, y + door_h);

                            // right side remaining top pvc
                            draw_pvc(x+w-holes.pvc, y+holes.lc_thick, holes.pvc, door_h-(holes.lc_thick*2));

                        } else {

                            /*
                             * fully inset door
                             */

                            // right door support (sq)
                            hole_line(x+door_in_left+door_w, y+holes.lc_thick, h-(holes.lc_thick*2), holes.dd_in+holes.lc_thick, 'b2t');
                            // right side (lc)
                            hole_line(x+w-holes.pvc, y+holes.pvc, h-holes.pvc, holes.pn_r_in,'b2t');
                            // door bottom (lc)
                            hole_line(x+door_in_left+holes.pvc, y+door_h-holes.pvc, door_w-(holes.pvc*2), holes.pn_b_in, 'r2l');
                            // door right side (lc)
                            hole_line(x+door_w+door_in_left-(holes.pvc), y+holes.pvc, door_h-holes.pvc, holes.dd_in, 't2b');
                            // door top left (lc)
                            hole_line(x, y, door_in_left-(holes.pvc), holes.dd_in, 'l2r');
                            // door top right (lc)
                            hole_line(x+door_in_left+door_w+holes.pvc, y, w-door_in_left-door_w-holes.pvc, holes.dd_in, 'l2r');
                            // door top (lc)
                            hole_line(x+door_in_left, y, door_w, holes.dd_in, 'l2r');

                            // door bottom fold
                            draw_score(x + door_in_left, y + door_h, x + door_in_left + door_w, y + door_h);
                            // door right cut
                            draw_cut(x+door_in_left+door_w, y, x+door_in_left+door_w, y+door_h);

                        }
                    }

                }

                // deflectors
                if (panel_type === 'deflector_horizontal' ) {

                    /*
                     * holes
                     */

                    var hole_distance_w = w/2;

                    if ( deflector_type === 'standard' ) {

                        // top left
                        hole_line(x, y, hole_distance_w, holes.df_t_in, 'l2r', true);
                        // top right
                        hole_line(x+hole_distance_w, y, hole_distance_w, holes.df_t_in, 'r2l', true);
                        // left side
                        hole_line(x, y+holes.pvc, h-holes.pvc, holes.df_sides_top, 't2b', true);
                        // right side
                        hole_line(x+w-holes.pvc, y+holes.pvc, h-holes.pvc, holes.df_sides_top, 't2b', true);

                    } else if ( deflector_type === 'door_center' ) {

                        // top left
                        hole_line(x, y, hole_distance_w, holes.dd_in, 'l2r', true, true);
                        // top right
                        hole_line(x+hole_distance_w, y, hole_distance_w, holes.dd_in, 'r2l', true, true);

                    } else if ( deflector_type === 'door_left_side' ) {

                        // top
                        hole_line(x, y, w, holes.df_t_in, 'l2r', true);
                        // left side
                        hole_line(x, y+holes.pvc, h-holes.pvc, holes.df_sides_top, 't2b', true);

                    } else if ( deflector_type === 'door_right_side' ) {

                        // top
                        hole_line(x, y, w, holes.df_t_in, 'r2l', true);
                        // right side
                        hole_line(x+w-holes.pvc, y+holes.pvc, h-holes.pvc, holes.df_sides_top, 't2b', true);

                    } else {

                        // top left
                        hole_line(x, y, hole_distance_w, holes.df_t_in, 'l2r', true);
                        // top right
                        hole_line(x+hole_distance_w, y, hole_distance_w, holes.df_t_in, 'r2l', true);
                        // left side
                        hole_line(x, y+holes.pvc, h-holes.pvc, holes.df_sides_top, 't2b', true);
                        // right side
                        hole_line(x+w-holes.pvc, y+holes.pvc, h-holes.pvc, holes.df_sides_top, 't2b', true);

                    }



                    /*
                     * score
                     */

                    // top fold
                    draw_score(x, y + holes.df_line, x + w, y + holes.df_line);

                }
                if (panel_type === 'deflector_vertical' ) {

                    /*
                     * holes
                     */

                    var hole_distance_h = h/2;

                    if ( deflector_type === 'standard' ) {

                        // top left (rotated)
                        hole_line(x, y+hole_distance_h, hole_distance_h, holes.df_t_in, 'b2t', true);
                        // top right (rotated)
                        hole_line(x, y, hole_distance_h, holes.df_t_in, 't2b', true);
                        // left side (rotated)
                        hole_line(x+holes.pvc, y, w-holes.pvc, holes.df_sides_top, 'l2r', true);
                        // right side (rotated)
                        hole_line(x+holes.pvc, y+h-holes.pvc, w-holes.pvc, holes.df_sides_top, 'l2r', true);

                    } else if ( deflector_type === 'door_center' ) {

                        // top left (rotated)
                        hole_line(x, y+hole_distance_h, hole_distance_h, holes.df_t_in, 'b2t', true);
                        // top right (rotated)
                        hole_line(x, y, hole_distance_h, holes.df_t_in, 't2b', true);

                    } else if ( deflector_type === 'door_left_side' ) {

                        // top left (rotated)
                        hole_line(x, y, h, holes.df_t_in, 'b2t', true);
                        // left side (rotated)
                        hole_line(x+holes.pvc, y+h-holes.pvc, w-holes.pvc, holes.df_sides_top, 'l2r', true);

                    } else if ( deflector_type === 'door_right_side' ) {

                        // top right (rotated)
                        hole_line(x, y, h, holes.df_t_in, 't2b', true);
                        // right side (rotated)
                        hole_line(x+holes.pvc, y, w-holes.pvc, holes.df_sides_top, 'l2r', true);

                    } else {

                        // top left (rotated)
                        hole_line(x, y+hole_distance_h, hole_distance_h, holes.df_t_in, 'b2t', true);
                        // top right (rotated)
                        hole_line(x, y, hole_distance_h, holes.df_t_in, 't2b', true);
                        // left side (rotated)
                        hole_line(x+holes.pvc, y, w-holes.pvc, holes.df_sides_top, 'l2r', true);
                        // right side (rotated)
                        hole_line(x+holes.pvc, y+h-holes.pvc, w-holes.pvc, holes.df_sides_top, 'l2r', true);

                    }

                    /*
                     * score
                     */

                    // top fold (rotated)
                    draw_score(x + holes.df_line, y, x + holes.df_line, y + h);

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
                        dd_in = this_sheet[7]*px_scale,
                        df_type = this_sheet[5];
                    if (panel_type === 'dropdown') {
                        draw_panel(x,y,w,h,master.hole,panel_type,dd_w,dd_h,dd_in);
                    } else if (panel_type === 'deflector_vertical' || panel_type === 'deflector_horizontal') {
                        draw_panel(x,y,w,h,master.hole,panel_type,dd_w,dd_h,dd_in,df_type);
                    } else {
                        draw_panel(x,y,w,h,master.hole,panel_type);
                    }
                }

                // the grid
                var grid_x = 0,
                    grid_y = 0,
                    grid_w = master.w,
                    grid_h = master.h;
                // for (var vert = 0; vert*px_scale<grid_w; vert++ ) {
                //     draw_grid(grid_x+(vert*px_scale), grid_y, grid_x+(vert*px_scale), grid_h);
                // }
                // for (var hor = 0; hor * px_scale < grid_h; hor++ ) {
                //     draw_grid(grid_x, grid_y+(hor*px_scale), grid_w, grid_y+(hor*px_scale));
                // }
            }

            // downloadable?
            function encode_as_img_and_link(link_container){
                // Add some critical information
                var count = 0;
                $('.sheet').each(function() {
                    count++;

                    // encoding and downloads
                    var svg_elem = $(this).find('svg');
                    svg_elem.attr({ version: '1.1' , xmlns:"http://www.w3.org/2000/svg"});
                    var container = $(this);
                    var svg = container.html();
                    var b64 = btoa(unescape(encodeURIComponent((svg)))); // or use btoa if supported
                    // var b64 = window.btoa(svg); // or use btoa if supported
                    // Works in recent Webkit(Chrome)
                    container.append($("<img src='data:image/svg+xml;base64,\n"+b64+"' alt='file.svg'/>"));
                    // Works in Firefox 3.6 and Webit and possibly any browser which supports the data-uri
                    link_container.append($("<span class='link'><a href-lang='image/svg+xml' download='sheet_"+count+".svg' href='data:image/svg+xml;base64,\n"+b64+"' title='sheet_"+count+".svg'>sheet_"+count+".svg</a></span>"));
                    svg_elem.hide();
                });
            }
            $(this).prepend('<div class="link_container"></div>');
            var link_container = $(this).children('.link_container');
            link_container.prepend('<h5>Download Links</h5>');
            encode_as_img_and_link(link_container);

        });

    };
})(jQuery);