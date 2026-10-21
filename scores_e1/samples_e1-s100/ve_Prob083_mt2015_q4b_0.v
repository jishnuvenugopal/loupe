
module TopModule_tb (
    input  x,
    input  y,
    output z
);

    TopModule dut (
        .x(x),
        .y(y),
        .z(z)
    );

    initial begin
        
        x = 0;
        y = 0;
        #5;
        x = 0;
        y = 0;
        #10;
        x = 0;
        y = 0;
        #15;
        x = 0;
        y = 0;
        #20;
        x = 0;
        y = 0;
        #25;
        x = 1;
        y = 0;
        #30;
        x = 1;
        y = 0;
        #35;
        x = 0;
        y = 1;
        #40;
        x = 0;
        y = 1;
        #45;
        x = 1;
        y = 1;
        #50;
        x = 1;
        y = 1;
        #55;
        x = 0;
        y = 0;
        #60;
        x = 0;
        y = 1;
        #65;
        x = 0;
        y = 1;
        #70;
        x = 1;
        y = 1;
        #75;
        x = 0;
        y = 1;
        #80;
        x = 0;
        y = 1;
        #85;
        x = 0;
        y = 1;
        #90;
        x = 1;
        y = 0;
    end

endmodule
