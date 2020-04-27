$fn=50;

wall_thickness = 1;
standoff_wall_thickness = 1.5;
standoff_inner_diameter = 2.5;
standoff_screw_diameter = 5.1;

hole_to_side = 5.08;

pcb_width = 96.52;
pcb_depth = 77.47;

pcb_plate_distance = 2.5;

pcb_front_outer_distance = 5; // 13
pcb_front_inner_distance = pcb_front_outer_distance - wall_thickness;

housing_width = pcb_width + (2*wall_thickness);

housing_depth = pcb_depth + (2*wall_thickness);

pcb_back_inner_distance = 18;

// Distance from the top
switch_y1 = 33.02;
switch_y2 = 58.42;

// Distance from the left
switch_x1 = 10.16;
switch_x2 = 35.56;
switch_x3 = 60.96;
switch_x4 = 86.36;

// Standoffs
module standoff_top(x,y) {
    standoff_outer_diameter = standoff_inner_diameter + (2*standoff_wall_thickness);
    standoff_outer_screw_diameter = standoff_screw_diameter + (2*standoff_wall_thickness);
   
    difference() {
        union() {
            translate([x, y ,0]) cylinder(h=(pcb_back_inner_distance-wall_thickness)/2,d=standoff_outer_screw_diameter);
            translate([x, y ,0]) cylinder(h=(pcb_back_inner_distance-wall_thickness),d=standoff_outer_diameter);
        }
        translate([x, y ,-0.1]) cylinder(h=pcb_back_inner_distance-wall_thickness+1,d=standoff_inner_diameter);
        translate([x, y ,-0.1]) cylinder(h=(pcb_back_inner_distance-wall_thickness+1)/2 -1,d=standoff_screw_diameter);
    }
}

// Standoff locations in top and bottom
standoff_x1 = wall_thickness + hole_to_side;
standoff_x2 = wall_thickness + pcb_depth - hole_to_side;

standoff_y1 = wall_thickness + hole_to_side;
standoff_y2 = wall_thickness + pcb_width - hole_to_side;

// Basic Bottom
module bottomcase() {

difference() {

// Main wall
cube([housing_depth, housing_width, pcb_back_inner_distance]);
    
// Inner space
translate([wall_thickness,wall_thickness,wall_thickness])
cube([pcb_depth, pcb_width,pcb_back_inner_distance]);
    
// Hole for USB wire
translate([62+wall_thickness,0,6+wall_thickness])
rotate([90,90,0])
cylinder(h=wall_thickness*3, d=12, center=true);

translate([62+wall_thickness,0,12+wall_thickness])
//rotate([90,90,0])
cube([12,wall_thickness*3,12], center = true);
// add holes from the bottom
translate([standoff_x1, standoff_y1 ,-1]) cylinder(d=standoff_screw_diameter + (2*standoff_wall_thickness), h=3);
translate([standoff_x2, standoff_y1 ,-1]) cylinder(d=standoff_screw_diameter + (2*standoff_wall_thickness), h=3);
translate([standoff_x1, standoff_y2 ,-1]) cylinder(d=standoff_screw_diameter + (2*standoff_wall_thickness), h=3);
translate([standoff_x2, standoff_y2 ,-1]) cylinder(d=standoff_screw_diameter + (2*standoff_wall_thickness), h=3);
}
// add Standoffs
standoff_top(standoff_x1, standoff_y1);
standoff_top(standoff_x2, standoff_y1);
standoff_top(standoff_x1, standoff_y2);
standoff_top(standoff_x2, standoff_y2);
}


translate([-100,0,0])bottomcase();


// Solid switch cube. Can be used to subtract from cubes to punch correct-sized holes.
module switch() {
    cube(14,center=true);
}

// Basic top
module topcase() {

difference() {

// Main wall
cube([housing_depth, housing_width,pcb_front_outer_distance]);
    
translate([wall_thickness,wall_thickness,wall_thickness])
cube([pcb_depth, pcb_width,pcb_front_inner_distance+1]);
    /*
translate([switch_x1, switch_y1, 0]) switch();
translate([switch_x2, switch_y1, 0]) switch();
translate([switch_x3, switch_y1, 0]) switch();
translate([switch_x4, switch_y1, 0]) switch();
    
translate([switch_x1, switch_y2, 0]) switch();
translate([switch_x2, switch_y2, 0]) switch();
translate([switch_x3, switch_y2, 0]) switch();
translate([switch_x4, switch_y2, 0]) switch();
    */
translate([switch_y1+wall_thickness, switch_x1+wall_thickness, 0]) switch();
translate([switch_y1+wall_thickness, switch_x2+wall_thickness, 0]) switch();
translate([switch_y1+wall_thickness, switch_x3+wall_thickness, 0]) switch();
translate([switch_y1+wall_thickness, switch_x4+wall_thickness, 0]) switch();
    
translate([switch_y2+wall_thickness, switch_x1+wall_thickness, 0]) switch();
translate([switch_y2+wall_thickness, switch_x2+wall_thickness, 0]) switch();
translate([switch_y2+wall_thickness, switch_x3+wall_thickness, 0]) switch();
translate([switch_y2+wall_thickness, switch_x4+wall_thickness, 0]) switch();
}

// add Standoffs
standoff_top(standoff_x1, standoff_y1);
standoff_top(standoff_x2, standoff_y1);
standoff_top(standoff_x1, standoff_y2);
standoff_top(standoff_x2, standoff_y2);

// Switch plate
//translate([0, 0, ]) cube([housing_depth, housing_width, wall_thickness]);

}

translate([20,0,0]) topcase();


