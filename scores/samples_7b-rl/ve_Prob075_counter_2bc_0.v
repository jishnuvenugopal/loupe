
module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output [1:0] state
);

reg [1:0] count_reg;

assign state = count_reg;


always @(posedge clk or posedge areset) begin
    if (areset) begin
        count_reg <= 2'b01;
    end else begin
        if (train_valid) begin
            if (train_taken) begin
                
                if (count_reg < 2'b11)
                    count_reg <= count_reg + 1;
            end else begin
                
                if (count_reg > 2'b00)
                    count_reg <= count_reg - 1;
            end
        end
    end
end

endmodule
