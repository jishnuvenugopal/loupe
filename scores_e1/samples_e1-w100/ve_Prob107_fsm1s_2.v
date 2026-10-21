
module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    
    reg [1:0] current_state;
    reg [1:0] previous_state;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= 2'b00;
            previous_state <= 2'b00;
        end else begin
            previous_state <= current_state;
            case (current_state)
                2'b00: begin
                    if (in == 0) begin
                        current_state <= 2'b01;
                    end else if (in == 1) begin
                        current_state <= 2'b00;
                    end
                end
                2'b01: begin
                    if (in == 0) begin
                        current_state <= 2'b00;
                    end else if (in == 1) begin
                        current_state <= 2'b01;
                    end
                end
            endcase
        end
    end

    
    always @(*) begin
        case (current_state)
            2'b00: out <= 1'b1;
            2'b01: out <= 1'b0;
        endcase
    end

endmodule
