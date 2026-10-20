
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
            shift_ena_reg <= 1'b0;
        end else begin
            if (counter == 4'd4) begin
                counter <= 4'd0;
                shift_ena_reg <= 1'b0;
            end else begin
                counter <= counter + 1'b1;
                shift_ena_reg <= 1'b1;
            end
        end
    end

    
    assign shift_ena = shift_ena_reg;

endmodule
