
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

    
    reg [31:0] history_register;

    
    always @(posedge areset) begin
        history_register <= 32'b0;
    end

    
    always @(posedge clk) begin
        if (areset) begin
            history_register <= 32'b0;
        end else begin
            if (predict_valid) begin
                
                history_register[31:1] <= history_register[30:0];
                history_register[0] <= predict_taken;
            end else if (train_mispredicted) begin
                
                history_register <= {train_history, train_taken};
            end
        end
    end

    
    assign predict_history = history_register;

endmodule
