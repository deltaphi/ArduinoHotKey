
$fn=50;

wall_thickness = 2; // Should be a multiple of 0.4
fit_tolerance = 0.2;

standoff_wall_thickness = 1.6; // Should be a multiple of 0.4.
standoff_inner_diameter = 2.8; // 2,5 when tapping for M3 with extra gear.
standoff_screw_diameter = 6; // Extra space to sink the screw into.
standoff_screw_passthrough_diameter = 3.6; // 3.2 minimum when not tapping.
screw_length = 12;

hole_to_side = 5.08; // Value tested OK

pcb_width = 96.52;
pcb_depth = 77.47;
pcb_thickness = 2;
pcb_side_fit_tolerance = 1;

pcb_front_outer_distance = 5; // 13
pcb_front_inner_distance = pcb_front_outer_distance - wall_thickness;

housing_width = pcb_width + (2*(pcb_side_fit_tolerance + wall_thickness));

housing_depth = pcb_depth + (2*(pcb_side_fit_tolerance + wall_thickness));

pcb_back_inner_distance = 18; // Value tested OK
pcb_back_outer_distance = pcb_back_inner_distance + wall_thickness;

lip_height = pcb_thickness + fit_tolerance;
lip_width = (wall_thickness / 2) - (fit_tolerance / 2);

// Distance from the top
switch_y1 = 33.02; // Value tested OK
switch_y2 = 58.42; // Value tested OK

// Distance from the left
switch_x1 = 10.16; // Value tested OK
switch_x2 = 35.56; // Value tested OK
switch_x3 = 60.96; // Value tested OK
switch_x4 = 86.36; // Value tested OK

// Standoffs

// * Dimenstions
standoff_outer_diameter = standoff_inner_diameter + (2*standoff_wall_thickness);
standoff_outer_screw_diameter = standoff_screw_diameter + (2*standoff_wall_thickness);
standoff_screwhole_diameter = standoff_screw_passthrough_diameter + (2*standoff_wall_thickness);

// * locations in top and bottom
standoff_x1 = wall_thickness + pcb_side_fit_tolerance + hole_to_side;
standoff_x2 = wall_thickness + pcb_side_fit_tolerance + pcb_depth - hole_to_side;

standoff_y1 = wall_thickness + pcb_side_fit_tolerance + hole_to_side;
standoff_y2 = wall_thickness + pcb_side_fit_tolerance + pcb_width - hole_to_side;

// * Module in the bottom case
module standoff_bottom(x,y) {
   
    // Leave 1mm space in the top screw holes
    standoff_bottom_screw_length = screw_length - pcb_thickness - pcb_front_outer_distance + 1;
    standoff_screw_head_height = pcb_back_inner_distance - standoff_bottom_screw_length;
   
    difference() {
        // Solid part
        union() {
            // Screw head part. Should leave standoff_bottom_screw_length - wall_thickness for the following thin part.
            translate([x, y ,0]) cylinder(h=standoff_screw_head_height + wall_thickness,d=standoff_outer_screw_diameter);
            // Screw part
            translate([x, y ,0]) cylinder(h=pcb_back_outer_distance,d=standoff_screwhole_diameter);
        }
       
        // Take away the holes
       
        // Screw head hole part.
        translate([x, y ,-0.1]) cylinder(h=standoff_screw_head_height,d=standoff_screw_diameter);
       
        // Screw hole part
        translate([x, y ,-0.1]) cylinder(h=pcb_back_outer_distance+1,d=standoff_screw_passthrough_diameter);
    }
}

// * Module in the top case
module standoff_top(x,y,height) {
    difference() {
        translate([x, y ,0]) cylinder(h=height,d=standoff_outer_diameter);
        translate([x, y ,-0.1]) cylinder(h=height+1,d=standoff_inner_diameter);
    }
}






// Basic Bottom
module bottomcase() {

    difference() {

        union() {
            // Main wall
            cube([housing_depth, housing_width, pcb_back_outer_distance]);

            // Inner lip
            translate([lip_width, lip_width, 0]) cube([housing_depth - 2*lip_width, housing_width - 2*lip_width, pcb_back_outer_distance+lip_height]);
        }
           
        // Inner space
        translate([wall_thickness,wall_thickness,wall_thickness])
        cube([pcb_depth + (2*pcb_side_fit_tolerance), pcb_width + (2*pcb_side_fit_tolerance),pcb_back_inner_distance+lip_height+1]);
           
        // Hole for USB wire
        translate([62+wall_thickness,0,6+wall_thickness])
        rotate([90,90,0])
        cylinder(h=wall_thickness*3, d=12, center=true);

        translate([62+wall_thickness,0,14+wall_thickness])
        cube([12,wall_thickness*3,12+lip_height], center = true);
           
        // add holes from the bottom
        translate([standoff_x1, standoff_y1 ,-0.1]) cylinder(d=standoff_screw_diameter + (2*standoff_wall_thickness), h=wall_thickness+1);
        translate([standoff_x2, standoff_y1 ,-0.1]) cylinder(d=standoff_screw_diameter + (2*standoff_wall_thickness), h=wall_thickness+1);
        translate([standoff_x1, standoff_y2 ,-0.1]) cylinder(d=standoff_screw_diameter + (2*standoff_wall_thickness), h=wall_thickness+1);
        translate([standoff_x2, standoff_y2 ,-0.1]) cylinder(d=standoff_screw_diameter + (2*standoff_wall_thickness), h=wall_thickness+1);
    }
    // add Standoffs
    standoff_bottom(standoff_x1, standoff_y1);
    standoff_bottom(standoff_x2, standoff_y1);
    standoff_bottom(standoff_x1, standoff_y2);
    standoff_bottom(standoff_x2, standoff_y2);
}




// Solid switch cube. Can be used to subtract from cubes to punch correct-sized holes.
// Designed so that the center plane represents the top of the case.
// Adds a recess so that the plate thickness around the switch is limited.
module switch() {
    switch_hole_side = 14;// Value tested correctly for Cherry MX
    switch_plate_thickness = 1.5;
   
    spacer_side = switch_hole_side + 2; // 1mm all round
   
   
    translate([-switch_hole_side/2,-switch_hole_side/2,-1]) cube([switch_hole_side, switch_hole_side, wall_thickness+2]);
    translate([-spacer_side/2,-spacer_side/2,switch_plate_thickness]) cube([spacer_side,spacer_side,wall_thickness+2]);
}

// switch();

module switcharray() {
    translate([switch_y1, switch_x1, 0]) switch();
    translate([switch_y1, switch_x2, 0]) switch();
    translate([switch_y1, switch_x3, 0]) switch();
    translate([switch_y1, switch_x4, 0]) switch();
           
    translate([switch_y2, switch_x1, 0]) switch();
    translate([switch_y2, switch_x2, 0]) switch();
    translate([switch_y2, switch_x3, 0]) switch();
    translate([switch_y2, switch_x4, 0]) switch();
}

// Basic top
module topcase() {

    difference() {

        // Main wall with added height for lip
        cube([housing_depth, housing_width, pcb_front_outer_distance + lip_height]);
           
        // Carve out interior
        translate([wall_thickness, wall_thickness, wall_thickness])
        cube([pcb_depth + (2*pcb_side_fit_tolerance), pcb_width + (2*pcb_side_fit_tolerance), pcb_front_inner_distance+2]);

        // Carve out lip
        translate([lip_width, lip_width, pcb_front_outer_distance])
        cube([housing_depth - 2*lip_width, housing_width - 2*lip_width, pcb_front_inner_distance+2]);

        // Carve out switch holes
        translate([wall_thickness+pcb_side_fit_tolerance, wall_thickness+pcb_side_fit_tolerance, 0]) switcharray();
    }

    // Standoffs
    translate([0,0,wall_thickness-0.1]) standoff_top(standoff_x1, standoff_y1, pcb_front_inner_distance+0.1);
    translate([0,0,wall_thickness-0.1]) standoff_top(standoff_x2, standoff_y1, pcb_front_inner_distance+0.1);
    translate([0,0,wall_thickness-0.1]) standoff_top(standoff_x1, standoff_y2, pcb_front_inner_distance+0.1);
    translate([0,0,wall_thickness-0.1]) standoff_top(standoff_x2, standoff_y2, pcb_front_inner_distance+0.1);
}

module all() {
    translate([-100,0,0]) bottomcase();
    translate([20,0,0]) topcase();
}

all();