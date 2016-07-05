function [x,y] = dr_toIntegers(individual)
    % translation to integer numbers.
    sign_x = individual(1);
    sign_y = individual(6);
    num_x_binary = individual(2:5);
    num_y_binary = individual(7:10);

    x = bi2de(num_x_binary);
    y = bi2de(num_y_binary);

    if(sign_x == 1)
        x = -x;
    end

    if(sign_y == 1)
        y = -y;
    end
end