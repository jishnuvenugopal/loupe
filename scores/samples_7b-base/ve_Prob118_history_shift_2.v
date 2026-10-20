
module TopModule(
    input wire clk,
    input wire areset,
    input wire predict_valid,
    input wire predict_taken,
    input wire train_mispredicted,
    input wire [31:0] train_history,
    output reg [31:0] predict_history
);
    reg [31:0] history_shift_reg;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history_shift_reg <= 32'b0;
        end else begin
            if (train_mispredicted) begin
                history_shift_reg <= {train_history[30:0], train_taken};
            end else if (predict_valid) begin
                history_shift_reg <= {history_shift_reg[31:1], predict_taken};
            end
        end
    end

    assign predict_history = history_shift_reg;

endmodule
