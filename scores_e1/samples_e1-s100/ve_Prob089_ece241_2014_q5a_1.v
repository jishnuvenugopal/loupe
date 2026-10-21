
module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    
    reg [1:0] state;
    reg [7:0] counter;
    reg [7:0] input_bits;
    reg [7:0] output_bits;

    
    assign state = 2'b00;
    assign counter = 8'b00000000;
    assign input_bits = 8'b00000000;
    assign output_bits = 8'b00000000;

    
    always @(posedge clk) begin
        if (areset) begin
            state <= 2'b00;
            counter <= 8'b00000000;
            input_bits <= 8'b00000000;
            output_bits <= 8'b00000000;
        end else begin
            
            input_bits <= x;
            counter <= counter + 1'b1;

            
            case (state)
                2'b00: begin
                    if (input_bits[7]) begin
                        state <= 2'b01;
                    end else begin
                        state <= 2'b00;
                    end
                end
                2'b01: begin
                    if (input_bits[7]) begin
                        state <= 2'b00;
                    end else begin
                        state <= 2'b01;
                    end
                end
                default: begin
                    state <= 2'b00;
                end
            endcase

            
            output_bits <= input_bits ^ 8'b11111111;
        end
    end

    
    assign z = output_bits;

endmodule
