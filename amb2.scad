$fs = 1;
$fa = 1;

material_width = 3;
kerf = 0.2;
unit_height = 60;

module base_3d()
{
    linear_extrude(height=material_width) base();
}

module base()
{
    difference()
    {
        square([200, 250], center=true);
        for (r=[0, 180])
        {
            rotate([0,0,r]) translate([100-(material_width/2)+(kerf/2), 0]) square([material_width, 100+kerf], center=true);
            rotate([0,0,r]) translate([0, 125-(material_width/2)+(kerf/2)]) square([100+kerf, material_width], center=true);
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
            translate ([0, -125+material_width]) square([unit_height-material_width, 250-material_width-material_width]);
            translate([30, -(250)/2]) square([unit_height-45, 250]);
            translate([-(material_width+kerf)/2, 0]) square([material_width+kerf, 100+kerf], center=true);
            if (type==2)
            {
                translate([10, (250-material_width)/2]) square([20, material_width+kerf], center=true);
            }
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
        union()
        {
            translate ([-100, 0]) square([200, unit_height-material_width]);
            translate([0, -(material_width+kerf)/2]) square([100+kerf, material_width+kerf], center=true);
        }
        for (m=[0, 1])
        {
            #mirror([m, 0]) translate([-100, 30]) square([material_width-kerf, unit_height-45-kerf]);
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

left();
translate([400, 0]) through();