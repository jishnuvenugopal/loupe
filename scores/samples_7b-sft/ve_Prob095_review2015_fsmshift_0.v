
module TopModule (
    input  clk,
    input  reset,
    output reg shift_ena
);
    reg [1:0] counter;
    reg reset_prev;

    always @(posedge clk) begin
        reset_prev <= reset;
        if (reset && !reset_prev) begin          
            counter <= 2'b00;
            shift_ena <= 1'b1;
        end else if (shift_ena) begin
            if (counter == 2'b11) begin          
                shift_ena <= 1'b0;
            end else begin
                counter <= counter + 1;
            end
        end
    end
endmodule
