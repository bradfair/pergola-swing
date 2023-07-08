// Config:

// type of decorative cut on the rafter tails and beams
tail_type = "japanese"; // [japanese, viking]

// # of rafters on the zipline tower
tower_rafters = 4;

// # of rafters on the swing set
swing_rafters = 9;

// distance from the beginning of one rafter to the beginning of the next
rafter_spacing = 16;

// distance the rafters overhang the beams, and the beams overhang the posts
overhang = 12;

// depth of the structure
depth = 48;

// height of the zipline tower platform
platform_height = 60;

// Structure:
module structure() {
    // put a % in front of a module name to make it transparent-ish, e.g. %southeast_post();
    // put a # in front of a module name to debug it / make it transparent-ish but red
    // put a ! in front of a module name to show only that module
    // put a * in front of a module name to hide it
    
    // a module can't have a color assigned if it has one of those prefixes, so you can either
    // move the module out of the color block, or comment out the color block
    
    // F5 to preview -- colors work there, but you might see some skins covering up the cutouts
    // F6 to render -- colors don't work there, but the cutouts are correct
    color("lightblue") {
        southeast_post();
        southwest_post();
        east_post();
        west_post();
        northeast_post();
        northwest_post();
    }
    southeast_beam();
    southwest_beam();
    south_rafters();
    northeast_beam(); 
    northwest_beam();
    north_rafters();
    
    
    // Still a work in progress, obvs
    platform();
    translate([(tower_rafters - 1) * rafter_spacing, 0, 30]) x();
    translate([(tower_rafters + swing_rafters - 1) * rafter_spacing, 0, 30]) x();
}

$fn = 128;

// Code:

tower_length = (tower_rafters - 1) * rafter_spacing + 5.5;
total_length = (tower_rafters + swing_rafters - 1) * rafter_spacing + 5.5;
swingset_length = total_length - tower_length;
echo(str("the structure is ", total_length, " inches long by ", depth + 5.5, " inches deep."));
echo(str("the tower section is ", tower_length, " inches long."));
echo(str("the swingset section is ", swingset_length, " inches long."));


module post(h) {
  union() {
    // tenon height is 4"
    cube([5.5, 5.5, h-4]);
    translate([0.5, 2, h-4]) cube([4.5, 1.5, 4]);
  }
}

module southeast_post() {
  translate([0, 0, 0]) post(143.25);
}

module southwest_post() {
  translate([0, depth, 0]) post(143.25);    
}

module east_post() {
  difference() {
    translate([(tower_rafters - 1) * rafter_spacing, 0, 0]) post(143.25);   
    
    // Northeast beam
    northeast_beam();  
      
    // Peg holes for beam
    translate([(tower_rafters - 1) * rafter_spacing + 3.5,-.25,93]) rotate([-90,0,0]) cylinder(6, 0.5, 0.5);
    translate([(tower_rafters - 1) * rafter_spacing + 3.5,-.25,95]) rotate([-90,0,0]) cylinder(6, 0.5, 0.5);
  }
}

module west_post() {
  difference() {
    translate([(tower_rafters - 1) * rafter_spacing, depth, 0]) post(143.25);   
    
    // Northeast beam
    northwest_beam(); 
      
    // Peg holes for beam
    translate([(tower_rafters - 1) * rafter_spacing + 3.5, depth - 0.25, 93]) rotate([-90,0,0]) cylinder(6, 0.5, 0.5);
    translate([(tower_rafters - 1) * rafter_spacing + 3.5, depth - 0.25, 95]) rotate([-90,0,0]) cylinder(6, 0.5, 0.5);
  }
}

module northeast_post() {
  translate([(tower_rafters + swing_rafters - 1) * rafter_spacing, 0, 0]) post(95.25);
}    

module northwest_post() {
  translate([(tower_rafters + swing_rafters - 1) * rafter_spacing, depth, 0]) post(95.25);
}

module southeast_beam() {
  length = 2*overhang + ((tower_rafters - 1) * rafter_spacing) + 5.5;
  translate([-overhang, 0, 139.25]) 
    difference() {
        // Beam itself
        cube([length, 5.5, 5.5]);

        // Mortises
        translate([overhang + 0.5, 2, 0]) cube([4.5, 1.5, 4]);
        translate([(tower_rafters - 1) * rafter_spacing + overhang + 0.5, 2, 0]) cube([4.5, 1.5, 4]);
        
        // Decorative cutouts
        if (tail_type == "viking") {
            translate([0,-.25,0]) rotate([-90,0,0]) cylinder(6, 4, 4);
            translate([length,-.25,0]) rotate([-90,0,0]) cylinder(6, 4, 4);
        } 
        else if (tail_type == "japanese") {
             // 4.5" up and 4.5" in from the bottom corner using math.
            translate([-4.5, -0.25, 0]) rotate([0, 45, 0]) cube(sqrt(40.5));
            translate([length-4.5, -0.25, 0]) rotate([0, 45, 0]) cube(sqrt(40.5));
        }
        
        // Half-laps for rafters
        for (x = [overhang:rafter_spacing:(tower_rafters - 1) * rafter_spacing + overhang]) 
            translate([x, 0, 4.5]) cube([5.5, 5.5, 1]);
        
        // Peg holes
        translate([overhang + 1.75,-.25,1.5]) rotate([-90,0,0]) cylinder(6, 0.5, 0.5);
        translate([overhang + 3.75,-.25,1.5]) rotate([-90,0,0]) cylinder(6, 0.5, 0.5);
        translate([length - overhang - 5.5 + 1.75,-.25,1.5]) rotate([-90,0,0]) cylinder(6, 0.5, 0.5);
        translate([length - overhang - 5.5 + 3.75,-.25,1.5]) rotate([-90,0,0]) cylinder(6, 0.5, 0.5);
    }
}

module southwest_beam() {
    // Just duplicate the Southeast beam
    translate([0, depth, 0]) southeast_beam();
}

module northeast_beam() {
    starts_at = (tower_rafters - 1) * rafter_spacing + 1.5; // This beam starts 1.5" into the post from the south
    length = (swing_rafters) * rafter_spacing + overhang + 4; // 4-inch tenon depth

    translate([starts_at, 0, 91.25]) 
        difference() {
            union() {
            // Tenon for post
            translate([0, 2, 0.5]) cube([4, 1.5, 4.5]);    
            
                difference() {
                    // Exposed beam
                    translate([3, 0, 0]) cube([length-3, 5.5, 5.5]);
                    
                    // Post angle
                    rotate([0, 10.305, 0]) translate([-7.0625, -2.5, -2.5]) cube([10, 10, 10]);
                }
            }
            // Mortise
            translate([length - overhang - 5, 2, 0]) cube([4.5, 1.5, 4]);            

            // Decorative Cutout
            if (tail_type == "viking") {
                translate([length,-.25,0]) rotate([-90,0,0]) cylinder(6, 4, 4);
            }
            else if (tail_type == "japanese") {
                // 4.5" up and 4.5" in from the bottom corner using math.
                translate([length-4.25, -0.25, 0]) rotate([0, 45, 0]) cube(sqrt(40.5)); 
            }
            
            // Half-laps for rafters
            for (x = [-1.5+rafter_spacing:rafter_spacing:swing_rafters * rafter_spacing]) 
                translate([x, 0, 4.5]) cube([5.5, 5.5, 1]);

            // Peg holes
            translate([length - overhang - 5.5 + 1.75, -0.25, 1.5]) rotate([-90,0,0]) cylinder(6, 0.5, 0.5);
            translate([length - overhang - 5.5 + 3.75, -0.25, 1.5]) rotate([-90,0,0]) cylinder(6, 0.5, 0.5);
        }
}

module northwest_beam() {
    // Just duplicate the Northeast beam
    translate([0, depth, 0]) northeast_beam();
}


module rafter() {
    length = (2 * overhang) + depth + 5.5;
    difference() {
        // The rafter itself
        cube([5.5, length, 5.5]);
        
        // Half-laps for beams
        translate([0, overhang, 0]) cube([5.5, 5.5, 1]);
        translate([0, depth + overhang, 0]) cube([5.5, 5.5, 1]);
        
        // Decorative cutouts
        if (tail_type == "viking") {
            translate([-.25, 0, 0]) rotate([0,90,0]) cylinder(6, 4, 4);
            translate([-.25, length, 0]) rotate([0,90,0]) cylinder(6, 4, 4);
        }
        else if (tail_type == "japanese") {
            // 4.5" up and 4.5" in from the bottom corner using math.
            translate([-0.25, -4.5, 0]) rotate([-45, 0, 0]) cube(sqrt(40.5));
            translate([-0.25, length-4.5, 0]) rotate([-45, 0, 0]) cube(sqrt(40.5)); 
        }
    }
    
}

module south_rafters() {
    for (x = [0:rafter_spacing:(tower_rafters - 1) * rafter_spacing]) 
        translate([x, -overhang, 142.75]) rafter();
}

module north_rafters() {
    first_rafter = rafter_spacing * tower_rafters;
    for (x = [first_rafter:rafter_spacing:first_rafter + (swing_rafters - 1) * rafter_spacing]) 
        translate([x, -overhang, 94.75]) rafter();
}

module platform() {
    translate([0, 0, platform_height]) cube([53.5, 53.5, 1.5]);
}

module x() {
    // 45-degree X between two beams:
    cube([5.5, 53.5, 5.5]);
    translate([0, 3.89+1.61, 0]) rotate([45, 0, 0]) cube([5.5, 65.6, 5.5]);
    translate([0, 48+3.89, 3.89]) rotate([135, 0, 0]) cube([5.5, 65.6, 5.5]);
    translate([0, 0, 7.778+38]) cube([5.5, 53.5, 5.5]);
}

structure();