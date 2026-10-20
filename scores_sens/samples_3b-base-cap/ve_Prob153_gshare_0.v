
module TopModule (
    input  clk,
    input  areset,

    input  predict_valid,
    input  predict_pc [6:0],
    output predict_taken,
    output predict_history [6:0],

    input  train_valid,
    input  train_taken,
    input  train_mispredicted,
    input  train_history [6:0],
    input  train_pc [6:0]
);

    
    localparam PHT_SIZE = 128;
    localparam HISTORY_SIZE = 7;

    
    reg [6:0] global_history;
    reg [6:0] pht [PHT_SIZE-1:0];
    reg [6:0] predicted_history;
    reg predicted_taken;

    
    wire [6:0] index = predict_pc ^ global_history;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            pht[index] <= 2'b00;
        end else if (train_valid && train_mispredicted) begin
            pht[index] <= 2'b00;
        end else if (train_valid) begin
            pht[index] <= pht[index] + 1'b01;
        end
    end

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            predicted_history <= 7'b0000000;
            predicted_taken <= 1'b0;
        end else if (predict_valid) begin
            predicted_history <= predict_history ^ predict_pc;
            predicted_taken <= pht[index][1];
        end
    end

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            global_history <= 7'b0000000;
        end else if (train_valid && train_mispredicted) begin
            global_history <= train_history;
        end else if (train_valid) begin
            global_history <= global_history ^ train_pc;
        end else if (predict_valid) begin
            global_history <= global_history ^ predict_pc;
        end
    end

    
    assign predict_taken = predicted_taken;
    assign predict_history = predicted_history;

endmodule
