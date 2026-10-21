
module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    
    reg [1:0] state;

    
    always @(posedge clk) begin
        case (state)
            2'b00: begin
                if (in == 1'b0) begin
                    state <= 2'b01;
                end else begin
                    state <= 2'b00;
                end
            end
            2'b01: begin
                if (in == 1'b0) begin
                    state <= 2'b00;
                end else begin
                    state <= 2'b10;
                end
            end
            2'b10: begin
                if (in == 1'b0) begin
                    state <= 2'b11;
                end else begin
                    state <= 2'b10;
                end
            end
            2'b11: begin
                if (in == 1'b0) begin
                    state <= 2'b00;
                end else begin
                    state <= 2'b01;
                end
            end
        endcase
    end

    
    always @(posedge areset) begin
        state <= 2'b00;
    end

    
    always @(*) begin
        out <= state[1];
    end

endmodule
