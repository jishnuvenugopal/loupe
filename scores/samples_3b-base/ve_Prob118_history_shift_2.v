
module TopModule (
    input  clk,
    input  areset,
    input  predict_valid,
    input  predict_taken,
    input  train_mispredicted,
    input  train_taken,
    input  train_history,  
    output predict_history  
);

    
    reg [31:0] branch_history;

    
    always @(posedge clk) begin
        if (areset) begin
            branch_history <= 32'b0;
        end
    end

    
    always @(posedge clk) begin
        if (predict_valid && predict_taken) begin
            
            branch_history <= {branch_history[30:0], predict_taken};
        end else if (train_mispredicted) begin
            
            branch_history <= {train_history, train_taken};
        end
    end

    
    assign predict_history = branch_history;

endmodule
