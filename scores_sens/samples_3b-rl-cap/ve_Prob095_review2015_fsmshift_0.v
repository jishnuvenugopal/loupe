
module TopModule (
    input  wire clk,
    input  wire reset,
    output reg  shift_ena
);

    
    reg [3:0] counter;
    reg shift_ena_reg;

    always @(posedge clk) begin
        if (reset) begin
            counter <= 4'd0;
            shift_ena_reg <= 1'b1;
        end else begin
            if (counter == 4'd0) begin
                shift_ena_reg <= 1'b1;
                counter <= 4'd1;
            end else if (counter == 4'd1) begin
                shift_ena_reg <= 1'b1;
                counter <= 4'd2;
            end else if (counter == 4'd2) begin
                shift_ena_reg <= 1'b1;
                counter <= 4'd3;
            end else if (counter == 4'd3) begin
                shift_ena_reg <= 1'b1;
                counter <= 4'd4;
            end else begin
                shift_ena_reg <= 1'b0;
                counter <= counter - 4'd1;
            end
        end
    end

    assign shift_ena = shift_ena_reg;

endmodule
