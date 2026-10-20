module mux2X1(
        input [7:0] a,
        input [7:0] b,
        input sel,
        output reg [7:0] y
    );
        always @(*) begin
            if(sel)
                y = a;
            else
                y = b;
        end
    endmodule