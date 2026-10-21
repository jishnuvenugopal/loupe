
module TopModule (
    input clk,
    input areset,
    input predict_valid,
    input predict_taken,
    input train_mispredicted,
    input train_taken,
    input train_history   (32 bits),
    output predict_history (32 bits)
);

    
    reg [31:0] branch_history;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            branch_history <= 0;
        end else if (predict_valid) begin
            branch_history <= {branch_history[30:0], predict_taken};
        end else if (train_mispredicted) begin
            branch_history <= {train_history[31:0], train_taken};
        end
    end

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            predict_history <= 0;
        end else if (train_mispredicted) begin
            predict_history <= branch_history;
        end
    end

endmodule
