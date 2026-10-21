
module TopModule_tb (
    input  [2:0] a,
    output [15:0] q
);

    TopModule dut (
        .a(a),
        .q(q)
    );

    initial begin
        $monitor("time %t a=%b q=%b", $time, a, q);
        #5 a = 3'b000;
        #5 a = 3'b001;
        #5 a = 3'b010;
        #5 a = 3'b011;
        #5 a = 3'b100;
        #5 a = 3'b101;
        #5 a = 3'b110;
        #5 a = 3'b111;
        #5 a = 3'b000;
    end

endmodule
