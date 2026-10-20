
module TopModule(
    output one
);

    reg one;

    always @(*) begin
        one = 1'b1;
    end

endmodule
