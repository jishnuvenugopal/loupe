
module top_tb (
    input wire x,
    input wire y,
    output reg z
);
    top top (
        .x(x),
        .y(y),
        .z(z)
    );

    initial begin
        $monitor("time %0t x %0b y %0b z %0b", $time, x, y, z);
        #0 x = 0;
        #5 x = 0;
        #10 x = 0;
        #15 x = 0;
        #20 x = 0;
        #25 x = 1;
        #30 x = 1;
        #35 x = 0;
        #40 x = 0;
        #45 x = 1;
        #50 x = 1;
        #55 x = 0;
        #60 x = 0;
        #65 x = 0;
        #70 x = 1;
        #75 x = 0;
        #80 x = 0;
        #85 x = 0;
        #90 x = 1;
        #95 x = 0;
        #100 x = 0;
    end
endmodule
