
module TopModule (
    input  clk,
    input  areset,
    input  train_valid,
    input  train_taken,
    output reg [1:0] state
);

always @(posedge clk) begin
    if (areset) begin
        state <= 2'b01;
  
    end else begin
        if (train_valid) begin
            if (train_taken) begin
                state <= state + 1;
  
            end else begin
                state <= (state == 0) ? state : state - 1;
  
            end
        end
    end
end

endmodule 