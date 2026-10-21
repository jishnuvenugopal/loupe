
module fsm (
    input wire IN,
    input wire CLK,
    input wire RST,
    output reg MATCH
);

    reg [1:0] state;
    reg [2:0] counter;

    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            state <= 2'b00;
            counter <= 3'b000;
        end else begin
            case (state)
                2'b00: begin
                    if (IN == 1'b1) begin
                        state <= 2'b01;
                        counter <= 3'b001;
                    end else begin
                        state <= 2'b00;
                    end
                end
                2'b01: begin
                    if (IN == 1'b1) begin
                        counter <= counter + 1'b1;
                    end else begin
                        state <= 2'b00;
                    end
                end
                2'b10: begin
                    if (IN == 1'b1) begin
                        state <= 2'b01;
                        counter <= 3'b001;
                    end else begin
                        state <= 2'b10;
                    end
                end
                2'b11: begin
                    if (IN == 1'b1) begin
                        state <= 2'b01;
                        counter <= 3'b001;
                    end else begin
                        state <= 2'b11;
                    end
                end
            endcase

            if (state == 2'b01) begin
                if (counter == 3'b001) begin
                    MATCH <= 1'b1;
                end else begin
                    MATCH <= 1'b0;
                end
            end
        end
    end

endmodule
