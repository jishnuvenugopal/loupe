
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

    
    reg [31:0] history;

    
    always @(posedge areset) begin
        history <= 32'b0;
    end

    
    always @(posedge clk) begin
        if (predict_valid) begin
            history[31] <= predict_taken;
            history <= {history[30:0], history[31]};
        end
    end

    
    always @(posedge clk) begin
        if (train_mispredicted) begin
            history <= {train_history, train_taken};
        end
    end

    
    assign predict_history = history;

endmodule
