
module fsm (
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

    
    parameter [3:0] IDLE = 4'd0;
    parameter [3:0] S1 = 4'd1;
    parameter [3:0] S2 = 4'd2;
    parameter [3:0] S3 = 4'd3;
    parameter [3:0] S4 = 4'd4;
    parameter [3:0] S5 = 4'd5;

    reg [3:0] state;

    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            state <= IDLE;
            MATCH <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (IN == 1'b1) begin
                        state <= S1;
                    end else begin
                        state <= IDLE;
                    end
                end
                S1: begin
                    if (IN == 1'b0) begin
                        state <= S2;
                    end else begin
                        state <= IDLE;
                    end
                end
                S2: begin
                    if (IN == 1'b0) begin
                        state <= S3;
                    end else begin
                        state <= IDLE;
                    end
                end
                S3: begin
                    if (IN == 1'b1) begin
                        state <= S4;
                    end else begin
                        state <= IDLE;
                    end
                end
                S4: begin
                    if (IN == 1'b1) begin
                        state <= S5;
                    end else begin
                        state <= IDLE;
                    end
                end
                S5: begin
                    if (IN == 1'b1) begin
                        MATCH <= 1'b1;
                        state <= S5;
                    end else begin
                        MATCH <= 1'b0;
                        state <= IDLE;
                    end
                end
                default: begin
                    state <= IDLE;
                    MATCH <= 1'b0;
                end
            endcase
        end
    end

endmodule
