
module fsm (
    input IN,
    input CLK,
    input RST,
    output MATCH
);
    reg [3:0] shift_reg;

    always @(posedge CLK) begin
        if (RST)
            shift_reg <= 4'b0;
        else
            shift_reg <= {shift_reg[2:0], IN};
    end

    assign MATCH = (shift_reg == 4'b1001) & IN;

endmodule
