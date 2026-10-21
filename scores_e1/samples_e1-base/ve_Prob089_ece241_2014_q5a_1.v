
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
                    
                    input_data <= x;
                    state <= 2'b01;
                end
                2'b01: begin
                    
                    output_data <= ~input_data;
                    state <= 2'b10;
                end
                2'b10: begin
                    
                    state <= 2'b00;
                end
                default: begin
                    state <= 2'b00;
                end
            endcase
        end
    end

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            z <= 1'b0;
        end else begin
            z <= output_data[7];
        end
    end

endmodule
