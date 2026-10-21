
module fsm (
    input wire IN,
    input wire CLK,
    input wire RST,
    output reg MATCH
);

    reg [3:0] counter;
    reg [1:0] state;

    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            counter <= 0;
            state <= IDLE;
            MATCH <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (IN == 1) begin
                        counter <= 1;
                        state <= MATCH;
                    end
                end
                MATCH: begin
                    if (IN == 1) begin
                        counter <= counter + 1;
                    end else begin
                        counter <= 0;
                        state <= IDLE;
                    end
                end
            endcase
            if (counter == 5) begin
                MATCH <= 1;
            end else if (counter == 9) begin
                MATCH <= 1;
            end else if (counter == 0) begin
                MATCH <= 0;
            end
        end
    end

endmodule
