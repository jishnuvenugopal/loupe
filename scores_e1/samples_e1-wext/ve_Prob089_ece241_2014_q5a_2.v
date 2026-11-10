
module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    
    reg [1:0] current_state;
    reg [7:0] current_value;
    reg [7:0] complemented_value;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= 2'b00;
            current_value <= 8'b00000000;
            complemented_value <= 8'b00000000;
        end else begin
            case (current_state)
                2'b00: begin
                    if (x[0]) begin
                        current_value <= {current_value[7:0], 1'b1};
                        complemented_value <= {current_value[7:0], 1'b0};
                    end else begin
                        current_value <= current_value;
                        complemented_value <= complemented_value;
                    end
                    current_state <= 2'b01;
                end
                2'b01: begin
                    if (x[1]) begin
                        current_value <= {current_value[7:0], 1'b1};
                        complemented_value <= {current_value[7:0], 1'b0};
                    end else begin
                        current_value <= current_value;
                        complemented_value <= complemented_value;
                    end
                    current_state <= 2'b10;
                end
                2'b10: begin
                    if (x[2]) begin
                        current_value <= {current_value[7:0], 1'b1};
                        complemented_value <= {current_value[7:0], 1'b0};
                    end else begin
                        current_value <= current_value;
                        complemented_value <= complemented_value;
                    end
                    current_state <= 2'b11;
                end
                2'b11: begin
                    if (x[3]) begin
                        current_value <= {current_value[7:0], 1'b1};
                        complemented_value <= {current_value[7:0], 1'b0};
                    end else begin
                        current_value <= current_value;
                        complemented_value <= complemented_value;
                    end
                    current_state <= 2'b00;
                end
                default: begin
                    current_state <= 2'b00;
                    current_value <= 8'b00000000;
                    complemented_value <= 8'b00000000;
                end
            endcase
        end
    end

    
    assign z = complemented_value;

endmodule
