
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

    
    reg predict_state;

    
    always @(posedge areset) begin
        history <= 32'b0;
        predict_state <= 1'b0;
    end

    
    always @(posedge clk) begin
        if (areset) begin
            history <= 32'b0;
            predict_state <= 1'b0;
        end else begin
            if (predict_valid && !predict_state) begin
                
                history <= {train_taken, history[31:1]};
                predict_state <= 1'b1;
            end else if (train_mispredicted) begin
                
                history <= train_history;
                predict_state <= 1'b0;
            end
        end
    end

    
    assign predict_history = history;

endmodule
