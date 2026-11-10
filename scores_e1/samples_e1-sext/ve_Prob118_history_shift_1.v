
module TopModule (
    input clk,
    input areset,
    input predict_valid,
    input predict_taken,
    input train_mispredicted,
    input train_taken,
    input train_history,
    output reg [31:0] predict_history
);

    reg [31:0] history;
    reg [3:0] history_counter;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history <= 0;
            history_counter <= 0;
        end else begin
            if (predict_valid) begin
                history = history << 1;
                history[0] = predict_taken;
                history_counter <= history_counter + 1;
            end else if (train_mispredicted) begin
                history = train_history;
                history_counter <= 0;
            end
        end
    end

    assign predict_history = history;

endmodule
