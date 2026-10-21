
module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    
    reg [1:0] current_state;
    reg [1:0] next_state;

    
    reg out;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= 2'b00;
            out <= 1'b0;
        end else begin
            case (current_state)
                2'b00: begin
                    if (in == 1'b0) begin
                        next_state <= 2'b00;
                        out <= 1'b0;
                    end else begin
                        next_state <= 2'b01;
                        out <= 1'b0;
                    end
                end
                2'b01: begin
                    if (in == 1'b0) begin
                        next_state <= 2'b01;
                        out <= 1'b0;
                    end else begin
                        next_state <= 2'b10;
                        out <= 1'b0;
                    end
                end
                2'b10: begin
                    if (in == 1'b0) begin
                        next_state <= 2'b10;
                        out <= 1'b0;
                    end else begin
                        next_state <= 2'b00;
                        out <= 1'b1;
                    end
                end
                2'b11: begin
                    if (in == 1'b0) begin
                        next_state <= 2'b11;
                        out <= 1'b0;
                    end else begin
                        next_state <= 2'b10;
                        out <= 1'b1;
                    end
                end
            endcase
        end
    end

    
    assign out = current_state[1];

endmodule
