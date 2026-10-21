
module TopModule (
    input  [2:0] a,
    output [15:0] q
);

    
    assign q[15:12] = a[2] & a[1] & a[0];
    assign q[11:8] = a[2] & a[1] | a[2] & a[0];
    assign q[7:4] = a[2] | a[1] | a[0];
    assign q[3:0] = a[1] | a[0];

endmodule

module TopModule_tb (
    input  [2:0] a,
    output [15:0] q
);

    reg [2:0] a;
    wire [15:0] q;

    TopModule top (
        .a(a),
        .q(q)
    );

    initial begin
        
        a = 3'b000;
        #5 a = 3'b001;
        #5 a = 3'b010;
        #5 a = 3'b011;
        #5 a = 3'b100;
        #5 a = 3'b101;
        #5 a = 3'b110;
        #5 a = 3'b111;
        #5 a = 3'b000;
        #5 a = 3'b001;
        #5 a = 3'b010;
        #5 a = 3'b011;
        #5 a = 3'b100;
        #5 a = 3'b101;
        #5 a = 3'b110;
        #5 a = 3'b111;
    end

endmodule
