
module TopModule (
    input clk,
    input areset,
    input predict_valid,
    input predict_taken,
    input train_mispredicted,
    input train_history,
    output predict_history
);

    
    reg [31:0] predict_history;

    
    always @(posedge clk) begin
        if (areset) begin
            predict_history <= 32'b0;
        end
    end

    
    always @(posedge clk) begin
        if (predict_valid) begin
            
            predict_history <= {predict_taken, predict_history[31:1]};
        end
        if (train_mispredicted) begin
            
            predict_history <= {train_history, train_taken};
        end
    end

endmodule
