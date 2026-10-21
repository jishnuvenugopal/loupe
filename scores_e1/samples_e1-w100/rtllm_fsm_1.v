
module fsm (
    input wire IN,
    input wire CLK,
    input wire RST,
    output reg MATCH
);

reg [4:0] counter;
reg [1:0] state;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        counter <= 0;
        state <= 0;
        MATCH <= 0;
    end else begin
        case (state)
            0: begin
                if (IN == 1) begin
                    counter <= 1;
                    state <= 1;
                end else begin
                    counter <= 0;
                end
            end
            1: begin
                if (IN == 1) begin
                    counter <= counter + 1;
                end else begin
                    counter <= 0;
                end
                if (counter == 5) begin
                    MATCH <= 1;
                end
                if (counter == 9) begin
                    MATCH <= 1;
                end
            end
            default: begin
                counter <= 0;
                state <= 0;
                MATCH <= 0;
            end
        endcase
    end
end

endmodule
