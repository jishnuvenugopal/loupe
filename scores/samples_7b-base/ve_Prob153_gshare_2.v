
module TopModule(
    input  clk,
    input  areset,
    input  predict_valid,
    input  [6:0] predict_pc,
    output predict_taken,
    output [6:0] predict_history,
    input  train_valid,
    input  train_taken,
    input  train_mispredicted,
    input  [6:0] train_history,
    input  [6:0] train_pc
);
    parameter PHT_SIZE = 128;
    parameter PHT_ENTRY_WIDTH = 2;
    parameter HISTORY_WIDTH = 7;

    reg [HISTORY_WIDTH-1:0] global_history;
    reg [PHT_SIZE-1:0][PHT_ENTRY_WIDTH-1:0] pht;
    reg [HISTORY_WIDTH-1:0] predicted_history;
    reg predict_taken_reg;

    integer hash;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            global_history <= 0;
            predicted_history <= 0;
            predict_taken_reg <= 0;
        end else begin
            if (train_valid) begin
                hash = predict_pc ^ global_history;
                pht[hash] <= (pht[hash] << 1) | train_taken[0];
                if (train_mispredicted) begin
                    global_history <= train_history;
                end
            end

            if (predict_valid) begin
                hash = predict_pc ^ global_history;
                predicted_history <= global_history << 1;
                predicted_history[HISTORY_WIDTH-1] <= pht[hash][0];
                predict_taken_reg <= pht[hash][1];
            end
        end
    end

    assign predict_history = predicted_history;
    assign predict_taken = predict_taken_reg;
endmodule
