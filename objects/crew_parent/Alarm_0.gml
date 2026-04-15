if(instance_exists(crew_1) && distance_to_object(crew_1) < afstand)
{
    target_x = player.x;
    target_y = player.y;
}
   else {
    	target_x = random_range(xstart - 100, xstart + 100);
        target_y = random_range(ystart - 100, ystart + 100);
    } 
   

alarm[0] = 60;