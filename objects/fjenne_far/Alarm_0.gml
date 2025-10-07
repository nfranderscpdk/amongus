if(instance_exists(fjenne_1) && distance_to_object(fjenne_1) < afstand)
{
    target_x = JackVenomTank.x;
    target_y = JackVenomTank.y;
}
   else {
    	target_x = random_range(xstart - 100, xstart + 100);
        target_y = random_range(ystart - 100, ystart + 100);
    } 
   

alarm[0] = 60;