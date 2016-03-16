$fs = 0.5;
$fa = 1;

material_width = 3;
kerf = 0.4;
unit_height = 60;

module al_bracket_l()
{
    translate([0,14]) square([10,2], center=true);
    translate([0,7]) circle(d=3.5);
}

module al_bracket_r()
{
    translate([0,7]) circle(d=3.5);
}

module base_3d()
{
    linear_extrude(height=material_width) base();
}

module base()
{
    difference()
    {
        square([200-material_width-material_width, 250-material_width-material_width], center=true);
        for (r=[0, 180])
        {
            rotate([0,0,r]) translate([0, -125+material_width]) al_bracket_r();
            for (y=[-60, 60])
            {
                rotate([0,0,r]) translate([-100+material_width, y]) rotate([0,0,-90]) al_bracket_r();
            }
        }
    }
}

module side_3d(type=0)
{
    linear_extrude(height=material_width) side(type);
}


/* 
Type 0 = No Cutouts
Type 1 = Straight Through 
Type 2 = Angle Exit Side
Type 3 = Angle Blank Side
*/
module side(type = 0)
{
    difference()
    {
        union()
        {
            translate ([-material_width, -125]) square([unit_height, 250]);
            if (type==2)
            {
                translate([10, (250-material_width)/2]) square([20, material_width+kerf], center=true);
            }
        }
        
        for (y=[-60, 60])
        {
            translate([0, y]) rotate([0,0,-90]) al_bracket_l();
        }
        
        for (r=[0, 180])
        {
            translate([40, 0]) rotate([0,0,r]) translate([0, -125+material_width]) al_bracket_l();
        }

        if (type>0)
        {
            translate([10, -(250-material_width-material_width-4.8)/2]) square([20, 5], center=true);
        }
        if (type == 1)
        {
            translate([10, (250-material_width-material_width-4.8)/2]) square([20, 5], center=true);
        }
        if (type == 2)
        {
            translate([10, -75-15]) square([20, 30], center=true);
            translate([36-material_width, 25]) circle(d=12);
        }
    }
}

module end_3d(type=0)
{
    linear_extrude(height=material_width) end(type);
}

/* 
Type 0 = No Cutouts
Type 1 = Straight Through 
Type 2 = Angle
*/
module end(type = 0)
{
    difference()
    {
        translate ([-100+material_width, -material_width]) square([200-material_width-material_width, unit_height]);
        
        al_bracket_l();
        
        for (r=[0, 180])
        {
            translate([0, 40]) rotate([0,0,r]) translate([-100+material_width, 0]) rotate([0,0,-90]) al_bracket_r();
        }

        if(type == 1)
        {
            translate([0, 36-material_width]) circle(d=12);
        }
        if (type == 2)
        {
            translate([ (-200+5+material_width)/2, 10]) square([5+material_width, 20], center=true);
        }
    }
}

module through()
{
    base();
    translate([110, 0]) side(1);
    translate([-110, 0]) mirror([1,0]) side(1);
    translate([0, 135]) end(1); 
    translate([0, -135]) mirror([0,1]) end(1); 
}

module left()
{
    base();
    translate([110, 0]) side(3);
    translate([-110, 0]) mirror([1,0]) side(2);
    translate([0, 135]) end(2); 
    translate([0, -135]) mirror([0,1]) end(1); 
}

module through_3d()
{
    color("red") base_3d();
    color("green")translate([100, 0, material_width]) rotate([0, -90]) side_3d(1);
    color("orange")translate([-100, 0, material_width]) rotate([0, 90]) mirror([1,0]) side_3d(1);
    color("blue")translate([0, 125, material_width]) rotate([90, 0]) end_3d(1); 
    color("purple")translate([0, -125, material_width]) rotate([-90, 0]) mirror([0,1]) end_3d(1); 
}

module left_3d()
{
    color("red") base_3d();
    color("green")translate([100, 0, material_width]) rotate([0, -90]) side_3d(3);
    color("orange")translate([-100, 0, material_width]) rotate([0, 90]) mirror([1,0]) side_3d(2);
    color("blue")translate([0, 125, material_width]) rotate([90, 0]) end_3d(2); 
    color("purple")translate([0, -125, material_width]) rotate([-90, 0]) mirror([0,1]) end_3d(1); 
}

//left();
//translate([400, 0]) through();

through_3d();