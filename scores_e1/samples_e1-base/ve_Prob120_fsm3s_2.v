
module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    
    reg [1:0] state;
    reg output;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 2'b00;
            output <= 1'b0;
        end else begin
            case (state)
                2'b00: begin
                    if (in == 1'b0) begin
                        state <= 2'b01;
                        output <= 1'b0;
                    end else begin
                        state <= 2'b00;
                        output <= 1'b0;
                    end
                end
                2'b01: begin
                    if (in == 1'b0) begin
                        state <= 2'b00;
                        output <= 1'b0;
                    end else begin
                        state <= 2'b10;
                        output <= 1'b0;
                    end
                end
                2'b10: begin
                    if (in == 1'b0) begin
                        state <= 2'b00;
                        output <= 1'b0;
                    end else begin
                        state <= 2'b11;
                        output <= 1'b1;
                    end
                end
                2'b11: begin
                    if (in == 1'b0) begin
                        state <= 2'b00;
                        output <= 1'b0;
                    end else begin
                        state <= 2'b01;
                        output <= 1'b0;
                    end
                end
            endcase
        end
    end

    
    assign out = output;

endmodule
