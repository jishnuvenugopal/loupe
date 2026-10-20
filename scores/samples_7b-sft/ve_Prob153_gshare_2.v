
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

    reg [6:0] global_history;
    reg [1:0] pht [0:127];

    
    wire [6:0] predict_index = predict_pc ^ global_history;
    reg predict_taken_comb;
    reg [6:0] predict_history_comb;

    always @(*) begin
        predict_taken_comb = pht[predict_index][1];
        predict_history_comb = global_history;
    end

    assign predict_taken = predict_taken_comb;
    assign predict_history = predict_history_comb;

    integer i;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            global_history <= 7'b0;
            for (i = 0;
 i < 128;
 i = i + 1) begin
                pht[i] <= 2'b00;
            end
        end else begin
            if (train_valid) begin
                
                wire [6:0] train_index = train_pc ^ global_history;

                
                if (train_taken) begin
                    if (pht[train_index] != 2'b11) begin
                        pht[train_index] <= pht[train_index] + 1;
                    end
                end else begin
                    if (pht[train_index] != 2'b00) begin
                        pht[train_index] <= pht[train_index] - 1;
                    end
                end

                
                if (train_mispredicted) begin
                    global_history <= train_history;
                end else begin
                    global_history <= global_history ^ train_pc;
                end
            end
        end
    end

endmodule
