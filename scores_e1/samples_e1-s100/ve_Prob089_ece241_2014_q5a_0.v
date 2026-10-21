
module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg [1:0] state;
    reg [7:0] input_data;
    reg [7:0] output_data;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b00;
            input_data <= 8'b00000000;
            output_data <= 8'b00000000;
        end else begin
            case (state)
                2'b00: begin
                    if (x) begin
                        state <= 2'b01;
                        input_data <= input_data << 1;
                        input_data[0] <= 1'b1;
                    end else begin
                        state <= 2'b00;
                        input_data <= input_data << 1;
                        input_data[0] <= 1'b0;
                    end
                end
                2'b01: begin
                    if (x) begin
                        state <= 2'b01;
                        input_data <= input_data << 1;
                        input_data[0] <= 1'b1;
                    end else begin
                        state <= 2'b00;
                        input_data <= input_data << 1;
                        input_data[0] <= 1'b0;
                    end
                end
                default: begin
                    state <= 2'b00;
                    input_data <= input_data << 1;
                    input_data[0] <= 1'b0;
                end
            endcase

            if (state == 2'b01) begin
                output_data <= ~input_data;
            end
        end
    end

    assign z = output_data;

endmodule
