
module TopModule (
    input  clk,
    input  d,
    output q
);

    
    reg [1:0] counter;
    always @(posedge clk) begin
        if (counter == 2'b11) begin
            counter <= 2'b00;
        end else begin
            counter <= counter + 1'b1;
        end
    end

    
    reg q_reg;
    always @(posedge clk) begin
        if (counter == 2'b01) begin
            q_reg <= d;
        end
    end

    
    assign q = q_reg;

endmodule
