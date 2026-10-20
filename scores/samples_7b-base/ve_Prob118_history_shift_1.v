
module TopModule(
    input wire clk,
    input wire areset,
    input wire predict_valid,
    input wire predict_taken,
    input wire train_mispredicted,
    input wire train_taken,
    input wire [31:0] train_history,
    output wire [31:0] predict_history
);

    reg [31:0] history_reg;

    always @(posedge clk) begin
        if (areset) begin
            history_reg <= 32'b0;
        end else if (predict_valid) begin
            history_reg <= {history_reg[30:0], predict_taken};
        end else if (train_mispredicted) begin
            history_reg <= {train_history[31:0], train_taken[0]};
        end
    end

    assign predict_history = history_reg;

endmodule
