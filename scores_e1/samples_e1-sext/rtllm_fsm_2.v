
module fsm (
    input wire IN,
    input wire CLK,
    input wire RST,
    output reg MATCH
);

reg [1:0] state;
reg match;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= 2'b00;
        match <= 1'b0;
    end else begin
        case (state)
            2'b00: begin
                if (IN == 1'b1) begin
                    state <= 2'b01;
                    match <= 1'b1;
                end
            end
            2'b01: begin
                if (IN == 1'b1) begin
                    state <= 2'b01;
                    match <= 1'b1;
                end else begin
                    state <= 2'b00;
                    match <= 1'b0;
                end
            end
            default: begin
                state <= 2'b00;
                match <= 1'b0;
            end
        endcase
    end
end

endmodule
