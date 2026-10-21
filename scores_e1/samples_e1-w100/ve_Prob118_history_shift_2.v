
module TopModule (
    input clk,
    input areset,
    input predict_valid,
    input predict_taken,
    input train_mispredicted,
    input train_taken,
    input train_history,
    output predict_history
);

    reg [31:0] history;
    reg [31:0] history_backup;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history <= 32'b0;
            history_backup <= 32'b0;
        end else begin
            if (predict_valid) begin
                history <= {history[30:0], predict_taken};
            end else if (train_mispredicted) begin
                history_backup <= history;
                history <= {train_history[31:0], train_taken};
            end
        end
    end

    assign predict_history = history;

endmodule
