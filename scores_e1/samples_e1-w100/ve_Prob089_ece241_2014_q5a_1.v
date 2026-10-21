
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
            
            if (counter < 8'b11111111) begin
                counter <= counter + 1'b1;
            end else begin
                counter <= 8'b00000000;
            end

            
            if (counter < 8'b11111111) begin
                input_bits <= input_bits << 1;
                input_bits[7] <= x;
            end else begin
                input_bits <= 8'b00000000;
            end

            
            if (state == 2'b00) begin
                if (input_bits[7] == 1'b1) begin
                    state <= 2'b01;
                end else begin
                    state <= 2'b00;
                end
            end else if (state == 2'b01) begin
                if (input_bits[7] == 1'b1) begin
                    state <= 2'b00;
                end else begin
                    state <= 2'b01;
                end
            end

            
            if (state == 2'b00) begin
                output_bits <= input_bits;
            end else if (state == 2'b01) begin
                output_bits <= ~input_bits;
            end
        end
    end

    
    assign z = output_bits;

endmodule
