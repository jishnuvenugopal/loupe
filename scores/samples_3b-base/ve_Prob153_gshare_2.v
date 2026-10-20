
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
    localparam INDEX_WIDTH = 7;
    localparam HISTORY_WIDTH = 7;

    
    reg [INDEX_WIDTH-1:0] index;
    reg [HISTORY_WIDTH-1:0] global_history;
    reg [PHT_SIZE-1:0] pht;
    reg [PHT_SIZE-1:0] pht_next;
    reg [HISTORY_WIDTH-1:0] history_next;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            index <= 0;
        end else if (predict_valid) begin
            index <= {predict_pc[6:0], global_history[6:0]};
        end
    end

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            pht <= 0;
        end else if (train_valid) begin
            if (train_mispredicted) begin
                
                history_next <= train_history;
            end else begin
                
                pht_next[index] <= pht[index] + 1;
            end
        end
    end

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            pht <= 0;
        end else if (train_valid) begin
            if (train_mispredicted) begin
                
                history_next <= train_history;
            end else begin
                
                pht_next[index] <= pht[index] + 1;
            end
        end
    end

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            predict_taken <= 0;
            predict_history <= 0;
        end else if (predict_valid) begin
            
            index <= {predict_pc[6:0], global_history[6:0]};

            
            pht <= pht_next;

            
            if (pht[index] >= 64) begin
                predict_taken <= 1;
            end else begin
                predict_taken <= 0;
            end

            
            history_next <= {predict_taken, global_history[6:0]};
        end
    end

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            global_history <= 0;
        end else if (predict_valid) begin
            global_history <= history_next;
        end
    end

    
    assign predict_taken = predict_taken;
    assign predict_history = predict_history;

endmodule
