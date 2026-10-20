
module TopModule (
    input clk,
    input areset,
    input predict_valid,
    input [6:0] predict_pc,
    output predict_taken,
    output [6:0] predict_history,
    input train_valid,
    input train_taken,
    input train_mispredicted,
    input [6:0] train_history,
    input [6:0] train_pc
);

    
    parameter PHT_SIZE = 128;
    parameter HISTORY_SIZE = 7;
    parameter COUNTER_WIDTH = 2;

    
    reg [HISTORY_SIZE-1:0] predict_history_reg;
    reg [COUNTER_WIDTH-1:0] pht [0:PHT_SIZE-1];
    reg [HISTORY_SIZE-1:0] pht_index;
    reg [COUNTER_WIDTH-1:0] pht_value;
    reg update_history;

    
    assign pht_index = predict_pc ^ predict_history_reg;

    
    assign pht_value = pht[pht_index];

    
    assign predict_taken = (pht_value == 2'b11);
    assign predict_history = predict_history_reg;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            predict_history_reg <= 7'b0;
            foreach (pht[i]) begin
                pht[i] <= 2'b00;
 
            end
        end else if (train_valid) begin
            pht[pht_index] <= (train_taken) ? (pht[pht_index] < 2'b11 ? pht[pht_index] + 1 : pht[pht_index]) : (pht[pht_index] > 2'b00 ? pht[pht_index] - 1 : pht[pht_index]);
            if (train_mispredicted) begin
                predict_history_reg <= train_history;
            end
            update_history <= 1'b1;
        end else if (update_history) begin
            update_history <= 1'b0;
        end else if (predict_valid) begin
            predict_history_reg <= predict_history_reg << 1;
            predict_history_reg[0] <= (pht_value == 2'b11);
        end
    end

endmodule
