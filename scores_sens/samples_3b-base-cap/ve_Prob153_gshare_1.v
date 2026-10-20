
module TopModule (
    input  clk,
    input  areset,

    input  predict_valid,
    input  predict_pc [6:0],
    output reg predict_taken,
    output reg [6:0] predict_history,

    input  train_valid,
    input  train_taken,
    input  train_mispredicted,
    input  train_history [6:0],
    input  train_pc [6:0]
);

    
    localparam PHT_SIZE = 128;
    localparam HISTORY_SIZE = 7;

    
    reg [6:0] global_history;
    reg [PHT_SIZE-1:0] pht;

    
    reg [6:0] index = predict_pc ^ global_history;

    
    reg [1:0] pht_counter[PHT_SIZE-1:0];

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            pht_counter <= {PHT_SIZE{2'b00}};
        end else if (train_valid) begin
            if (train_mispredicted) begin
                
                global_history <= train_history;
            end
            
            pht_counter[index] <= pht_counter[index] + 1;
        end
    end

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            predict_taken <= 1'b0;
            predict_history <= global_history;
        end else if (predict_valid) begin
            
            if (pht_counter[index] >= 64) begin
                predict_taken <= 1'b1;
            end else begin
                predict_taken <= 1'b0;
            end
            
            global_history <= global_history << 1;
            global_history[6] <= train_taken;
        end
    end

endmodule
