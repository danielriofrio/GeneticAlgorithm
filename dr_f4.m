function [ Y ] = dr_f4( x, y )

     a = 20;
     b = 0.2;
     c = 2*pi;
     s1 = x^2 + y^2;
     s2 = cos(c*x) + cos(x*y);
     Y = -a*exp(-b*sqrt(1/2*s1))-exp(1/2*s2)+a+exp(1);

end
