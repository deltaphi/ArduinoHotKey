$fn=50;

wall_thickness = 1;
standoff_wall_thickness = 1.5;
standoff_inner_diameter = 2.5;

hole_to_side = 5.08;

pcb_width = 96.52;
pcb_depth = 77.47;

pcb_plate_distance = 2.5;

pcb_front_outer_distance = 13;
pcb_front_inner_distance = pcb_front_outer_distance - wall_thickness;

housing_width = pcb_width + (2*wall_thickness);

housing_depth = pcb_depth + (2*wall_thickness);

pcb_back_inner_distance = 18;

// Standoffs
module standoff_top() {
  standoff_outer_diameter = standoff_inner_diameter + (2*standoff_wall_thickness);
  difference() { 
    cylinder(h=pcb_back_inner_distance-wall_thickness,d=standoff_outer_diameter);
    cylinder(h=pcb_back_inner_distance-wall_thickness+1,d=standoff_inner_diameter);
  }
}

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
}


standoff_x1 = wall_thickness + hole_to_side;
standoff_x2 = wall_thickness + pcb_depth - hole_to_side;

standoff_y1 = wall_thickness + hole_to_side;
standoff_y2 = wall_thickness + pcb_width - hole_to_side;

translate([standoff_x1, standoff_y1 ,wall_thickness]) standoff_top();
translate([standoff_x2, standoff_y1 ,wall_thickness]) standoff_top();
translate([standoff_x1, standoff_y2 ,wall_thickness]) standoff_top();
translate([standoff_x2, standoff_y2 ,wall_thickness]) standoff_top();

}


bottomcase();



// Basic top
module topcase() {

difference() {

// Main wall
cube([housing_depth, housing_width,pcb_front_outer_distance]);
    
translate([wall_thickness,wall_thickness,wall_thickness])
cube([pcb_depth, pcb_width,pcb_front_inner_distance]);
}

// Switch plate
//translate([0, 0, ]) cube([housing_depth, housing_width, wall_thickness]);

}

//topcase();


